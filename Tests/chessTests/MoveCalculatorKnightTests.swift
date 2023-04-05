//
//  MoveCalculatorKnightTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class MoveCalculatorKnightTests: XCTestCase {
    func test_allMoves() throws {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Sd4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "d4")?.count, 8)
    }

    func test_occupiedByOwnArmy() throws {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Sd4 e6")
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "d4")?.count, 7)
        chessBoard.addPieces(.white, "b3")
        XCTAssertEqual(sut.possibleMoves(from: "d4")?.count, 6)
    }

    func test_occupiedByEnemyArmy() throws {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Sd4")
        chessBoard.addPieces(.black, "b3 e6")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "d4")
        XCTAssertEqual(moves?.agressive.count, 2)
        XCTAssertEqual(moves?.passive.count, 6)
    }
}
