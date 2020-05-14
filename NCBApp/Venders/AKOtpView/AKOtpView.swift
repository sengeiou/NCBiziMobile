//
//  AKOtpView.swift
//  AKOtpView
//
//  Created by ِAdham Alkhateeb on 8/13/18.
//  Copyright © 2018 Klindayzer. All rights reserved.
//

import UIKit

@IBDesignable
open class AKOtpView: UIView, AKOtpTextFieldDelegate {

    // MARK: - @IBInspectable
    public var numberOfDigits: Int = 0
    public var borderErrorColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var borderNormalColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var borderFillColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var textErrorColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var textNormalColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var customBorderWidth: CGFloat = 0.0
    
    
    // MARK: - Properities
    private var isIB: Bool {
        #if TARGET_INTERFACE_BUILDER
        return true
        #endif
        return false
    }
    private let shapeType: AKShapeType = .circle
    private var font: UIFont?
    private var otps = [AKOtpTextField]()
    private var otpCode: String!
    private var codeDidSet: ((_ code: String) -> Void)!
    public var isError: Bool? {
        didSet {
            otps.forEach { $0.isError = isError}
            
            if isError! {
                shakeView {
                    self.isError = false
                    self.otps[0].becomeFirstResponder()
                }
            }
        }
    }
    
    
    // MARK: - AKOtpView
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func draw(_ rect: CGRect) {
        
        guard !isIB else { return }
        
//        addOtpTextFields()
//        openKeyboard()
    }
    
    func initView(_ contentWidth: CGFloat) {
        addOtpTextFields(contentWidth)
        openKeyboard()
    }
    
    // MARK: - Public Methods
    public func setupView(withFont font: UIFont? = nil, _ codeDidSet: @escaping (_ code: String) -> Void) {
        self.codeDidSet = codeDidSet
        self.font = font
    }
    
    public func openKeyboard() {
        otps[0].becomeFirstResponder()
    }
    
    
    // MARK: Private Methods
    private func addOtpTextFields(_ contentWidth: CGFloat) {
        
        let initialItemSize = CGFloat(contentWidth) / CGFloat(numberOfDigits)
        let spaces = initialItemSize / 3
        let totalSpaceSize = spaces * CGFloat(numberOfDigits - 1)
        let size = ((initialItemSize * CGFloat(numberOfDigits)) - totalSpaceSize) / CGFloat(numberOfDigits)
//        let y = (frame.size.height - size) / 2
        
        for i in 0..<numberOfDigits {
            let otp = AKOtpTextField()
//            if i == 0 {
//                otp = AKOtpTextField(frame: CGRect(x: 0.0, y: y, width: size, height: size))
//            } else {
//                otp = AKOtpTextField(frame: CGRect(x: (size * CGFloat(i)) + (spaces * CGFloat(i)), y: y, width: size, height: size))
//            }
            
            otp.borderErrorColor = borderErrorColor
            otp.borderNormalColor = borderNormalColor
            otp.borderFillColor = borderFillColor
            otp.textErrorColor = textErrorColor
            otp.textNormalColor = textNormalColor
            otp.shapeType = .circle
            otp.borderWidth = customBorderWidth
            if font != nil {
                otp.font = font
            }
            otp.index = i
            otp.akDelegate = self
            
            otps.append(otp)
            
            addSubview(otp)
            
            var originX: CGFloat = 0.0
            if i > 0 {
                originX = (size * CGFloat(i)) + (spaces * CGFloat(i))
            }
            
            otp.snp.makeConstraints({ (make) in
                make.width.height.equalTo(size)
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(originX)
            })
        }
        
//        otps.forEach {
//            addSubview($0)
//        }
    }
    
    private func shakeView(completion: (() -> Void)? = nil) {
        let xDelta = CGFloat(16.0)
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0 / 6.0, animations: {
                self.transform = CGAffineTransform(translationX: xDelta, y: 0.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 6.0, relativeDuration: 1.0 / 6.0, animations: {
                self.transform = CGAffineTransform(translationX: -xDelta, y: 0.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 3.0, relativeDuration: 1.0 / 3.0, animations: {
                self.transform = CGAffineTransform(translationX: xDelta / 2.0, y: 0.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2.0 / 3.0, relativeDuration: 1.0 / 3.0, animations: {
                self.transform = CGAffineTransform.identity
            })
            
        }) { (animated) in
            completion?()
        }
    }
    
    // MARLK: - DuOtpTextFieldDelegate
    func backSpaceClicked(_ textField: AKOtpTextField) {
        
        if textField.index == 0 {
//            otps[0].resignFirstResponder()
        } else {
            otps[textField.index - 1].becomeFirstResponder()
        }
    }
    
    func codeSet(_ textField: AKOtpTextField, codeReceived: String) {
//        if codeReceived.count == numberOfDigits {
//            let characters = Array(codeReceived).map{String($0)}
//            for i in 0..<numberOfDigits {
//                if i < characters.count {
//                    otps[i].text = characters[i]
//                    if i == numberOfDigits - 1 {
//                        otps[i].becomeFirstResponder()
//                        codeDidSet(codeReceived)
//                        break
//                    }
//                }
//            }
//            
//            return
//        }
        
        if textField.index == otps.count - 1 {
            otps[textField.index].resignFirstResponder()
        } else {
            otps[textField.index + 1].becomeFirstResponder()
        }
        
        var tempCode = ""
        otps.forEach { tempCode.append($0.text!)}
        
        otpCode = tempCode
        if otpCode.count == numberOfDigits {
            codeDidSet(otpCode)
        }
    }
    
    func clear() {
        for textField in otps {
            textField.text = ""
        }
        openKeyboard()
    }
    
    var enoughInfo: Bool {
        for otp in otps {
            if otp.text == "" {
                return false
            }
        }
        
        return true
    }
}
