//
//  CollectionViewCell.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 07.02.22.
//

import UIKit


class CollectionViewCell: UICollectionViewCell {

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

    func configure(backgroundColor: String, title: String, tag: Int) {
        button.backgroundColor = UIColor(named: backgroundColor)
        button.setTitle(title, for: .normal)
        button.tag = tag
    }
}
