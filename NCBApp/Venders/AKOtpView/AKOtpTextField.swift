//
//  AKOtpTextField.swift
//  AKOtpView
//
//  Created by ِAdham Alkhateeb on 8/13/18.
//  Copyright © 2018 Klindayzer. All rights reserved.
//

import UIKit
import SnapKit

protocol AKOtpTextFieldDelegate {
    func backSpaceClicked(_ textField: AKOtpTextField)
    func codeSet(_ textField: AKOtpTextField, codeReceived: String)
}

class AKOtpTextField: UITextField, UITextFieldDelegate {
    
    private var isIB: Bool {
        #if TARGET_INTERFACE_BUILDER
        return true
        #endif
        return false
    }
    
    // MARK: - Properities
    var akDelegate: AKOtpTextFieldDelegate!
    var codeReceived = ""
    
    var borderErrorColor: UIColor!
    var borderNormalColor: UIColor! {
        didSet {
            layer.borderColor = borderNormalColor.cgColor
        }
    }
    var borderFillColor: UIColor!
    var textErrorColor: UIColor!
    var textNormalColor: UIColor! {
        didSet {
            textColor = textNormalColor
        }
    }
    var shapeType: AKShapeType!
    var customBorderWidth: CGFloat = 0.0
    var index: Int!
    
    var isError: Bool? {
        didSet {
            layer.borderColor = isError! ? borderErrorColor.cgColor : borderNormalColor.cgColor
            textColor = isError! ? textErrorColor : textNormalColor
            
            if !isError! {
                text = ""
            }
        }
    }
    
    
    // MARK: - UITextField
    override func draw(_ rect: CGRect) {
        
        guard !isIB else { return }
        
        if shapeType == .circle {
            
//            layer.cornerRadius = frame.size.height / 2.0
//            layer.borderWidth = customBorderWidth
//            clipsToBounds = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard !isIB else { return }
        
        delegate = self
        textAlignment = .center
        textColor = textNormalColor
        keyboardType = .numberPad
        
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "6B6B6B")
        addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalToSuperview()
        }
        
        addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldEditingDidChange(_ sender: Any) {
        if let text = self.text {
            layer.borderColor = !text.isEmpty ? borderFillColor.cgColor : borderNormalColor.cgColor
            textColor = textNormalColor
        } else {
            layer.borderColor = borderNormalColor.cgColor
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
//        codeReceived.append(string)
//        if codeReceived.count == NumberConstant.numberOfOTPDigits {
//            Timer.timer(withTimeInterval: 0.01, repeats: false, block: {
//                self.akDelegate.codeSet(self, codeReceived: self.codeReceived)
//                self.codeReceived = ""
//            })
//            return false
//        }
        
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length
        
        let isMaxLenght = newLength <= 1
        
        if isMaxLenght {
            Timer.timer(withTimeInterval: 0.01, repeats: false, block: {
                self.akDelegate.codeSet(self, codeReceived: "")
            })
        }
        return isMaxLenght
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        Timer.timer(withTimeInterval: 0.01, repeats: false, block: {
            self.akDelegate.backSpaceClicked(self)
        })
    }
}
