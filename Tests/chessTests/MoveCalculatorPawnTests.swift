//
//  MoveCalculatorPawnTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class MoveCalculatorPawnTests: XCTestCase {
    func test_initialMoves() throws {
        let chessBoard = ChessBoard()
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "e2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        var moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.passive.count, 2)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessboardLoader.load(.black, "f3")
        moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.passive.count, 2)
        XCTAssertEqual(moves?.agressive.count, 1)

        chessboardLoader.load(.black, "e3")
        moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.passive.count, 0)
        XCTAssertEqual(moves?.agressive.count, 1)
    }

    func test_movesOnSquaresTakenByOwnArmy() throws {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "e4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        var moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 1)
        XCTAssertEqual(moves?.agressive.count, 0)

        ChessBoardLoader(chessBoads: chessBoard).load(.black, "e5")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.count, 0)
    }

    func test_exposeKing() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d2")
            .load(.black, "Ke8 Ha5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 0)
    }

    func test_guardingKing() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 e2")
            .load(.black, "Ke8 He5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.count, 2)
    }

    func test_defendKing() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d2")
            .load(.black, "Ke8 Hc3")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 1)
        XCTAssertEqual(moves?.agressive, ["c3"])
    }

    func test_takeEnemyPawn() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 d4 e4")
            .load(.black, "Ke8 e5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e5")
        XCTAssertEqual(moves?.agressive, ["d4"])
        XCTAssertEqual(moves?.passive, [])
    }
}
