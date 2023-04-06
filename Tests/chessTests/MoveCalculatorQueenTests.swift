//
//  MoveCalculatorQueenTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class MoveCalculatorQueenTests: XCTestCase {
    func test_initialMoves() throws {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "He4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        var moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 27)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessBoard.addPieces(.black, "We6")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 24)
        XCTAssertEqual(moves?.agressive.count, 1)

        chessBoard.addPieces(.black, "Ke1")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 23)
        XCTAssertEqual(moves?.agressive.count, 2)

        chessBoard.addPieces(.white, "c2")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 21)
        XCTAssertEqual(moves?.agressive.count, 2)
    }

    func test_diagonalKingDefence() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1 Hd2")
        chessBoard.addPieces(.black, "Ke8 Ha5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d2")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.agressive.contains("a5"), true)
        XCTAssertEqual(moves?.passive.contains("c3"), true)
        XCTAssertEqual(moves?.passive.contains("b4"), true)
    }
}
