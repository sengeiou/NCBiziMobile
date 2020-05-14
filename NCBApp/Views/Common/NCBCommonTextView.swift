//
//  NCBCommonTextView.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCommonTextView: UITextView {
    
    var placeholderString: String? {
        didSet {
            text = placeholderString
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: CGRect.zero, textContainer: nil)
        
        initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        font = regularFont(size: 15)
        textColor = ColorName.placeHolder.color
        
        layer.cornerRadius = NumberConstant.commonRadius
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        
        delegate = self
    }
    
}

extension NCBCommonTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderString {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count > 1 {
            return false
        }

        if text == "" {
            return true
        }

        var currentText = textView.text ?? ""
        let validString = CharacterSet(charactersIn: StringConstant.specialCharacters)
        if currentText.count < 100 && text.rangeOfCharacter(from: validString) == nil {
            currentText = currentText.folding(options: .diacriticInsensitive, locale: .current)
            textView.text = currentText + text
        }

        return false
    }
}
