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
    var identifier = Card.getUniqueIdentifier()
    var cardFlipCount = 0
    
    static func getUniqueIdentifier() -> Int {
        let uuid = UUID().uuidString
        let numericFormUUID = Int(uuid.hash)
        return numericFormUUID
    }
    
}
