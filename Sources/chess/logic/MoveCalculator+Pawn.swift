//
//  MoveCalculator+Pawn.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func pawnMoves(_ piece: Pawn?) -> PossibleMoves? {
        guard let pawn = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        for square in pawn.passiveMoves {
            if self.chessBoard.isSquareFree(square) {
                passive.append(square)
            } else {
                break
            }
        }

        for square in pawn.agressiveMoves {
            if self.isFieldOccupiedByEnemyArmy(piece: pawn, square: square) {
                agressive.append(square)
            }
        }

        if agressive.isEmpty, passive.isEmpty {
            return nil
        }
        return PossibleMoves(passive: passive, agressive: agressive)
    }
}
