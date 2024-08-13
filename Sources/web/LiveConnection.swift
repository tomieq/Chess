//
//  LiveConnection.swift
//  chess
//
//  Created by Tomasz Kucharski on 05/08/2024.
//
import Foundation
import Swifter

class LiveConnection {
    static let shared = LiveConnection()
    private var websockets: [WebSocketSession] = []
    private let queue = DispatchQueue.main
    
    func addConnection(_ socket: WebSocketSession) {
        self.websockets.append(socket)
        print("Active connections: \(websockets.count)")
    }
    func removeConnection(_ socket: WebSocketSession) {
        websockets.removeAll { $0 == socket }
        print("Active connections: \(websockets.count)")
    }
    func notifyClient(_ command: WebSocketCommand) {
        queue.async { [unowned self] in
            self.websockets.forEach { $0.writeText(command.raw) }
        }
    }
}
