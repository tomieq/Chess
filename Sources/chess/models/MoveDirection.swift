//
//  MoveDirection.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

enum MoveDirection: CaseIterable {
    case right
    case left
    case up
    case down
    case upRight
    case upLeft
    case downRight
    case downLeft
}

extension MoveDirection {
    var opposite: MoveDirection {
        switch self {
        case .right:
            .left
        case .left:
            .right
        case .up:
            .down
        case .down:
            .up
        case .upRight:
            .downLeft
        case .upLeft:
            .downRight
        case .downRight:
            .upLeft
        case .downLeft:
            .upRight
        }
    }
}
}
