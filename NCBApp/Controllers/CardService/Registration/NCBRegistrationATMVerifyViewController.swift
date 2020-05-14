//
//  NCBRegistrationATMVerifyViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import Foundation

import LocalAuthentication

class NCBRegistrationATMVerifyViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties
    
    var accountName = ""
    var branch = ""
    var cardProducts = ""
    var cardClass = ""
    var pee:Double = 0.0
    var msgid = ""
    
    var cardData: NCBCardModel!
    var getFeeCardModel:NCBGetFeeCardModel!
    var branchModel: NCBBranchModel!
    var presenter: NCBCardServicePresenter?
    var isOTP = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBRegistrationATMVerifyViewController {
    
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
        
        hiddenHeaderView()
        
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Thông tin giao dịch")
    }
    
    override func verifyAction() {
        
        isOTP = true
        doConfirm()
    
        /*
        switch footerType {
        case .confirm:
            doConfirm("")
        case .verify:
            doConfirm(TransactionConfirmType.OTP.rawValue)
        }
        */
    }
    
    override func verifyWithTouchID() {
        isOTP = false
        doConfirm()
    }
    
    override func otpAuthenticateSuccessfully() {
        
        if let vc = R.storyboard.cardService.ncbRegistrationATMSuccessfulViewController() {
            vc.setData(branch: branchModel.depart_name ?? "", cardProduct:cardProducts, cardClass: cardClass, pee: pee,accountName: accountName)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension NCBRegistrationATMVerifyViewController {
    
    func setupData(getFeeCardModel:NCBGetFeeCardModel,branchModel:NCBBranchModel,cardProduct: String,cardClass: String, accountName:String) {
       
        self.getFeeCardModel = getFeeCardModel
        self.branchModel = branchModel
        self.branch = branchModel.branch_name ?? ""
        self.cardProducts = cardProduct
        self.cardClass = cardClass
        self.pee = getFeeCardModel.fee ?? 0.0
        self.accountName = accountName
        
    }
    
    fileprivate func doConfirm() {
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["acctNo"] = accountName
        params["codeFee"] = getFeeCardModel.codeFee
        params["fee"] = getFeeCardModel.fee
        params["departCode"] = branchModel.depart_code
        params["cardProduct"] = cardProducts
        params["cardClass"] = cardClass
        params["lang"] = TransactionLangType.VI.rawValue
        params["msgid"] = ""
        
        if isOTP {
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = ""
        } else {
            params["confirmType"] = getConfirmType()
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
        }
        
        SVProgressHUD.show()
        presenter?.createAtmConfirm(params: params)
    }
    
    fileprivate func doApproval(_ otp: String) {
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["acctNo"] = accountName
        params["codeFee"] = getFeeCardModel.codeFee
        params["fee"] = getFeeCardModel.fee
        params["departCode"] = branchModel.depart_code
        params["cardProduct"] = cardProducts
        params["cardClass"] = cardClass
        params["lang"] = TransactionLangType.VI.rawValue
        params["msgid"] = msgid
        params["confirmType"] = TransactionConfirmType.OTP.rawValue
        params["confirmValue"] = otp
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: TransactionType.createAtmApproval)
    }
    
}

extension NCBRegistrationATMVerifyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier, for: indexPath) as! NCBRegistrationATMVerifyInfoTableViewCell
   
        cell.locationLbl.text = "Địa điểm nhận thẻ: \(branchModel.depart_name ?? "")"
        cell.peeLbl.text =  "Phí dịch vụ: "+self.pee.currencyFormatted
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        header?.lbSourceAccountValue.text = self.accountName
        header?.lbSourceAccount.text = "Tài khoản mở thẻ"
        header?.lbDestAccountValue.text = self.cardProducts
        header?.lbDestAccount.text = "Sản phẩm thẻ"
        header?.lbDestName.text = "Hạng thẻ: \(self.cardClass)"
        header?.lbBankName.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    
}

extension NCBRegistrationATMVerifyViewController: NCBCardServicePresenterDelegate {
    
    func createAtmConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if !isOTP {
                if let vc = R.storyboard.cardService.ncbRegistrationATMSuccessfulViewController() {
                    vc.setData(branch: branchModel.depart_name ?? "", cardProduct:cardProducts, cardClass: cardClass, pee: pee,accountName: accountName)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return
            }
            
            self.msgid = services?.msgid ?? ""
            showOTP()
    
        }
    }
   
}

extension NCBRegistrationATMVerifyViewController {
    
    override func otpViewDidSelectAccept(_ otp: String) {
        doApproval(otp)
        
    }
    
    override func otpViewDidSelectResend() {
//        otpResend(msgId: msgid)
        
        let params: [String: Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "userId": NCBShareManager.shared.getUserID(),
            "acctNo": accountName,
            "fee": getFeeCardModel.fee ?? ""
        ]
        otpResend(msgId: msgid, params: params, type: .createAtmApproval)
    }
    
}


