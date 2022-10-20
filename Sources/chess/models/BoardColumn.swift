//
//  BoardColumn.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

enum BoardColumn: Int, Equatable, CaseIterable {
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

extension BoardColumn {
    init?(_ letter: Character) {
        guard let column = (BoardColumn.allCases.first{ $0.letter == letter }) else {
            return nil
        }
        self = column
    }

    var letter: Character {
        switch self {
        case .a:
            return "a"
        case .b:
            return "b"
        case .c:
            return "c"
        case .d:
            return "d"
        case .e:
            return "e"
        case .f:
            return "f"
        case .g:
            return "g"
        case .h:
            return "h"
        }
    }
}
