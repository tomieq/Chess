//
//  MoveCalculator+Rook.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func rookMoves(_ piece: Rook?, calculation: MoveCalculation) -> PossibleMoves? {
        guard let rook = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        func isAllowed(piece: ChessPiece, to square: BoardSquare) -> Bool {
            guard calculation == .deep else {
                return true
            }
            return self.isMoveSafeForKing(piece: piece, to: square)
        }
        var allowedDirection: [MoveDirection: Bool] = [:]
        func isSafeForKing(_ direction: MoveDirection, piece: ChessPiece, to square: BoardSquare) -> Bool {
            if let isAllowed = allowedDirection[direction] {
                return isAllowed
            }
            let isAllowed = isAllowed(piece: piece, to: square)
            allowedDirection[direction] = isAllowed
            return isAllowed
        }

        for direction in MoveDirection.allCases {
            for square in rook.square.squares(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    guard isSafeForKing(direction, piece: rook, to: square) else {
                        break
                    }
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: rook, square: square) {
                    guard isSafeForKing(direction, piece: rook, to: square) else {
                        break
                    }
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
