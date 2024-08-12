import Foundation
import Swifter
import Template
import BootstrapTemplate
import chess

print("To load learning resources provide absolute path fo tmq files with tmq={path}")
let folder = ArgumentParser.getValue("tmq") ?? FileManager.default.currentDirectoryPath
let db = GameOpeningDatabase(folder: folder)
let chessBoard = ChessBoard()
chessBoard.setupGame()

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
        template.body = body
        return .ok(.html(template))
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
                    guard let letter = chessBoard[move.to]?.letter else {
                        print("ERROR-move: At \(move.to) there is no piece!")
                        return
                    }
                    liveConnection.notifyClient(.removePiece(move.from))
                    liveConnection.notifyClient(.removePiece(move.to))
                    liveConnection.notifyClient(.addPiece(move.to, letter: letter))
                case .remove(_, _, let square):
                    liveConnection.notifyClient(.removePiece(square))
                case .add(_, _, let square):
                    guard let letter = chessBoard[square]?.letter else {
                        print("ERROR-add: At \(square) there is no piece!")
                        return
                    }
                    liveConnection.notifyClient(.addPiece(square, letter: letter))
                }
            }
            if event.status == .checkmate {
                liveConnection.notifyClient(.checkMate)
            }
            liveConnection.notifyClient(.whiteDump(chessBoard.dump(color: .white)))
            liveConnection.notifyClient(.blackDump(chessBoard.dump(color: .black)))
            let notations = chessBoard.pgn
                .chunked(by: 2)
                .enumerated()
                .map { "\($0.offset + 1). \($0.element.joined(separator: " "))" }
            liveConnection.notifyClient(.pgn(notations.joined(separator: "\n")))
            let tips = db.getTips(to: chessBoard.pgnFlat)
            liveConnection.notifyClient(.tip(tips.joined(separator: "\n").replacingOccurrences(of: "\n", with: "<br>")))
        }
    }
}

extension ChessBoard {
    var jsPosition: [String:String] {
        var position: [String:String] = [:]
        for piece in self.allPieces {
            position[piece.square.description] = piece.letter
        }
        return position
    }
}
