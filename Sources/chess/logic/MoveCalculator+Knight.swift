//
//  MoveCalculator+Knight.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func knightMoves(_ piece: Knight?) -> PossibleMoves? {
        guard let knight = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        for square in knight.basicMoves {
            if self.chessBoard.isSquareFree(square) {
                passive.append(square)
            } else if self.isFieldOccupiedByEnemyArmy(piece: knight, square: square) {
                agressive.append(square)
            }
        }

        if agressive.isEmpty, passive.isEmpty {
            return nil
        }
        return PossibleMoves(passive: passive, agressive: agressive)
    }
}
