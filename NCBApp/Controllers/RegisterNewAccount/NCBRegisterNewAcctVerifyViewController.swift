//
//  NCBRegisterNewAcctVerifyViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import LocalAuthentication

class NCBRegisterNewAcctVerifyViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties

    var msgid = ""
    var accountName = ""
    var tailNumberModel:NCBTailNumberModel!
    var returnNumberModel: NCBReturnNumberModel!
    var product:NCBRegisterNewServiceProductModel!
    var presenter: NCBRegisterNewAcctPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func otpAuthenticateSuccessfully() {
        if let vc = R.storyboard.registerNewAcct.ncbRegisterNewAcctSuccessfulViewController() {
            vc.setupData(product: product, tailNumberModel: tailNumberModel, returnNumberModel: returnNumberModel, accountName: accountName)
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
}

extension NCBRegisterNewAcctVerifyViewController {
    
    override func setupView() {
        super.setupView()
        
        infoTblView.register(UINib(nibName: R.nib.ncbRegistrationATMVerifyInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
        presenter = NCBRegisterNewAcctPresenter()
        presenter?.delegate = self
        
        lbAmountTitle.text = "Phí dịch vụ"
        if returnNumberModel != nil{
            let fee = returnNumberModel.serviceFee
            lbAmountValue.text = fee?.currencyFormatted
        }
        lbFee.text = ""

    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Thông tin giao dịch")
    }
    
    override func verifyAction() {
        doConfirm()
        
    }
    
    override func verifyWithTouchID() {
        doApproval(nil)
    }
    
}

extension NCBRegisterNewAcctVerifyViewController {
    
    func setupData(product:NCBRegisterNewServiceProductModel, tailNumberModel:NCBTailNumberModel,returnNumberModel:NCBReturnNumberModel, accountName:String) {
        self.tailNumberModel = tailNumberModel
        self.returnNumberModel = returnNumberModel
        self.accountName = accountName
        self.product = product
    }
    
    fileprivate func showSucceedTransfer() {
        if let vc = R.storyboard.registerNewAcct.ncbRegisterNewAcctSuccessfulViewController() {
            vc.setupData(product: product, tailNumberModel: tailNumberModel, returnNumberModel: returnNumberModel, accountName: accountName)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doConfirm() {
        var params: [String: Any] = [:]
        params["cif"] = NCBShareManager.shared.getUser()!.cif
        params["userName"] = NCBShareManager.shared.getUser()!.username
        params["account"] = accountName
        params["newAccount"] = returnNumberModel.accountNo
        params["feeAmt"] = returnNumberModel.serviceFee
        params["prdCode"] = self.product.value
        params["msgId"] = msgid
        
        SVProgressHUD.show()
        presenter?.generateOTPOpenAccountOnline(params: params)
    }
    
    fileprivate func doApproval(_ otp: String?) {
        
        var params: [String: Any] = [:]
        params["cif"] = NCBShareManager.shared.getUser()!.cif
        params["userName"] = NCBShareManager.shared.getUser()!.username
        params["account"] = accountName
        params["newAccount"] = returnNumberModel.accountNo
        params["feeAmt"] = returnNumberModel.serviceFee
        params["prdCode"] = product.value
        params["msgId"] = msgid
        params["chargCode"] = returnNumberModel.chargCode
      
        SVProgressHUD.show()
        if let otp = otp {
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = otp
        } else {
            params["confirmType"] = getConfirmType()
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
        }
    
        SVProgressHUD.show()
        print(params)
        otpAuthenticate(params: params, type: TransactionType.openAccountOnline)
      
    }
    
    fileprivate func doResendOTP() {
//       otpResend(msgId: msgid)
        doConfirm()
    }
    
}

extension NCBRegisterNewAcctVerifyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier, for: indexPath) as! NCBRegistrationATMVerifyInfoTableViewCell
        
        cell.locationLbl.text = "Loại tài khoản số đẹp: "
        if tailNumberModel != nil {
            cell.peeLbl.text = tailNumberModel.name
        }else{
            cell.peeLbl.text = ""
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        header?.lbSourceAccountValue.text = self.accountName
        header?.lbSourceAccount.text = "Từ tài khoản"
        if returnNumberModel != nil {
            header?.lbDestAccountValue.text = returnNumberModel.accountNo
        }else{
             header?.lbDestAccountValue.text = ""
        }

        header?.lbDestAccount.text = "Số tài khoản mới"
        header?.lbDestName .text = ""
        header?.lbBankName.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}


extension NCBRegisterNewAcctVerifyViewController:NCBRegisterNewAcctPresenterDelegate {
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
            showOTP()
            
        }
    }
    
}

extension NCBRegisterNewAcctVerifyViewController {
    
    override func otpViewDidSelectAccept(_ otp: String) {
        doApproval(otp)
        
    }
    
    override func otpViewDidSelectResend() {
        doResendOTP()
    }
    
}
