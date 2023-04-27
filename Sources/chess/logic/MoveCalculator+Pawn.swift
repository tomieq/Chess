//
//  MoveCalculator+Pawn.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func pawnMoves(_ piece: Pawn?, calculation: MoveCalculation) -> PossibleMoves? {
        guard let pawn = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []
        var covers: [BoardSquare] = []

        func isSafeForKing(piece: ChessPiece, to square: BoardSquare) -> Bool {
            guard calculation == .deep else {
                return true
            }
            return self.isMoveSafeForKing(piece: piece, to: square)
        }
        for square in pawn.passiveMoves {
            if self.chessBoard.isSquareFree(square), isSafeForKing(piece: pawn, to: square) {
                passive.append(square)
            } else {
                break
            }
        }

        for square in pawn.agressiveMoves {
            if self.isFieldOccupiedByEnemyArmy(piece: pawn, square: square), isSafeForKing(piece: pawn, to: square) {
                agressive.append(square)
            } else if self.isFieldOccupiedByOwnArmy(piece: pawn, square: square), isSafeForKing(piece: pawn, to: square) {
                covers.append(square)
            }
        }

        return PossibleMoves(passive: passive, agressive: agressive, covers: covers)
    }
}
