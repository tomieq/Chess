//
//  PawnMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class PawnMoveTests: MoveTests {
    func test_initialMoves() throws {
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "c2")
        XCTAssertEqual(possibleMoves(from: "c2"), ["c3", "c4"])
        chessboardLoader.load(.black, "d7")
        XCTAssertEqual(possibleMoves(from: "d7"), ["d6", "d5"])

//        chessboardLoader.load(.black, "f3")
//        moves = sut.possibleMoves(from: "e2")
//        XCTAssertEqual(moves?.passive.count, 2)
//        XCTAssertEqual(moves?.agressive.count, 1)
//
//        chessboardLoader.load(.black, "e3")
//        moves = sut.possibleMoves(from: "e2")
//        XCTAssertEqual(moves?.passive.count, 0)
//        XCTAssertEqual(moves?.agressive.count, 1)
    }
    
    func test_initialMovesBlockedByOwnArmy() throws {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 c2 d2 Wc4 Wd3")
            .load(.black, "Ke8 e7 f7 Ge6 Wf5")
        XCTAssertEqual(possibleMoves(from: "c2"), ["c3"])
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
        XCTAssertEqual(possibleMoves(from: "f7"), ["f6"])
        XCTAssertEqual(possibleMoves(from: "e7").count, 0)
    }
    
    func test_middleMovesBlockedByOwnArmy() throws {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 b4 c4 Wc5 g7")
            .load(.black, "Ke8 f3 g3 Wg2")
        XCTAssertEqual(possibleMoves(from: "b4"), ["b5"])
        XCTAssertEqual(possibleMoves(from: "c4").count, 0)
        XCTAssertEqual(possibleMoves(from: "g7"), ["g8"])
        XCTAssertEqual(possibleMoves(from: "f3"), ["f2"])
        XCTAssertEqual(possibleMoves(from: "g3").count, 0)
    }
    
    func test_pawnDefendsQueen() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 c2 Wa2 Hb3")
            .load(.black, "Ke8 Gd3")
        XCTAssertEqual(possibleMoves(from: "c2"), ["c3", "c4", "d3"])
        XCTAssertEqual(defenders(for: "c2"), ["a2", "b3"])
        XCTAssertEqual(possibleVictims(for: "c2"), ["d3"])
        XCTAssertEqual(defended(from: "c2"), ["b3"])
    }
    
    func test_pawnIsDefendedByKnight() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf3 d4 Sf5")
            .load(.black, "Ke8 Sb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possiblePredators(for: "d4"), ["b5"])
    }

    func test_pawnIsMultipleDefended() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf1 Ga1 c3 Wh3 Wg3 Sd1")
            .load(.black, "Ke8 Se4 Wc7 Wc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3").count, 0)
        XCTAssertEqual(possibleVictims(for: "c3").count, 0)
        XCTAssertEqual(possiblePredators(for: "c3").count, 3)
    }

    func test_exposeKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d2")
            .load(.black, "Ke8 Ha5")
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
    }

    func test_guardingKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 e2")
            .load(.black, "Ke8 He5")
        XCTAssertEqual(possibleMoves(from: "e2").count, 2)
    }

    func test_defendKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d2")
            .load(.black, "Ke8 Hc3")
        XCTAssertEqual(possibleMoves(from: "d2").count, 1)
        XCTAssertEqual(possibleVictims(for: "d2"), ["c3"])
    }

    func test_takeEnemyPawn() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d4 e4")
            .load(.black, "Ke8 e5")
        XCTAssertEqual(possibleMoves(from: "d4"), ["d5", "e5"])
        XCTAssertEqual(possibleVictims(for: "d4"), ["e5"])
        XCTAssertEqual(possiblePredators(for: "d4"), ["e5"])
        XCTAssertEqual(possibleMoves(from: "e4").count, 0)
    }
    
    func test_pawnDefends() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d3 c4")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(possiblePredators(for: "c4"), ["d5"])
        XCTAssertEqual(defenders(for: "c4"), ["d3"])
    }
}

