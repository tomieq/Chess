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
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Nd4")
        XCTAssertEqual(possibleMoves(from: "d4").count, 8)
    }

    func test_movesLimitedByOwnArmy() throws {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Nd4 e6")
        XCTAssertEqual(possibleMoves(from: "d4").count, 7)
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "b3")
        XCTAssertEqual(possibleMoves(from: "d4").count, 6)
    }

    func test_attacks() throws {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Nd4")
            .load(.black, "b3 e6")
        XCTAssertEqual(possibleVictims(for: "d4").count, 2)
        XCTAssertEqual(possibleMoves(from: "d4").count, 8)
    }
    
    func test_movePinnedByBishop() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Nf2")
            .load(.black, "Bh4")
        XCTAssertEqual(possibleVictims(for: "f2").count, 0)
        XCTAssertEqual(possibleMoves(from: "f2").count, 0)
        XCTAssertEqual(possiblePredators(for: "f2"), ["h4"])
    }
    
    func test_movePinnedByRook() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Nd1")
            .load(.black, "Ra1")
        XCTAssertEqual(possibleVictims(for: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(possiblePredators(for: "d1"), ["a1"])
    }
    
    func test_movePinnedByQueen() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Nd1")
            .load(.black, "Qa1")
        XCTAssertEqual(possibleVictims(for: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(possiblePredators(for: "d1"), ["a1"])
    }
    
    func test_knightIsDefendedByKnight() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf3 Nd4 Nf5")
            .load(.black, "Ke8 Nb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 2)
        XCTAssertEqual(possibleVictims(for: "d4"), ["b5"])
        XCTAssertEqual(possiblePredators(for: "d4"), ["b5"])
    }
    
    func test_queenIsDoubleDefended() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf1 Ba1 Nc3 Rh3 Rg3 Nd1")
            .load(.black, "Ke8 Ne4 Rc7 Rc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3"), ["d1"])
        XCTAssertEqual(possibleVictims(for: "c3"), ["e4"])
        XCTAssertEqual(possiblePredators(for: "c3").count, 3)
    }
    
    func test_knightIsMultipleDefended() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kf1 Ba1 Nc3 Rf3 Rh3 g3")
            .load(.black, "Ke8 Ne4 Rc6 Rc8 Nc7")
        XCTAssertEqual(defenders(for: "c3").count, 2)
        XCTAssertEqual(defended(from: "c3").count, 0)
        XCTAssertEqual(possibleVictims(for: "c3"), ["e4"])
        XCTAssertEqual(possiblePredators(for: "c3").count, 2)
    }
    
    func test_pawnDefendsAndAttacks() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d3 Nc4")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(possiblePredators(for: "c4"), ["d5"])
        XCTAssertEqual(defenders(for: "c4"), ["d3"])
    }
    
    func test_isDefendedByKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Nd2 Nf2")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(defenders(for: "f2"), ["e1"])
        XCTAssertEqual(defenders(for: "d2"), ["e1"])
    }
    
    func test_isAttackedByEnemyKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Kh1 Nd2 Nf2")
            .load(.black, "Ke1 d5")
        XCTAssertEqual(possiblePredators(for: "f2"), ["e1"])
        XCTAssertEqual(possiblePredators(for: "d2"), ["e1"])
    }
}

