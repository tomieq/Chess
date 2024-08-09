//
//  MoveTests.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation
import XCTest
@testable import chess

class MoveTests: XCTestCase {
    
    let chessBoard = ChessBoard()
    
    func possibleMoves(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleMoves ?? []
    }
    
    func defended(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.defends ?? []
    }
    
    func defenders(for square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.defenders ?? []
    }
    
    func possibleVictims(for square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleVictims ?? []
    }
    
    func possibleAttackers(for square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleAttackers ?? []
    }
}

