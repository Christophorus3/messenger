//
//  BaseCell.swift
//  Messenger
//
//  Created by Christoph Wottawa on 22.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .white
    }
}
