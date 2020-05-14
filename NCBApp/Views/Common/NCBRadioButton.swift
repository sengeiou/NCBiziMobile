//
//  NCBRadioButton.swift
//  NCBApp
//
//  Created by Thuan on 8/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRadioButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    fileprivate func setupView() {
        titleLabel?.font = regularFont(size: NumberConstant.smallFontSize)
        setTitleColor(ColorName.holderText.color, for: .normal)
        setImage(R.image.ic_radio_uncheck(), for: .normal)
        setImage(R.image.ic_radio_check(), for: .selected)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
    
}
