//
//  KingMoveValidator.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class KingMoveValidator {
    let gameState: GameState
    let kingColor: ChessPieceColor

    init(gameState: GameState, kingColor: ChessPieceColor) {
        self.gameState = gameState
        self.kingColor = kingColor
    }

    func possibleMoves(prefilteredMoves: [ChessPieceAddress]) -> [ChessPieceAddress] {
        let moves = self.filterEnemyKingBarrier(prefilteredMoves: prefilteredMoves)
        return moves
    }

    private func filterEnemyKingBarrier(prefilteredMoves: [ChessPieceAddress]) -> [ChessPieceAddress] {
        let enemyKing = self.gameState.pieces.first{ $0.type == .king && $0.color == self.kingColor.other }
        guard let enemyKing = enemyKing else {
            print("Could not find enemy king!")
            return prefilteredMoves
        }
        let enemyKingBarrier = enemyKing.address.neighbours
        return prefilteredMoves.filter { address in
            !enemyKingBarrier.contains(address)
        }
    }
}
