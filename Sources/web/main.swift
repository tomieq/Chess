import Foundation
import Swifter
import Template



do {
    let server = HttpServer()
    server["/"] = { request, headers in
        let template = Template.load(relativePath: "templates/index.html")
        return .ok(.html(template))
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
