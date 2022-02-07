//
//  ConcentrationPresenter.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 27.01.22.
//

import Foundation

protocol ConcentrationPresenterDelegate : AnyObject {
    func getCardButtonInfo(withIndex: Int, isFaceUp: Bool, isMatched: Bool, title: String, backgroundColor: String)
    var flipCount : Int { get set }
    var scoreCount : Int { get set }
}

class ConcentrationPresenter{
    
    init(themeRepository: ThemeRepository){
        self.themeRepository = themeRepository
    }

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
    var defaultColor = "Black"
    
    func onLoad(cardButtonQuantity: Int, concentrationPresenterDelegate: ConcentrationPresenterDelegate){
        self.concentrationPresenterDelegate = concentrationPresenterDelegate
        //Set default index for new Game
        setDefaultIndexOfNewGame()
        //Set quantity of the Buttons, we are passing it to the Presenter
        self.cardButtonQuantity = cardButtonQuantity
        //Set Background Color and Emojis
        setTheme()
    }
    
    func setTheme() { //Pass background color and emojis for UI
        guard let backgroundColor = themeRepository.getThemeEmoji(with: themeQuantity ?? 0).1 else { return }
        guard let emojiChoices = themeRepository.getThemeEmoji(with: themeQuantity ?? 0).0 else {return }
        
        self.backgroundColor = backgroundColor
        self.emojiChoices = emojiChoices
    }
    
    func onCardButton(cardNumber: Int, indices: Range<Int>){
        concentrationPresenterDelegate?.flipCount += 1
        //passing cardNumber to model Concentration, where we define score and check if it is facedUp or Matched
        game.chooseCard(at: cardNumber)
        //Its duty is to define UI, when it's faced up or it's not, implements emoji as title and background color
        updateCardModel(cardButtonsRange: indices)
        //Set score counter label to Model Concentration's scoreCount property
        concentrationPresenterDelegate?.scoreCount = game.scoreCount
    }
    
    func setDefaultIndexOfNewGame(){
        themeQuantity = Int.random(in: 0..<themeRepository.emojiForTheme.count ) //Initializing random integer for new game from the theme array
    }
    
    func emoji(for card: Card) -> String{
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            //Assigns emojis to cards and removes that emojis from the current array
            let randomIndex = Int.random(in: 0..<emojiChoices.count)
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
                                                                  backgroundColor: defaultColor)
            }else{
                concentrationPresenterDelegate?.getCardButtonInfo(withIndex: index,
                                                                  isFaceUp: false,
                                                                  isMatched: card.isMatched,
                                                                  title: "",
                                                                  backgroundColor: backgroundColor)
            }
        }
    }
    
    func onRestartButton(cardButtonQuantity: Int, indices: Range<Int>){
        //Set default index for new Game
        setDefaultIndexOfNewGame()
        //Removes past identifier, boolean isMatched, isFaceUp and cardFlipCounter
        game.cardList.removeAll()
        //Removes past emojis from the Dictionary
        emoji.removeAll()
        //Set Background Color and Emojis for new Game
        setTheme()
        //Re-implements number of cards
        game = Concentration(numberOfPairsOfCard: cardButtonQuantity)
        //Its duty is to define UI, when it's faced up or it's not, implements emoji as title and background color
        updateCardModel(cardButtonsRange: indices)
        //Card Shuffle
        game.shuffleCards()
        //Re-implements background color for the Labels and Buttons
        concentrationPresenterDelegate?.flipCount = 0
        concentrationPresenterDelegate?.scoreCount = 0
    }
  
}
