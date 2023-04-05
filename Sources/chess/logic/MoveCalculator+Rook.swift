//
//  MoveCalculator+Rook.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func rookMoves(_ piece: Rook?) -> PossibleMoves? {
        guard let rook = piece else { return nil }
        // TODO: do not allow to move rook if move will expose king to the enemy
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        for direction in MoveDirection.allCases {
            for square in rook.moves(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: rook, square: square) {
                    agressive.append(square)
                    break
                } else if self.isFieldOccupiedByOwnArmy(piece: rook, square: square) {
                    break
                }
            }
        }
        if agressive.isEmpty, passive.isEmpty {
            return nil
        }
        return PossibleMoves(passive: passive, agressive: agressive)
    }
}
