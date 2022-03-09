//
//  CollectionViewCell.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 07.02.22.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func onCardButton(index: Int)
}

class CollectionViewCell: UICollectionViewCell {

    weak var delegate: CollectionViewCellDelegate?
    
    var button : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.CornerRadiusRegular
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.FontSizeBig)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = contentView.bounds
    }
    
    func configure(delegate: CollectionViewCellDelegate, cardInfo: CardInfo, at index: Int) {
        self.delegate = delegate
        button.backgroundColor = UIColor(named: cardInfo.backgroundColor)
        button.setTitle(cardInfo.title, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(onCardButton), for: .touchUpInside)
    }
    
    @objc private func onCardButton() {
        delegate?.onCardButton(index: button.tag)
    }
}
