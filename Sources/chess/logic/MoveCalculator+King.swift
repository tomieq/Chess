//
//  MoveCalculator+King.swift
//  
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

extension MoveCalculator {
    // calculates possible king moves
    func kingMoves(_ piece: King?) -> PossibleMoves? {
        guard let king = piece else { return nil }
        let basicMoves = king.basicMoves
            .withoutOccupiedByMyArmyFields(king, gameState: self.gameState)
            .withoutEnemyKingBarrier(king, gameState: self.gameState)
        let agresive = basicMoves.filter{ self.isFieldOccupiedByEnemyArmy(piece: king, address: $0) }
        var passive = basicMoves.filter{ self.gameState.isFieldFree($0) }
        passive.append(contentsOf: self.castlingMoves(for: king))
        return PossibleMoves(passive: passive, agressive: agresive)
    }
    
    // returns possible castling moves
    func castlingMoves(for king: King) -> [ChessPieceAddress] {
        guard king.canCastle else {
            return []
        }
        var moves: [ChessPieceAddress] = []
        switch king.color {
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

fileprivate extension Array where Element == ChessPieceAddress {
    func withoutEnemyKingBarrier(_ king: King, gameState: GameState) -> [Element] {
        let enemyKing = gameState.pieces.first{ $0.type == .king && $0.color == king.color.other }
        guard let enemyKingArea = enemyKing?.address.neighbours else {
            return self
        }
        return self.filter { !enemyKingArea.contains($0) }
    }
}
