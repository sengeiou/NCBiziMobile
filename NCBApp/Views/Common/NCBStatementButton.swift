//
//  NCBStatementButton.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBStatementButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        clipsToBounds = true
        backgroundColor = UIColor(hexString: "0083DC")
        layer.cornerRadius = self.frame.size.height/2
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = semiboldFont(size: 12)
        titleLabel?.adjustsFontSizeToFitWidth = true
        addShadow(offset: CGSize(width: 0, height: 3), color: UIColor.black, opacity: 0.15, radius: 3)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func destructiveType() {
        backgroundColor = UIColor(hexString: "9EBBD4")
    }
    
    func normalType() {
        backgroundColor = UIColor(hexString: "0083DC")
    }
    
}
