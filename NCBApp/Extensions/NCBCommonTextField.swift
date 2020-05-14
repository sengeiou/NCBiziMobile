//
//  NCBCommonTextField.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBCommonTextFieldDelegate: class {
    func textFieldDidSelectRightArrow(_ textField: UITextField)
}

class NCBCommonTextField: UITextField {
    
    @IBInspectable var arrowIcon: Bool = false
    
    fileprivate let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    weak var customDelegate: NCBCommonTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        borderStyle = .none
        clipsToBounds = true
        font = UIFont.systemFont(ofSize: 15.0)
        layer.cornerRadius = NumberConstant.commonRadius
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        
        if arrowIcon {
            addArrowIcon()
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    public func addArrowIcon(_ interactive: Bool? = nil) {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        rightView.backgroundColor = UIColor(hexString: "f2f2f2")
        
        rightView.isUserInteractionEnabled = interactive ?? true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectRightArrow))
        rightView.addGestureRecognizer(gesture)
        
        let icon = UIImageView()
        icon.image = R.image.ic_arrow_dropdown()
        icon.contentMode = .scaleAspectFit
        rightView.addSubview(icon)
        
        icon.snp.makeConstraints { (make) in
            make.width.height.equalTo(10)
            make.center.equalToSuperview()        }
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    @objc func didSelectRightArrow() {
        customDelegate?.textFieldDidSelectRightArrow(self)
    }
    
    func addRightText(_ text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.font = regularFont(size: 15)
        label.textColor = UIColor.black
        label.text = text
        label.textAlignment = .right
        
        self.rightView = label
        self.rightViewMode = .always
    }
    
}
