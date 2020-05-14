//
//  UIViewExtension.swift
//  NCBApp
//
//  Created by Thuan on 3/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let emptyMsgTag = 1507

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return 0
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clear
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return 0
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 40.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 40.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func drawGradient (startColor: UIColor, endColor: UIColor){
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        let cyan: UIColor = endColor
        
        let green: UIColor = startColor
        
        gradient.colors = [cyan.cgColor, green.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func tableEmptyMessage(_ isEmpty: Bool, msg: String? = nil) {
        for view in self.subviews {
            if view.tag == emptyMsgTag {
                view.removeFromSuperview()
                break
            }
        }
        
        let lbMsg = UILabel()
        if !isEmpty {
            lbMsg.text = ""
        } else {
            lbMsg.text = (msg != nil) ? msg : "Chưa có dữ liệu"
        }
        lbMsg.textColor = UIColor.black
        lbMsg.font = semiboldFont(size: 14)
        lbMsg.textColor = UIColor(hexString: "959595")
        lbMsg.tag = emptyMsgTag
        addSubview(lbMsg)
        
        lbMsg.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}


