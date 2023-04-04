//
//  MoveCalculator.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

class MoveCalculator {
    let gameState: ChessBoard

    init(gameState: ChessBoard) {
        self.gameState = gameState
    }

    func possibleMoves(from address: BoardSquare) -> PossibleMoves? {
        guard let piece = self.gameState.getPiece(address) else {
            print("Could not find a piece at address \(address)")
            return nil
        }
        switch piece.type {
        case .king:
            return self.kingMoves(piece as? King)
        default:
            break
        }
        return nil
    }

    func isFieldOccupiedByOwnArmy(piece: ChessPiece, address: BoardSquare) -> Bool {
        guard let colorOnAddress = self.gameState.getPiece(address)?.color else {
            return false
        }
        return colorOnAddress == piece.color
    }

    func isFieldOccupiedByEnemyArmy(piece: ChessPiece, address: BoardSquare) -> Bool {
        guard let colorOnAddress = self.gameState.getPiece(address)?.color else {
            return false
        }
        return colorOnAddress != piece.color
    }
}

extension Array where Element == BoardSquare {
    func withoutOccupiedByMyArmyFields(_ piece: ChessPiece, gameState: ChessBoard) -> [Element] {
        let myArmySquares = gameState.pieces.filter{ $0.color == piece.color.other }.map { $0.square }
        return self.filter { !myArmySquares.contains($0) }
    }
}
