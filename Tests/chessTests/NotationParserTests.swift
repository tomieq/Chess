//
//  NotationParserTests.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

import Foundation
import XCTest
@testable import chess

class NotationParserTests: XCTestCase {
    
    var moveManager: ChessMoveManager {
        let board = ChessBoard()
        board.setupGame()
        let manager = ChessMoveManager(chessboard: board)
        return manager
    }
    
    func test_basicMoves() throws {
        let sut = NotationParser(moveManager: moveManager)
        let events = try sut.apply("""
        1. e4 e5
        2. Nf3 Nc6
        3. Bc4
        """)
        XCTAssertEqual(events, [
            .pieceMoved(type: .pawn, move: ChessMove(from: "e2", to: "e4")),
            .pieceMoved(type: .pawn, move: ChessMove(from: "e7", to: "e5")),
            .pieceMoved(type: .knight, move: ChessMove(from: "g1", to: "f3")),
            .pieceMoved(type: .knight, move: ChessMove(from: "b8", to: "c6")),
            .pieceMoved(type: .bishop, move: ChessMove(from: "f1", to: "c4")),
                               ])
    }
}




