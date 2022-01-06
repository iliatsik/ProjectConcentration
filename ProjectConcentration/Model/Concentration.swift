//
//  Concentration.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var indexOfOneAndOnlyCard : Int?
    
    var scoreCount = 0
    
    func chooseCard(at index: Int){
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreCount += 2
                } else if cards[index].cardFlipCount > 0 || cards[matchIndex].cardFlipCount > 0 {
                    scoreCount -= 1
                }
                cards[index].isFaceUp = true
                cards[index].cardFlipCount += 1
                cards[matchIndex].cardFlipCount += 1
                indexOfOneAndOnlyCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyCard = index
            }
        }
    }
    
    func shuffleCards() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCard : Int){
        for _ in 0..<numberOfPairsOfCard {
            let card = Card()
            cards += [card, card]
        }
        shuffleCards()
    }
    
}
