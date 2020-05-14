//
//  NCBAuthenticateLoginOtherDeviceViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBAuthenticateLoginOtherDeviceViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderColor = UIColor(hexString: "02A9E9").cgColor
            containerView.layer.borderWidth = 1.0
            containerView.layer.cornerRadius = 25.0
            containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var inputVerificationCodeTxtF: UITextField!
    
    @IBOutlet weak var confirmCodeButton: UIButton! {
        didSet{
            confirmCodeButton.layer.cornerRadius = 25.0
            confirmCodeButton.layer.masksToBounds = true
            confirmCodeButton.drawGradient(startColor: UIColor.init(red: 0, green: 192/255, blue: 247/255, alpha: 1), endColor: UIColor.init(red: 0, green: 140/255, blue: 236/255, alpha: 1))
        }
    }
    
    @IBOutlet weak var sendCodeAgainBtn: UIButton!
    
    var p: NCBMainLoginPresenter?
    fileprivate var otpPresenter: NCBOTPAuthenticationPresenter?
    fileprivate var settingPresenter: NCBSettingsPresenter?
    var msgId: String = ""
    var floatMenu = Floaty()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func onConfirmCodeAction(_ sender: Any) {
        if inputVerificationCodeTxtF.text == "" {
            showAlert(msg: "LOGIN_DEVICE#-OTP-1".getMessage() ?? "Vui lòng nhập mã xác thực")
            return
        }
        
        validateOtp()
    }
    
    @IBAction func onResendCodeAction(_ sender: Any) {
        var params: [String: Any] = [:]
        params["userid"] = NCBShareManager.shared.getUser()?.username ?? ""
        params["otpType"] = "sms"
        params["msgID"] = msgId
        params["lang"] = TransactionLangType.VI.rawValue
        params["smsType"] = "CONFIRM"
        
        SVProgressHUD.show()
        otpPresenter?.otpResend(params: params, type: .userRequest)
    }

}

extension NCBAuthenticateLoginOtherDeviceViewController {
    
    override func setupView() {
        super.setupView()
        
        inputVerificationCodeTxtF.delegate = self
        if #available(iOS 12.0, *) {
            inputVerificationCodeTxtF.textContentType = .oneTimeCode
        }
        inputVerificationCodeTxtF.keyboardType = .numberPad
        inputVerificationCodeTxtF.becomeFirstResponder()
        
        p = NCBMainLoginPresenter()
        p?.delegate = self
        
        settingPresenter = NCBSettingsPresenter()
        
        let params: [String : Any] = [
            "userid" : NCBShareManager.shared.getUser()?.username ?? "",
            "otpType" : "sms",
            "lang" : TransactionLangType.VI.rawValue,
//            "address": "confirm"
        ]
        p?.generateotp(params: params)
        
        otpPresenter = NCBOTPAuthenticationPresenter()
        otpPresenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        titleLbl.text = "Lần đầu đăng nhập trên thiết bị.\nQuý khách vui lòng nhập \"Mã xác thực\" được gửi đến SMS để xác thực."
        confirmCodeButton.setTitle("Xác thực thiết bị", for: .normal)
        sendCodeAgainBtn.underline(text: "Gửi lại mã xác thực", font: italicFont(size: 12)!, color: UIColor.white)
        inputVerificationCodeTxtF.attributedPlaceholder = NSAttributedString.init(string: "Mã xác thực", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}

extension NCBAuthenticateLoginOtherDeviceViewController {
    
    fileprivate func setupMenu() {
        floatMenu.removeFromSuperview()
        floatMenu = Floaty()
        
        floatMenu.hasShadow = false
        floatMenu.fabDelegate = self
        floatMenu.size = 42
        floatMenu.buttonImage = UIImage(named: "ic_login.pdf")
        floatMenu.buttonImageFocus = UIImage(named: "ic_login_focus.pdf")
        floatMenu.sticky = false
        
        
        let dichVuItem = FloatyItem()
        dichVuItem.hasShadow = false
        dichVuItem.icon = UIImage(named: "ic_registerNewService")
        dichVuItem.imageSize = CGSize(width: 42, height: 42)
        dichVuItem.itemBackgroundColor = UIColor.clear
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        dichVuItem.title = localized("login.menu.register.service")
        dichVuItem.titleLabel.font = regularFont(size: 14)
        dichVuItem.titleLabel.textAlignment = .right
        
        dichVuItem.handler = { dichVuItem in
            self.floatMenu.close()
            self.showServiceRegister()
        }
        floatMenu.addItem(item: dichVuItem)
        
        let lienHeItem = FloatyItem()
        lienHeItem.hasShadow = false
        lienHeItem.icon = UIImage(named: "ic_contact")
        lienHeItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        lienHeItem.title = localized("login.menu.contact")
        lienHeItem.titleLabel.font = regularFont(size: 14)
        lienHeItem.titleLabel.textAlignment = .right
        
        lienHeItem.handler = { lienHeItem in
            self.floatMenu.close()
            self.showContact()
        }
        floatMenu.addItem(item: lienHeItem)
        
        let hoTroItem = FloatyItem()
        hoTroItem.hasShadow = false
        hoTroItem.icon = UIImage(named: "ic_support")
        hoTroItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        hoTroItem.title = localized("login.menu.support")
        hoTroItem.titleLabel.font = regularFont(size: 14)
        hoTroItem.titleLabel.textAlignment = .right
        hoTroItem.handler = { hoTroItem in
            self.floatMenu.close()
            self.showSupport()
        }
        floatMenu.addItem(item: hoTroItem)
        
        let mangLuoiItem = FloatyItem()
        mangLuoiItem.hasShadow = false
        mangLuoiItem.icon = UIImage(named: "ic_network")
        mangLuoiItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        mangLuoiItem.title = localized("login.menu.network")
        mangLuoiItem.titleLabel.font = regularFont(size: 14)
        mangLuoiItem.titleLabel.textAlignment = .right
        mangLuoiItem.handler = { mangLuoiItem in
            self.floatMenu.close()
            self.showNet()
        }
        floatMenu.addItem(item: mangLuoiItem)
        
        view.addSubview(floatMenu)
    }
    
    
    fileprivate func validateOtp() {
        SVProgressHUD.show()
        
        let params: [String : Any] = [
            "username" : NCBShareManager.shared.getUser()?.username ?? "",
            "msgid" : msgId,
            "otp" : inputVerificationCodeTxtF.text ?? "",
            "address": "confirm"
        ]
        
        p?.validotp(params: params)
    }
    
}

extension NCBAuthenticateLoginOtherDeviceViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= NumberConstant.numberOfOTPDigits
    }
    
}

extension NCBAuthenticateLoginOtherDeviceViewController: NCBMainLoginPresenterDelegate {
    
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
        
//        gotoMain()
        
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
        
        let params = [
            "userId": NCBShareManager.shared.getUser()?.username ?? ""
        ]
        settingPresenter?.deleteForLogin(params: params)
        settingPresenter?.deleteForTransaction(params: params)
        
        UserDefaults.standard.setValue(true, forKey: "DidLogin")
        NCBShareManager.shared.setUserID(NCBShareManager.shared.getUser()?.username ?? "")
        gotoMain()
    }
    
}

extension NCBAuthenticateLoginOtherDeviceViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func otpResendCompleted(error: String?, msgId: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let msgId = msgId {
            self.msgId = msgId
        }
        
        showAlert(msg: "Gửi lại mã xác thực OTP thành công!")
    }
    
}

extension NCBAuthenticateLoginOtherDeviceViewController: FloatyDelegate {
    // MARK: - Floaty Delegate Methods
    
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
        
    }
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
        
    }
    
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
        
    }
}

