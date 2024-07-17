//
//  MoveCalculatorRookTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class MoveCalculatorRookTests: XCTestCase {
    func test_movesOccupiedByOwnArmy() {
        let chessBoard = ChessBoard()
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "Wa1 a2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "a1")?.count, 7)
        chessboardLoader.load(.white, "Wh1")
        XCTAssertEqual(sut.possibleMoves(from: "a1")?.count, 6)
        chessboardLoader.load(.black, "g1")
        let moves = sut.possibleMoves(from: "a1")
        XCTAssertEqual(moves?.agressive.count, 1)
        XCTAssertEqual(moves?.passive.count, 5)
    }

    func test_movesOccupiedByEnemyArmy() {
        let chessBoard = ChessBoard()
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "Wd1")
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "d1")?.count, 14)
        chessboardLoader.load(.black, "d3")
        XCTAssertEqual(sut.possibleMoves(from: "d1")?.count, 9)
    }

    func test_exposeKing() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Wd2")
            .load(.black, "Ke8 Ha5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 0)
    }

    func test_defendKing() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke2 Wd2")
            .load(.black, "Ke8 Ha2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.agressive.contains("a2"), true)
        XCTAssertEqual(moves?.passive.contains("b2"), true)
        XCTAssertEqual(moves?.passive.contains("c2"), true)
    }
}
