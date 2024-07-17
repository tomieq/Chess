//
//  KnightMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class KnightMoveTests: XCTestCase {
    
    let chessBoard = ChessBoard()
    
    private func possibleMoves(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleMoves ?? []
    }
    
    private func supports(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.backedUpFriends ?? []
    }
    
    private func attacks(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleVictims ?? []
    }
    
    private func attackedBy(on square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possiblePredators ?? []
    }
    
    func test_allMoves() throws {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Sd4")
        XCTAssertEqual(possibleMoves(from: "d4").count, 8)
    }

    func test_movesLimitedByOwnArmy() throws {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Sd4 e6")
        XCTAssertEqual(possibleMoves(from: "d4").count, 7)
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "b3")
        XCTAssertEqual(possibleMoves(from: "d4").count, 6)
    }

    func test_attacks() throws {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Sd4")
            .load(.black, "b3 e6")
        XCTAssertEqual(attacks(from: "d4").count, 2)
        XCTAssertEqual(possibleMoves(from: "d4").count, 8)
    }
    
    func test_movePinnedByBishop() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Sf2")
            .load(.black, "Gh4")
        XCTAssertEqual(attacks(from: "f2").count, 0)
        XCTAssertEqual(possibleMoves(from: "f2").count, 0)
        XCTAssertEqual(attackedBy(on: "f2"), ["h4"])
    }
    
    func test_movePinnedByRook() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Sd1")
            .load(.black, "Wa1")
        XCTAssertEqual(attacks(from: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(attackedBy(on: "d1"), ["a1"])
    }
    
    func test_movePinnedByQueen() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Sd1")
            .load(.black, "Ha1")
        XCTAssertEqual(attacks(from: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(attackedBy(on: "d1"), ["a1"])
    }
}

