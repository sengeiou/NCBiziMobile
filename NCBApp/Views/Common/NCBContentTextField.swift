//
//  NCBContentTextField.swift
//  NCBApp
//
//  Created by Thuan on 7/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBContentTextField: NewNCBCommonTextField, UITextFieldDelegate {
    
    var allowUnlimit = false
    var limitValue = 100
    
    override func initView() {
        super.initView()
        
//        for view in self.subviews {
//            if view.tag == bottomLineTag {
//                view.backgroundColor = UIColor.clear
//            }
//        }
        
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if allowUnlimit {
            return true
        }
        
//        if string.count > 1 {
//            return false
//        }
        
        if string == "" {
            return true
        }
        
        var currentText = textField.text ?? ""
        let acceptableStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 -."
        let cs = NSCharacterSet(charactersIn: acceptableStr).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if currentText.count < limitValue && string == filtered {
            currentText = currentText.folding(options: .diacriticInsensitive, locale: .current)
            textField.text = currentText + string
        }
        
        return false
    }
    
}
