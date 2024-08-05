import Foundation
import Swifter
import Template
import chess

let chessboard = ChessBoard()
chessboard.setupGame()

do {
    let server = HttpServer()
    server["/"] = { request, headers in
        let template = Template.load(relativePath: "templates/index.html")
        return .ok(.html(template))
    }
    server.get["style.css"] = { _, _ in
        let template = Template.load(relativePath: "templates/style.tpl.css")
        template["squareSize"] = 60
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
            try chessboard.move(from: from, to: to)
            return .ok(.js(""))
        } catch {
            return .badRequest(.text("Error: \(error)"))
        }
        
    }
    server.notFoundHandler = { request, responseHeaders in
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
