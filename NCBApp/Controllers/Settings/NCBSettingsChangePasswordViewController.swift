//
//  NCBSettingsChangePasswordViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBSettingsChangePasswordViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var currentPassTf: NewNCBCommonTextField! {
        didSet {
            currentPassTf.placeholder = "Nhập mật khẩu hiện tại"
            currentPassTf.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var newPassTf: NewNCBCommonTextField! {
        didSet {
            newPassTf.placeholder = "Nhập mật khẩu mới"
            newPassTf.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var retypePassTf: NewNCBCommonTextField! {
        didSet {
             retypePassTf.placeholder = "Nhập lại mật khẩu mới"
             retypePassTf.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var  changePassBtn: NCBCommonButton! {
        didSet {
            changePassBtn.setTitle("Đổi mật khẩu", for: .normal)
        }
    }
    
    @IBAction func changePass(_ sender: Any) {
        
        if currentPassTf.text == "" {
            showAlert(msg: "UPDATEPASS-6".getMessage() ?? "Quý khách vui lòng nhập mật khẩu hiện tại")
            return
        }
        if newPassTf.text == "" {
            showAlert(msg: "UPDATEPASS-7".getMessage() ?? "Quý khách vui lòng nhập mật khẩu mới")
            return
        }
        
        if newPassTf.text == NCBShareManager.shared.getUser()?.username {
            showAlert(msg: "UPDATEPASS-3".getMessage() ??  "Mật khẩu không được trùng với tên đăng nhập. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if newPassTf.text == currentPassTf.text {
            showAlert(msg: "UPDATEPASS-2".getMessage() ?? "")
            return
        }
        
        if !newPassTf.text!.passwordValid {
            showAlert(msg: "UPDATEPASS-4".getMessage() ?? "Mật khẩu phải có độ dài tối thiểu 08 ký tự, bao gồm các ký tự chữ và số, có chứa chữ hoa, chữ thường và ký tự đặc biệt.")
            return
        }
        
        if retypePassTf.text == "" {
            showAlert(msg: "Quý khách vui lòng nhập lại mật khẩu mới")
            return
        }
        if newPassTf.text != retypePassTf.text{
            showAlert(msg: "UPDATEPASS-5".getMessage() ?? "Nhập xác nhận mật khẩu mới và Nhập mật khẩu mới không trùng nhau. Quý khách vui lòng kiểm tra lại.")
            return
        }
        
//        let params: [String : Any] = [
//            "userid" : NCBShareManager.shared.getUser()?.username ?? "",
//            "otpType" : "sms",
//            "lang" : "vi",
//        ]
        SVProgressHUD.show()
        let params: [String: Any] = [
            "userid": NCBShareManager.shared.getUser()?.username ?? "",
            "oldPass": currentPassTf.text ?? ""
        ]
        p?.verifyOldPass(params: params)
//        p?.changePassGenerateOtp(params: params)
        
    }

    // MARK: - Properties
    var msgid = ""
    var p: NCBMainLoginPresenter?
    fileprivate var otpPresenter: NCBOTPAuthenticationPresenter?
    fileprivate var otpVC = R.storyboard.bottomSheet.ncbotpViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBSettingsChangePasswordViewController {
    override func setupView() {
        super.setupView()

        p = NCBMainLoginPresenter()
        p?.delegate = self
        changePassBtn.backgroundColor = UIColor(hexString: "D6DEE4")
        
        otpPresenter = NCBOTPAuthenticationPresenter()
        otpPresenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Đổi mật khẩu")
    }
}

extension NCBSettingsChangePasswordViewController: NCBMainLoginPresenterDelegate {
    
    func verifyOldPass(error: String?) {
        if let error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: error)
            return
        }
        
        let params: [String : Any] = [
            "userid" : NCBShareManager.shared.getUser()?.username ?? "",
            "otpType" : "sms",
            "lang" : TransactionLangType.VI.rawValue
        ]
        p?.changePassGenerateOtp(params: params)
    }
    
    func changePassGenerateOtp(services: NCBGenerateOTPModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            self.msgid = services?.msgID ?? ""
            showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: true)
            otpVC.delegate = self
        }
    }
    
    func validateLoginOTPCompleted(success: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showError(msg: _error) { [weak self] in
                if success == codeOTPError3rd {
//                    doLogout()
                    self?.userLogout()
                }
            }
            otpVC.clear()
        }else{
            let params: [String : Any] = [
                "username" : NCBShareManager.shared.getUser()?.username ?? "",
                "newpass" : newPassTf.text!,
                "oldpass" : currentPassTf.text!
            ]
            print(params)
            SVProgressHUD.show()
            p?.updatePassword(params: params)
        }
    }
    
    func updatePasswordCompleted(success: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            removeBottomSheet()
            showError(msg: "Quý khách đã thay đổi mật khẩu thành công", confirmTitle: "Đồng ý") {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

}

extension NCBSettingsChangePasswordViewController:NCBOTPViewControllerDelegate{
    func otpDidSelectAccept(_ otp: String) {
        SVProgressHUD.show()
        let params: [String : Any] = [
            "username" : NCBShareManager.shared.getUser()?.username ?? "",
            "msgid" : self.msgid,
            "otp" : otp
        ]
        print(params)
        p?.validotp(params: params)
    }
    
    func otpDidSelectResend() {
        var params: [String: Any] = [:]
        params["userid"] = NCBShareManager.shared.getUser()?.username ?? ""
        params["otpType"] = "sms"
        params["msgID"] = msgid
        params["lang"] = TransactionLangType.VI.rawValue
        params["smsType"] = "OTP"
        
        SVProgressHUD.show()
        otpPresenter?.otpResend(params: params, type: .userRequest)
    }
    
}

extension NCBSettingsChangePasswordViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func otpResendCompleted(error: String?, msgId: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let msgId = msgId {
            self.msgid = msgId
        }
        
        showAlert(msg: "Gửi lại mã xác thực OTP thành công!")
    }
    
}
