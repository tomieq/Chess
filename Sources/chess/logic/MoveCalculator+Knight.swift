//
//  MoveCalculator+Knight.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func knightMoves(_ piece: Knight?, calculation: MoveCalculation) -> PossibleMoves? {
        guard let knight = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        func isSafeForKing(piece: ChessPiece, to square: BoardSquare) -> Bool {
            guard calculation == .deep else {
                return true
            }
            return self.isMoveSafeForKing(piece: piece, to: square)
        }

        for square in knight.basicMoves {
            if self.chessBoard.isSquareFree(square), isSafeForKing(piece: knight, to: square) {
                passive.append(square)
            } else if self.isFieldOccupiedByEnemyArmy(piece: knight, square: square), isSafeForKing(piece: knight, to: square) {
                agressive.append(square)
            }
        }

        if agressive.isEmpty, passive.isEmpty {
            return nil
        }
        return PossibleMoves(passive: passive, agressive: agressive)
    }
}
