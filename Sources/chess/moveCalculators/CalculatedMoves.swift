//
//  CalculatedMoves.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

struct CalculatedMoves {
    let possibleMoves: [BoardSquare]
    let possibleVictims: [BoardSquare]
    let backedUpFriends: [BoardSquare]
    let possiblePredators: [BoardSquare]
    
    
    static var `default`: CalculatedMoves {
        CalculatedMoves(possibleMoves: [], 
                        possibleVictims: [],
                        backedUpFriends: [],
                        possiblePredators: [])
    }
}
