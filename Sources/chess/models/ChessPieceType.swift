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

    var plName: String {
        switch self {
        case .king:
            return "Król"
        case .queen:
            return "Hetman"
        case .rook:
            return "Wieża"
        case .bishop:
            return "Goniec"
        case .knight:
            return "Skoczek"
        case .pawn:
            return "Pion"
        }
    }
}
