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
        let prefilteredMoves = self.filterAddressesTakenByOwnArmy(piece: piece, basicMoves: piece.basicMoves)
        switch piece.type {
        case .king:
            let validator = KingMoveValidator(gameState: self.gameState, kingColor: piece.color)
            return validator.possibleMoves(prefilteredMoves: prefilteredMoves)
        default:
            break
        }
        return prefilteredMoves
    }

    private func filterAddressesTakenByOwnArmy(piece: ChessPiece, basicMoves: [ChessPieceAddress]) -> [ChessPieceAddress] {
        basicMoves.filter { [weak self] address in
            guard let pieceOnAddress = self?.gameState.getPiece(address) else {
                return true
            }
            if pieceOnAddress.color == piece.color {
                return false
            }
            return true
        }
    }
}
