//
//  NCBIncomeTextField.swift
//  NCBApp
//
//  Created by Thuan on 9/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBIncomeTextField: NewNCBCommonTextField, UITextFieldDelegate {
    
    override func initView() {
        super.initView()
        
        keyboardType = .numberPad
        addTarget(self, action: #selector(moneyEditingChanged), for: .editingChanged)
        delegate = self
        
        addRightText("VND")
    }
    
    @objc func moneyEditingChanged() {
        let money = self.text!.removeSpecialCharacter
        if let moneyValaue = Double(money) {
            self.text = moneyValaue.formattedWithDotSeparator
        }
    }
    
    var getAmount: Double {
        return Double(self.text!.removeSpecialCharacter) ?? 0.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        let numericRegEx = "[0-9]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", numericRegEx)
        return predicate.evaluate(with: string)
    }
    
}
