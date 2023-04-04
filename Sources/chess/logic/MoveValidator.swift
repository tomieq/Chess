//
//  MoveValidator.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

class MoveValidator {
    let gameState: GameState

    init(gameState: GameState) {
        self.gameState = gameState
    }

    func canMove(from startAddress: ChessPieceAddress, to destinationAddress: ChessPieceAddress) -> Bool {
        self.possibleMoves(from: startAddress).contains(destinationAddress)
    }

    func possibleMoves(from address: ChessPieceAddress) -> [ChessPieceAddress] {
        guard let piece = self.gameState.getPiece(address) else {
            print("Could not find a piece at address \(address)")
            return []
        }
        var moves: [ChessPieceAddress] = []
        switch piece.type {
        case .king:
            let validator = KingMoveValidator(gameState: self.gameState, king: piece as! King)
            moves = validator.possibleMoves(from: address)
        default:
            break
        }
        return moves.filter { self.isFieldTaken(piece: piece, address: $0) }
    }

    private func isFieldTaken(piece: ChessPiece, address: ChessPieceAddress) -> Bool {
        guard let pieceOnAddress = self.gameState.getPiece(address) else {
            return true
        }
        if pieceOnAddress.color == piece.color {
            return false
        }
        return true
    }
}
