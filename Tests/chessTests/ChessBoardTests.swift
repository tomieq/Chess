//
//  ChessBoardTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import chess
import XCTest
/*
class ChessBoardTests: XCTestCase {
    func test_addingPieceToGame() {
        let sut = ChessBoard()
        sut.addPiece(Knight(.black, "c6"))

        let piece = sut.getPiece("c6")
        XCTAssertEqual(piece?.type, .knight)
        XCTAssertEqual(piece?.color, .black)
    }

    func test_addingPawnFromText() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut)
            .load(.black, "c7 d7 f7")
            .load(.white, "b2")
        XCTAssertEqual(sut.pieces.count, 4)
        XCTAssertEqual(sut.getPiece("c7")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("d7")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("f7")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("f7")?.color, .black)
        XCTAssertEqual(sut.getPiece("b2")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("b2")?.color, .white)
    }

    func test_addingChessPiecesUsingText() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut).load(.black, "Wa1 Sb1 Gc1 Hd1 Ke1")
        XCTAssertEqual(sut.pieces.count, 5)
        XCTAssertEqual(sut.getPiece("a1")?.type, .rook)
        XCTAssertEqual(sut.getPiece("b1")?.type, .knight)
        XCTAssertEqual(sut.getPiece("c1")?.type, .bishop)
        XCTAssertEqual(sut.getPiece("d1")?.type, .queen)
        XCTAssertEqual(sut.getPiece("e1")?.type, .king)
    }

    func test_isSquareFree() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut)
            .load(.black, "c7 d7 f7")
            .load(.white, "b2")
        XCTAssertTrue(sut.isSquareFree("c2"))
        XCTAssertFalse(sut.isSquareFree("c7"))
    }

    func test_pieceRemoval() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut).load(.black, "c7")
        XCTAssertFalse(sut.isSquareFree("c7"))
        sut.remove("c7")
        XCTAssertTrue(sut.isSquareFree("c7"))
    }

    func test_move() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut).load(.white, "d2")
        XCTAssertFalse(sut.isSquareFree("d2"))
        sut.move(source: "d2", to: "d3")
        XCTAssertTrue(sut.isSquareFree("d2"))
        XCTAssertFalse(sut.isSquareFree("d3"))
    }

    func test_copy() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut).load(.white, "d2")
        XCTAssertFalse(sut.isSquareFree("d2"))

        let copy = sut.copy
        copy.move(source: "d2", to: "d3")

        XCTAssertFalse(sut.isSquareFree("d2"))
        XCTAssertTrue(copy.isSquareFree("d2"))
        XCTAssertFalse(copy.isSquareFree("d3"))
    }
}
*/
