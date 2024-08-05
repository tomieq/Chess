import Foundation
import Swifter
import Template
import BootstrapTemplate
import chess

var chessboard = ChessBoard()
chessboard.setupGame()
var moveManager = ChessMoveManager(chessboard: chessboard)

var websockets: [WebSocketSession] = []

do {
    let server = HttpServer()
    server["/"] = { request, headers in
        let template = BootstrapTemplate()
        template.addCSS(url: "style.css")
        template.addJS(url: "gameController.js")
        template.addJS(url: "init.js")
        template.body = Template.load(relativePath: "templates/body.tpl.html")
        return .ok(.html(template))
    }
    server.get["new"] = { _, _ in
        chessboard = ChessBoard()
        chessboard.setupGame()
        moveManager = ChessMoveManager(chessboard: chessboard)
        return .movedTemporarily("/")
    }
    server.get["init.js"] = {  request, _ in
        let template = Template.load(relativePath: "templates/init.tpl.js")
        var left: BoardSquare? = "a8"
        var matrix: [[String]] = []
        while let line = left {
            var elems: [String] = []
            var square: BoardSquare? = line
            while square != nil {
                if let piece = chessboard[square] {
                    var letter = piece.type == .pawn ? "P" : piece.type.enLetter
                    if piece.color == .white {
                        letter = letter.lowercased()
                    }
                    elems.append(letter)
                } else {
                    elems.append(".")
                }
                square = square?.move(.right)
            }
            matrix.append(elems)
            left = left?.move(.down)
        }
        template["matrix"] = matrix
        template["address"] = request.headers.get("host")
        return .ok(.js(template))
    }
    server.get["style.css"] = { _, _ in
        let template = Template.load(relativePath: "templates/style.tpl.css")
        template["squareSize"] = 50
        return .ok(.css(template))
    }
    server.get["move"] = { request, _ in
        struct Movement: Codable {
            let from: String
            let to: String
        }
        do {
            let move: Movement = try request.queryParams.decode()
            let from = BoardSquare(stringLiteral: move.from)
            let to = BoardSquare(stringLiteral: move.to)
            try moveManager.move(from: from, to: to)
            websockets.forEach { $0.writeText("\(moveManager.colorOnMove) on move") }
            return .ok(.js(""))
        } catch {
            websockets.forEach { $0.writeText("\(error)") }
            return .badRequest(.text("Error: \(error)"))
        }
        
    }
    server["/websocket"] = websocket(text: { (session, text) in
    }, binary: { (session, binary) in
        session.writeBinary(binary)
    }, pong: { (_, _) in
        // Got a pong frame
    }, connected: { socket in
        // New client connected
        websockets.append(socket)
    }, disconnected: { socket in
        // Client disconnected
        websockets.removeAll { $0 == socket }
    })
    server.middleware.append({ request, _ in
        request.disableKeepAlive = true
        return nil
    })
    server.notFoundHandler = { request, responseHeaders in
        if let filePath = BootstrapTemplate.absolutePath(for: request.path) {
            try HttpFileResponse.with(absolutePath: filePath)
        }
        let resourcePath = Resource().absolutePath(for: request.path)
        try HttpFileResponse.with(absolutePath: resourcePath)
        return .notFound()
    }
    try server.start(8080)
    print("Server started on port \(try server.port())")
    dispatchMain()
} catch {
    print(error)
}
