//
//  KingMoveCalculator.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class KingMoveCalculator: MoveCalculator {
    var moveCounter: Int = 0
    
    var possibleMoves: [BoardSquare] = []
    
    var possibleVictims: [BoardSquare] = []
    
    var defended: [BoardSquare] = []
    var defenders: [BoardSquare] = []
    
    var possiblePredators: [BoardSquare] = []
    
    var supportedBy: [BoardSquare] = []
    
    let chessBoard: ChessBoard
    private var square: BoardSquare
    
    init(from square: BoardSquare, on chessBoard: ChessBoard) {
        self.square = square
        self.chessBoard = chessBoard
    }
}
