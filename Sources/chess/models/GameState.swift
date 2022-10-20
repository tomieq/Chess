//
//  GameState.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

typealias GamePiece = ChessPiece & MovableChessPiece

class GameState {
    var pieces: [GamePiece]

    init() {
        self.pieces = []
    }

    func addPiece(_ piece: GamePiece?) {
        guard let piece = piece else {
            return
        }
        self.pieces.append(piece)
    }

    func getPiece(_ address: ChessPieceAddress) -> GamePiece? {
        self.pieces.first{ $0.address == address }
    }
}
