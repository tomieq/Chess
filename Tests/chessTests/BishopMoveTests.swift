//
//  BishopMoveTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
import XCTest
@testable import chess

class BishopMoveTests: XCTestCase {
    
    let chessBoard = ChessBoard()
    
    private func possibleMoves(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleMoves ?? []
    }
    
    private func supports(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.backedUpFriends ?? []
    }
    
    private func possibleVictims(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleVictims ?? []
    }
    
    private func possiblePredators(on square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possiblePredators ?? []
    }
    
    func testMovesFromA1() throws {
        let bishop = Bishop(.white, "a1")
        chessBoard.addPiece(bishop)
        let basicMoves = possibleMoves(from: "a1")
        XCTAssertEqual(basicMoves.count, 7)
        XCTAssertTrue(basicMoves.contains("b2"))
        XCTAssertTrue(basicMoves.contains("c3"))
        XCTAssertTrue(basicMoves.contains("g7"))
        XCTAssertTrue(basicMoves.contains("h8"))
        XCTAssertFalse(basicMoves.contains("b1"))
    }

    func testMovesFromH3() throws {
        let bishop = Bishop(.white, "h3")
        chessBoard.addPiece(bishop)
        let basicMoves = possibleMoves(from: "h3")
        XCTAssertEqual(basicMoves.count, 7)
        XCTAssertTrue(basicMoves.contains("g2"))
        XCTAssertTrue(basicMoves.contains("f1"))
        XCTAssertTrue(basicMoves.contains("g4"))
        XCTAssertTrue(basicMoves.contains("c8"))
        XCTAssertFalse(basicMoves.contains("h5"))
    }

    func testMovesFromE5() throws {
        let bishop = Bishop(.white, "e5")
        chessBoard.addPiece(bishop)
        let basicMoves = possibleMoves(from: "e5")
        XCTAssertEqual(basicMoves.count, 13)
        XCTAssertTrue(basicMoves.contains("f6"))
        XCTAssertTrue(basicMoves.contains("f4"))
        XCTAssertTrue(basicMoves.contains("d6"))
        XCTAssertTrue(basicMoves.contains("d4"))
        XCTAssertFalse(basicMoves.contains("d5"))
    }

    func test_movesOccupiedByOwnArmy() {
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "Ge4")
        var moves = possibleMoves(from: "e4")
        XCTAssertEqual(possibleMoves(from: "e4").count, 13)
        XCTAssertEqual(possibleVictims(from: "e4").count, 0)

        chessboardLoader.load(.white, "g6")
        XCTAssertEqual(possibleMoves(from: "e4").count, 11)
        XCTAssertEqual(possibleVictims(from: "e4").count, 0)

        chessboardLoader.load(.white, "c6")
        XCTAssertEqual(possibleMoves(from: "e4").count, 8)
        XCTAssertEqual(possibleVictims(from: "e4").count, 0)

        chessboardLoader.load(.white, "f3")
        XCTAssertEqual(possibleMoves(from: "e4").count, 5)
        XCTAssertEqual(possibleVictims(from: "e4").count, 0)

        chessboardLoader.load(.white, "c2")
        XCTAssertEqual(possibleMoves(from: "e4").count, 3)
        XCTAssertEqual(possibleVictims(from: "e4").count, 0)
    }

    func test_movesOccupiedByEnemy() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Gc1")
            .load(.black, "Wa3 Se3")
        XCTAssertEqual(possibleMoves(from: "c1").count, 4)
        XCTAssertEqual(possibleVictims(from: "c1").count, 2)
    }

    func test_exposeKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke2 Gd2")
            .load(.black, "Ke8 Ha2")
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
    }

    func test_defendKing() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Gd2")
            .load(.black, "Ke8 Ha5")
        let moves = possibleMoves(from: "d2")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("c3"), true)
        XCTAssertEqual(moves.contains("b4"), true)
        XCTAssertEqual(possibleVictims(from: "d2"), ["a5"])
        XCTAssertEqual(possiblePredators(on: "d2"), ["a5"])
    }
}

