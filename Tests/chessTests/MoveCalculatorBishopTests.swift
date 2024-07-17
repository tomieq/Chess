//
//  MoveCalculatorBishopTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class MoveCalculatorBishopTests: XCTestCase {
    func test_movesOccupiedByOwnArmy() {
        let chessBoard = ChessBoard()
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "Ge4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        var moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 13)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessboardLoader.load(.white, "g6")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 11)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessboardLoader.load(.white, "c6")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 8)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessboardLoader.load(.white, "f3")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 5)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessboardLoader.load(.white, "c2")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 3)
        XCTAssertEqual(moves?.agressive.count, 0)
    }

    func test_movesOccupiedByEnemy() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Gc1")
            .load(.black, "Wa3 Se3")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "c1")
        XCTAssertEqual(moves?.passive.count, 2)
        XCTAssertEqual(moves?.agressive.count, 2)
    }

    func test_exposeKing() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke2 Gd2")
            .load(.black, "Ke8 Ha2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 0)
    }

    func test_defendKing() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Gd2")
            .load(.black, "Ke8 Ha5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.agressive.contains("a5"), true)
        XCTAssertEqual(moves?.passive.contains("c3"), true)
        XCTAssertEqual(moves?.passive.contains("b4"), true)
    }
}
