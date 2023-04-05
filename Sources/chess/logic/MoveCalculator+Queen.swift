//
//  MoveCalculator+Queen.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func queenMoves(_ piece: Queen?) -> PossibleMoves? {
        guard let queen = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        for direction in MoveDirection.allCases {
            for square in queen.square.squares(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: queen, square: square) {
                    agressive.append(square)
                    break
                } else if self.isFieldOccupiedByOwnArmy(piece: queen, square: square) {
                    break
                }
            }
        }

        for direction in DiagonalDirection.allCases {
            for square in queen.square.squares(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: queen, square: square) {
                    agressive.append(square)
                    break
                } else if self.isFieldOccupiedByOwnArmy(piece: queen, square: square) {
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
