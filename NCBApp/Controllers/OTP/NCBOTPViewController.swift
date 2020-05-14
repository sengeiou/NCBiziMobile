//
//  NCBOTPViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyAttributes

protocol NCBOTPViewControllerDelegate: class {
    func otpDidSelectAccept(_ otp: String)
    func otpDidSelectResend()
}

class NCBOTPViewController: UIViewController {
    
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var lbBasicNotice: UILabel!
    @IBOutlet weak var viewAdvancedNotice: UIView!
    @IBOutlet weak var lbAdvancedStep1: UILabel!
    @IBOutlet weak var lbAdvancedStep2: UILabel!
    
    fileprivate var p: NCBOTPAuthenticationPresenter?
    weak var delegate: NCBOTPViewControllerDelegate?
    var otpLevel: OtpLevelType?
    var advancedCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbDesc.font = semiboldFont(size: 14)
        lbDesc.textColor = ColorName.blurNormalText.color
        lbDesc.text = "Vui lòng nhập mã OTP"
        
        tfCode.font = semiboldFont(size: 18)
        tfCode.attributedPlaceholder = NSAttributedString(string:"Mã xác thực (OTP)", attributes:[NSAttributedString.Key.font: semiboldFont(size: 14)!])
        tfCode.textColor = UIColor.black
        tfCode.textAlignment = .center
        if #available(iOS 12.0, *) {
            tfCode.textContentType = .oneTimeCode
        }
        tfCode.keyboardType = .numberPad
        tfCode.addTarget(self, action: #selector(codeEditingChange), for: .editingChanged)
        tfCode.delegate = self
        
        resendBtn.underline(text: "Gửi lại OTP", font: semiboldFont(size: 12)!)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        
        if let otpLevel = otpLevel {
            useSoftOTP(advanced: otpLevel == .advanced)
        }
        
        lbBasicNotice.font = semiboldFont(size: 13)
        lbBasicNotice.textColor = ColorName.blurNormalText.color
        lbBasicNotice.text = "Vui lòng lấy mã xác thực cơ bản tại ứng dụng NCB Smart OTP"
        
        lbAdvancedStep1.font = regularFont(size: 13)
        lbAdvancedStep1.textColor = ColorName.blurNormalText.color
        let attrs = "Bước 1: Sao chép mã ".withFont(regularFont(size: 13)!) + "\(advancedCode ?? "")".withFont(semiboldFont(size: 13)!).withTextColor(ColorName.amountBlueText.color!) + " vào phần xác thực nâng cao trên ứng dụng NCB Smart OTP.".withFont(regularFont(size: 13)!)
        lbAdvancedStep1.attributedText = attrs
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(copyCode))
        lbAdvancedStep1.isUserInteractionEnabled = true
        lbAdvancedStep1.addGestureRecognizer(gesture)
        
        lbAdvancedStep2.font = regularFont(size: 13)
        lbAdvancedStep2.textColor = ColorName.blurNormalText.color
        lbAdvancedStep2.text = "Bước 2: Lấy mã xác thực nâng cao được sinh ra tại ứng dụng NCB Smart OTP để xác thực giao dịch này."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tfCode.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    @IBAction func resendAction(_ sender: Any) {
        delegate?.otpDidSelectResend()
    }
    
    @objc fileprivate func codeEditingChange() {
        if tfCode.text?.count == NumberConstant.numberOfOTPDigits {
            delegate?.otpDidSelectAccept(tfCode.text!)
        }
    }
    
    func clear() {
        if tfCode != nil {
            tfCode.text = ""
        }
    }
    
    fileprivate func useSoftOTP(advanced: Bool) {
        resendBtn.isHidden = true
        lbBasicNotice.isHidden = advanced
        viewAdvancedNotice.isHidden = !advanced
    }
    
    @objc fileprivate func copyCode() {
        UIPasteboard.general.string = advancedCode ?? ""
        showAlert(msg: "Sao chép mã thành công")
    }
    
}

extension NCBOTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= NumberConstant.numberOfOTPDigits
    }
    
}
