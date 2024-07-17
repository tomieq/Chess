//
//  BoardSquare.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

struct BoardSquare {
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

extension BoardSquare: Equatable {}
extension BoardSquare: Hashable {}

extension BoardSquare: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        guard value.count == 2,
              let firstLetter = value.first,
              let column = BoardColumn(firstLetter),
              let lastLetter = value.last,
              let row = Int("\(lastLetter)") else {
            print("Invalid text address(\(value)) while creating BoardSquare")
            fatalError()
        }
        self.column = column
        self.row = row
    }
}

extension BoardSquare: CustomStringConvertible {
    var description: String {
        "\(self.column.letter)\(self.row)"
    }
}

extension BoardSquare {
    func move(_ direction: MoveDirection) -> BoardSquare? {
        switch direction {
        case .right:
            return BoardSquare(self.column.toRight, self.row)
        case .left:
            return BoardSquare(self.column.toLeft, self.row)
        case .up:
            return BoardSquare(self.column, self.row + 1)
        case .down:
            return BoardSquare(self.column, self.row - 1)
        case .upRight:
            return BoardSquare(self.column.toRight, self.row + 1)
        case .upLeft:
            return BoardSquare(self.column.toLeft, self.row + 1)
        case .downRight:
            return BoardSquare(self.column.toRight, self.row - 1)
        case .downLeft:
            return BoardSquare(self.column.toLeft, self.row - 1)
        }
    }
}

extension BoardSquare {
    func squares(to direction: MoveDirection) -> [BoardSquare] {
        var moves: [BoardSquare?] = []
        var square: BoardSquare? = self
        for _ in 1..<8 {
            square = square?.move(direction)
            if square.isNil {
                break
            }
            moves.append(square)
        }
        return moves.compactMap { $0 }
    }
}

extension BoardSquare {
    var knightMoves: [BoardSquare] {
        [
            self.move(.right)?.move(.upRight),
            self.move(.right)?.move(.downRight),
            self.move(.left)?.move(.upLeft),
            self.move(.left)?.move(.downLeft),
            self.move(.up)?.move(.upRight),
            self.move(.up)?.move(.upLeft),
            self.move(.down)?.move(.downRight),
            self.move(.down)?.move(.downLeft)
        ].compactMap { $0 }
    }
}

extension BoardSquare {
    var neighbours: [BoardSquare] {
        MoveDirection.allCases.compactMap { self.move($0) }
    }
}
