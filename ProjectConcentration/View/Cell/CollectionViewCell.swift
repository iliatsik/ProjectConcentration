//
//  CollectionViewCell.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 07.02.22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "cell"

    var button : UIButton?

    override func layoutSubviews() {
        super.layoutSubviews()
        button?.frame = CGRect(x: 0, y: 0,
                                  width: contentView.frame.size.width,
                                  height: contentView.frame.size.height)
    }
    
    func configure(button: UIButton){
        self.button = button
        contentView.addSubview(button)
    }
}
