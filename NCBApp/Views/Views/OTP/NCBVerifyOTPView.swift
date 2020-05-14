//
//  NCBVerifyOTPView.swift
//  NCBApp
//
//  Created by Thuan on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

typealias NCBVerifyOTPViewHide = () -> (Void)
typealias NCBVerifyOTPViewAccept = (String) -> (Void)
typealias NCBVerifyOTPViewResend = () -> (Void)

class NCBVerifyOTPView: UIView {
    
    //MARK: Outlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var otpView: AKOtpView!
    
    //MARK: Properties
    
    var hide: NCBVerifyOTPViewHide!
    var accept: NCBVerifyOTPViewAccept!
    var resend: NCBVerifyOTPViewResend!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbDesc.font = regularFont(size: 13)
        lbDesc.text = "Quý khách vui lòng nhập mã OTP đã được gửi đến số điện thoại đăng ký để xác nhận giao dịch."
        
        resendBtn.titleLabel?.font = italicFont(size: 13)
        resendBtn.setTitle("Gửi lại OTP", for: .normal)
        
        bgView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hiddenAction))
        bgView.addGestureRecognizer(gesture)
        
        resendBtn.addTarget(self, action: #selector(resendAction), for: .touchUpInside)
        
        otpView.numberOfDigits = 6
        otpView.borderNormalColor = UIColor.gray
        otpView.borderFillColor = UIColor.lightGray
        otpView.textNormalColor = UIColor.black
        
        otpView.setupView(withFont: boldFont(size: 28)) { [weak self] (code) in
            self?.accept(code)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func didEnterBackground(_ notification: Notification) {
        self.endEditing(true)
    }

    @objc func resendAction() {
        resend()
    }
    
    @objc func hiddenAction() {
        self.endEditing(true)
        hide()
    }
    
    func animShow(_ original: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        var newFrame = self.frame
                        newFrame.origin.y = 0
                        self.frame = newFrame
                        original.layoutIfNeeded()
        }, completion: { (value) in
            self.bgView.isHidden = false
        })
    }
    
    func animHide(_ original: UIView) {
        self.bgView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        var newFrame = self.frame
                        newFrame.origin.y = original.frame.size.height
                        self.frame = newFrame
                        original.layoutIfNeeded()
        }, completion: { (value) in
            
        })
    }

}

