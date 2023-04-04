//
//  KingMoveValidator.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class KingMoveValidator {
    let gameState: GameState
    let king: King

    enum Filter {
        static func enemyKingArea(enemyKing: ChessPiece?, address: ChessPieceAddress) -> Bool {
            guard let enemyKing = enemyKing else {
                return true
            }
            return !enemyKing.address.neighbours.contains(address)
        }
    }

    init(gameState: GameState, king: King) {
        self.gameState = gameState
        self.king = king
    }

    func possibleMoves(from address: ChessPieceAddress) -> [ChessPieceAddress] {
        let enemyKing = self.gameState.pieces.first{ $0.type == .king && $0.color == self.king.color.other }

        var moves = self.king.basicMoves
            .filter { Filter.enemyKingArea(enemyKing: enemyKing, address: $0) }
        moves = self.addCastlingMoves(to: moves)
        return moves
    }

    private func addCastlingMoves(to moves: [ChessPieceAddress]) -> [ChessPieceAddress] {
        guard self.king.canCastle else {
            return moves
        }
        var moves = moves
        switch self.king.color {
        case .white:
            if let rook = self.gameState.getPiece("h1") as? Rook, rook.canCastle {
                moves.append("g1")
            }
            if let rook = self.gameState.getPiece("a1") as? Rook, rook.canCastle {
                moves.append("c1")
            }
        case .black:
            if let rook = self.gameState.getPiece("h8") as? Rook, rook.canCastle {
                moves.append("g8")
            }
            if let rook = self.gameState.getPiece("a8") as? Rook, rook.canCastle {
                moves.append("c8")
            }
        }
        return moves
    }
}
