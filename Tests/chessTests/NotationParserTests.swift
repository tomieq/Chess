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
    
    func test_quickCheckMate() throws {
        let sut = NotationParser(moveManager: moveManager, language: .polish)
        let events = try sut.apply("""
        e4 e5
        Hh5? Sc6
        Gc4 Sf6??
        Hxf7#
        """)
        XCTAssertEqual(events[0], .pieceMoved(type: .pawn, move: ChessMove(from: "e2", to: "e4")))
        XCTAssertEqual(events[1], .pieceMoved(type: .pawn, move: ChessMove(from: "e7", to: "e5")))
        XCTAssertEqual(events[2], .pieceMoved(type: .queen, move: ChessMove(from: "d1", to: "h5")))
        XCTAssertEqual(events[3], .pieceMoved(type: .knight, move: ChessMove(from: "b8", to: "c6")))
        XCTAssertEqual(events[4], .pieceMoved(type: .bishop, move: ChessMove(from: "f1", to: "c4")))
        XCTAssertEqual(events[5], .pieceMoved(type: .knight, move: ChessMove(from: "g8", to: "f6")))
        XCTAssertEqual(events[6], .pieceTakes(type: .queen, move: ChessMove(from: "h5", to: "f7"), takenType: .pawn))
        XCTAssertEqual(events[7], .checkMate(.white))
                            
    }
}




