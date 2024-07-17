//
//  ChessPiece.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation


struct ChessPiece {
    let type: ChessPieceType
    let color: ChessPieceColor
    let square: BoardSquare
    let longDistanceAttackDirections: [MoveDirection]
    let moveCalculator: MoveCalculator

    init(_ detached: DetachedChessPiece,
         _ moveCalculator: MoveCalculator) {
        self.type = detached.type
        self.color = detached.color
        self.longDistanceAttackDirections = detached.longDistanceAttackDirections
        self.square = detached.square
        self.moveCalculator = moveCalculator
    }
}

extension ChessPiece: Equatable {
    static func == (lhs: ChessPiece, rhs: ChessPiece) -> Bool {
        lhs.color == rhs.color && lhs.square == rhs.square && lhs.type == rhs.type
    }
}

extension ChessPiece: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.color)
        hasher.combine(self.square)
    }
}

extension ChessPiece: CustomStringConvertible {
    var description: String {
        "\(self.color.plName) \(self.type.plName) z \(self.square)"
    }
}
