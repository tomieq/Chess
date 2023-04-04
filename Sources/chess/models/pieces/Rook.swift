//
//  Rook.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Rook: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ address: ChessPieceAddress) {
        self.init(.rook, color, address)
    }

    var basicMoves: [ChessPieceAddress] {
        var moves: [ChessPieceAddress?] = []
        var toLeft: ChessPieceAddress? = self.address
        var toRight: ChessPieceAddress? = self.address
        var toUp: ChessPieceAddress? = self.address
        var toDown: ChessPieceAddress? = self.address
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
        self.moveCounter == 0 && self.isAtStartingField
    }
    
    var isAtStartingField: Bool {
        switch self.color {
        case .white:
            return ["a1", "h1"].contains(self.address)
        case .black:
            return ["a8", "h8"].contains(self.address)
        }
    }
}
