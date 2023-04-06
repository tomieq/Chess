//
//  MoveCalculator.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

enum MoveCalculation {
    case valid
    case light
}

class MoveCalculator {
    let chessBoard: ChessBoard

    init(chessBoard: ChessBoard) {
        self.chessBoard = chessBoard
    }

    func possibleMoves(from address: BoardSquare, calculation: MoveCalculation = .valid) -> PossibleMoves? {
        guard let piece = self.chessBoard.getPiece(address) else {
            print("Could not find a piece at address \(address)")
            return nil
        }
        switch piece.type {
        case .pawn:
            return self.pawnMoves(piece as? Pawn)
        case .king:
            return self.kingMoves(piece as? King, calculation: calculation)
        case .rook:
            return self.rookMoves(piece as? Rook)
        case .knight:
            return self.knightMoves(piece as? Knight)
        case .bishop:
            return self.bishopMoves(piece as? Bishop)
        case .queen:
            return self.queenMoves(piece as? Queen)
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

    func squaresControlled(by color: ChessPieceColor) -> [BoardSquare] {
        let pieces = self.chessBoard.getPieces(color: color)
        let passiveMoves = pieces.compactMap{ self.possibleMoves(from: $0.square, calculation: .light) }.flatMap { $0.passive }
        return passiveMoves
    }
}

extension Array where Element == BoardSquare {
    func withoutOccupiedByMyArmyFields(_ piece: ChessPiece, chessBoard: ChessBoard) -> [Element] {
        let myArmySquares = chessBoard.getPieces(color: piece.color.other).map { $0.square }
        return self.filter { !myArmySquares.contains($0) }
    }
}
