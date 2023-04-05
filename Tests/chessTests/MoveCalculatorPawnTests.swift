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
        XCTAssertNil(moves)
    }
}
