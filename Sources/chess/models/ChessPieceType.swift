//
//  ChessPieceType.swift
//
//
//  Created by Tomasz on 10/09/2022.
//

import Foundation

enum ChessPieceType: CaseIterable {
    case king
    case queen
    case rook
    case bishop
    case knight
    case pawn
}

extension ChessPieceType {
    var enName: String {
        switch self {
        case .king:
            return "King"
        case .queen:
            return "Queen"
        case .rook:
            return "Rook"
        case .bishop:
            return "Bishop"
        case .knight:
            return "Knight"
        case .pawn:
            return "Pawn"
        }
    }

    var enLetter: String {
        switch self {
        case .king:
            return "K"
        case .queen:
            return "Q"
        case .rook:
            return "R"
        case .bishop:
            return "B"
        case .knight:
            return "N"
        case .pawn:
            return ""
        }
    }

    var plName: String {
        switch self {
        case .king:
            return "król"
        case .queen:
            return "hetman"
        case .rook:
            return "wieża"
        case .bishop:
            return "goniec"
        case .knight:
            return "skoczek"
        case .pawn:
            return "pion"
        }
    }

    var plLetter: String {
        switch self {
        case .king:
            return "K"
        case .queen:
            return "H"
        case .rook:
            return "W"
        case .bishop:
            return "G"
        case .knight:
            return "S"
        case .pawn:
            return ""
        }
    }
}

extension ChessPieceType {
    static func make(letter: String, language: Language) -> ChessPieceType? {
        switch language {
        case .english:
            return Self.allCases.first{ $0.enLetter.first == letter.first }
        case .polish:
            return Self.allCases.first{ $0.plLetter.uppercased().first == letter.first }
        }
    }
}
