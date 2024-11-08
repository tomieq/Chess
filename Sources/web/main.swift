import Foundation
import Swifter
import Template
import BootstrapTemplate
import chess

let db = CommentDatabase()
let chessBoard = ChessBoard()
chessBoard.setupGame()
let fenGenerator = FenGenerator(chessboard: chessBoard)
let commandFactory = ChessMoveCommandFactory(chessboard: chessBoard)
let moveExecutor = ChessMoveExecutor(chessboard: chessBoard)
moveExecutor.connect(to: LiveConnection.shared)

let parser = NotationParser(moveExecutor: moveExecutor)
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
        body["addCommentUrl"] = "addComment.js"
        template.body = body
        return .ok(.html(template))
    }
    server.post["addComment.js"] = { request, _ in
        guard let comment = request.formData.get("comment"), comment.isEmpty.not else {
            return .ok(.js(JSCode.showError("Missing comment")))
        }
        db.add(positionID: fenGenerator.fenPosition, colorOnMove: chessBoard.colorOnMove, comment: comment)
        return .ok(.js(""))
    }
    server.get["new"] = { _, _ in
        chessBoard.setupGame()
        LiveConnection.shared.notifyClient(.reloadBoard)
        return .movedTemporarily("/")
    }
    server.get["init.js"] = {  request, _ in
        let template = Template.load(relativePath: "templates/init.tpl.js")
        
        template["startingPositionDictionary"] = "{" + chessBoard.jsPosition.map{ " '\($0.key)':'\($0.value)'"}.joined(separator: ", ") + "}"
        template["address"] = request.headers.get("host")
        return .ok(.js(template))
    }
    server.get["reload.js"] = { _, _ in
        let template = Template.load(relativePath: "templates/reloadBoard.tpl.js")
        template["startingPositionDictionary"] = "{" + chessBoard.jsPosition.map{ " '\($0.key)':'\($0.value)'"}.joined(separator: ", ") + "}"
        template["random"] = UUID().uuidString.components(separatedBy: "-").first
        return .ok(.js(template))
    }
    server.get["style.css"] = { _, _ in
        let template = Template.load(relativePath: "templates/style.tpl.css")
        template["squareSize"] = 65
        template["squareNameOffset"] = 40
        return .ok(.css(template))
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
            let parts = text.components(separatedBy: ":")
            guard parts.count == 2, let amount = Int(parts[1]), amount > 0 else { return }
            for _ in (1...amount) {
                moveExecutor.revert()
            }
        }
        if text.starts(with: "newGame") {
            chessBoard.setupGame()
            LiveConnection.shared.notifyClient(.reloadBoard)
        }
        if text.starts(with: "move:") {
            let parts = text.split(separator: ":", maxSplits: 2).map{ "\($0)" }
            guard parts.count == 3 else {
                print("Invalid move command \(text)")
                return
            }
            do {
                let from = BoardSquare(stringLiteral: parts[1])
                let to = BoardSquare(stringLiteral: parts[2])
                let command = try commandFactory.make(from: from, to: to)
                moveExecutor.process(command)
            } catch {
                if let moveError = error as? ChessMoveCommandFactoryError {
                    switch moveError {
                    case .invalidSquare:
                        break
                    case .noPiece:
                        break
                    case .colorOnMove(let color):
                        LiveConnection.shared.notifyClient(.error("Now it is \(color)`s turn"))
                    case .canNotMove(let type, let square):
                        LiveConnection.shared.notifyClient(.error("You cannot move \(type.enName) to \(square)"))
                    }
                }
            }
        }
    }, binary: { (session, binary) in
        session.writeBinary(binary)
    }, pong: { (_, _) in
        // Got a pong frame
    }, connected: { socket in
        print("New websocket connected")
        LiveConnection.shared.addConnection(socket)
        
        LiveConnection.shared.notifyClient(.whiteDump(chessBoard.dump(color: .white)))
        LiveConnection.shared.notifyClient(.blackDump(chessBoard.dump(color: .black)))
        LiveConnection.shared.notifyClient(.pgn(PgnUIView.html(chessBoard: chessBoard)))

        LiveConnection.shared.notifyClient(.fen(fenGenerator.fen))
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
