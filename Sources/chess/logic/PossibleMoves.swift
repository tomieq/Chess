//
//  PossibleMoves.swift
//  
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

struct PossibleMoves {
    let passive: [ChessPieceAddress]
    let agressive: [ChessPieceAddress]
}

extension PossibleMoves {
    var count: Int {
        self.passive.count + self.agressive.count
    }
}
