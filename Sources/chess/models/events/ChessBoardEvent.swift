//
//  ChessBoardEvent.swift
//  
//
//  Created by Tomasz on 06/08/2024.
//

import Foundation

enum ChessBoardEvent {
    case pieceAdded(at: [BoardSquare])
    case pieceMoved(ChessBoardMove)
    case pieceRemoved(from: BoardSquare)
}
