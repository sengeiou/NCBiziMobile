//
//  NCBSlideButton.swift
//  NCBApp
//
//  Created by Thuan on 7/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

fileprivate let switchViewW: CGFloat = 60
fileprivate let switchViewH: CGFloat = 30
fileprivate let switchViewSpacing: CGFloat = 5

protocol NCBSlideButtonDelegate {
    func didChangeTab(_ isOn: Bool)
}

class NCBSlideButton: UIButton {
    
    var delegate: NCBSlideButtonDelegate?
    
    fileprivate var leftBtn: UIButton!
    fileprivate var rightBtn: UIButton!
    
    var isOn: Bool = false {
        didSet {
            leftBtn.isSelected = isOn
            rightBtn.isSelected = !isOn
            leftBtn.backgroundColor = (leftBtn.isSelected) ? ColorName.amountBlueText.color : UIColor.clear
            rightBtn.backgroundColor = (rightBtn.isSelected) ? ColorName.amountBlueText.color : UIColor.clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func setupView() {
        clipsToBounds = true
        layer.cornerRadius = self.frame.size.height/2
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexString: "DEE8F1").cgColor
        backgroundColor = UIColor(hexString: "EBF4FC")
        setTitle("", for: .normal)
    }
    
    func setTitle(left: String, right: String) {
        leftBtn = UIButton()
        leftBtn.layer.cornerRadius = self.frame.size.height/2
        leftBtn.titleLabel?.font = semiboldFont(size: 14)
        leftBtn.setTitleColor(UIColor(hexString: "959595"), for: .normal)
        leftBtn.setTitleColor(UIColor.white, for: .selected)
        leftBtn.setTitle(left, for: .normal)
        leftBtn.isSelected = isOn
        leftBtn.backgroundColor = (leftBtn.isSelected) ? ColorName.amountBlueText.color : UIColor.clear
        leftBtn.addTarget(self, action: #selector(valueChanged), for: .touchUpInside)
        
        rightBtn = UIButton()
        rightBtn.layer.cornerRadius = self.frame.size.height/2
        rightBtn.titleLabel?.font = semiboldFont(size: 14)
        rightBtn.setTitleColor(UIColor(hexString: "959595"), for: .normal)
        rightBtn.setTitleColor(UIColor.white, for: .selected)
        rightBtn.setTitle(right, for: .normal)
        rightBtn.isSelected = !isOn
        rightBtn.backgroundColor = (rightBtn.isSelected) ? ColorName.amountBlueText.color : UIColor.clear
        rightBtn.addTarget(self, action: #selector(valueChanged), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [leftBtn, rightBtn])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        
        stack.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    @objc func valueChanged() {
        isOn = !isOn
        delegate?.didChangeTab(isOn)
    }

    func disabled() {
        leftBtn.isUserInteractionEnabled = false
        rightBtn.isUserInteractionEnabled = false
    }
}
