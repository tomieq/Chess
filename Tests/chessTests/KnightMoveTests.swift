//
//  KnightMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class KnightMoveTests: MoveTests {
    
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
        XCTAssertEqual(possibleVictims(for: "d4").count, 2)
        XCTAssertEqual(possibleMoves(from: "d4").count, 8)
    }
    
    func test_movePinnedByBishop() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Sf2")
            .load(.black, "Gh4")
        XCTAssertEqual(possibleVictims(for: "f2").count, 0)
        XCTAssertEqual(possibleMoves(from: "f2").count, 0)
        XCTAssertEqual(possiblePredators(for: "f2"), ["h4"])
    }
    
    func test_movePinnedByRook() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Sd1")
            .load(.black, "Wa1")
        XCTAssertEqual(possibleVictims(for: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(possiblePredators(for: "d1"), ["a1"])
    }
    
    func test_movePinnedByQueen() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Sd1")
            .load(.black, "Ha1")
        XCTAssertEqual(possibleVictims(for: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(possiblePredators(for: "d1"), ["a1"])
    }
    
    func test_knightIsDefendedByKnight() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf3 Sd4 Sf5")
            .load(.black, "Ke8 Sb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 2)
        XCTAssertEqual(possibleVictims(for: "d4"), ["b5"])
        XCTAssertEqual(possiblePredators(for: "d4"), ["b5"])
    }
}

