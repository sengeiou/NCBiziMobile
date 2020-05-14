//
//  NCBTermDepView.swift
//  NCBApp
//
//  Created by Thuan on 8/21/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBTermDepView: UIView {
    
    var textField: NewNCBCommonTextField!
    fileprivate var lbInterestRate: UILabel!
    
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
        textField.isEnabled = false
        addSubview(textField)
        
        for view in textField.subviews {
            if view.tag == bottomLineTag {
                view.backgroundColor = UIColor.clear
            }
        }
        
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
        
        lbInterestRate = UILabel()
        lbInterestRate.font = semiboldFont(size: 12)
        lbInterestRate.textColor = UIColor(hexString: "6B6B6B")
        lbInterestRate.numberOfLines = 1
        lbInterestRate.isHidden = true
        addSubview(lbInterestRate)
        
        lbInterestRate.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(-7)
        }
        
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = NumberConstant.commonHeightTextField
            }
        }
    }
    
    func setInterestRate(_ value: String) {
        lbInterestRate.text = value
        lbInterestRate.isHidden = false
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = 80
            }
        }
    }
    func getInterestRate() -> String {
        return lbInterestRate.text ?? ""
    }
    
    func clear() {
        textField.text = ""
        clearInterestRate()
    }
    
    func clearInterestRate() {
        lbInterestRate.text = ""
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = NumberConstant.commonHeightTextField
            }
        }
    }
    
}
