//
//  NCBLoginTextField.swift
//  NCBApp
//
//  Created by ADMIN on 7/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBLoginTextField: UITextField {
    
    var placeholderString: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholderString!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 45)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        delegate = self
        font = regularFont(size: 14)
        textColor = UIColor.white
        borderStyle = .none
        
        layer.cornerRadius = 25.0
        layer.borderWidth = 1.0
     
        layer.masksToBounds = true
        layer.borderColor = UIColor( red: 2/255, green: 169/255, blue:233/255, alpha: 1.0 ).cgColor
        
        backgroundColor = UIColor( red: 0, green: 189/255, blue:255/255, alpha: 0.1 )
    }
    
    func addLeftView(with image: UIImage?) {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        view.setImage(image, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        view.isUserInteractionEnabled = false
        
        self.leftView = view
        self.leftViewMode = .always
    }
    
    func addRightButton() {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        view.setImage(R.image.ic_view(), for: .selected)
        view.setImage(R.image.ic_disable_view(), for: .normal)
        view.addTarget(self, action: #selector(showPassword(_:)), for: .touchUpInside)
        view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14)
        
        self.rightView = view
        self.rightViewMode = .always
    }
    
    @objc func showPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !self.isSecureTextEntry
        sender.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: sender.isSelected ? 18 : 14)
    }
    
}

extension NCBLoginTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && !isSecureTextEntry {
            return false
        }
        return true
    }
}
