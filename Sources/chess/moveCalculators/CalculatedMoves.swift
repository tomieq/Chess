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
    let possiblePredators: [BoardSquare]
    let defended: [BoardSquare]
    let defenders: [BoardSquare]
    
    
    static var `default`: CalculatedMoves {
        CalculatedMoves(possibleMoves: [],
                        possibleVictims: [],
                        possiblePredators: [],
                        defended: [],
                        defenders: [])
    }
}
