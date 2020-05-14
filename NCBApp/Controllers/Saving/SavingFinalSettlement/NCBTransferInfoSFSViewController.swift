//
//  NCBTransferInfoSFSViewController.swift
//  NCBApp
//
//  Created by Van Dong on 27/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBTransferInfoSFSViewController: NCBTransactionInformationViewController {
    
    var transferInfomation: TransferInfomationModel?
    var accountSFS: NCBDetailSettlementSavingAccountModel?
    fileprivate var msgId = ""
    fileprivate var p: NCBSavingAccountPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func verifyAction() {
        doConfirm()
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
extension NCBTransferInfoSFSViewController {
    
    override func setupView() {
        super.setupView()
        p = NCBSavingAccountPresenter()
        p?.delegate = self
        
        hiddenBiometricView()
        
        lbAmountTitle.text = "Số tiền tất toán"
        lbAmountValue.text = "\(transferInfomation?.amount ?? "")"
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifyTransactionGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 250
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

extension NCBTransferInfoSFSViewController{
    fileprivate func doConfirm() {
        guard let accountSFS = accountSFS else {return}
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()?.username
        params["cifno"] = NCBShareManager.shared.getUser()?.cif
        params["amount"] = accountSFS.principal ?? 0.0
        params["savingAcctNo"] = accountSFS.acctNo ?? ""
        params["savingNo"] = accountSFS.savingNumber ?? ""
        params["typeId"] = accountSFS.typeId ?? ""
        params["msgId"] = msgId

        SVProgressHUD.show()
        p?.generateOTPFinalSettlementAccount(params: params)
    }
    
    fileprivate func doApproval(_ otp: String?) {
        guard let accountSFS = accountSFS else {return}
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()?.username
        params["cifno"] = NCBShareManager.shared.getUser()?.cif
        params["amount"] = accountSFS.principal ?? 0.0
        params["savingAcctNo"] = accountSFS.acctNo ?? ""
        params["savingNo"] = accountSFS.savingNumber ?? ""
        params["typeId"] = accountSFS.typeId ?? ""
        params["payOutPr"] = accountSFS.payoutPr ?? ""
        params["opt"] = otp
        params["msgid"] = msgId
        params["lang"] = TransactionLangType.VI.rawValue
        print(params)
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: .finalSettlementSavingAccount)
    }
    
    fileprivate func showSuccessScreen() {
        if let vc = R.storyboard.saving.ncbTransferSuccessSFSViewController() {
            vc.transferInfomation = transferInfomation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NCBTransferInfoSFSViewController: NCBSavingAccountPresenterDelegate{
    func getMsgIdFromOTPCompleted(msgId: String?, error: String?) {
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

extension NCBTransferInfoSFSViewController: UITableViewDelegate, UITableViewDataSource{

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
        let header = R.nib.ncbVerifyTransactionInfoTableViewCell.firstView(owner: self)
        
        header?.tittleLb1.text = "Từ tài khoản tiết kiệm"
        header?.accountNo1.text = transferInfomation?.savingAccount
        header?.label1.text = "Ngày đến hạn: \(transferInfomation?.termDest ?? "")"
        
        header?.tittleLb2.text = "Tài khoản hưởng gốc, lãi"
        header?.accountNo2.text = transferInfomation?.sourceAccount
        
        header?.label2.text = ""
        header?.label3.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
}
