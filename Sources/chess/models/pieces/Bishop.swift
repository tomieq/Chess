//
//  Bishop.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Bishop: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.bishop, color, square)
    }

    var basicMoves: [BoardSquare] {
        var moves: [BoardSquare?] = []
        var toUpLeft: BoardSquare? = self.square
        var toUpRight: BoardSquare? = self.square
        var toDownLeft: BoardSquare? = self.square
        var toDownRight: BoardSquare? = self.square
        for _ in 1..<8 {
            toUpLeft = toUpLeft?.move(.up)?.move(.left)
            toUpRight = toUpRight?.move(.up)?.move(.right)
            toDownLeft = toDownLeft?.move(.down)?.move(.left)
            toDownRight = toDownRight?.move(.down)?.move(.right)
            moves.append(toUpLeft)
            moves.append(toUpRight)
            moves.append(toDownLeft)
            moves.append(toDownRight)
        }
        return moves.compactMap { $0 }
    }
}
