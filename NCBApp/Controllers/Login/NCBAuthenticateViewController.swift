//
//  NCBAuthenticateViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBAuthenticateViewController: NCBBaseViewController {    
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderColor = UIColor(hexString: "02A9E9").cgColor
            containerView.layer.borderWidth = 1.0
            containerView.layer.cornerRadius = 25.0
            containerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var infoLbl: UILabel! {
        didSet {
            infoLbl.text = "NCBLOGIN-6".getMessage() ?? "Mã kích hoạt đã được gửi đến số điện thoại đăng ký dịch vụ. Quý khách vui lòng nhập mã số để kích hoạt dịch vụ"
        }
    }
    @IBOutlet weak var activeCodeTxtF: UITextField! {
        didSet {
            activeCodeTxtF.attributedPlaceholder = NSAttributedString.init(string: "Nhập mã kích hoạt", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
            activeCodeTxtF.delegate = self
        }
    }
    @IBOutlet weak var sendActiveCodeAgainBtn: UIButton! {
        didSet {
            sendActiveCodeAgainBtn.underline(text: "Gửi lại mã kích hoạt", font: italicFont(size: 12)!, color: UIColor.white)
        }
    }
    @IBOutlet weak var activeBtn: UIButton! {
        didSet {
            activeBtn.setTitle("Kích hoạt", for: .normal)
            activeBtn.layer.cornerRadius = 25.0
            activeBtn.layer.masksToBounds = true
            activeBtn.drawGradient(startColor: UIColor.init(red: 0, green: 192/255, blue: 247/255, alpha: 1), endColor: UIColor.init(red: 0, green: 140/255, blue: 236/255, alpha: 1))
        }
    }
    @IBOutlet weak var checkAgreePolicyBtn: UIButton!{
        didSet{
            checkAgreePolicyBtn.setImage(R.image.radio_uncheck(), for: .normal)
            checkAgreePolicyBtn.setImage(R.image.radio_checked(), for: .selected)
            checkAgreePolicyBtn.isSelected = true
        }
    }
    @IBOutlet weak var permissionTxtV: UITextView!{
        didSet{
            setupTextView()
            permissionTxtV.backgroundColor = UIColor.clear
            permissionTxtV.delegate = self
        }
    }
    
    // MARK: - Properties
    fileprivate var p: NCBMainLoginPresenter?
    fileprivate var otpPresenter: NCBOTPAuthenticationPresenter?
    
    var msgId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func sendActiveCodeAgain(_ sender: UIButton) {
        var params: [String: Any] = [:]
        params["userid"] = NCBShareManager.shared.getUser()?.username ?? ""
        params["otpType"] = "sms"
        params["msgID"] = msgId
        params["lang"] = TransactionLangType.VI.rawValue
        params["smsType"] = "ACTIVE"
        
        SVProgressHUD.show()
        otpPresenter?.otpResend(params: params, type: .userRequest)
    }
    
    @IBAction func activeCode(_ sender: UIButton) {
        if activeCodeTxtF.text == "" {
            showAlert(msg: "ACTIVE_OTP-1".getMessage() ?? "Vui lòng nhập mã kích hoạt")
            return
        }
        
        if !checkAgreePolicyBtn.isSelected {
            showAlert(msg: "ACTIVE-1".getMessage() ?? "Vui lòng chọn Đồng ý với điều kiện điều khoản sử dụng dịch vụ")
            return
        }
        
        let params: [String : Any] = [
            "username" : NCBShareManager.shared.getUser()?.username ?? "",
            "msgid" : msgId,
            "otp" : activeCodeTxtF.text ?? "",
            "address": "active"
        ]
        
        SVProgressHUD.show()
        p?.validotp(params: params)
    }
    @IBAction func agreePolicy(_ sender: UIButton) {
        checkAgreePolicyBtn.isSelected = !checkAgreePolicyBtn.isSelected
    }
    
}

extension NCBAuthenticateViewController {

    override func setupView() {
        super.setupView()
        
        if #available(iOS 12.0, *) {
            activeCodeTxtF.textContentType = .oneTimeCode
        }
        activeCodeTxtF.keyboardType = .numberPad
        activeCodeTxtF.becomeFirstResponder()
        
        p = NCBMainLoginPresenter()
        let params: [String : Any] = [
            "userid" : NCBShareManager.shared.getUser()?.username ?? "",
            "otpType" : "sms",
            "lang" : TransactionLangType.VI.rawValue,
//            "address": "active"
        ]
        p?.generateotp(params: params)
        p?.delegate = self
        
        otpPresenter = NCBOTPAuthenticationPresenter()
        otpPresenter?.delegate = self
    }

    func setupTextView() {
        let fullString = "Tôi đồng ý với các Điều kiện và điều khoản sử dụng dịch vụ \(appName)"
        let attributeSubString = "Điều kiện và điều khoản"
        let range = (fullString as NSString).range(of: attributeSubString)
        let defaultFont = UIFont.systemFont(ofSize: 15)
        let attributedString = NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: R.font.sfProTextRegular(size: 14) ?? defaultFont])
        let url = "http://stackoverflow.com"
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor(hexString: "02A9E9"), range: range)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "02A9E9"), NSAttributedString.Key.font: R.font.sfProTextMedium(size: 14) ?? defaultFont], range: range)
        _ = attributedString.setAsLink(textToFind: attributeSubString, linkURL: url)
        permissionTxtV.attributedText = attributedString
    }
}

extension NCBAuthenticateViewController: NCBMainLoginPresenterDelegate {
    func generateLoginOTPCompleted(msgId: String?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        self.msgId = msgId ?? ""
    }
    
    func validateLoginOTPCompleted(success: String?, error: String?) {
        if let _error = error {
            SVProgressHUD.dismiss()
            showError(msg: _error) {
                if success == codeOTPError3rd {
                    doLogout()
                }
            }
            return
        }
        
        let params: [String : Any] = [
             "username" : NCBShareManager.shared.getUser()?.username ?? "",
             "status" : "A",
             "deviceID" : getUUID(),
             "OS" : UIDevice.current.systemVersion,
             "deviceType": UIDevice.modelName
        ]
        
        p?.updateProfileStatus(params: params)
        
    }
    
    func updateProfileStatusCompleted(success: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let userInfo = NCBShareManager.shared.getUser() {
            if let _chPass = userInfo.chpass, _chPass == ChangePassCase.no.rawValue {
                gotoChangePassword()
            } else {
                UserDefaults.standard.setValue(true, forKey: "DidLogin")
                NCBShareManager.shared.setUserID(userInfo.username ?? "")
                gotoMain()
            }
        }
    }
    
}

extension NCBAuthenticateViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func otpResendCompleted(error: String?, msgId: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let msgId = msgId {
            self.msgId = msgId
        }
        
        showAlert(msg: "Gửi lại mã kích hoạt OTP thành công!")
    }
    
}

extension NCBAuthenticateViewController: UITextViewDelegate, UITextFieldDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let vc = R.storyboard.login.ncbPermissionAndPolicyViewController() {
            let nav = UINavigationController(rootViewController: vc)
            vc.didAgreePolicyCallback = { [weak self] () -> (Void) in
                self?.checkAgreePolicyBtn.isSelected = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= NumberConstant.numberOfOTPDigits
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
