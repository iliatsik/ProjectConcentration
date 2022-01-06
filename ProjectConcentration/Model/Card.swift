//
//  Card.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier : Int
    var cardFlipCount = 0

    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
