//
//  NCBCommonButton.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCommonButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawGradient(horizontal: true)
    }
    
    fileprivate func setupView() {
        clipsToBounds = true
        layer.cornerRadius = self.frame.size.height/2
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = displayBoldFont(size: 14)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
     func drawGradient (horizontal: Bool){
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        let cyan: UIColor = UIColor.init(red: 0, green: 72/255, blue: 173/255, alpha: 1)
        
        let green: UIColor = UIColor.init(red: 9/255, green: 152/255, blue: 227/255, alpha: 1)
        
        gradient.colors = [cyan.cgColor, green.cgColor]
        
        if (horizontal  == true) {
            // Hoizontal - commenting these two lines will make the gradient veritcal
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        // gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
}
