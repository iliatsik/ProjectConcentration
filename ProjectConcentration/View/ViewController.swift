//
//  ViewController.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import UIKit


class ViewController: UIViewController {
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var compactCompactConstraints: [NSLayoutConstraint] = []
    
    private var concentrationViewModel : ConcentrationViewModel!
    
    //Property observer for Count label
    private var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }

    //Property observer for Score label
    private var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }
    
    private var randomIndexOfEmoji = 0
    private var randomColor = UIColor()
    
    private lazy var randomEmojiGame = [animalEmojiChoices, flagEmojiChoices, foodEmojiChoices]
    
    private let animalEmojiChoices = Theme(cardColor: .systemOrange, emojiList:
                                    ["🐝","🐒","🐍","🦂","🦕","🦞","🪱", "🦃","🐋","🦌","🦚","🐩","🦒","🐕‍🦺","🦤","🦔"])
    private let flagEmojiChoices = Theme(cardColor: .systemGreen, emojiList: ["🇧🇷","🇧🇪","🇬🇪","🇩🇪","🇪🇸","🇺🇸","🏴󠁧󠁢󠁷󠁬󠁳󠁿","🏴󠁧󠁢󠁳󠁣󠁴󠁿","🇿🇦","🇳🇴","🇳🇿","🇲🇽","🇮🇹","🇯🇵","🇮🇩","🇬🇷"])
    private let foodEmojiChoices = Theme(cardColor: .systemPurple, emojiList:
                                    ["🍏","🍎","🍐","🍇","🍒","🍓","🥐","🍗","🫑","🧀","🥑","🧁","🍫","🍿","🥗","🫐"])
    
    //Creating Count Label Programmatically
    private var flipCountLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = UIRelated.buttonCornerRadius.rawValue
        label.text = "Flips: 0"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIRelated.boldFontSize.rawValue)
        label.textColor = .black
        return label
    }()
    
    //Creating Score Label Programmatically
    private var scoreCountLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = UIRelated.buttonCornerRadius.rawValue
        label.textAlignment = .center
        label.text = "Score: 0"
        label.font = .boldSystemFont(ofSize: UIRelated.boldFontSize.rawValue)
        label.textColor = .black
        return label
    }()
    
    //Creating Restart Button Programmatically
    private var restartButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = UIRelated.buttonCornerRadius.rawValue
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Restart", for: .normal)
        button.addTarget(self, action: #selector(restartAction(sender:)), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: UIRelated.boldFontSize.rawValue)
        return button
    }()
    
    //Creating 20 Card Button Programmatically
    private var cardButtons : [UIButton] = {
        var buttonArray = [UIButton]()
        for _ in 0...19 {
            let button = UIButton()
            button.backgroundColor = .orange
            button.layer.cornerRadius = UIRelated.labelCornerRadius.rawValue
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitle("", for: .normal)
            buttonArray.append(button)
        }
        return buttonArray
    }()
    
    //Creating Stack View for Score and Count label Programmatically
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //Creating vertical Stack views, where we put 5 horizontal stack views
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //Creating horizontal Stack views, where we put 4 card button
    private lazy var hStackView: [UIStackView] = {
        var stackViewArray = [UIStackView]()
        for _ in 0...4{
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.spacing = 12.0
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackViewArray.append(stackView)
        }
        return stackViewArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        implementViewModel()
        interfaceImplementation()
        buttonImplementation()
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureAutoLayout()
        
        //Here we activate three types of contrainsts, which is compatible for all devices
        NSLayoutConstraint.activate(regularConstraints)
        NSLayoutConstraint.activate(compactConstraints)
        NSLayoutConstraint.activate(compactCompactConstraints)
        
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    private func layoutTrait(traitCollection:UITraitCollection) {
        
        if (traitCollection.horizontalSizeClass == .compact &&  traitCollection.verticalSizeClass == .regular) || (traitCollection.horizontalSizeClass == .regular &&
            traitCollection.verticalSizeClass == .regular)  {
            //Implementing auto layouts for iPhone's Portrait mode and iPad's Landscape and Portrait modes
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
                NSLayoutConstraint.deactivate(compactCompactConstraints)
            }
            if traitCollection.horizontalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
                //Here we increasing font size of the cards for iPad
                for index in 0...19 { cardButtons[index].titleLabel?.font = .boldSystemFont(ofSize: 80) }
            }
            
            //Adjusting restart button's, score and flip label's font size
            restartButton.titleLabel?.font = .boldSystemFont(ofSize: UIRelated.boldFontSize.rawValue)
            flipCountLabel.font = .boldSystemFont(ofSize: UIRelated.boldFontSize.rawValue)
            scoreCountLabel.font = .boldSystemFont(ofSize: UIRelated.boldFontSize.rawValue)
            NSLayoutConstraint.activate(compactConstraints)
            
        } else if (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact) {
            //Implementing auto layouts for little sized iPhone's Landscape mode
            if compactCompactConstraints.count > 0 && compactCompactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
                NSLayoutConstraint.deactivate(compactConstraints)
            }

            //Adjusting restart button's, score and flip label's font size
            //Adjusting stack view, where we have count and score label, axis mode to vertical from horizontal
            restartButton.titleLabel?.font = .boldSystemFont(ofSize: UIRelated.regularFontSize.rawValue)
            flipCountLabel.font = .boldSystemFont(ofSize: UIRelated.regularFontSize.rawValue)
            scoreCountLabel.font = .boldSystemFont(ofSize: UIRelated.regularFontSize.rawValue)
            labelStackView.axis = .vertical
            NSLayoutConstraint.activate(compactCompactConstraints)
            
        }  else { //For all other devices:
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
                NSLayoutConstraint.deactivate(compactCompactConstraints)
            }
         
            //Adjusting restart button's, score and flip label's font size
            //Adjusting stack view, where we have count and score label, axis mode to vertical from horizontal
            restartButton.titleLabel?.font = .boldSystemFont(ofSize: UIRelated.regularFontSize.rawValue)
            flipCountLabel.font = .boldSystemFont(ofSize: UIRelated.regularFontSize.rawValue)
            scoreCountLabel.font = .boldSystemFont(ofSize: UIRelated.regularFontSize.rawValue)
            labelStackView.axis = .vertical
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    private func configureAutoLayout() {
        view.addSubview(vStackView)
        view.addSubview(labelStackView)
        view.addSubview(restartButton)
        
        regularConstraints.append(contentsOf: [
            /* For vertical stack view, we are using center x, which is defined as the view's quarter,
            center y as view's center y, height is defined as 4/5 of the view's height,width as half
            of the view's height */
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 4 - view.safeAreaInsets.right),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            /* For labelStackView, which is score and count label, center Y is defined as half greater than
             or equal of the view's center Y, right anchor is connected with verticalStackView, constant 24,
             left anchor is connected with view, constants 48, and width is quarter of the view */
            labelStackView.centerYAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: view.centerYAnchor, multiplier: 0.5),
            labelStackView.trailingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: -24), 
            labelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 48),
            
            /* Restart button's center X is connected with labelStackViews centerX, bottom corner is defined
             as verticalStackView bottom layout margin with constant 24, width is equal to label stack view's width */
            restartButton.centerXAnchor.constraint(equalTo: labelStackView.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: vStackView.layoutMarginsGuide.bottomAnchor, constant: -24),
            restartButton.widthAnchor.constraint(equalTo: labelStackView.widthAnchor)
        ])
 
        compactConstraints.append(contentsOf: [
            /* For vertical stack view, we are using center x, which is defined as the view's center X,
            center y as view's center y with constant: view's top safe area multiplied by two, height is defined as 65/100 of the view's height, width as the view's height with constant: view's top safe area */
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                constant: -(view.safeAreaInsets.top * 2)),
            vStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                              constant: -(view.safeAreaInsets.top)),
            
            /* For labelStackView, top anchor is connected with verticalStackView's bottom anchor,
             width is equalt to of the vertical stack view, center X is defined as view's center X */
            labelStackView.topAnchor.constraint(equalTo: vStackView.bottomAnchor,
                                                constant: view.safeAreaInsets.top),
            labelStackView.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            /* Restart button's center X is connected with view's centerX, bottom anchor is connected with view's bottom anchor, constant: view's top safe area */
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo:   view.bottomAnchor,
                                                  constant:  -(view.safeAreaInsets.top))
        ])

        compactCompactConstraints.append(contentsOf: [
            /* For vertical stack view, we are using center x, which is defined as the view's quarter,
            center y as view's center y, height is defined as 95/100 of the view's height,width as 65/100
            of the view's height */
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor,
                                                constant: view.frame.width / 4),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.95),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            
            /* For labelStackView, center Y is defined as half greater than
             or equal of the view's center Y, right anchor is connected with verticalStackView, constant 364,
             left anchor is connected with view, constants 36, and width is 1/5 of the view */
            labelStackView.centerYAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: view.centerYAnchor, multiplier: 0.5),
            labelStackView.trailingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: -36),
            labelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            
            /* Restart button's center X is connected with labelStackViews centerX, bottom corner is defined
             as verticalStackView bottom layout margin with constant view's top safe area, width is equal to label stack view's width */
            restartButton.centerXAnchor.constraint(equalTo: labelStackView.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: vStackView.layoutMarginsGuide.bottomAnchor, constant: -(view.safeAreaInsets.top)),
            restartButton.widthAnchor.constraint(equalTo: labelStackView.widthAnchor)
        ])
    }
    
    @objc private func buttonAction(sender: UIButton!) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            concentrationViewModel.game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreCount = concentrationViewModel.game.scoreCount
        } else {
            print("error")
        }
    }
    
    @objc private func restartAction(sender: UIButton!) {
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
    
    private func buttonImplementation(){
        //Appending card in the stack view's and horizontal stack view in the vertical stack view
       [self.cardButtons[0],
        self.cardButtons[1],
        self.cardButtons[2],
        self.cardButtons[3]].forEach { hStackView[0].addArrangedSubview($0) }
       
       [self.cardButtons[4],
        self.cardButtons[5],
        self.cardButtons[6],
        self.cardButtons[7]].forEach { hStackView[1].addArrangedSubview($0) }
       
       [self.cardButtons[8],
        self.cardButtons[9],
        self.cardButtons[10],
        self.cardButtons[11]].forEach { hStackView[2].addArrangedSubview($0) }
       
       [self.cardButtons[12],
        self.cardButtons[13],
        self.cardButtons[14],
        self.cardButtons[15]].forEach { hStackView[3].addArrangedSubview($0) }
       
       [self.cardButtons[16],
        self.cardButtons[17],
        self.cardButtons[18],
        self.cardButtons[19]].forEach { hStackView[4].addArrangedSubview($0) }
       
       [self.hStackView[0],
        self.hStackView[1],
        self.hStackView[2],
        self.hStackView[3],
        self.hStackView[4]].forEach { vStackView.addArrangedSubview($0) }
       
       [self.scoreCountLabel,
        self.flipCountLabel].forEach { labelStackView.addArrangedSubview($0)}
   }
   
    private func implementViewModel() {
        //Passing card button's quantity to ConcentrationViewModel
        self.concentrationViewModel = ConcentrationViewModel(quantity: (cardButtons.count + 1) / 2)
    }
   
    private func updateViewFromModel() {
       for index in cardButtons.indices {
           let button = cardButtons[index]
           let card = concentrationViewModel.game.cardList[index]
           if card.isFaceUp {
               button.setTitle(concentrationViewModel.emoji(for: card), for: .normal)
               button.titleLabel?.font = .systemFont(ofSize: UIRelated.labelFontSize.rawValue)
               button.backgroundColor = .black
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
      //Implementing new game's
      randomIndexOfEmoji = randomEmojiGame.count.arc4random
      randomColor = randomEmojiGame[randomIndexOfEmoji].cardColor
      concentrationViewModel.emojiChoices = randomEmojiGame[randomIndexOfEmoji].emojiList
      restartButton.backgroundColor = randomColor
      scoreCountLabel.backgroundColor = randomColor
      flipCountLabel.backgroundColor = randomColor
      for button in cardButtons {
          button.layer.cornerRadius = UIRelated.buttonCornerRadius.rawValue
          button.backgroundColor = randomColor
      }
  }
   
   
}

