//
//  Concentration.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import Foundation

class Concentration {
    
    init(numberOfPairsOfCard : Int){
        for _ in 0..<numberOfPairsOfCard {
            let card = Card()
            cardList += [card, card]
        }
        shuffleCards()
    }
    
    var cardList = [Card]()
    
    private var indexOfOneAndOnlyCard : Int?
    
    var scoreCount = 0
    
    func chooseCard(at index: Int){
        //It's a declaration of cards, we are implement these statements, while cards aren't matching, just to define the exact score
        
        guard cardList[index].isMatched else {
            if let matchIndex = indexOfOneAndOnlyCard, matchIndex != index {
                if cardList[matchIndex].identifier == cardList[index].identifier {
                    //If cards matched, then we will assign boolean isMatched to true and we will update score label and add two point
                    cardList[matchIndex].isMatched = true
                    cardList[index].isMatched = true
                    scoreCount += 2
                } else if cardList[index].cardFlipCount > 0 || cardList[matchIndex].cardFlipCount > 0 {
                    //If we repeat and tap same card, score will be decreased by one point
                    scoreCount -= 1
                }
                cardList[index].isFaceUp = true
                //Here we mark used cards
                cardList[index].cardFlipCount += 1
                cardList[matchIndex].cardFlipCount += 1
                indexOfOneAndOnlyCard = nil
            } else {
                for flipDownIndex in cardList.indices {
                    //Hides emojis
                    cardList[flipDownIndex].isFaceUp = false
                }
                cardList[index].isFaceUp = true
                indexOfOneAndOnlyCard = index
            }
            return
        }
    }
    
    func shuffleCards() {
        cardList.shuffle()
    }
    
}
