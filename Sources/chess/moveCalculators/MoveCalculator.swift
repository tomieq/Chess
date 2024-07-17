//
//  MoveCalculator.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

protocol MoveCalculator {
    var moveCounter: Int { get }
    // fields where this piece can move (including possibleVictims)
    var possibleMoves: [BoardSquare] { get }
    
    // fields that this piece can attack
    var possibleVictims: [BoardSquare] { get }
    
    // fields that are defended by this piece
    var backedUpFriends: [BoardSquare] { get }
    
    // fields that defend this piece
    //var backingUpFriends: [BoardSquare] { get }
    
    // fields that this piece might get attack from
    var possiblePredators: [BoardSquare] { get }
}
