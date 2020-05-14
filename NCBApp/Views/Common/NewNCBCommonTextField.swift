//
//  NewNCBCommonTextField.swift
//  NCBApp
//
//  Created by Thuan on 7/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

@objc protocol NewNCBCommonTextFieldDelegate: class {
    @objc optional func textFieldDidSelectRightArrow(_ textField: UITextField)
    @objc optional func textFieldDidChangeNameReminiscent(_ textField: UITextField, value: Bool)
}

fileprivate let normalColor = ColorName.normalText.color!
fileprivate let holderColor = ColorName.holderText.color!
fileprivate let normalFont = semiboldFont(size: 14)
fileprivate let holderFont = regularFont(size: 12)
let bottomLineTag = 999

class NewNCBCommonTextField: HoshiTextField {
    
    weak var customDelegate: NewNCBCommonTextFieldDelegate?
    fileprivate var switchBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        font = normalFont
        placeholderColor = holderColor
        placeholderFontScale = 1.0
        textColor = normalColor
        borderStyle = .none
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = ColorName.bottomLine.color
        bottomLine.tag = bottomLineTag
        
        addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = NumberConstant.commonHeightTextField
            }
        }
    }
    
    override func animateViewsForTextEntry() {
        super.animateViewsForTextEntry()
        
        if text!.isEmpty && isFirstResponder {
            placeholderLabel.textColor = holderColor
            placeholderLabel.font = holderFont
        } else if !text!.isEmpty {
            placeholderLabel.textColor = holderColor
            placeholderLabel.font = holderFont
        } else {
            placeholderLabel.textColor = normalColor
            placeholderLabel.font = normalFont
        }
    }
    
    override func animateViewsForTextDisplay() {
        super.animateViewsForTextDisplay()
        
        if text!.isEmpty {
            placeholderLabel.textColor = holderColor
            placeholderLabel.font = normalFont
        }
    }
    
    func addRightView(_ image: UIImage?) {
        let rightView = UIButton()
        rightView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightView.setImage(image, for: .normal)
        rightView.addTarget(self, action: #selector(didSelectRightArrow), for: .touchUpInside)
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    func addRightText(_ text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
        label.font = regularFont(size: 14)
        label.textColor = ColorName.normalText.color
        label.text = text
        label.textAlignment = .right
        
        self.rightView = label
        self.rightViewMode = .always
    }
    
    func addSaveButton() {
        switchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
        switchBtn?.setImage(R.image.unsave_beneficiary_btn(), for: .normal)
        switchBtn?.setImage(R.image.save_beneficiary_btn(), for: .selected)
        switchBtn?.isSelected = true
        switchBtn!.addTarget(self, action: #selector(switchChanged(_:)), for: .touchUpInside)
        
        let lbSave = UILabel()
        lbSave.text = "Lưu"
        lbSave.font = regularFont(size: 12)
        lbSave.textColor = ColorName.holderText.color
        self.addSubview(lbSave)

        lbSave.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-40)
        }
        
        self.rightView = switchBtn
        self.rightViewMode = .always
    }
    
    func addRightArrow(_ isDown: Bool? = false) {
        let arrow = UIButton()
        arrow.isUserInteractionEnabled = !(customDelegate == nil)
        arrow.setImage((isDown ?? true) ? R.image.ic_accessory_arrow_down() : R.image.ic_accessory_arrow_right(), for: .normal)
        arrow.addTarget(self, action: #selector(didSelectRightArrow), for: .touchUpInside)
        arrow.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        self.rightView = arrow
        self.rightViewMode = .always
    }
    
    @objc func didSelectRightArrow() {
        customDelegate?.textFieldDidSelectRightArrow?(self)
    }
    
    @objc func switchChanged(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        customDelegate?.textFieldDidChangeNameReminiscent?(self, value: sender.isSelected)
    }
    
    func clear() {
//        switchBtn?.isSelected = false
    }
    
    func isOnSaveBeneficiary() {
        switchBtn?.isSelected = true
    }
    
}
