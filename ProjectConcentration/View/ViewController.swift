//
//  ViewController.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import UIKit

class ViewController: UIViewController {

    private var concentrationViewModel : ConcentrationViewModel!
    
    private var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    private var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }

    private var randomIndexOfEmoji = 0
    private var randomColor = UIColor()
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreCountLabel: UILabel!
    @IBOutlet private weak var restartLabel: UIButton!
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        implementViewModel()
        updateUI()
        interfaceImplementation()
    }
    
    private func implementViewModel() {
        self.concentrationViewModel = ConcentrationViewModel(quantity: (cardButtons.count + 1) / 2)
    }
    
    private func updateUI() {
        restartLabel.layer.cornerRadius =
            UIRelated.labelCornerRadius.rawValue
        scoreCountLabel.layer.masksToBounds = true
        scoreCountLabel.layer.cornerRadius = UIRelated.labelCornerRadius.rawValue
        flipCountLabel.layer.masksToBounds = true
        flipCountLabel.layer.cornerRadius = UIRelated.labelCornerRadius.rawValue
    }
    @IBAction private func touchRestart(_ sender: UIButton) {
        //Chooses random theme
        interfaceImplementation()
        //Removes current games card implementation and emojis
        concentrationViewModel.game.cardList.removeAll()
        concentrationViewModel.emoji.removeAll()
        //Assigns the quantity of the cards
        concentrationViewModel.game = Concentration(numberOfPairsOfCard: (cardButtons.count + 1 ) / 2)
        //Button Implementation
        updateViewFromModel()
        //Card Shuffle
        concentrationViewModel.game.shuffleCards()
        flipCount = 0
        scoreCount = 0
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            concentrationViewModel.game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreCount = concentrationViewModel.game.scoreCount
        } else {
            print("error")
        }
    }

    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = concentrationViewModel.game.cardList[index]
            if card.isFaceUp {
                button.setTitle(concentrationViewModel.emoji(for: card), for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: UIRelated.labelFontSize.rawValue)
                button.backgroundColor = .white
                button.isEnabled = false
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : randomColor
                button.isEnabled = true
                if button.backgroundColor == .clear { button.isEnabled = false }
            }
        }
    }
    
    private func interfaceImplementation() {
        randomIndexOfEmoji = randomEmojiGame.count.arc4random
        randomColor = randomEmojiGame[randomIndexOfEmoji].cardColor
        concentrationViewModel.emojiChoices = randomEmojiGame[randomIndexOfEmoji].emojiList
        restartLabel.backgroundColor = randomColor
        scoreCountLabel.backgroundColor = randomColor
        flipCountLabel.backgroundColor = randomColor
        for button in cardButtons {
            button.layer.cornerRadius = UIRelated.buttonCornerRadius.rawValue
            button.backgroundColor = randomColor
        }
    }
    
    private lazy var randomEmojiGame = [animalEmojiChoices, flagEmojiChoices, foodEmojiChoices]
    
    private let animalEmojiChoices = Theme(cardColor: .systemOrange, emojiList:
        ["🐝","🐒","🐍","🦂","🦕","🦞","🪱", "🦃","🐋","🦌","🦚","🐩","🦒","🐕‍🦺","🦤","🦔"])
    private let flagEmojiChoices = Theme(cardColor: .systemGreen, emojiList: ["🇧🇷","🇧🇪","🇬🇪","🇩🇪","🇪🇸","🇺🇸","🏴󠁧󠁢󠁷󠁬󠁳󠁿","🏴󠁧󠁢󠁳󠁣󠁴󠁿","🇿🇦","🇳🇴","🇳🇿","🇲🇽","🇮🇹","🇯🇵","🇮🇩","🇬🇷"])
    private let foodEmojiChoices = Theme(cardColor: .systemPurple, emojiList:
        ["🍏","🍎","🍐","🍇","🍒","🍓","🥐","🍗","🫑","🧀","🥑","🧁","🍫","🍿","🥗","🫐"])
    
}


enum UIRelated : CGFloat {
    case labelCornerRadius = 18
    case buttonCornerRadius = 12
    case labelFontSize = 60
}
