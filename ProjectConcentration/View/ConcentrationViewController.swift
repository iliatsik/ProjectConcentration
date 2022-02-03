//
//  ViewController.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import UIKit


class ConcentrationViewController: UIViewController {
    
    enum CornerRadiusSize : CGFloat {
        case regular = 18
        case small = 12
    }
    
    enum FontSize : CGFloat{
        case large = 80
        case big = 45
        case regular = 35
        case small = 25
    }
    
    enum SpacingSize : CGFloat{
        case small = 12.0
        case regular = 20.0
    }
    
    enum ElementQuantity : CGFloat{
        case button = 20
        case stackView = 5
    }
    
    enum AutoLayoutConstant : CGFloat{
        case constantSmall = -36
        case constantRegular = -24
        case constantBig = 36
        case constantLarge = 48
        case multiplierLittle = 0.2
        case multiplierSmall = 0.25
        case multiplierHalf = 0.5
        case multiplierRegular = 0.65
        case multiplierBig = 0.8
        case multiplierLarge = 0.95
    }
    
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var compactCompactConstraints: [NSLayoutConstraint] = []
    
    
    private let presenter = ConcentrationPresenter(themeRepository: ThemeRepository() )
    
    //Property observer for Count label
    var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    //Property observer for Score label
    var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }
    
    //Creating Count Label Programmatically
    private var flipCountLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = CornerRadiusSize.small.rawValue
        label.text = "Flips: 0"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
        label.textColor = .black
        return label
    }()
    
    //Creating Score Label Programmatically
    private var scoreCountLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = CornerRadiusSize.small.rawValue
        label.textAlignment = .center
        label.text = "Score: 0"
        label.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
        label.textColor = .black
        return label
    }()
    
    //Creating Restart Button Programmatically
    private var restartButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = CornerRadiusSize.small.rawValue
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Restart", for: .normal)
        button.addTarget(self, action: #selector(restartAction(sender:)), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
        return button
    }()
    
    //Creating 20 Card Button Programmatically
    private var cardButtons : [UIButton] = {
        var buttonArray = [UIButton]()
        for _ in 0...Int(ElementQuantity.button.rawValue - 1) {
            let button = UIButton()
            button.backgroundColor = .orange
            button.layer.cornerRadius = CornerRadiusSize.regular.rawValue
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(onCardButton(sender:)), for: .touchUpInside)
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
        stackView.spacing = SpacingSize.regular.rawValue
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //Creating vertical Stack views, where we put 5 horizontal stack views
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = SpacingSize.small.rawValue
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //Creating horizontal Stack views, where we put 4 card button
    private lazy var hStackView: [UIStackView] = {
        var stackViewArray = [UIStackView]()
        for _ in 0...Int(ElementQuantity.stackView.rawValue - 1){
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.spacing = SpacingSize.small.rawValue
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackViewArray.append(stackView)
        }
        return stackViewArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        presenter.onViewDidLoad(cardButtonQuantity: (cardButtons.count + 1) / 2, concentrationPresenterDelegate: self)
        configureBackgroundColor()
        configureButton()
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
                for index in 0...Int(ElementQuantity.button.rawValue - 1) { cardButtons[index].titleLabel?.font = .boldSystemFont(ofSize: FontSize.large.rawValue) }
            }
            
            //Adjusting restart button's, score and flip label's font size
            restartButton.titleLabel?.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
            flipCountLabel.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
            scoreCountLabel.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
            NSLayoutConstraint.activate(compactConstraints)
            
        } else if (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact) {
            //Implementing auto layouts for little sized iPhone's Landscape mode
            if compactCompactConstraints.count > 0 && compactCompactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            
            //Adjusting restart button's, score and flip label's font size
            //Adjusting stack view, where we have count and score label, axis mode to vertical from horizontal
            restartButton.titleLabel?.font = .boldSystemFont(ofSize: FontSize.small.rawValue)
            flipCountLabel.font = .boldSystemFont(ofSize: FontSize.small.rawValue)
            scoreCountLabel.font = .boldSystemFont(ofSize: FontSize.small.rawValue)
            labelStackView.axis = .vertical
            NSLayoutConstraint.activate(compactCompactConstraints)
            
        }  else { //For all other devices:
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
                NSLayoutConstraint.deactivate(compactCompactConstraints)
            }
            
            //Adjusting restart button's, score and flip label's font size
            //Adjusting stack view, where we have count and score label, axis mode to vertical from horizontal
            restartButton.titleLabel?.font = .boldSystemFont(ofSize: FontSize.small.rawValue)
            flipCountLabel.font = .boldSystemFont(ofSize: FontSize.small.rawValue)
            scoreCountLabel.font = .boldSystemFont(ofSize: FontSize.small.rawValue)
            labelStackView.axis = .vertical
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
}

extension ConcentrationViewController : ConcentrationPresenterDelegate{
    func getCardButtonInfo(withIndex: Int, isFaceUp: Bool, isMatched: Bool, title: String, backgroundColor: String){
        //We are passing this function with delegate, to receive the information about current button and set its properties
        let button = cardButtons[withIndex]
        if isFaceUp{
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: FontSize.big.rawValue)
            button.backgroundColor = UIColor(named: backgroundColor)
            button.isEnabled = false
        } else{
            button.setTitle("", for: .normal)
            button.backgroundColor = isMatched ? .clear : UIColor(named: backgroundColor)
            button.isEnabled = true
            if button.backgroundColor == .clear { button.isEnabled = false }
        }
    }
}

extension ConcentrationViewController{ //Private Functions
    
    @objc private func onCardButton(sender: UIButton!) {
        //Checking if cardButton's index is nil or not
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            presenter.onCardButton(cardNumber: cardNumber, indices: cardButtons.indices)
        } else {
            print("error")
        }
    }
    
    @objc private func restartAction(sender: UIButton!) {
        presenter.onRestartButton(cardButtonQuantity: (cardButtons.count + 1) / 2, indices: cardButtons.indices)
        configureBackgroundColor()
    }
    
    private func configureBackgroundColor() {
        //Set background color for Restart,Card Buttons and Flip,xScore Label
        restartButton.backgroundColor = UIColor(named: presenter.backgroundColor)
        scoreCountLabel.backgroundColor = UIColor(named: presenter.backgroundColor)
        flipCountLabel.backgroundColor = UIColor(named: presenter.backgroundColor)
        cardButtons.forEach { button in
            button.layer.cornerRadius = CornerRadiusSize.small.rawValue
            button.backgroundColor = UIColor(named: presenter.backgroundColor)
        }
    }
    
    private func configureButton(){
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
            vStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: AutoLayoutConstant.multiplierBig.rawValue),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: AutoLayoutConstant.multiplierHalf.rawValue),
            
            /* For labelStackView, which is score and count label, center Y is defined as half greater than
             or equal of the view's center Y, right anchor is connected with verticalStackView, constant 24,
             left anchor is connected with view, constants 48, and width is quarter of the view */
            labelStackView.centerYAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: view.centerYAnchor, multiplier: AutoLayoutConstant.multiplierHalf.rawValue),
            labelStackView.trailingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: AutoLayoutConstant.constantRegular.rawValue),
            labelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: AutoLayoutConstant.multiplierSmall.rawValue),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: AutoLayoutConstant.constantLarge.rawValue),
            
            /* Restart button's center X is connected with labelStackViews centerX, bottom corner is defined
             as verticalStackView bottom layout margin with constant 24, width is equal to label stack view's width */
            restartButton.centerXAnchor.constraint(equalTo: labelStackView.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: vStackView.layoutMarginsGuide.bottomAnchor, constant: AutoLayoutConstant.constantRegular.rawValue),
            restartButton.widthAnchor.constraint(equalTo: labelStackView.widthAnchor)
        ])
        
        compactConstraints.append(contentsOf: [
            /* For vertical stack view, we are using center x, which is defined as the view's center X,
             center y as view's center y with constant: view's top safe area multiplied by two, height is defined as 65/100 of the view's height, width as the view's height with constant: view's top safe area */
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                constant: -(view.safeAreaInsets.top * 2)),
            vStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: AutoLayoutConstant.multiplierRegular.rawValue),
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
            vStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: AutoLayoutConstant.multiplierLarge.rawValue),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: AutoLayoutConstant.multiplierRegular.rawValue),
            
            /* For labelStackView, center Y is defined as half greater than
             or equal of the view's center Y, right anchor is connected with verticalStackView, constant 364,
             left anchor is connected with view, constants 36, and width is 1/5 of the view */
            labelStackView.centerYAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: view.centerYAnchor, multiplier: AutoLayoutConstant.multiplierHalf.rawValue),
            labelStackView.trailingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: AutoLayoutConstant.constantSmall.rawValue),
            labelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: AutoLayoutConstant.multiplierLittle.rawValue),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AutoLayoutConstant.constantBig.rawValue),
            
            /* Restart button's center X is connected with labelStackViews centerX, bottom corner is defined
             as verticalStackView bottom layout margin with constant view's top safe area, width is equal to label stack view's width */
            restartButton.centerXAnchor.constraint(equalTo: labelStackView.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: vStackView.layoutMarginsGuide.bottomAnchor, constant: -(view.safeAreaInsets.top)),
            restartButton.widthAnchor.constraint(equalTo: labelStackView.widthAnchor)
        ])
    }
}
