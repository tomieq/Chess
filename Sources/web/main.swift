import Foundation
import Swifter
import Template
import BootstrapTemplate
import chess

var chessBoard = ChessBoard()
chessBoard.setupGame()

var commandFactory = ChessMoveCommandFactory(chessboard: chessBoard)
var moveExecutor = ChessMoveExecutor(chessboard: chessBoard)
moveExecutor.connect(to: LiveConnection.shared)

var parser = NotationParser(moveExecutor: moveExecutor)
var moves = parser.split("""
                        1. e4 e5
                        2. Nf3 Nc6
                        3. Bc4
        """)

do {
    let server = HttpServer()
    server["/"] = { request, headers in
        let template = BootstrapTemplate()
        template.addCSS(url: "style.css")
        template.addJS(url: "gameController.js")
        template.addJS(url: "confetti.browser.min.js")
        template.addJS(url: "init.js")
        let body = Template.load(relativePath: "templates/body.tpl.html")
        if moves.isEmpty.not {
            body.assign([:], inNest: "nextMoveButton")
        }
        body.assign([:], inNest: "revertMoveButton")
        template.body = body
        return .ok(.html(template))
    }
    server.get["new"] = { _, _ in
        chessBoard = ChessBoard()
        chessBoard.setupGame()
        commandFactory = ChessMoveCommandFactory(chessboard: chessBoard)
        moveExecutor = ChessMoveExecutor(chessboard: chessBoard)
        moveExecutor.connect(to: LiveConnection.shared)
        parser = NotationParser(moveExecutor: moveExecutor)
        return .movedTemporarily("/")
    }
    server.get["init.js"] = {  request, _ in
        let template = Template.load(relativePath: "templates/init.tpl.js")
        
        template["matrix"] = chessBoard.matrix
        template["address"] = request.headers.get("host")
        return .ok(.js(template))
    }
    server.get["reload.js"] = { _, _ in
        let template = Template.load(relativePath: "templates/reloadBoard.tpl.js")
        template["matrix"] = chessBoard.matrix
        template["random"] = UUID().uuidString.components(separatedBy: "-").first
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
            let command = try commandFactory.make(from: from, to: to)
            moveExecutor.process(command)
            return .ok(.js(""))
        } catch {
            if let moveError = error as? ChessMoveCommandFactoryError {
                switch moveError {
                case .invalidSquare:
                    break
                case .noPiece:
                    break
                case .colorOnMove(let color):
                    return .ok(.js(JSCode.showError("Now it is \(color)`s turn")))
                case .canNotMove(let type, let square):
                    return .ok(.js(JSCode.showError("You cannot move \(type.enName) to \(square)")))
                }
            }
            return .ok(.js(JSCode.showError("\(error)")))
        }
        
    }
    server["/websocket"] = websocket(text: { (session, text) in
        if text.starts(with: "nextMove") {
            if let move = moves.first {
                moves.removeFirst()
                do {
                    try parser.process(move)
                } catch {
                    print("Error \(error)")
                }
            }
            if moves.isEmpty {
                LiveConnection.shared.notifyClient(.hideNextMoveButton)
            }
        }
        if text.starts(with: "revertMove") {
            moveExecutor.revert()
        }
    }, binary: { (session, binary) in
        session.writeBinary(binary)
    }, pong: { (_, _) in
        // Got a pong frame
    }, connected: { socket in
        print("New websocket connected")
        LiveConnection.shared.addConnection(socket)
    }, disconnected: { socket in
        print("Websocket disconnected")
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


extension ChessMoveExecutor {
    func connect(to liveConnection: LiveConnection) {
        self.moveListener = { event in
            event.changes.forEach { change in
                switch change {
                case .move(let move):
                    let letter = chessBoard[move.to]?.letter
                    liveConnection.notifyClient(.removePiece(move.from))
                    liveConnection.notifyClient(.removePiece(move.to))
                    liveConnection.notifyClient(.addPiece(move.to, letter: letter!))
                case .remove(_, _, let square):
                    liveConnection.notifyClient(.removePiece(square))
                case .add(_, _, let square):
                    let letter = chessBoard[square]?.letter
                    liveConnection.notifyClient(.addPiece(square, letter: letter!))
                }
            }
            liveConnection.notifyClient(.text(event.notation))
            if event.status != .normal {
                liveConnection.notifyClient(.text("\(event.status)"))
            }
            if event.status == .checkmate {
                liveConnection.notifyClient(.checkMate)
            }
        }
    }
}

extension ChessBoard {
    var matrix: [[String]] {
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
        return matrix
    }
}
