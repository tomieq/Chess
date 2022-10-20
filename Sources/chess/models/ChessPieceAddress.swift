//
//  ChessPieceAddress.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

struct ChessPieceAddress {
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

extension ChessPieceAddress: Equatable {}

extension ChessPieceAddress: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        guard value.count == 2,
              let firstLetter = value.first,
              let column = BoardColumn(firstLetter),
              let lastLetter = value.last,
              let row = Int("\(lastLetter)") else {
            print("Invalid text address(\(value)) while creating ChessPieceAddress")
            fatalError()
        }
        self.column = column
        self.row = row
    }
}

extension ChessPieceAddress: CustomStringConvertible {
    var description: String {
        "\(self.column.letter)\(self.row)"
    }
}

extension ChessPieceAddress {
    func move(_ direction: MoveDirection) -> ChessPieceAddress? {
        switch direction {
        case .right:
            return ChessPieceAddress(self.column.toRight, self.row)
        case .left:
            return ChessPieceAddress(self.column.toLeft, self.row)
        case .up:
            return ChessPieceAddress(self.column, self.row + 1)
        case .down:
            return ChessPieceAddress(self.column, self.row - 1)
        }
    }
}

extension ChessPieceAddress {
    func path(to destination: ChessPieceAddress) -> [ChessPieceAddress] {
        var addresses: [ChessPieceAddress?] = [self]
        if self.row == destination.row {
            // horizontal
            if self.column < destination.column {
                // to the right
                var toRight: ChessPieceAddress? = self
                while toRight.notNil, toRight!.column < destination.column {
                    toRight = toRight?.move(.right)
                    addresses.append(toRight)
                }
            }
            if self.column > destination.column {
                // to the left
                var toLeft: ChessPieceAddress? = self
                while toLeft.notNil, toLeft!.column > destination.column {
                    toLeft = toLeft?.move(.left)
                    addresses.append(toLeft)
                }
            }
        }
        if self.column == destination.column {
            // vertival
            if self.row < destination.row {
                // to up
                var toUp: ChessPieceAddress? = self
                while toUp.notNil, toUp!.row < destination.row {
                    toUp = toUp?.move(.up)
                    addresses.append(toUp)
                }
            }
            if self.row > destination.row {
                // to down
                var toDown: ChessPieceAddress? = self
                while toDown.notNil, toDown!.row > destination.row {
                    toDown = toDown?.move(.down)
                    addresses.append(toDown)
                }
            }
        }
        if destination.isDiagonal(to: self) {
            var horizontalDirection = MoveDirection.right
            var verticalDirection = MoveDirection.up

            if destination.row > self.row, destination.column < self.column {
                // top left
                horizontalDirection = .left
            } else if destination.row < self.row, destination.column < self.column {
                // bottom left
                verticalDirection = .down
                horizontalDirection = .left
            } else if destination.row < self.row, destination.column > self.column {
                // bottom right
                verticalDirection = .down
                horizontalDirection = .right
            }

            var next: ChessPieceAddress? = self
            while next.notNil, next! != destination {
                next = next?.move(verticalDirection)?.move(horizontalDirection)
                addresses.append(next)
            }
        }
        return addresses.compactMap{ $0 }
    }

    func isDiagonal(to destination: ChessPieceAddress) -> Bool {
        guard self != destination else {
            return false
        }
        let horizontalDistance = abs(self.column.rawValue - destination.column.rawValue)
        let verticalDistance = abs(self.row - destination.row)
        return horizontalDistance == verticalDistance
    }
}
