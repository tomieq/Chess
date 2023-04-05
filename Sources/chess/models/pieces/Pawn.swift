//
//  Pawn.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Pawn: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.pawn, color, square)
    }

    var crawningDirection: MoveDirection {
        switch self.color {
        case .white:
            return .up
        case .black:
            return .down
        }
    }

    var isAtStartingSquare: Bool {
        switch self.color {
        case .white:
            return self.square.row == 2
        case .black:
            return self.square.row == 7
        }
    }

    var passiveMoves: [BoardSquare] {
        var moves: [BoardSquare?] = []
        moves.append(self.square.move(self.crawningDirection))
        if self.isAtStartingSquare {
            moves.append(self.square.move(self.crawningDirection)?.move(self.crawningDirection))
        }
        return moves.compactMap{ $0 }
    }

    var agressiveMoves: [BoardSquare] {
        var moves: [BoardSquare?] = []
        moves.append(self.square.move(self.crawningDirection)?.move(.left))
        moves.append(self.square.move(self.crawningDirection)?.move(.right))
        return moves.compactMap{ $0 }
    }

    var basicMoves: [BoardSquare] {
        self.passiveMoves + self.agressiveMoves
    }
}
