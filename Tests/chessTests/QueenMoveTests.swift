//
//  QueenMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class QueenMoveTests: MoveTests {
    
    func test_initialMoves() throws {
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "He4")
        XCTAssertEqual(possibleMoves(from: "e4").count, 27)
        XCTAssertEqual(possibleVictims(for: "e4").count, 0)

        chessboardLoader.load(.black, "We6")
        XCTAssertEqual(possibleMoves(from: "e4").count, 25)
        XCTAssertEqual(possibleVictims(for: "e4").count, 1)
        XCTAssertEqual(possiblePredators(for: "e4").count, 1)

        chessboardLoader.load(.black, "Ke1")
        XCTAssertEqual(possibleMoves(from: "e4").count, 25)
        XCTAssertEqual(possibleVictims(for: "e4").count, 2)

        chessboardLoader.load(.white, "c2")
        XCTAssertEqual(possibleMoves(from: "e4").count, 23)
        XCTAssertEqual(possibleVictims(for: "e4").count, 2)
    }

    func test_diagonalKingDefence() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Hd2")
            .load(.black, "Ke8 Ha5")
        let moves = possibleMoves(from: "d2")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("c3"), true)
        XCTAssertEqual(moves.contains("b4"), true)
        XCTAssertEqual(possibleVictims(for: "d2"), ["a5"])
    }
    
    func test_queenIsDefendedByKnight() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf3 Hd4 Sf5")
            .load(.black, "Ke8 Sb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possiblePredators(for: "d4"), ["b5"])
    }
    
    func test_queenIsmultipleDefended() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf1 Ga1 Hc3 Wh3 Wg3 Sd1")
            .load(.black, "Ke8 Se4 Wc7 Wc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3").count, 2)
        XCTAssertEqual(possibleVictims(for: "c3"), ["c7"])
        XCTAssertEqual(possiblePredators(for: "c3").count, 3)
    }
}

