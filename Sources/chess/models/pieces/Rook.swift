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
        self.square.squares(to: .right) + self.square.squares(to: .left) + self.square.squares(to: .up) + self.square.squares(to: .down)
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
