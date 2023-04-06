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
        chessBoard.addPieces(.white, "Wa1 a2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "a1")?.count, 7)
        chessBoard.addPieces(.white, "Wh1")
        XCTAssertEqual(sut.possibleMoves(from: "a1")?.count, 6)
        chessBoard.addPieces(.black, "g1")
        let moves = sut.possibleMoves(from: "a1")
        XCTAssertEqual(moves?.agressive.count, 1)
        XCTAssertEqual(moves?.passive.count, 5)
    }

    func test_movesOccupiedByEnemyArmy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Wd1")
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "d1")?.count, 14)
        chessBoard.addPieces(.black, "d3")
        XCTAssertEqual(sut.possibleMoves(from: "d1")?.count, 9)
    }

    func test_exposeKing() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1 Wd2")
        chessBoard.addPieces(.black, "Ke8 Ha5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertNil(moves)
    }

    func test_defendKing() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke2 Wd2")
        chessBoard.addPieces(.black, "Ke8 Ha2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.agressive.contains("a2"), true)
        XCTAssertEqual(moves?.passive.contains("b2"), true)
        XCTAssertEqual(moves?.passive.contains("c2"), true)
    }
}
