//
//  ChessBoard+js.swift
//  chess
//
//  Created by Tomasz Kucharski on 12/08/2024.
//
import chess

extension ChessBoard {
    var jsPosition: [String:String] {
        var position: [String:String] = [:]
        for piece in self.allPieces {
            position[piece.square.description] = piece.letter
        }
        return position
    }
}
