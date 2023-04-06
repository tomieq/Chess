//
//  MoveCalculator+King.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

extension MoveCalculator {
    // calculates possible king moves
    func kingMoves(_ piece: King?, calculation: MoveCalculation) -> PossibleMoves? {
        guard let king = piece else { return nil }
        var basicMoves = king.basicMoves
            .withoutOccupiedByMyArmyFields(king, chessBoard: self.chessBoard)
        if calculation == .valid {
            basicMoves = basicMoves.withoutEnemyControlledFields(king, moveCalculator: self)
        }
        let agresive = basicMoves.filter{ self.isFieldOccupiedByEnemyArmy(piece: king, square: $0) }
        var passive = basicMoves.filter{ self.chessBoard.isSquareFree($0) }
        passive.append(contentsOf: self.castlingMoves(for: king))
        return PossibleMoves(passive: passive, agressive: agresive)
    }

    // returns possible castling moves
    private func castlingMoves(for king: King) -> [BoardSquare] {
        guard king.canCastle else {
            return []
        }
        var moves: [BoardSquare] = []
        switch king.color {
        case .white:
            if let rook = self.chessBoard.getPiece("h1") as? Rook, rook.canCastle,
               self.areSquaresFree("f1", "g1"), self.areSquaresSafe(for: .white, "f1", "g1") {
                moves.append("g1")
            }
            if let rook = self.chessBoard.getPiece("a1") as? Rook, rook.canCastle,
               self.areSquaresFree("b1", "c1", "d1"), self.areSquaresSafe(for: .white, "b1", "c1", "d1") {
                moves.append("c1")
            }
        case .black:
            if let rook = self.chessBoard.getPiece("h8") as? Rook, rook.canCastle,
               self.areSquaresFree("f8", "g8"), self.areSquaresSafe(for: .black, "f8", "g8") {
                moves.append("g8")
            }
            if let rook = self.chessBoard.getPiece("a8") as? Rook, rook.canCastle,
               self.areSquaresFree("b8", "c8", "d8"), self.areSquaresSafe(for: .black, "b8", "c8", "d8") {
                moves.append("c8")
            }
        }
        return moves
    }

    private func areSquaresFree(_ squares: BoardSquare...) -> Bool {
        for square in squares {
            if !self.chessBoard.isSquareFree(square) {
                return false
            }
        }
        return true
    }

    private func areSquaresSafe(for color: ChessPieceColor, _ squares: BoardSquare...) -> Bool {
        let controlledSquares = self.squaresControlled(by: color.other)
        for square in squares {
            if controlledSquares.contains(square) {
                return false
            }
        }
        return true
    }
}

fileprivate extension Array where Element == BoardSquare {
    func withoutEnemyControlledFields(_ king: King, moveCalculator: MoveCalculator) -> [Element] {
        let enemyControlledSquares = moveCalculator.squaresControlled(by: king.color.other)
        return self.filter { !enemyControlledSquares.contains($0) }
    }
}
