//
//  NCBUnderlineTextField.swift
//  TouchFaceID
//
//  Created by Lê Sơn on 4/2/19.
//  Copyright © 2019 Lê Sơn. All rights reserved.
//

import UIKit

class NCBUnderlineTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        font = UIFont.systemFont(ofSize: 15.0)
        borderStyle = .none
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        
        addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    
    func addLeftView(with image: UIImage?) {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: CGFloat(25), y: CGFloat(5), width: CGFloat(30), height: CGFloat(25))
        imageView.contentMode = .center
        imageView.image = image
        self.leftView = imageView
        self.leftViewMode = .always
    }
    
    func addRightButton() {
        let seePasswordBtn = UIButton()
        seePasswordBtn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        seePasswordBtn.setImage(R.image.ic_view(), for: .normal)
        seePasswordBtn.setImage(R.image.ic_disable_view(), for: .selected)
        seePasswordBtn.addTarget(self, action: #selector(showPassword(_:)), for: .touchUpInside)
        self.rightView = seePasswordBtn
        self.rightViewMode = .always
    }
    
    @objc func showPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
}

