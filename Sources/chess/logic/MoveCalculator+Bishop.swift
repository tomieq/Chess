//
//  MoveCalculator+Bishop.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func bishopMoves(_ piece: Bishop?) -> PossibleMoves? {
        guard let bishop = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        for direction in DiagonalDirection.allCases {
            for square in bishop.square.squares(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: bishop, square: square) {
                    agressive.append(square)
                    break
                } else if self.isFieldOccupiedByOwnArmy(piece: bishop, square: square) {
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
