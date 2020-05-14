//
//  NCBRegisterNewAcctDetailViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegisterNewAcctDetailViewController: NCBBaseVerifyTransactionViewController {
    @IBOutlet weak var descScv: UIScrollView! {
        didSet {
            
        }
    }
    @IBOutlet weak var descWebView: UIWebView! {
        didSet {
            descWebView.delegate = self
            descWebView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var vidBtn: NCBCommonButton! {
        didSet {
            vidBtn.setTitle("Chọn tài khoản số đẹp", for: .normal)
        }
    }
    
    @IBOutlet weak var normalBtn: NCBCommonButton! {
        didSet {
            normalBtn.setTitle("Đăng ký mở không chọn tài khoản", for: .normal)
        }
    }
    
    @IBAction func vidAction(_ sender: Any) {
//        if let vc = R.storyboard.registerNewAcct.ncbNewRegisterVidAcctViewController() {
//            vc.setData(data: product)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        showAlert(msg: "Tính năng đang phát triển")
    }
    
    @IBAction func normalAction(_ sender: Any) {
        if let _vc = R.storyboard.registerNewAcct.ncbNewRegisterNormalAcctViewController() {
            _vc.setupData(data: product)
            _vc.delegate = self
            showBottomSheet(controller: _vc, size: 330)
        }
    }

    var product:NCBRegisterNewServiceProductModel!
    var presenter: NCBRegisterNewAcctPresenter?
    var msgid = ""
    fileprivate var confirmType: String?
    fileprivate var otpVC = R.storyboard.bottomSheet.ncbotpViewController()!
    fileprivate let touchMe = BiometricIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func otpAuthenticateSuccessfully() {
        if let vc = R.storyboard.registerNewAcct.ncbRegisterNewAcctSuccessfulViewController() {
            vc.setupData(product: product, newAcc: otpAuthPresenter?.approvalSuccessBody ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func otpAuthenticateFailure() {
        otpVC.clear()
    }
}

extension NCBRegisterNewAcctDetailViewController {
    
    override func setupView() {
        super.setupView()
        presenter = NCBRegisterNewAcctPresenter()
        presenter?.delegate = self
        
        let openNormalAcct = product.openNormalAcct
        if openNormalAcct == false{
            normalBtn.isHidden = true
        }
        var params: [String: Any] = [:]
        params["typeValue"] = product.value
        print(params)
        
        SVProgressHUD.show()
        presenter?.getDescProductOpenAccountOnline(params: params)

    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Đăng ký mở tài khoản")
    }
    func setData(data:NCBRegisterNewServiceProductModel) {
        self.product = data
    }
}

extension NCBRegisterNewAcctDetailViewController:NCBRegisterNewAcctPresenterDelegate {
    
    func getDescProductOpenAccountOnline(services: String?, error: String?) {
        if let _error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: _error)
        }else{
//            SVProgressHUD.show()
            let htmlString = services ?? ""
            descWebView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    func generateOTPOpenAccountOnline(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if self.msgid != "" {
            showAlert(msg: "Gửi lại mã xác thực OTP thành công!")
            return
        }
            
        if let msg = services {
            self.msgid = msg
            showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: true)
            otpVC.delegate = self
        }
    }

}
extension NCBRegisterNewAcctDetailViewController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}

extension NCBRegisterNewAcctDetailViewController:NCBNewRegisterNormalAcctViewControllerDelegate {
    fileprivate func doConfirm() {
        var params: [String: Any] = [:]
        params["cif"] = NCBShareManager.shared.getUser()!.cif
        params["userName"] = NCBShareManager.shared.getUser()!.username
        params["account"] = ""
        params["newAccount"] = ""
        params["feeAmt"] = 0.0
        params["prdCode"] = self.product.value
        params["msgId"] = msgid
        SVProgressHUD.show()
        presenter?.generateOTPOpenAccountOnline(params: params)
        
    }

    func faceId() {
//        if !isOpenTransactionTouchID {
//            showAlert(msg: "Vui lòng kích hoạt xác nhận giao dịch bằng \(touchMe.biometricSuffix) tại phần cài đặt trong ứng dụng")
//            return
//        }
        
        if !checkBioAvailable(touchMe, isOpen: isOpenTransactionTouchID) {
            return
        }
        
        touchMe.evaluate { [weak self] (error, msg) in
            if error == biometricSuccessCode {
                self?.doApproval(nil)
            } else {
                if let msg = msg {
                    self?.showAlert(msg: msg)
                }
            }
        }
    }
    
    func optConfirm() {
        self.doConfirm()

    }
    
    fileprivate func doApproval(_ otp: String?) {
        
        var params: [String: Any] = [:]
        params["cif"] = NCBShareManager.shared.getUser()!.cif
        params["userName"] = NCBShareManager.shared.getUser()!.username
        params["account"] = ""
        params["newAccount"] = ""
        params["feeAmt"] = 0.0
        params["prdCode"] = self.product.value
        params["msgId"] = msgid
        
        if let otp = otp {
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = otp
            
        } else {
            params["confirmType"] = getConfirmType()
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
        }
        print(params)
        otpAuthenticate(params: params, type: .openAccountOnline)
    }
    
    
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension NCBRegisterNewAcctDetailViewController:NCBOTPViewControllerDelegate {
    
    func otpDidSelectAccept(_ otp: String) {
        doApproval(otp)
    }
    
    func otpDidSelectResend() {
//        otpResend(msgId: msgid)
        doConfirm()
    }
}
