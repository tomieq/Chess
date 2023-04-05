//
//  MoveCalculator.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

class MoveCalculator {
    let chessBoard: ChessBoard

    init(chessBoard: ChessBoard) {
        self.chessBoard = chessBoard
    }

    func possibleMoves(from address: BoardSquare) -> PossibleMoves? {
        guard let piece = self.chessBoard.getPiece(address) else {
            print("Could not find a piece at address \(address)")
            return nil
        }
        switch piece.type {
        case .king:
            return self.kingMoves(piece as? King)
        case .rook:
            return self.rookMoves(piece as? Rook)
        case .knight:
            return self.knightMoves(piece as? Knight)
        default:
            break
        }
        return nil
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
}

extension Array where Element == BoardSquare {
    func withoutOccupiedByMyArmyFields(_ piece: ChessPiece, chessBoard: ChessBoard) -> [Element] {
        let myArmySquares = chessBoard.pieces.filter{ $0.color == piece.color.other }.map { $0.square }
        return self.filter { !myArmySquares.contains($0) }
    }
}
