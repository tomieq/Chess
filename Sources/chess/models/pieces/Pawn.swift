//
//  Pawn.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Pawn: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ address: String) {
        self.init(.pawn, color, address)
    }

    var basicMoves: [ChessPieceAddress] {
        switch self.color {
        case .white:
            return self.basicWhiteMoves()
        case .black:
            return self.basicBlackMoves()
        }
    }

    private func basicWhiteMoves() -> [ChessPieceAddress] {
        var moves: [ChessPieceAddress?] = [
            self.address.move(.up),
            self.address.move(.up)?.move(.left),
            self.address.move(.up)?.move(.right)
        ]
        if self.address.row == 2 {
            moves.append(self.address.move(.up)?.move(.up))
        }
        return moves.compactMap { $0 }
    }

    private func basicBlackMoves() -> [ChessPieceAddress] {
        var moves: [ChessPieceAddress?] = [
            self.address.move(.down),
            self.address.move(.down)?.move(.left),
            self.address.move(.down)?.move(.right)
        ]
        if self.address.row == 7 {
            moves.append(self.address.move(.down)?.move(.down))
        }
        return moves.compactMap { $0 }
    }
}
