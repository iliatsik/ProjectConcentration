//
//  ConcentrationPresenter.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 27.01.22.
//

import Foundation

struct CardInfo {
    var index = Int()
    var title = String()
    var backgroundColor = String()
}

class ConcentrationPresenter{
    
    init(themeRepository: ThemeRepository) {
        self.themeRepository = themeRepository
    }
    
    private var themeRepository: ThemeRepository
    
    lazy var game = Concentration(numberOfPairsOfCard: cardButtonQuantity ?? 0)
    lazy var vc = ConcentrationViewController()
    //Quantity of the Buttons
    var cardButtonQuantity: Int?
    //Dictionary,there is index and emoji, we are passing it to the Model Concentration, with func(for card: Card) -> String
    var emoji = [Int : String]()
    //Current emojis
    var emojiChoices = [String]()
    //Quantity of emojis, it counts how many array do we have
    var themeQuantity: Int?
    var backgroundColor = String()
    var defaultColor = "Black"
    
    var scoreCount = 0
    var flipCount = 0
    
    var cardInfo = [CardInfo]()
    
    func onLoad(cardButtonQuantity: Int ) {
        //Set default index for new Game
        setDefaultIndexOfNewGame()
        //Set quantity of the Buttons, we are passing it to the Presenter
        self.cardButtonQuantity = cardButtonQuantity
        setTheme()
        firstUpdateCardModel()
        //Set Background Color and Emojis
    }
    
    func setTheme() { //Pass background color and emojis for UI
        guard let backgroundColor = themeRepository.getThemeEmoji(with: themeQuantity ?? 0).1 else { return }
        guard let emojiChoices = themeRepository.getThemeEmoji(with: themeQuantity ?? 0).0 else {return }
        
        self.backgroundColor = backgroundColor
        self.emojiChoices = emojiChoices
    }
    
    func onCardButton(cardNumber: Int) {
        //passing cardNumber to model Concentration, where we define score and check if it is facedUp or Matched
        game.chooseCard(at: cardNumber)
        //Its duty is to define UI, when it's faced up or it's not, implements emoji as title and background color
        updateCardModel()
        //Set score counter label to Model Concentration's scoreCount property
        scoreCount = game.scoreCount
        if !game.cardList[cardNumber].isMatched { flipCount += 1 }
    }
    
    func setDefaultIndexOfNewGame() {
        themeQuantity = Int.random(in: 0..<themeRepository.emojiForTheme.count ) //Initializing random integer for new game from the theme array
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            //Assigns emojis to cards and removes that emojis from the current array
            let randomIndex = Int.random(in: 0..<emojiChoices.count)
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func firstUpdateCardModel() {
        for index in Constants.indices {
            cardInfo.append(.init(index: index,
                                  title: "",
                                  backgroundColor: backgroundColor ))
        }
    }
    
    func updateCardModel() {
        //We are getting indices of the cardButtons and implementing its condition
        for index in Constants.indices {
            let card = game.cardList[index]
            cardInfo[index].index = index
            cardInfo[index].title = card.isFaceUp ? emoji(for: card) : ""
            cardInfo[index].backgroundColor = card.isFaceUp ? defaultColor : backgroundColor
            if card.isMatched {
                cardInfo[index].backgroundColor = defaultColor;
                cardInfo[index].title = ""
            }
        }
    }
    
    func onRestartButton(cardButtonQuantity: Int) {
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
        updateCardModel()
        //Card Shuffle
        game.shuffleCards()
        //Re-implements background color for the Labels and Buttons
        flipCount = 0
        scoreCount = 0
    }
}
