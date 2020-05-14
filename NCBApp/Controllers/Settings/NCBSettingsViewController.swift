//
//  NCBSettingsViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import LocalAuthentication
import Malert

enum TouchIDType: Int {
    case login = 0
    case transaction
}

enum SoftOTPAction: Int {
    case register = 0
    case resend
}

enum SoftOTPCommand: String {
    case register = "REGISTER"
    case unregister = "CANCEL"
}

enum SoftOTPRegisterIndex: Int {
    case sms = 0
    case softOtp
}

class NCBSettingsViewController: NCBBaseVerifyTransactionViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbLoginTitle: UILabel!
    @IBOutlet weak var switchLoginBtn: UIButton!
    @IBOutlet weak var lbVerifyTransactionTitle: UILabel!
    @IBOutlet weak var switchVerifyTransactionBtn: UIButton!
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var forLoginContainerView: UIView!
    @IBOutlet weak var heightForLoginContainerView: NSLayoutConstraint!
    @IBOutlet weak var forTransactionContainerView: UIView!
    @IBOutlet weak var heightForTransactionContainerView: NSLayoutConstraint!
    @IBOutlet weak var lbChangePassword: UILabel!
    @IBOutlet weak var lbChangeMethod: UILabel!
    @IBOutlet weak var lbSoftOtp: UILabel!
    @IBOutlet weak var settingLoginIcon: UIImageView!
    @IBOutlet weak var settingTransactionIcon: UIImageView!
    @IBOutlet weak var settingChangePassIcon: UIImageView!
    @IBOutlet weak var settingChangeMethodIcon: UIImageView!
    @IBOutlet weak var settingResendCodeIcon: UIImageView!
    
    //MARK: Properties
    
    fileprivate var p: NCBSettingsPresenter?
    fileprivate let touchMe = BiometricIDAuth()
    fileprivate var biometricSuffix: String {
        return touchMe.biometricSuffix
    }
    fileprivate var currentType: TouchIDType = .login
    fileprivate var otpVC = R.storyboard.bottomSheet.ncbotpViewController()!
    fileprivate var msgid: String?
    fileprivate var softOTPRegisterCommand = ""
    fileprivate var softOTPAction: SoftOTPAction = .register
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTouchIDStatus()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func appMovedToForeground() {
        if BiometricIDAuth().checkBioStateChanged() {
            showAlert(msg: BiometricIDAuth().biometricType() == .faceID ? "Chức năng Đăng nhập/Xác thực bằng FaceID đã bị ngừng do có sự thay đổi FaceID trên thiết bị. Quý khách vui lòng kích hoạt lại chức năng này trong phần cài đặt ứng dụng." : "Chức năng Đăng nhập/Xác thực bằng vân tay đã bị ngừng do có sự thay đổi vân tay trên thiết bị. Quý khách vui lòng kích hoạt lại chức năng này trong phần cài đặt ứng dụng.")
            switchLoginBtn.isSelected = false
            switchVerifyTransactionBtn.isSelected = false
        }
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        if let _vc = R.storyboard.setting.ncbSettingsChangePasswordViewController() {
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
    @IBAction func changeMethodAction(_ sender: Any) {
        guard let user = NCBShareManager.shared.getUser() else {
            return
        }
        
        softOTPAction = .register
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Chọn phương thức nhận OTP", items: [BottomSheetStringItem(title: "Qua tin nhắn SMS", isCheck: user.softOtpRegistered == false), BottomSheetStringItem(title: "Qua ứng dụng NCB Smart OTP", isCheck: user.softOtpRegistered == true)], isHasOptionItem: true, blurItemSelected: true)
            showBottomSheet(controller: vc, size: 250)
        }
    }
    
    @IBAction func resendSoftOTPAction(_ sender: Any) {
        softOTPAction = .resend
        resendSoftOTP()
    }
    
}

extension NCBSettingsViewController {
    
    override func setupView() {
        super.setupView()
        
        switchLoginBtn.setImage(R.image.unsave_beneficiary_btn(), for: .normal)
        switchLoginBtn.setImage(R.image.save_beneficiary_btn(), for: .selected)
        
        switchVerifyTransactionBtn.setImage(R.image.unsave_beneficiary_btn(), for: .normal)
        switchVerifyTransactionBtn.setImage(R.image.save_beneficiary_btn(), for: .selected)
        
        lbLoginTitle.font = regularFont(size: 14)
        lbLoginTitle.textColor = ColorName.blackText.color
        
        lbVerifyTransactionTitle.font = regularFont(size: 14)
        lbVerifyTransactionTitle.textColor = ColorName.blackText.color
        
        lbChangePassword.font = regularFont(size: 14)
        lbChangePassword.textColor = ColorName.blackText.color
        
        lbChangeMethod.font = regularFont(size: 14)
        lbChangeMethod.textColor = ColorName.blackText.color
        
        lbSoftOtp.font = regularFont(size: 14)
        lbSoftOtp.textColor = ColorName.blackText.color
        
        lbNote.font = italicFont(size: 12)
        lbNote.textColor = UIColor(hexString: "0083DC")
        
        p = NCBSettingsPresenter()
        p?.delegate = self
        
        switchLoginBtn.addTarget(self, action: #selector(valueChanged(_:)), for: .touchUpInside)
        switchVerifyTransactionBtn.addTarget(self, action: #selector(valueChanged(_:)), for: .touchUpInside)
        
        switchLoginBtn.isSelected = isOpenLoginTouchID
        switchVerifyTransactionBtn.isSelected = isOpenTransactionTouchID
        
        if touchMe.biometricType() == .none {
            forLoginContainerView.isHidden = true
            heightForLoginContainerView.constant = 0
            forTransactionContainerView.isHidden = true
            heightForTransactionContainerView.constant = 0
        }
        
        if touchMe.biometricType() == .touchID {
            settingLoginIcon.changeTintColor(R.image.ic_setting_login_toucid())
            settingTransactionIcon.changeTintColor(R.image.ic_setting_transaction_toucid())
        } else {
            settingLoginIcon.changeTintColor(R.image.ic_setting_login_faceid())
            settingTransactionIcon.changeTintColor(R.image.ic_setting_transaction_faceid())
        }
        settingChangePassIcon.changeTintColor(R.image.ic_setting_change_pass())
        settingChangeMethodIcon.changeTintColor(R.image.ic_setting_change_otp())
        settingResendCodeIcon.changeTintColor(R.image.ic_setting_resend_otp())
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CÀI ĐẶT")
        
        lbLoginTitle.text = "Đăng nhập bằng \(biometricSuffix)"
        lbVerifyTransactionTitle.text = "Xác thực giao dịch bằng \(biometricSuffix)"
        lbChangePassword.text = "Đổi mật khẩu đăng nhập"
        lbChangeMethod.text = "Đổi phương thức nhận OTP"
        lbSoftOtp.text = "Gửi lại mã kích hoạt Soft OTP"
        
        lbNote.text = "*Lưu ý: Việc thiết lập \(biometricSuffix) trên thiết bị này sẽ vô hiệu hóa chức năng đăng nhập/xác thực bằng \(biometricSuffix) của CIF \(NCBShareManager.shared.getUser()!.cif ?? "") đã được cài đặt trên thiết bị khác (nếu có)"
    }
    
}

extension NCBSettingsViewController {
    
    @objc fileprivate func valueChanged(_ switchBtn: UIButton) {
        switchBtn.isSelected = !switchBtn.isSelected
        
        var type: TouchIDType = .login
        if switchBtn == switchVerifyTransactionBtn {
            type = .transaction
        }
        
        if switchBtn.isSelected {
            touchMe.evaluate { [unowned self] (error, msg) in
                if error == biometricSuccessCode {
                    self.showEnterPasswordPopup(type)
                } else {
                    switchBtn.isSelected = !switchBtn.isSelected
                    if let msg = msg {
                        self.showAlert(msg: msg)
                    }
                }
            }
            
            return
        }
        
        if let view = NCBAlertView.instantiateFromNib() {
            let malert = Malert(customView: view)
            malert.cornerRadius = 15
            malert.backgroundColor = UIColor.clear
            malert.animationType = .fadeIn
            
            var titleStr = ""
            
            if type == .login {
                switch touchMe.biometricType() {
                case .faceID:
                    titleStr = "FACEID-2".getMessage() ?? ""
                case .touchID:
                    titleStr = "TOUCHID-3".getMessage() ?? ""
                default:
                    break
                }
            } else {
                switch touchMe.biometricType() {
                case .faceID:
                    titleStr = "FACEID-3".getMessage() ?? ""
                case .touchID:
                    titleStr = "TOUCHID-4".getMessage() ?? ""
                default:
                    break
                }
            }
            
            view.setTitle(title: "Thông báo", message: titleStr, confirmTitle: "Đồng ý", cancelTitle: "Huỷ")
            view.confirmCallback = { [weak self] in
                SVProgressHUD.show()
                
                let params = [
                    "userId": NCBShareManager.shared.getUser()?.username ?? ""
                ]
                
                switch type {
                case .login:
                    self?.p?.deleteForLogin(params: params)
                case .transaction:
                    self?.p?.deleteForTransaction(params: params)
                }
                malert.dismiss(animated: true, completion: nil)
            }
            view.cancelCallback = {
                switchBtn.isSelected = !switchBtn.isSelected
                malert.dismiss(animated: true, completion: nil)
            }
            present(malert, animated: true)
        }
    }
    
    fileprivate func getTouchIDStatus() {
        var params: [String: Any] = [:]
        if let value = NCBKeychainService.loadLoginTouchID() {
            params["touchidlogin"] = value
        }
        
        if let value = NCBKeychainService.loadTransactionTouchID() {
            params["touchid4transfer"] = value
        }
        
        if params.count == 0 {
            return
        }
        
        SVProgressHUD.show()
        p?.checkStatus(params: params)
    }
    
}

extension NCBSettingsViewController {
    
    fileprivate func showEnterPasswordPopup(_ type: TouchIDType) {
        currentType = type
        if let vc = R.storyboard.setting.ncbEnterPasswordViewController() {
            vc.delegate = self
            showBottomSheet(controller: vc, size: NumberConstant.otpViewHeight, disablePanGesture: true)
        }
    }
    
    fileprivate func doRegister(_ pass: String, type: TouchIDType) {
        let params = [
            "userId": NCBShareManager.shared.getUser()?.username ?? "",
            "pass": pass,
            "touchID": "",
            "msgid": ""
        ]
        
        SVProgressHUD.show()
        switch type {
        case .login:
            p?.registerForLogin(params: params)
        case .transaction:
            p?.registerForTransaction(params: params)
        }
    }
    
    fileprivate func registerSoftOTP(command: String, msgId: String? = nil) {
        SVProgressHUD.show()
        softOTPRegisterCommand = command
        
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["cif"] = NCBShareManager.shared.getUser()?.cif
        params["command"] = command
        params["lang"] = TransactionLangType.VI.rawValue
        params["msgid"] = msgId
        
        p?.registerSoftOTP(params: params)
    }
    
    fileprivate func registerSoftOTPApprove(_ otp: String) {
        guard let msgid = msgid else {
            return
        }
        
        let params: [String: Any] = [
            "userName": NCBShareManager.shared.getUser()?.username ?? "",
            "cif": NCBShareManager.shared.getUser()?.cif ?? "",
            "command": softOTPRegisterCommand,
            "msgid": msgid,
            "otp": otp
        ]
        
        otpAuthenticate(params: params, type: .softOTPRegister)
    }
    
    fileprivate func resendSoftOTP(msgId: String? = nil) {
        SVProgressHUD.show()
        
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["cif"] = NCBShareManager.shared.getUser()?.cif
        params["msgid"] = msgId
        
        p?.resendSoftOTP(params: params)
    }
    
    fileprivate func resendSoftOTPApprove(_ otp: String) {
        guard let msgid = msgid else {
            return
        }
        
        let params: [String: Any] = [
            "userName": NCBShareManager.shared.getUser()?.username ?? "",
            "cif": NCBShareManager.shared.getUser()?.cif ?? "",
            "msgid": msgid,
            "otp": otp
        ]
        
        otpAuthenticate(params: params, type: .softOTPResend)
    }
    
    fileprivate func showOTP() {
        showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: false)
        otpVC.delegate = self
    }
    
}

extension NCBSettingsViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        guard let user = NCBShareManager.shared.getUser() else {
            return
        }
        
        if index == SoftOTPRegisterIndex.sms.rawValue && user.softOtpRegistered == false {
            return
        }
        
        if index == SoftOTPRegisterIndex.softOtp.rawValue && user.softOtpRegistered == true {
            return
        }
        
        removeBottomSheet()
        registerSoftOTP(command: (index == SoftOTPRegisterIndex.sms.rawValue) ? SoftOTPCommand.unregister.rawValue : SoftOTPCommand.register.rawValue)
    }
    
}

extension NCBSettingsViewController: NCBEnterPasswordViewControllerDelegate {
    
    func enterPasswordCancel() {
        closeBottomSheet()
        switch currentType {
        case .login:
            switchLoginBtn.isSelected = !switchLoginBtn.isSelected
        case .transaction:
            switchVerifyTransactionBtn.isSelected = !switchVerifyTransactionBtn.isSelected
        }
    }
    
    func enterPasswordContinue(pass: String) {
        closeBottomSheet()
        doRegister(pass, type: currentType)
    }
    
}

extension NCBSettingsViewController: NCBOTPViewControllerDelegate {
    
    func otpDidSelectAccept(_ otp: String) {
        switch softOTPAction {
        case .register:
            registerSoftOTPApprove(otp)
        case .resend:
            resendSoftOTPApprove(otp)
        }
    }
    
    func otpDidSelectResend() {
        switch softOTPAction {
        case .register:
            registerSoftOTP(command: softOTPRegisterCommand, msgId: msgid)
        case .resend:
            resendSoftOTP(msgId: msgid)
        }
    }
    
    override func otpAuthenticateSuccessfully() {
        switch softOTPAction {
        case .register:
            if let user = NCBShareManager.shared.getUser() {
                if user.softOtpRegistered == true {
                    user.otpReg = OtpRegType.sms.rawValue
                } else {
                    user.otpReg = OtpRegType.soft.rawValue
                }
            }
        default:
            break
        }
        
        closeBottomSheet()
        showAlert(msg: otpAuthPresenter?.approvalSuccessDescription ?? "")
    }
    
    override func otpAuthenticateFailure() {
        otpVC.clear()
    }
    
}

extension NCBSettingsViewController: NCBSettingsPresenterDelegate {
    
    func registerForLoginCompleted(error: String?, msg: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            switchLoginBtn.isSelected = !switchLoginBtn.isSelected
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Đăng ký \(touchMe.biometricSuffix) thành công")
        UserDefaults.standard.set(true, forKey: keyLoginTouchIDStatus+NCBShareManager.shared.getUserID())
        UserDefaults.standard.synchronize()
        NCBKeychainService.saveDomainState(data: touchMe.domainState())
    }
    
    func deleteForLoginCompleted(error: String?, msg: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            switchLoginBtn.isSelected = !switchLoginBtn.isSelected
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Xoá đăng ký \(touchMe.biometricSuffix) thành công")
        UserDefaults.standard.set(false, forKey: keyLoginTouchIDStatus+NCBShareManager.shared.getUserID())
        UserDefaults.standard.synchronize()
    }
    
    func registerForTransactionCompleted(error: String?, msg: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            switchVerifyTransactionBtn.isSelected = !switchVerifyTransactionBtn.isSelected
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Đăng ký \(touchMe.biometricSuffix) thành công")
        UserDefaults.standard.set(true, forKey: keyTransactionTouchIDStatus+NCBShareManager.shared.getUserID())
        UserDefaults.standard.synchronize()
        NCBKeychainService.saveDomainState(data: touchMe.domainState())
    }
    
    func deleteForTransactionCompleted(error: String?, msg: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            switchVerifyTransactionBtn.isSelected = !switchVerifyTransactionBtn.isSelected
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Xoá đăng ký \(touchMe.biometricSuffix) thành công")
        UserDefaults.standard.set(false, forKey: keyTransactionTouchIDStatus+NCBShareManager.shared.getUserID())
        UserDefaults.standard.synchronize()
    }
    
    func checkStatusCompleted(status: NCBTouchIDStatusModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _ = error {
            return
        }
        
        if let enableTouchid = status?.enableTouchid, !enableTouchid {
            switchLoginBtn.isSelected = false
        }
        
        if let enableTouchid = status?.enableTouchid4transfer, !enableTouchid {
            switchVerifyTransactionBtn.isSelected = false
        }
    }
    
    func registerSoftOTPCompleted(error: String?, msgId: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.msgid = msgId
        showOTP()
    }
    
    func resendSoftOTPCompleted(error: String?, msgId: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.msgid = msgId
        showOTP()
    }
    
}
