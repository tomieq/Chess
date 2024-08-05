//
//  ChessBoardTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import chess
import XCTest

class ChessBoardTests: XCTestCase {
    func test_addingPieceToGame() {
        let sut = ChessBoard()
        sut.addPiece(Knight(.black, "c6"))

        let piece = sut.piece(at: "c6")
        XCTAssertEqual(piece?.type, .knight)
        XCTAssertEqual(piece?.color, .black)
    }

    func test_addingPawnFromText() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut)
            .load(.black, "c7 d7 f7")
            .load(.white, "b2")
        XCTAssertEqual(sut.pieces.count, 4)
        XCTAssertEqual(sut.piece(at: "c7")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "d7")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "f7")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "f7")?.color, .black)
        XCTAssertEqual(sut.piece(at: "b2")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "b2")?.color, .white)
    }

    func test_addingChessPiecesUsingText() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut).load(.black, "Ra1 Nb1 Bc1 Qd1 Ke1")
        XCTAssertEqual(sut.pieces.count, 5)
        XCTAssertEqual(sut.piece(at: "a1")?.type, .rook)
        XCTAssertEqual(sut.piece(at: "b1")?.type, .knight)
        XCTAssertEqual(sut.piece(at: "c1")?.type, .bishop)
        XCTAssertEqual(sut.piece(at: "d1")?.type, .queen)
        XCTAssertEqual(sut.piece(at: "e1")?.type, .king)
    }

    func test_isFree() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut)
            .load(.black, "c7 d7 f7")
            .load(.white, "b2")
        XCTAssertTrue(sut.isFree("c2"))
        XCTAssertFalse(sut.isFree("c7"))
    }

    func test_pieceRemoval() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoads: sut).load(.black, "c7")
        XCTAssertFalse(sut.isFree("c7"))
        sut.remove("c7")
        XCTAssertTrue(sut.isFree("c7"))
    }

//    func test_move() {
//        let sut = ChessBoard()
//        ChessBoardLoader(chessBoads: sut).load(.white, "d2")
//        XCTAssertFalse(sut.isFree("d2"))
//        sut.move(source: "d2", to: "d3")
//        XCTAssertTrue(sut.isFree("d2"))
//        XCTAssertFalse(sut.isFree("d3"))
//    }
}

