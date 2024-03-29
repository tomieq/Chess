//
//  ChessPieceColor.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

enum ChessPieceColor: String, CaseIterable {
    case white
    case black
}

extension ChessPieceColor {
    var other: ChessPieceColor {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
}

extension ChessPieceColor {
    var plName: String {
        switch self {
        case .white:
            return "biały"
        case .black:
            return "czarny"
        }
    }
}
