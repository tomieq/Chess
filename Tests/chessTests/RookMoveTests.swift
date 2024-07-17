//
//  RookMoveTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import chess
import XCTest

class RookMoveTests: MoveTests {
    
    func testMovesFromA1OnEMptyBoard() throws {
        let rook = Rook(.white, "a1")
        chessBoard.addPiece(rook)
        let basicMoves = possibleMoves(from: rook?.square)
        XCTAssertEqual(basicMoves.count, 14)
        XCTAssertTrue(basicMoves.contains("b1"))
        XCTAssertTrue(basicMoves.contains("h1"))
        XCTAssertTrue(basicMoves.contains("a4"))
        XCTAssertTrue(basicMoves.contains("a8"))
        XCTAssertFalse(basicMoves.contains("b2"))
    }

    func testMovesFromD4OnEMptyBoard() throws {
        let rook = Rook(.white, "d4")
        chessBoard.addPiece(rook)
        let basicMoves = possibleMoves(from: rook?.square)
        XCTAssertEqual(basicMoves.count, 14)
        XCTAssertTrue(basicMoves.contains("d1"))
        XCTAssertTrue(basicMoves.contains("h4"))
        XCTAssertTrue(basicMoves.contains("d3"))
        XCTAssertTrue(basicMoves.contains("a4"))
        XCTAssertFalse(basicMoves.contains("c3"))
        XCTAssertEqual(possiblePredators(for: "d4"), [])
        XCTAssertEqual(possibleVictims(for: "d4"), [])
    }

    func test_movesOccupiedByOwnArmy() {
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "Wa1 a2")
        XCTAssertEqual(possibleMoves(from: "a1").count, 7)
        chessboardLoader.load(.white, "Wh1")
        XCTAssertEqual(possibleMoves(from: "a1").count, 6)
        chessboardLoader.load(.black, "g1")
        XCTAssertEqual(possibleVictims(for: "a1").first, "g1")
        XCTAssertEqual(defended(from: "a1").first, "a2")
        XCTAssertEqual(possiblePredators(for: "d4"), [])
        XCTAssertEqual(possibleVictims(for: "d4"), [])
    }
    
    func test_movesOccupiedByEnemyArmy() {
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "Wd1")
        XCTAssertEqual(possibleMoves(from: "d1").count, 14)
        chessboardLoader.load(.black, "d3")
        XCTAssertEqual(possibleMoves(from: "d1").count, 9)
        XCTAssertEqual(possibleVictims(for: "d1").first, "d3")
        XCTAssertEqual(possiblePredators(for: "d1"), [])
    }
    
    func test_support() {
        chessBoard.setupGame()
        XCTAssertEqual(possibleMoves(from: "a1").count, 0)
        XCTAssertEqual(possibleVictims(for: "a1").count, 0)
        XCTAssertEqual(defended(from: "a1"), ["b1", "a2"])
    }

    func test_possibleMovesWhenPinnedByRook() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 We2")
            .load(.black, "Kh8 We7")
        XCTAssertEqual(possibleMoves(from: "e2").count, 5)
        XCTAssertEqual(possibleVictims(for: "e2"), ["e7"])
        XCTAssertEqual(possiblePredators(for: "e2"), ["e7"])
    }
    
    func test_possibleMovesWhenPinnedByBishop() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Wd2")
            .load(.black, "Ke8 Ga5")
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
        XCTAssertEqual(possibleVictims(for: "d2").count, 0)
        XCTAssertEqual(possiblePredators(for: "d2"), ["a5"])
    }

    func test_defendKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke2 Wd2")
            .load(.black, "Ke8 Ha2")
        let moves = possibleMoves(from: "d2")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("a2"), true)
        XCTAssertEqual(moves.contains("b2"), true)
        XCTAssertEqual(moves.contains("c2"), true)
        XCTAssertEqual(possibleVictims(for: "d2"), ["a2"])
        XCTAssertEqual(possiblePredators(for: "d2"), ["a2"])
    }
    
    func test_rookIsDefendedByKnight() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf3 Wd4 Sf5")
            .load(.black, "Ke8 Sb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possiblePredators(for: "d4"), ["b5"])
    }
    
    func test_rookIsmultipleDefended() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf1 Ga1 Wc3 Wh3 Hg3 Sd1")
            .load(.black, "Ke8 Se4 Wc7 Wc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3"), ["g3"])
        XCTAssertEqual(possibleVictims(for: "c3"), ["c7"])
        XCTAssertEqual(possiblePredators(for: "c3").count, 3)
    }

}

