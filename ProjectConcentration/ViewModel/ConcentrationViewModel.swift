//
//  ConcentrationViewModel.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 14.01.22.
//

import Foundation

class ConcentrationViewModel : NSObject {
    var emoji = [Int:String]()
    var emojiChoices = [String]()
    private var quantity : Int?
    lazy var game = Concentration(numberOfPairsOfCard: quantity ?? 0)
    
    init(quantity: Int) {
        self.quantity = quantity
    }
    
    func emoji(for card: Card) -> String{
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            //Assigns emojis to cards and removes that emojis from the current array
            let randomIndex = emojiChoices.count.arc4random
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

