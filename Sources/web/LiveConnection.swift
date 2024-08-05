//
//  LiveConnection.swift
//  chess
//
//  Created by Tomasz Kucharski on 05/08/2024.
//
import Swifter

class LiveConnection {
    static let shared = LiveConnection()
    private var websockets: [WebSocketSession] = []
    
    func addConnection(_ socket: WebSocketSession) {
        self.websockets.append(socket)
    }
    func removeConnection(_ socket: WebSocketSession) {
        websockets.removeAll { $0 == socket }
    }
    func notifyClient(_ text: String) {
        websockets.forEach { $0.writeText(text) }
    }
}