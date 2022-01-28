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
    var identifier = UUID().hashValue
    var cardFlipCount = 0
}
