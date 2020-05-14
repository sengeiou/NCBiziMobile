//
//  NCBTransferInfoSavingViewController.swift
//  NCBApp
//
//  Created by Van Dong on 26/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

struct TransferInfomationModel {
    var amount: String?
    var interest: String?
    var sourceAccount: String?
    var balSourceAcount: String
    var savingAccount: String?
    var termDest: String?
    init(amount: String?,interest: String?,sourceAccount: String?,balSourceAcount: String?,savingAccount: String?,termDest: String?) {
        self.amount = amount
        self.interest = interest
        self.sourceAccount = sourceAccount
        self.balSourceAcount = balSourceAcount!
        self.savingAccount = savingAccount
        self.termDest = termDest
    }
}

class NCBTransferInfoSavingViewController: NCBTransactionInformationViewController {
    
    var transferInfomation: TransferInfomationModel?
    fileprivate var msgId = ""
    fileprivate var p: NCBSavingAccountPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func verifyAction() {
        doConfirm()
    }
    
    override func verifyWithTouchID() {
        doApproval(nil)
    }
    
    override func otpViewDidSelectAccept(_ otp: String) {
        doApproval(otp)
    }
    
    override func otpViewDidSelectResend() {
//        otpResend(msgId: msgId)
        doConfirm()
    }
    
    override func otpAuthenticateSuccessfully() {
        showSuccessScreen()
    }

}
extension NCBTransferInfoSavingViewController {
    
    override func setupView() {
        super.setupView()
        
        p = NCBSavingAccountPresenter()
        p?.delegate = self
        
        lbAmountTitle.text = "Số tiền gửi"
        lbAmountValue.text = "\(transferInfomation?.amount ?? "") VND"
        lbFee.text = "Lãi suất gửi hiện tại: \(transferInfomation?.interest ?? "")%"
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifyTransactionGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Thông tin giao dịch")
    }
    
}
extension NCBTransferInfoSavingViewController{
    fileprivate func doConfirm() {
        guard let transferInfo = transferInfomation else {return}
        let amountConvert  = NumberFormatter().number(from: transferInfo.amount!.removeSpecialCharacter)?.doubleValue
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["cifno"] = NCBShareManager.shared.getUser()?.cif
        params["acct1"] = transferInfo.sourceAccount
        params["acct2"] = transferInfo.savingAccount
        params["amount"] = amountConvert
        params["msgId"] = msgId
        print(params)
        SVProgressHUD.show()
        p?.createOTPSavingAccountAddAmount(params: params)
    }
    
    fileprivate func doApproval(_ otp: String?) {
        guard let transferInfo = transferInfomation else {return}
        let amountConvert  = NumberFormatter().number(from: transferInfo.amount!.removeSpecialCharacter)?.doubleValue
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["cifno"] = NCBShareManager.shared.getUser()?.cif
        params["acct1"] = transferInfo.sourceAccount
        params["acct2"] = transferInfo.savingAccount
        params["amount"] = amountConvert
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
        otpAuthenticate(params: params, type: .additionalSavingAccount)
    }
    
    fileprivate func showSuccessScreen() {
        if let vc = R.storyboard.saving.ncbTransferSavingSuccessViewController() {
            vc.transferInfomation = transferInfomation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension NCBTransferInfoSavingViewController: NCBSavingAccountPresenterDelegate{
    func createOTPSavingAccountAddAmount(msgId: String?, error: String?) {
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
extension NCBTransferInfoSavingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransactionGeneralInfoTableViewCell
        cell.lbContent.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        
        header?.lbSourceAccount.text = "Từ tài khoản"
        header?.lbSourceAccountValue.text = transferInfomation?.sourceAccount
        
        header?.lbDestAccount.text = "Đến tài khoản tiết kiệm"
        header?.lbDestAccountValue.text = transferInfomation?.savingAccount
        
        header?.lbDestName.text = "Kỳ hạn gửi: \(transferInfomation?.termDest ?? "")"
        header?.lbBankName.text = "Số dư hiện tại: \(transferInfomation?.balSourceAcount ?? "")"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
