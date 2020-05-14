//
//  NCBCurrencyTextField.swift
//  NCBApp
//
//  Created by Thuan on 4/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBCurrencyTextFieldDelegate: class {
    func textFieldEditingAmount(_ textField: UITextField, value: String)
}


class NCBCurrencyTextField: NCBCommonTextField, UITextFieldDelegate {
    
    weak var amountDelegate: NCBCurrencyTextFieldDelegate?
    
    override func initView() {
        super.initView()
        setRightPaddingPoints(8.0)
        self.addTarget(self, action: #selector(moneyEditingChanged), for: .editingChanged)
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @objc func moneyEditingChanged() {
        let money = self.text!.removeSpecialCharacter
        if let moneyValaue = Double(money) {
            self.text = moneyValaue.formattedWithDotSeparator
        }
        amountDelegate?.textFieldEditingAmount(self, value: getCurrencySpellOut())
    }
    
    func getCurrencySpellOut() -> String {
        let money = self.text!.removeSpecialCharacter
        if let moneyValaue = Double(money) {
            return moneyValaue.asWord.firstUppercased + " đồng"
        } else {
            return ""
        }
    }
    
}
