//
//  ViewController.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCard: (cardButtons.count + 1 ) / 2)
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
    private var emojiChoices = [String]()
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreCountLabel: UILabel!
    @IBOutlet private weak var restartLabel: UIButton!
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartLabel.layer.cornerRadius = 18
        scoreCountLabel.layer.masksToBounds = true
        scoreCountLabel.layer.cornerRadius = 18
        flipCountLabel.layer.masksToBounds = true
        flipCountLabel.layer.cornerRadius = 18
        interfaceImplementation()
    }
    
    @IBAction private func touchRestart(_ sender: UIButton) {
        interfaceImplementation()
        game.cards.removeAll()
        emoji.removeAll()
        game = Concentration(numberOfPairsOfCard: (cardButtons.count + 1 ) / 2)
        updateViewFromModel()
        game.shuffleCards()
        flipCount = 0
        scoreCount = 0
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreCount = game.scoreCount
        } else {
            print("error")
        }
    }

    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 60)
                button.backgroundColor = .white
                button.isEnabled = false
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : randomColor
                button.isEnabled = true
            }
        }
    }
    
    private func interfaceImplementation() {
        randomIndexOfEmoji = randomEmojiGame.count.arc4random
        randomColor = randomEmojiGame[randomIndexOfEmoji].cardColor
        emojiChoices = randomEmojiGame[randomIndexOfEmoji].emoji
        restartLabel.backgroundColor = randomColor
        scoreCountLabel.backgroundColor = randomColor
        flipCountLabel.backgroundColor = randomColor
        for button in cardButtons {
            button.layer.cornerRadius = 12
            button.backgroundColor = randomColor
        }
    }
    
    private lazy var randomEmojiGame = [animalEmojiChoices, flagEmojiChoices, foodEmojiChoices]
    
    private var animalEmojiChoices = Theme(cardColor: .systemOrange, emoji:
        ["🐝","🐒","🐍","🦂","🦕","🦞","🪱", "🦃","🐋","🦌","🦚","🐩","🦒","🐕‍🦺","🦤","🦔"])
    private var flagEmojiChoices = Theme(cardColor: .systemGreen, emoji: ["🇧🇷","🇧🇪","🇬🇪","🇩🇪","🇪🇸","🇺🇸","🏴󠁧󠁢󠁷󠁬󠁳󠁿","🏴󠁧󠁢󠁳󠁣󠁴󠁿","🇿🇦","🇳🇴","🇳🇿","🇲🇽","🇮🇹","🇯🇵","🇮🇩","🇬🇷"])
    private var foodEmojiChoices = Theme(cardColor: .systemPurple, emoji:
        ["🍏","🍎","🍐","🍇","🍒","🍓","🥐","🍗","🫑","🧀","🥑","🧁","🍫","🍿","🥗","🫐"])
    

    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String{
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.count.arc4random 
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
}
