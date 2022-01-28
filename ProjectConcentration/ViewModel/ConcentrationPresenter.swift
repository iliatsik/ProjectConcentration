//
//  ConcentrationPresenter.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 27.01.22.
//

import Foundation

import Foundation

protocol ConcentrationPresenterDelegate : AnyObject {
    func getCardButtonInfo(withIndex: Int, isFaceUp: Bool, isMatched: Bool, title: String, backgroundColor: String)
}

class ConcentrationPresenter{
    weak private var concentrationPresenterDelegate : ConcentrationPresenterDelegate?
    private var themeRepository: ThemeRepository
    lazy var game = Concentration(numberOfPairsOfCard: cardButtonQuantity ?? 0)

    //Quantity of the Buttons
    var cardButtonQuantity : Int?
    //Dictionary,there is index and emoji, we are passing it to the Model Concentration, with func(for card: Card) -> String
    var emoji = [Int:String]()
    //Current emojis
    var emojiChoices = [String]()
    //Quantity of emojis, it counts how many array do we have
    var themeQuantity : Int?
    var backgroundColor = String()
    
    init(themeRepository: ThemeRepository){
        self.themeRepository = themeRepository
    }

    func setDefaultIndexOfNewGame(){
        themeQuantity = themeRepository.emojiForTheme.count.arc4random //Initializing random integer for new game from the theme array
    }
    
    func setTheme() { //Pass background color and emojis for UI
        guard let backgroundColor = themeRepository.getThemeEmoji(with: themeQuantity ?? 0).1 else { return }
        guard let emojiChoices = themeRepository.getThemeEmoji(with: themeQuantity ?? 0).0 else {return }

        self.backgroundColor = backgroundColor
        self.emojiChoices = emojiChoices
    }
    
    //Used for implementing Delegate
    func setViewDelegate(concentrationPresenterDelegate: ConcentrationPresenterDelegate?){
           self.concentrationPresenterDelegate = concentrationPresenterDelegate
    }
    
    func emoji(for card: Card) -> String{
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            //Assigns emojis to cards and removes that emojis from the current array
            let randomIndex = emojiChoices.count.arc4random
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    
    func updateCardModel(cardButtonsRange: Range<Int>){
        //We are getting indices of the cardButtons and implementing its condition
        for index in cardButtonsRange {
            let card = game.cardList[index]

            if card.isFaceUp{
                concentrationPresenterDelegate?.getCardButtonInfo(withIndex: index,
                                                                  isFaceUp: true,
                                                                  isMatched: card.isMatched,
                                                                  title: emoji(for: card),
                                                                  backgroundColor: "black")
            }else{
                concentrationPresenterDelegate?.getCardButtonInfo(withIndex: index,
                                                                  isFaceUp: false,
                                                                  isMatched: card.isMatched,
                                                                  title: "",
                                                                  backgroundColor: backgroundColor)
            }
        }
    }
    
    func restartGame(){
        //Set default index for new Game
        setDefaultIndexOfNewGame()
        //Removes past identifier, boolean isMatched, isFaceUp and cardFlipCounter
        game.cardList.removeAll()
        //Removes past emojis from the Dictionary
        emoji.removeAll()
        //Set Background Color and Emojis for new Game
        setTheme()
    }
}
