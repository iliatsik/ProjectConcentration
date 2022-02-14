//
//  ViewController.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import UIKit

enum Constants {
    static let buttonCount: Int = 20
    static let indices: Range<Int> = 0..<buttonCount
    static let ElementQuantityOfButton: CGFloat = 20.0
    static let SpacingSizeSmall: CGFloat = 12.0
    static let SpacingSizeRegular: CGFloat = 20.0
    static let FontSizeRegular: CGFloat = 35.0
    static let FontSizeBig: CGFloat = 45.0
    static let CornerRadiusRegular: CGFloat = 18.0
    static let CornerRadiusSmall: CGFloat = 12.0
}

class ConcentrationViewController: UIViewController {
    
    private var constraints: [NSLayoutConstraint] = []
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var collectionView : UICollectionView?
    private let presenter = ConcentrationPresenter(themeRepository: ThemeRepository() )

    //Creating Count Label Programmatically
    private var flipCountTitle : UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.CornerRadiusSmall
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: Constants.FontSizeRegular)
        label.textColor = .black
        return label
    }()
    
    //Creating Score Label Programmatically
     private var scoreCountTitle : UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.CornerRadiusSmall
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: Constants.FontSizeRegular)
        label.textColor = .black
        return label
    }()
    
    //Creating Restart Button Programmatically
    private var restartButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.CornerRadiusSmall
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Restart", for: .normal)
        button.addTarget(self, action: #selector(restartAction(sender:)), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.FontSizeRegular)
        return button
    }()

    //Creating Stack View for Score and Count label Programmatically
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Constants.SpacingSizeRegular
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        presenter.onLoad(cardButtonQuantity: Constants.buttonCount / 2)
        
        configureCounterLabels()
        configureBackgroundColor()
        configureLabelStackView()
        configureCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureAutoLayout()
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayout()
    }
}

extension ConcentrationViewController { //Private Functions
    
    @objc private func onCardButton(sender: UIButton) {
        presenter.onCardButton(cardNumber: sender.tag)
        configureCounterLabels()
        collectionView?.reloadData()
    }
    
    @objc private func restartAction(sender: UIButton) {
        presenter.onRestartButton(cardButtonQuantity: Constants.buttonCount / 2)
        configureCounterLabels()
        configureBackgroundColor()
        collectionView?.reloadData()
    }
    
    private func configureBackgroundColor() {
        //Set background color for Restart,Card Buttons and Flip,Score Label
        restartButton.backgroundColor = UIColor(named: presenter.backgroundColor)
        scoreCountTitle.backgroundColor = UIColor(named: presenter.backgroundColor)
        flipCountTitle.backgroundColor = UIColor(named: presenter.backgroundColor)
    }
    
    private func configureCounterLabels() {
        scoreCountTitle.text = "Score: \(presenter.scoreCount)"
        flipCountTitle.text = "Flips: \(presenter.flipCount)"
    }
    
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CollectionViewCell.self) )
        collectionView.backgroundColor = UIColor.black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView else { return }
   
            layout.itemSize = CGSize(width:collectionView.collectionViewLayout.collectionViewContentSize.width / 4 -
                                     collectionView.collectionViewLayout.collectionViewContentSize.width / 28,
                                     height: collectionView.collectionViewLayout.collectionViewContentSize.width / 4.6)

            let contentHeight: CGFloat = collectionView.frame.size.height
            let cellHeight: CGFloat = layout.itemSize.height * 5
            let cellSpacing: CGFloat = 10 * 4
            collectionView.contentInset = UIEdgeInsets(top: (contentHeight - cellHeight - cellSpacing) / 2, left: 0, bottom: 0, right: 0)
    }
    
    private func configureLabelStackView() {
        [self.scoreCountTitle,
         self.flipCountTitle].forEach { labelStackView.addArrangedSubview($0)}
    }
    
    private func configureAutoLayout() {
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        view.addSubview(labelStackView)
        view.addSubview(restartButton)
        
        constraints.append(contentsOf: [
            /* For Collection view, we are using center x, which is defined as the view's center X,
             center y as view's center y with constant: view's top safe area multiplied by two, height is defined as 65/100 of the view's height, width as the view's height with constant: view's top safe area */
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                constant: -(view.safeAreaInsets.top * 2)),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                              constant: -(view.safeAreaInsets.top)),
            
            /* For labelStackView, top anchor is connected with Collection View's bottom anchor,
             width is equal to the Collection View, center X is defined as view's center X */
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

extension ConcentrationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.buttonCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell else { return UICollectionViewCell.init() }
        cell.button.addTarget(self, action: #selector(onCardButton(sender:)), for: .touchUpInside)
        
        cell.configure(backgroundColor: presenter.cardInfo[indexPath.row].backgroundColor,
                       title: presenter.cardInfo[indexPath.row].title,
                       tag: indexPath.row)

        return cell
    }
}
