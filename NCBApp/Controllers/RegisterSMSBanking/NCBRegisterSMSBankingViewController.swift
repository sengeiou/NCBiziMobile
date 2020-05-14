//
//  NCBRegisterSMSBankingViewController.swift
//  NCBApp
//
//  Created by Van Dong on 12/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBRegisterSMSBankingViewController: NCBBaseVerifyTransactionViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var subViewAccount: UIView!
    @IBOutlet weak var serviceChargeView: UIView!
    @IBOutlet weak var titleServiceCharge: UILabel!{
        didSet{
            titleServiceCharge.textColor = UIColor(hexString: "6B6B6B")
            titleServiceCharge.font = regularFont(size: 12)
            titleServiceCharge.text = "Phí dịch vụ hàng tháng"
        }
    }
    @IBOutlet weak var amount: UILabel!{
        didSet{
            amount.font = semiboldFont(size: 14)
            amount.textColor = UIColor(hexString: "000000")
        }
    }
    
    @IBOutlet weak var titleSendSMS: UILabel!{
        didSet{
            titleSendSMS.textColor = UIColor(hexString: "0083DC")
            titleSendSMS.font = italicFont(size: 12)
            titleSendSMS.text = "SMS biến động số dư tài khoản sẽ được gửi đến số điện thoại đăng ký nhận OTP của quý khách"
        }
    }
    @IBOutlet weak var authenticateView: NCBAuthenticateTransactionView!
    
    //MARK: Properties
    
    let touchMe = BiometricIDAuth()
    var p: NCBRegisterSMSBankingPresenter?
    fileprivate var accountInfoView: NCBSourceAccountView?
    fileprivate var accountRegisterSMS: [NCBAccountRegisterSMSModel] = []
    fileprivate var listAccount: NCBAccountRegisterSMSModel?
    fileprivate var msgId = ""
    fileprivate var otpVC = R.storyboard.bottomSheet.ncbotpViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        otpAuthPresenter?.refreshToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NCBShareManager.shared.areTrading = true
    }
    
    override func backAction(sender: UIButton) {
        NCBShareManager.shared.areTrading = false
        super.backAction(sender: sender)
    }
    
}
extension NCBRegisterSMSBankingViewController {
    override func setupView() {
        super.setupView()
        
        accountInfoView = R.nib.ncbSourceAccountView.firstView(owner: self)
        subViewAccount.addSubview(accountInfoView!)
        
        accountInfoView?.snp.makeConstraints {(make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        accountInfoView?.delegate = self
        accountInfoView?.setLbSourceAccount("Tài khoản đăng ký nhận SMS biến động số dư")
        
        p = NCBRegisterSMSBankingPresenter()
        p?.delegate = self
        
        authenticateView.otpBtn.addTarget(self, action: #selector(verifyAction), for: .touchUpInside)
        authenticateView.touchIDBtn.addTarget(self, action: #selector(verifyTouchID), for: .touchUpInside)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setCustomHeaderTitle("Đăng ký SMS Banking")
    }
    
    override func otpAuthenticateSuccessfully() {
        showSuccessScreen()
    }
    
    override func otpAuthenticateFailure() {
        otpVC.clear()
    }
    
    @objc fileprivate func verifyAction() {
        doConfirm()
    }
    
    @objc fileprivate func verifyTouchID() {
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
    
    fileprivate func doConfirm() {
        guard let account = listAccount else {return}
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["account"] = account.acctNo
        params["cif"] = NCBShareManager.shared.getUser()?.cif
        params["mobile"] = NCBShareManager.shared.getUser()?.mobile
        params["msgId"] = msgId
        
        SVProgressHUD.show()
        p?.createOTPRegisterSMSBanking(params: params)
    }
    
    fileprivate func doApproval(_ otp: String?) {
        guard let account = listAccount else {return}
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["account"] = account.acctNo
        params["cif"] = NCBShareManager.shared.getUser()?.cif
        params["mobile"] = NCBShareManager.shared.getUser()?.mobile
        if let otp = otp {
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = otp
            params["msgId"] = msgId
        } else {
            params["confirmType"] = getConfirmType()
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
            params["msgId"] = ""
        }
        print(params)
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: .registerSMSBanking)
    }
    
    func getAccountRegisterSMSParams() -> [String : Any] {
        let params: [String : Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0,
        ]
        return params
    }
    fileprivate func showOTP() {
        showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: true)
        otpVC.delegate = self
    }
    
    fileprivate func showSuccessScreen() {
        removeBottomSheet()
        if let vc = R.storyboard.registerSMSBanking.ncbRegisterSMSBankingSuccessViewController() {
            vc.acctNo = listAccount?.acctNo ?? ""
            vc.mobile = NCBShareManager.shared.getUser()?.mobile ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension NCBRegisterSMSBankingViewController {
    
    override func refreshTokenCompleted(error: String?) {
    //        SVProgressHUD.dismiss()
            
        p?.getAccountRegisterSMS(params: getAccountRegisterSMSParams())
    }
    
}

extension NCBRegisterSMSBankingViewController: NCBRegisterSMSBankingPresenterDelegate{
    func getFeeRegisterSMSBanking(services: NCBFeeRegisterSMSBankingModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }
        if let data = services {
            amount.currencyLabel(with: Double(data.amount ?? 0))
        }

    }
    
    func getAccountRegisterSMS(services: [NCBAccountRegisterSMSModel]?, error: String?) {
        if let _error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: _error)
            return
        }
        
        if let data = services, data.count > 0 {
            let item = data[0]
            listAccount = data[0]
            item.isSelected = true
            accountInfoView?.setSourceAccount(item.acctNo)
            accountInfoView?.setSourceName(item.acName)
            accountInfoView?.setSourceBalance(item.curBal)
            accountRegisterSMS = data
        } else {
            showError(msg: "Tài khoản của quý khách đã được đăng ký dịch vụ") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        p?.getFeeRegisterSMSBanking()
    }
    
    func createOTPRegisterSMSBanking(msgId: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if self.msgId != "" {
            showAlert(msg: "Gửi lại mã xác thực OTP thành công!")
            return
        }
        
        self.msgId = msgId ?? ""
        showOTP()
    }
    
}

extension NCBRegisterSMSBankingViewController: NCBSourceAccountViewDelegate{
    func sourceDidSelect() {
        showAccountRegisterSMS()
    }
    
    @objc fileprivate func showAccountRegisterSMS() {
        if let controller = R.storyboard.bottomSheet.ncbListAccountRegisterSMSViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(accountRegisterSMS)
        }
    }

}
extension NCBRegisterSMSBankingViewController: NCBListAccountRegisterSMSViewControllerDelegate{
    func didSelectAccount(_ account: NCBAccountRegisterSMSModel) {
        self.accountInfoView?.setSourceAccount(account.acctNo)
        self.accountInfoView?.setSourceName(account.acName)
        self.accountInfoView?.setSourceBalance(account.curBal)
        listAccount = account
        closeBottomSheet()
    }
}
extension NCBRegisterSMSBankingViewController: NCBOTPViewControllerDelegate {
    
    func otpDidSelectAccept(_ otp: String) {
        doApproval(otp)
    }
    
    func otpDidSelectResend() {
//        otpResend(msgId: msgId)
        doConfirm()
    }
    
}
