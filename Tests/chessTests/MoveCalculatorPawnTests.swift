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
        chessBoard.addPieces(.white, "e2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        var moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.passive.count, 2)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessBoard.addPieces(.black, "f3")
        moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.passive.count, 2)
        XCTAssertEqual(moves?.agressive.count, 1)

        chessBoard.addPieces(.black, "e3")
        moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.passive.count, 0)
        XCTAssertEqual(moves?.agressive.count, 1)
    }

    func test_movesOnSquaresTakenByOwnArmy() throws {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "e4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        var moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 1)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessBoard.addPieces(.black, "e5")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.count, 0)
    }

    func test_exposeKing() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1 d2")
        chessBoard.addPieces(.black, "Ke8 Ha5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 0)
    }

    func test_guardingKing() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1 e2")
        chessBoard.addPieces(.black, "Ke8 He5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e2")
        XCTAssertEqual(moves?.count, 2)
    }

    func test_defendKing() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1 d2")
        chessBoard.addPieces(.black, "Ke8 Hc3")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 1)
        XCTAssertEqual(moves?.agressive, ["c3"])
    }

    func test_takeEnemyPawn() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1 d4 e4")
        chessBoard.addPieces(.black, "Ke8 e5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e5")
        XCTAssertEqual(moves?.agressive, ["d4"])
        XCTAssertEqual(moves?.passive, [])
    }
}
