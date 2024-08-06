import Foundation
import Swifter
import Template
import BootstrapTemplate
import chess

var chessBoard = ChessBoard()
chessBoard.setupGame()

var moveManager = ChessMoveManager(chessboard: chessBoard)
moveManager.eventHandler = { event in
    switch event {
    case .pieceMoved(_, let move):
        let letter = chessBoard[move.to]?.letter
        LiveConnection.shared.notifyClient("remove:\(move.from)")
        LiveConnection.shared.notifyClient("remove:\(move.to)")
        LiveConnection.shared.notifyClient("add:\(letter!):\(move.to)")
        let piece = chessBoard[move.to]!
        var text = "\(piece.color) \(piece.type.enName) moved to \(move.to)"
        if chessBoard.isCheck() { text.append(" with check!") }
        LiveConnection.shared.notifyClient("text:\(text)")
    case .pieceTakes(_, let move, let takenType):
        let letter = chessBoard[move.to]?.letter
        LiveConnection.shared.notifyClient("remove:\(move.from)")
        LiveConnection.shared.notifyClient("remove:\(move.to)")
        LiveConnection.shared.notifyClient("add:\(letter!):\(move.to)")
        let piece = chessBoard[move.to]!
        var text = "\(piece.color) \(piece.type.enName) takes \(piece.color.other) \(takenType.enName) on \(move.to)"
        if chessBoard.isCheck() { text.append(" with check!") }
        LiveConnection.shared.notifyClient("text:\(text)")
    case .promotion(let move, let type):
        let letter = chessBoard[move.to]?.letter
        LiveConnection.shared.notifyClient("remove:\(move.from)")
        LiveConnection.shared.notifyClient("remove:\(move.to)")
        LiveConnection.shared.notifyClient("add:\(letter!):\(move.to)")
        var text = "Promotion to \(type.enName) on \(move.to)"
        if chessBoard.isCheck() { text.append(" with check!") }
        LiveConnection.shared.notifyClient("text:\(text)")
    case .castling(let castling):
        castling.moves.forEach { move in
            let letter = chessBoard[move.to]?.letter
            LiveConnection.shared.notifyClient("remove:\(move.from)")
            LiveConnection.shared.notifyClient("remove:\(move.to)")
            LiveConnection.shared.notifyClient("add:\(letter!):\(move.to)")
        }
        var text = "Castling"
        if chessBoard.isCheck() { text.append(" with check!") }
        LiveConnection.shared.notifyClient("text:\(text)")
    case .checkMate(let color):
        let text = "Check mate for \(color)"
        LiveConnection.shared.notifyClient("text:\(text)")
    }
}


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
        chessBoard = ChessBoard()
        chessBoard.setupGame()
        moveManager = ChessMoveManager(chessboard: chessBoard)
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
                if let piece = chessBoard[square] {
                    elems.append(piece.letter)
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
            return .ok(.js(""))
        } catch {
            if let moveError = error as? ChessMoveError {
                switch moveError {
                case .invalidSquare:
                    break
                case .noPiece(let square):
                    break
                case .colorOnMove(let color):
                    return .ok(.js(JSCode.showError("Now it is \(color)`s turn")))
                case .canNotMove(let square):
                    return .ok(.js(JSCode.showError("You cannot move to \(square)")))
                }
            }
            return .ok(.js(JSCode.showError("\(error)")))
        }
        
    }
    server["/websocket"] = websocket(text: { (session, text) in
    }, binary: { (session, binary) in
        session.writeBinary(binary)
    }, pong: { (_, _) in
        // Got a pong frame
    }, connected: { socket in
        LiveConnection.shared.addConnection(socket)
    }, disconnected: { socket in
        LiveConnection.shared.removeConnection(socket)
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
