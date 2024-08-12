//
//  ChessPiece+extension.swift
//  chess
//
//  Created by Tomasz Kucharski on 05/08/2024.
//
import chess

extension ChessPiece {
    var letter: String {
        var letter = self.type == .pawn ? "P" : self.type.enLetter
        if self.color == .white {
            letter = letter.lowercased()
        }
        return letter
    }
}
