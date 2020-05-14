//
//  UIButtonExtension.swift
//  NCBApp
//
//  Created by Thuan on 7/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

extension UIButton {
    
    func underline(text: String, font: UIFont, color: UIColor? = nil) {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: (color == nil) ? ColorName.buttonBlueText.color! : color,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: text, attributes: attrs)
        self.setAttributedTitle(attributeString, for: .normal)
    }
    
    func drawGradient (fristColor:UIColor,secondColor:UIColor, horizontal: Bool){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [fristColor.cgColor, secondColor.cgColor]
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
