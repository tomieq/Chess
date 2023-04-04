//
//  Queen.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Queen: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.queen, color, square)
    }

    var basicMoves: [BoardSquare] {
        var moves: [BoardSquare?] = []
        var toUpLeft: BoardSquare? = self.square
        var toUpRight: BoardSquare? = self.square
        var toDownLeft: BoardSquare? = self.square
        var toDownRight: BoardSquare? = self.square
        var toLeft: BoardSquare? = self.square
        var toRight: BoardSquare? = self.square
        var toUp: BoardSquare? = self.square
        var toDown: BoardSquare? = self.square
        for _ in 1..<8 {
            toUpLeft = toUpLeft?.move(.up)?.move(.left)
            toUpRight = toUpRight?.move(.up)?.move(.right)
            toDownLeft = toDownLeft?.move(.down)?.move(.left)
            toDownRight = toDownRight?.move(.down)?.move(.right)
            toLeft = toLeft?.move(.left)
            toRight = toRight?.move(.right)
            toUp = toUp?.move(.up)
            toDown = toDown?.move(.down)
            moves.append(toUpLeft)
            moves.append(toUpRight)
            moves.append(toDownLeft)
            moves.append(toDownRight)
            moves.append(toLeft)
            moves.append(toRight)
            moves.append(toUp)
            moves.append(toDown)
        }
        return moves.compactMap { $0 }
    }
}
