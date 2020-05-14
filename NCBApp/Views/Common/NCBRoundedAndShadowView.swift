//
//  NCBRoundedAndShadowView.swift
//  NCBApp
//
//  Created by Thuan on 7/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRoundedAndShadowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    fileprivate func initView() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.13
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
    }
    
}
