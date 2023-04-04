//
//  Rook.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Rook: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.rook, color, square)
    }

    var basicMoves: [BoardSquare] {
        var moves: [BoardSquare?] = []
        var toLeft: BoardSquare? = self.square
        var toRight: BoardSquare? = self.square
        var toUp: BoardSquare? = self.square
        var toDown: BoardSquare? = self.square
        for _ in 1..<8 {
            toLeft = toLeft?.move(.left)
            toRight = toRight?.move(.right)
            toUp = toUp?.move(.up)
            toDown = toDown?.move(.down)
            moves.append(toLeft)
            moves.append(toRight)
            moves.append(toUp)
            moves.append(toDown)
        }
        return moves.compactMap { $0 }
    }

    var canCastle: Bool {
        self.moveCounter == 0 && self.isAtStartingPosition
    }
    
    var isAtStartingPosition: Bool {
        switch self.color {
        case .white:
            return ["a1", "h1"].contains(self.square)
        case .black:
            return ["a8", "h8"].contains(self.square)
        }
    }
}
