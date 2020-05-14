//
//  UIImageViewExtension.swift
//  NCBApp
//
//  Created by Thuan on 2/19/20.
//  Copyright © 2020 tvo. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func changeTintColor(_ image: UIImage?, color: String = "0083DC") {
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor(hexString: color)
    }
    
}
