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

    init?(_ textAddress: String) {
        guard textAddress.count == 2,
              let firstLetter = textAddress.first,
              let column = BoardColumn(firstLetter),
              let lastLetter = textAddress.last,
              let row = Int("\(lastLetter)") else {
            print("Invalid text address(\(textAddress)) while creating ChessPieceAddress")
            return nil
        }
        self.column = column
        self.row = row
    }
}

extension ChessPieceAddress: Equatable {}

extension ChessPieceAddress{
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
