//
//  NCBTransferAmountView.swift
//  NCBApp
//
//  Created by Thuan on 7/15/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SnapKit

class NCBTransferAmountView: UIView {
    
    var textField: NewNCBCommonTextField!
    fileprivate var lbAmount: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        textField = NewNCBCommonTextField()
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(moneyEditingChanged), for: .editingChanged)
        textField.addRightText("VND")
        addSubview(textField)
        
        for view in textField.subviews {
            if view.tag == bottomLineTag {
                view.backgroundColor = UIColor.clear
            }
        }
        
        textField.placeholder = "Số tiền chuyển"
        
        textField.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(NumberConstant.commonHeightTextField)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hexString: "EDEDED")
        
        addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        lbAmount = UILabel()
        lbAmount.font = semiboldFont(size: 12)
        lbAmount.textColor = UIColor(hexString: "6B6B6B")
        lbAmount.numberOfLines = 0
        lbAmount.isHidden = true
        addSubview(lbAmount)
        
        lbAmount.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(-5)
        }
        
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = NumberConstant.commonHeightTextField
            }
        }
    }
    
    @objc func moneyEditingChanged() {
        let money = textField.text!.removeSpecialCharacter
        if let moneyValaue = Double(money) {
            textField.text = moneyValaue.formattedWithDotSeparator
        }
        
        let spellStr = getCurrencySpellOut()
        lbAmount.text = spellStr
        lbAmount.isHidden = (spellStr == "")
        
        let height = spellStr.height(withConstrainedWidth: textField.frame.width, font: textField.font!)
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (spellStr == "") ? NumberConstant.commonHeightTextField : (NumberConstant.commonHeightTextField + height + 3)
            }
        }
    }
    
    func getCurrencySpellOut() -> String {
        let money = textField.text!.removeSpecialCharacter
        if let moneyValaue = Double(money) {
            return moneyValaue.asWord.firstUppercased + " đồng"
        } else {
            return ""
        }
    }
    
    func clear() {
        textField.text = ""
        lbAmount.text = ""
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = NumberConstant.commonHeightTextField
            }
        }
    }
    
}
