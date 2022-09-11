//
//  BoardAdress.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

enum BoardColumn: Int, Equatable {
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h
}

extension BoardColumn {
    var toRight: BoardColumn? {
        BoardColumn(rawValue: self.rawValue + 1)
    }

    var toLeft: BoardColumn? {
        BoardColumn(rawValue: self.rawValue - 1)
    }
}

struct ChessPiecePosition {
    let column: BoardColumn
    let row: Int

    init?(_ column: BoardColumn?, _ row: Int) {
        guard row <= 8, row >= 1, let column = column else {
            return nil
        }
        self.row = row
        self.column = column
    }
}

extension ChessPiecePosition: Equatable {}

extension ChessPiecePosition{
    func move(_ direction: MoveDirection) -> ChessPiecePosition? {
        switch direction {
        case .right:
            return ChessPiecePosition(self.column.toRight, self.row)
        case .left:
            return ChessPiecePosition(self.column.toLeft, self.row)
        case .up:
            return ChessPiecePosition(self.column, self.row + 1)
        case .down:
            return ChessPiecePosition(self.column, self.row - 1)
        }
    }
}
