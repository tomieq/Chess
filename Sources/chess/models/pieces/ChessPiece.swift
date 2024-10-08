//
//  ChessPiece.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation


public struct ChessPiece {
    public let type: ChessPieceType
    public let color: ChessPieceColor
    public let square: BoardSquare
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
    
    func moved(to square: BoardSquare) -> ChessPiece {
        ChessPiece(DetachedChessPiece(type,
                                      color,
                                      square,
                                      longDistanceAttackDirections: longDistanceAttackDirections),
                   moveCalculator)
    }
}

extension ChessPiece {
    public var fenLetter: String {
        var letter = self.type == .pawn ? "P" : self.type.enLetter
        if self.color == .black {
            letter = letter.lowercased()
        }
        return letter
    }
}

extension ChessPiece: Equatable {
    public static func == (lhs: ChessPiece, rhs: ChessPiece) -> Bool {
        lhs.color == rhs.color && lhs.square == rhs.square && lhs.type == rhs.type
    }
}

extension ChessPiece: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.color)
        hasher.combine(self.square)
    }
}

extension ChessPiece: CustomStringConvertible {
    public var description: String {
        "\(self.color.enName) \(self.type.enName) on \(self.square)"
    }
}
