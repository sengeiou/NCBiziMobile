//
//  UICollectionViewExtension.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

extension UICollectionViewCell {
    func configure() {
        
//        self.contentView.layer.cornerRadius = 12.0
//        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.gray.cgColor
//
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
//        self.layer.shadowOpacity = 0.7
//        self.layer.shadowRadius = 12.0
//        self.layer.masksToBounds = false
//        self.layer.cornerRadius = 8
//        self.clipsToBounds = false
        
        self.contentView.layer.cornerRadius = 6.0
        self.contentView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5 //0.13
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.clipsToBounds = false
    }
}
