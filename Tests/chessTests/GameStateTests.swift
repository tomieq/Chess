//
//  GameStateTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import chess
import XCTest

class GameStateTests: XCTestCase {
    func test_addingPieceToGame() {
        let sut = GameState()
        sut.addPiece(Knight(.black, "c6"))

        let piece = sut.getPiece("c6")
        XCTAssertEqual(piece?.type, .knight)
        XCTAssertEqual(piece?.color, .black)
    }
}
