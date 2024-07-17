//
//  PawnMoveCalculator.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class PawnMoveCalculator: MoveCalculator {
    var moveCounter: Int = 0
    
    var possibleMoves: [BoardSquare] = []
    
    var possibleVictims: [BoardSquare] = []
    
    var backedUpFriends: [BoardSquare] = []
    
    var possiblePredators: [BoardSquare] = []
    
    var supportedBy: [BoardSquare] = []
    
    let chessBoard: ChessBoard
    private var square: BoardSquare
    
    init(from square: BoardSquare, on chessBoard: ChessBoard) {
        self.square = square
        self.chessBoard = chessBoard
    }
}
