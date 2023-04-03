//
//  KingMoveValidator.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class KingMoveValidator {
    let gameState: GameState
    let king: ChessPiece

    init(gameState: GameState, king: ChessPiece) {
        self.gameState = gameState
        self.king = king
    }

    func possibleMoves(prefilteredMoves: [ChessPieceAddress]) -> [ChessPieceAddress] {
        var moves = self.filterEnemyKingBarrier(prefilteredMoves: prefilteredMoves)
        moves = self.addCastlingMoves(prefilteredMoves: moves)
        return moves
    }

    private func filterEnemyKingBarrier(prefilteredMoves: [ChessPieceAddress]) -> [ChessPieceAddress] {
        let enemyKing = self.gameState.pieces.first{ $0.type == .king && $0.color == self.king.color.other }
        guard let enemyKing = enemyKing else {
            print("Could not find enemy king!")
            return prefilteredMoves
        }
        let enemyKingBarrier = enemyKing.address.neighbours
        return prefilteredMoves.filter { address in
            !enemyKingBarrier.contains(address)
        }
    }

    private func addCastlingMoves(prefilteredMoves: [ChessPieceAddress]) -> [ChessPieceAddress] {
        guard let king = self.king as? King, king.canCastle else {
            return prefilteredMoves
        }
        var moves = prefilteredMoves
        switch self.king.color {
        case .white:
            if self.king.address == "e1" {
                if let rook = self.gameState.getPiece("h1") as? Rook, rook.canCastle {
                    moves.append("g1")
                }
                if let rook = self.gameState.getPiece("a1") as? Rook, rook.canCastle {
                    moves.append("c1")
                }
            }
        case .black:
            if self.king.address == "e8" {
                if let rook = self.gameState.getPiece("h8") as? Rook, rook.canCastle {
                    moves.append("g8")
                }
                if let rook = self.gameState.getPiece("a8") as? Rook, rook.canCastle {
                    moves.append("c8")
                }
            }
        }
        return moves
    }
}
