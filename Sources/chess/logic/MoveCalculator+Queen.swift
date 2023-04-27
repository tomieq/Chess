//
//  MoveCalculator+Queen.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

extension MoveCalculator {
    func queenMoves(_ piece: Queen?, calculation: MoveCalculation) -> PossibleMoves? {
        guard let queen = piece else { return nil }
        var passive: [BoardSquare] = []
        var agressive: [BoardSquare] = []
        var covers: [BoardSquare] = []

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
            for square in queen.square.squares(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    guard isSafeForKing(direction, piece: queen, to: square) else {
                        break
                    }
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: queen, square: square) {
                    guard isSafeForKing(direction, piece: queen, to: square) else {
                        break
                    }
                    agressive.append(square)
                    break
                } else if self.isFieldOccupiedByOwnArmy(piece: queen, square: square) {
                    if isSafeForKing(direction, piece: queen, to: square) {
                        covers.append(square)
                    }
                    break
                }
            }
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
            for square in queen.square.squares(to: direction) {
                if self.chessBoard.isSquareFree(square) {
                    guard isSafeForKing(direction, piece: queen, to: square) else {
                        break
                    }
                    passive.append(square)
                } else if self.isFieldOccupiedByEnemyArmy(piece: queen, square: square) {
                    guard isSafeForKing(direction, piece: queen, to: square) else {
                        break
                    }
                    agressive.append(square)
                    break
                } else if self.isFieldOccupiedByOwnArmy(piece: queen, square: square) {
                    if isSafeForKing(direction, piece: queen, to: square) {
                        covers.append(square)
                    }
                    break
                }
            }
        }

        if agressive.isEmpty, passive.isEmpty {
            return nil
        }
        return PossibleMoves(passive: passive, agressive: agressive, covers: covers)
    }
}
