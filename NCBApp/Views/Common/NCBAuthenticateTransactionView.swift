//
//  NCBAuthenticateTransactionView.swift
//  NCBApp
//
//  Created by Thuan on 9/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBOTPButton: UIButton {
    
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
        drawGradient(startColor: UIColor(hexString: "0998E3"), endColor: UIColor(hexString: "057ADD"))
    }
    
    fileprivate func setupView() {
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = displayBoldFont(size: 14)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
}

class NCBTouchIDButton: UIButton {
    
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
        drawGradient(startColor: UIColor(hexString: "0998E3"), endColor: UIColor(hexString: "0D66E2"))
    }
    
    fileprivate func setupView() {
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = displayBoldFont(size: 14)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
}

class NCBAuthenticateTransactionView: UIView {
    
    fileprivate let touchMe = BiometricIDAuth()
    let otpBtn = NCBOTPButton()
    let touchIDBtn = NCBTouchIDButton()
    
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
        backgroundColor = UIColor.clear
        addShadow(offset: CGSize(width: 0, height: 3), color: UIColor.black, opacity: 0.13, radius: 3)
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 25
        
        addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        otpBtn.setTitle("Xác thực OTP", for: .normal)
        
        touchIDBtn.setTitle("", for: .normal)
        touchIDBtn.isHidden = (touchMe.biometricType() == .none)
        
        let touchIDIcon = UIImageView()
        touchIDIcon.contentMode = .scaleAspectFit
        switch touchMe.biometricType() {
        case .faceID:
            touchIDIcon.image = R.image.ic_faceid()
        default:
            touchIDIcon.image = R.image.ic_touchid()
        }
        
        touchIDBtn.addSubview(touchIDIcon)
        touchIDIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        let touchIDTitle = UILabel()
        touchIDTitle.text = "Xác thực \(touchMe.biometricSuffix)"
        touchIDTitle.textAlignment = .center
        touchIDTitle.font = displayBoldFont(size: 14)
        touchIDTitle.textColor = UIColor.white
        touchIDTitle.numberOfLines = 0
        touchIDBtn.addSubview(touchIDTitle)
        
        touchIDTitle.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(touchIDIcon.snp.leading).offset(-10)
        }
        
        let stack = UIStackView(arrangedSubviews: [otpBtn, touchIDBtn])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2.0
        containerView.addSubview(stack)
        
        stack.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
}
