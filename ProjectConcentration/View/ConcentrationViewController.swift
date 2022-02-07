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
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var collectionView : UICollectionView?

    private let presenter = ConcentrationPresenter(themeRepository: ThemeRepository() )
    
    lazy var isIpad = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        presenter.onLoad(cardButtonQuantity: (cardButtons.count + 1) / 2, concentrationPresenterDelegate: self)

        configureBackgroundColor()
        configureButton()
        configureCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureAutoLayout()
        
        //Here we activate three types of contrainsts, which is compatible for all devices
        NSLayoutConstraint.activate(regularConstraints)
        NSLayoutConstraint.activate(compactConstraints)
        
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayout()
    }
 
    private func layoutTrait(traitCollection: UITraitCollection) {
        
        if (traitCollection.horizontalSizeClass == .compact &&  traitCollection.verticalSizeClass == .regular) || (traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular)  {
            
            //Implementing auto layouts for iPhone's Portrait mode and iPad's Landscape and Portrait modes
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            if traitCollection.horizontalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
                //Here we increasing font size of the cards for iPad
                for index in 0...Int(ElementQuantity.button.rawValue - 1) { cardButtons[index].titleLabel?.font = .boldSystemFont(ofSize: FontSize.large.rawValue) }
                isIpad = true
            }
            
            //Adjusting restart button's, score and flip label's font size
            restartButton.titleLabel?.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
            flipCountLabel.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
            scoreCountLabel.font = .boldSystemFont(ofSize: FontSize.regular.rawValue)
            
            NSLayoutConstraint.activate(compactConstraints)
        } else { //For all other devices:
            
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
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
    
    private func configureCollectionView(){
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    private func configureCollectionViewLayout(){
        guard let collectionView = collectionView else { return }
        if isIpad {
            layout.itemSize = CGSize(width:collectionView.collectionViewLayout.collectionViewContentSize.width / 4 -
                                     collectionView.collectionViewLayout.collectionViewContentSize.width / 16,
                                     height: collectionView.collectionViewLayout.collectionViewContentSize.width / 5)
        } else {
            layout.itemSize = CGSize(width:collectionView.collectionViewLayout.collectionViewContentSize.width / 4 -
                                     collectionView.collectionViewLayout.collectionViewContentSize.width / 28,
                                     height: collectionView.collectionViewLayout.collectionViewContentSize.width / 4.6)
            
            
            let contentHeight: CGFloat = collectionView.frame.size.height
            let cellHeight: CGFloat = layout.itemSize.height * 5
            let cellSpacing: CGFloat = 10 * 4
            collectionView.contentInset = UIEdgeInsets(top: (contentHeight - cellHeight - cellSpacing) / 2, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func configureButton(){
        [self.scoreCountLabel,
         self.flipCountLabel].forEach { labelStackView.addArrangedSubview($0)}
    }
    
    private func configureAutoLayout() {
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        
        view.addSubview(labelStackView)
        view.addSubview(restartButton)
        
        regularConstraints.append(contentsOf: [
            /* For vertical stack view, we are using center x, which is defined as the view's quarter,
             center y as view's center y, height is defined as 4/5 of the view's height,width as half
             of the view's height */
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 4 - view.safeAreaInsets.right),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: AutoLayoutConstant.multiplierBig.rawValue),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: AutoLayoutConstant.multiplierHalf.rawValue),
            
            /* For labelStackView, which is score and count label, center Y is defined as half greater than
             or equal of the view's center Y, right anchor is connected with verticalStackView, constant 24,
             left anchor is connected with view, constants 48, and width is quarter of the view */
            labelStackView.centerYAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: view.centerYAnchor, multiplier: AutoLayoutConstant.multiplierHalf.rawValue),
            labelStackView.trailingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: AutoLayoutConstant.constantRegular.rawValue),
            labelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: AutoLayoutConstant.multiplierSmall.rawValue),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: AutoLayoutConstant.constantLarge.rawValue),
            
            /* Restart button's center X is connected with labelStackViews centerX, bottom corner is defined
             as verticalStackView bottom layout margin with constant 24, width is equal to label stack view's width */
            restartButton.centerXAnchor.constraint(equalTo: labelStackView.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.bottomAnchor, constant: AutoLayoutConstant.constantRegular.rawValue),
            restartButton.widthAnchor.constraint(equalTo: labelStackView.widthAnchor)
        ])
        
        compactConstraints.append(contentsOf: [
            /* For vertical stack view, we are using center x, which is defined as the view's center X,
             center y as view's center y with constant: view's top safe area multiplied by two, height is defined as 65/100 of the view's height, width as the view's height with constant: view's top safe area */
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                constant: -(view.safeAreaInsets.top * 2)),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: AutoLayoutConstant.multiplierRegular.rawValue),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                              constant: -(view.safeAreaInsets.top)),
            
            /* For labelStackView, top anchor is connected with verticalStackView's bottom anchor,
             width is equalt to of the vertical stack view, center X is defined as view's center X */
            labelStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                                constant: view.safeAreaInsets.top),
            labelStackView.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            /* Restart button's center X is connected with view's centerX, bottom anchor is connected with view's bottom anchor, constant: view's top safe area */
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo:   view.bottomAnchor,
                                                  constant:  -(view.safeAreaInsets.top))
        ])
    }
}

extension ConcentrationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.configure(button: cardButtons[indexPath.row])
        return cell
    }
}
