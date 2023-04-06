//
//  MoveCalculator+Bishop.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func bishopMoves(_ piece: Bishop?, calculation: MoveCalculation) -> PossibleMoves? {
        guard let bishop = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []

        func isAllowed(piece: ChessPiece, to square: BoardSquare) -> Bool {
            guard calculation == .deep else {
                return true
            }
            return self.isMoveSafeForKing(piece: piece, to: square)
        }
        var allowedDiagonalDirection: [DiagonalDirection: Bool] = [:]
        func isSafeForKing(_ direction: DiagonalDirection, piece: ChessPiece, to square: BoardSquare) -> Bool {
            if let isAllowed = allowedDiagonalDirection[direction] {
                return isAllowed
            }
            let isAllowed = isAllowed(piece: piece, to: square)
            allowedDiagonalDirection[direction] = isAllowed
            return isAllowed
        }

        for direction in DiagonalDirection.allCases {
            for square in bishop.square.squares(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    guard isSafeForKing(direction, piece: bishop, to: square) else {
                        break
                    }
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: bishop, square: square) {
                    guard isSafeForKing(direction, piece: bishop, to: square) else {
                        break
                    }
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
