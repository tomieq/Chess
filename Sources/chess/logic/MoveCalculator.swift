//
//  MoveCalculator.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

class MoveCalculator {
    enum MoveCalculation {
        case deep
        case shallow
    }

    let chessBoard: ChessBoard

    init(chessBoard: ChessBoard) {
        self.chessBoard = chessBoard
    }

    func possibleMoves(from square: BoardSquare) -> PossibleMoves? {
        self.getPossibleMoves(from: square)
    }

    private func getPossibleMoves(from square: BoardSquare, calculation: MoveCalculation = .deep) -> PossibleMoves? {
        guard let piece = self.chessBoard.getPiece(square) else {
            print("Could not find a piece at square \(square)")
            return nil
        }
        switch piece.type {
        case .pawn:
            return self.pawnMoves(piece as? Pawn, calculation: calculation)
        case .king:
            return self.kingMoves(piece as? King, calculation: calculation)
        case .rook:
            return self.rookMoves(piece as? Rook, calculation: calculation)
        case .knight:
            return self.knightMoves(piece as? Knight, calculation: calculation)
        case .bishop:
            return self.bishopMoves(piece as? Bishop, calculation: calculation)
        case .queen:
            return self.queenMoves(piece as? Queen, calculation: calculation)
        }
    }

    func isFieldOccupiedByOwnArmy(piece: ChessPiece, square: BoardSquare) -> Bool {
        guard let colorOnAddress = self.chessBoard.getPiece(square)?.color else {
            return false
        }
        return colorOnAddress == piece.color
    }

    func isFieldOccupiedByEnemyArmy(piece: ChessPiece, square: BoardSquare) -> Bool {
        guard let colorOnAddress = self.chessBoard.getPiece(square)?.color else {
            return false
        }
        return colorOnAddress != piece.color
    }

    func isMoveSafeForKing(piece: ChessPiece, to square: BoardSquare) -> Bool {
        let forecaster = MoveCalculator(chessBoard: self.chessBoard.copy)
        forecaster.chessBoard.move(source: piece.square, to: square)
        guard let king = forecaster.chessBoard.getKing(color: piece.color) else {
            return true
        }
        let agressiveMoves = forecaster.chessBoard.getPieces(color: piece.color.other)
            .compactMap { forecaster.getPossibleMoves(from: $0.square, calculation: .shallow) }
            .flatMap{ $0.agressive }
        return !agressiveMoves.contains(king.square)
    }

    func squaresControlled(from square: BoardSquare) -> [BoardSquare] {
        guard let piece = self.chessBoard.getPiece(square) else {
            print("Could not find a piece at square \(square)")
            return []
        }
        switch piece.type {
        case .pawn:
            guard let pawn = piece as? Pawn else { return [] }
            return pawn.agressiveMoves
        default:
            return self.getPossibleMoves(from: square, calculation: .shallow)?.passive ?? []
        }
    }

    func squaresControlled(by color: ChessPieceColor) -> [BoardSquare] {
        let pieces = self.chessBoard.getPieces(color: color)
        let passiveMoves = pieces.flatMap{ self.squaresControlled(from: $0.square) }
        return passiveMoves.unique
    }

    func backup(for square: BoardSquare) -> [ChessPiece] {
        guard let piece = self.chessBoard.getPiece(square) else {
            return []
        }
        let forecaster = MoveCalculator(chessBoard: self.chessBoard.copy)
        forecaster.chessBoard.remove(square)
        forecaster.chessBoard.addPiece(Pawn(piece.color.other, square))
        let pieces = forecaster.chessBoard.getPieces(color: piece.color)
            .compactMap { piece -> (ChessPiece, [BoardSquare])? in
                guard let squares = forecaster.getPossibleMoves(from: piece.square, calculation: .shallow)?.agressive else {
                    return nil
                }
                return (piece, squares)
            }
            .filter { $0.1.contains(square) }
            .map { $0.0 }
        return pieces
    }
}

extension Array where Element == BoardSquare {
    func withoutOccupiedByMyArmyFields(_ piece: ChessPiece, chessBoard: ChessBoard) -> [Element] {
        let myArmySquares = chessBoard.getPieces(color: piece.color.other).map { $0.square }
        return self.filter { !myArmySquares.contains($0) }
    }
}
