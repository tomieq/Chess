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
        chessBoard.addPieces(.white, "Ge4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        var moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 13)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessBoard.addPieces(.white, "g6")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 11)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessBoard.addPieces(.white, "c6")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 8)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessBoard.addPieces(.white, "f3")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 5)
        XCTAssertEqual(moves?.agressive.count, 0)

        chessBoard.addPieces(.white, "c2")
        moves = sut.possibleMoves(from: "e4")
        XCTAssertEqual(moves?.passive.count, 3)
        XCTAssertEqual(moves?.agressive.count, 0)
    }

    func test_movesOccupiedByEnemy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Gc1")
        chessBoard.addPieces(.black, "Wa3 Se3")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "c1")
        XCTAssertEqual(moves?.passive.count, 2)
        XCTAssertEqual(moves?.agressive.count, 2)
    }
}
