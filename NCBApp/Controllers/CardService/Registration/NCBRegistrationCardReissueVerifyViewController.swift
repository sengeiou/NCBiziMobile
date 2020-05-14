//
//  NCBRegistrationCardReissueVerifyViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import Foundation
import LocalAuthentication

class NCBRegistrationCardReissueVerifyViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties
    
    
    fileprivate var confirmType: String?
    
    var accountName = ""
    var branch = ""
    var cardProducts = ""
    var cardClass = ""
    var pee:Double = 0.0
    
    var cardData: NCBCardModel!
    var branchModel: NCBBranchModel!
    var getFeeAcctReopenAtmModel:NCBGetFeeAcctReopenAtmModel!
    var typeCard:CreditCardType!
    var reason:NCBReasonAcctReopenAtmModel!

    var opt = ""
    var msgid = ""
    
    var presenter: NCBCardServicePresenter?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBRegistrationCardReissueVerifyViewController {
    
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
        
        branch = branchModel.depart_name ?? ""
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
        
        hiddenHeaderView()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Thông tin giao dịch")
    }
    
    override func verifyAction() {
        confirmType = TransactionConfirmType.OTP.rawValue
        doConfirm(TransactionConfirmType.OTP.rawValue)
        
      
    
    }
    
    override func verifyWithTouchID() {
        confirmType = getConfirmType()
        doConfirm(confirmType ?? "")
    }
    
}

extension NCBRegistrationCardReissueVerifyViewController {
    
    func setData(data:NCBCardModel, branchModel: NCBBranchModel, feeAcctReopenAtmModel:NCBGetFeeAcctReopenAtmModel,accountName:String,reason:NCBReasonAcctReopenAtmModel) {
        self.typeCard = CreditCardType.DB
        self.cardData = data
        self.branchModel = branchModel
        self.getFeeAcctReopenAtmModel = feeAcctReopenAtmModel
        self.cardProducts = data.parCardProduct?.product ?? ""
        self.cardClass = data.parCardProduct?.class_ ?? ""
        self.accountName = accountName
        self.pee = feeAcctReopenAtmModel.fee ?? 0.0
        self.reason = reason
    }
    func setData(data:NCBCardModel, branchModel: NCBBranchModel,accountName:String,reason:NCBReasonAcctReopenAtmModel) {
        self.typeCard = CreditCardType.VS
        self.cardData = data
        self.branchModel = branchModel
        self.cardProducts = data.parCardProduct?.product ?? ""
        self.cardClass = data.parCardProduct?.class_ ?? ""
        self.accountName = accountName
        self.reason = reason
    }
    func setCardData(data:NCBCardModel) {
        self.cardData = data

    }
    
    fileprivate func showSucceedTransfer() {
       
        if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
            vc.setData(cardData, type: .reissueCard)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doConfirm(_ confirmType: String) {
        if  typeCard == CreditCardType.DB{
            var params: [String: Any] = [:]
            params["cifno"] = NCBShareManager.shared.getUser()!.cif
            params["userId"] = NCBShareManager.shared.getUser()!.username
            params["acctNo"] = accountName
            params["codeFee"] = getFeeAcctReopenAtmModel.codeFee
            params["fee"] = getFeeAcctReopenAtmModel.fee
            params["departCode"] = branchModel.depart_code
            params["cardProduct"] = cardProducts
            params["cardClass"] = cardClass
            params["lang"] = "VI"
            params["msgid"] = ""
            params["cardNo"] = cardData.cardno
            
            
            if confirmType == getConfirmType() {
                params["confirmType"] = confirmType
                params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
                
            }else{
                params["confirmType"] = TransactionConfirmType.OTP.rawValue
                params["confirmValue"] = opt
            }
            params["reasonCode"] = reason.code
            SVProgressHUD.show()
            print(params)
            presenter?.reopenAtmConfirm(params:params)
        }else{
            var params: [String: Any] = [:]
            params["cifno"] = NCBShareManager.shared.getUser()!.cif
            params["userId"] = NCBShareManager.shared.getUser()!.username
            params["acctNo"] = accountName
            //params["codeFee"] = getFeeAcctReopenAtmModel.codeFee
           // params["fee"] = getFeeAcctReopenAtmModel.fee
            params["departCode"] = branchModel.depart_code
            params["cardProduct"] = cardProducts
            params["cardClass"] = cardClass
            params["lang"] = "VI"
            params["msgid"] = ""
            params["cardNo"] = cardData.cardno
            
            if confirmType == getConfirmType() {
                params["confirmType"] = confirmType
                params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
                
            }else{
                params["confirmType"] = TransactionConfirmType.OTP.rawValue
                params["confirmValue"] = opt
            }
            params["reasonCode"] = reason.code
            SVProgressHUD.show()
            print(params)
            presenter?.reopenVisaConfirm(params:params )
        }
        
        
        
       
    }
    
    fileprivate func doApproval(_ otp: String) {
        if  typeCard == CreditCardType.DB{
            var params: [String: Any] = [:]
            params["cifno"] = NCBShareManager.shared.getUser()!.cif
            params["userId"] = NCBShareManager.shared.getUser()!.username
            params["acctNo"] = accountName
            params["codeFee"] = getFeeAcctReopenAtmModel.codeFee
            params["fee"] = getFeeAcctReopenAtmModel.fee
            params["departCode"] = branchModel.depart_code
            params["cardProduct"] = cardProducts
            params["cardClass"] = cardClass
            params["lang"] = "VI"
            params["msgid"] = msgid
            params["cardNo"] = cardData.cardno
            
            if confirmType == TransactionConfirmType.OTP.rawValue{
                params["confirmType"] = TransactionConfirmType.OTP.rawValue
                params["confirmValue"] = otp
            }
            params["reasonCode"] = reason.code
            
            SVProgressHUD.show()
            otpAuthenticate(params: params, type: TransactionType.reopenAtmApproval)
        }else{
            var params: [String: Any] = [:]
            params["cifno"] = NCBShareManager.shared.getUser()!.cif
            params["userId"] = NCBShareManager.shared.getUser()!.username
            params["acctNo"] = accountName
            //params["codeFee"] = getFeeAcctReopenAtmModel.codeFee
            //params["fee"] = getFeeAcctReopenAtmModel.fee
            params["departCode"] = branchModel.depart_code
            params["cardProduct"] = cardProducts
            params["cardClass"] = cardClass
            params["lang"] = "VI"
            params["msgid"] = msgid
            params["cardNo"] = cardData.cardno
            
            if confirmType == TransactionConfirmType.OTP.rawValue{
                params["confirmType"] = TransactionConfirmType.OTP.rawValue
                params["confirmValue"] = otp
                
            }
            params["reasonCode"] = reason.code
            SVProgressHUD.show()
            otpAuthenticate(params: params, type: TransactionType.reopenVisaApproval)
        }
        
    }
    
    fileprivate func doResendOTP() {
//        otpResend(msgId: msgid)
        
        let params: [String: Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "userId": NCBShareManager.shared.getUserID(),
            "acctNo": accountName,
            "fee": (typeCard == CreditCardType.DB) ? getFeeAcctReopenAtmModel.fee ?? 0.0 : 0.0
        ]
        
        otpResend(msgId: msgid, params: params, type: (typeCard == CreditCardType.DB) ? .reopenAtmApproval : .reopenVisaApproval)
    }
    
}

extension NCBRegistrationCardReissueVerifyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier, for: indexPath) as! NCBRegistrationATMVerifyInfoTableViewCell
        
        cell.locationLbl.text = "Địa điểm nhận thẻ: "+self.branch
        if reason.codeExpired {
            cell.peeLbl.text =  ""
        } else {
            cell.peeLbl.text =  "Phí dịch vụ: "+self.pee.currencyFormatted
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        header?.lbSourceAccountValue.text = self.accountName
        header?.lbSourceAccount.text = "Tài khoản mở thẻ"
        header?.lbDestAccountValue.text = self.cardProducts
        header?.lbDestAccount.text = "Sản phẩm thẻ"
        header?.lbDestName.text = self.cardClass
        header?.lbBankName.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension NCBRegistrationCardReissueVerifyViewController {
    
    override func otpAuthenticateSuccessfully() {
        showSucceedTransfer()
        /*
        if let vc = R.storyboard.cardService.ncbOpenLockCardComplementViewController() {
            vc.setupData(data: cardData)
            vc.setupTypeComplement(type: CardComplementType.reissueCard)
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
    }
    
}

extension NCBRegistrationCardReissueVerifyViewController {
    
    override func otpViewDidSelectAccept(_ otp: String) {
        doApproval(otp)
        self.opt = otp
    }
    
    override func otpViewDidSelectResend() {
        doResendOTP()
    }
    
}

extension NCBRegistrationCardReissueVerifyViewController: NCBCardServicePresenterDelegate {
    func reopenAtmConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if confirmType == TransactionConfirmType.OTP.rawValue{
                if let msg = services?.msgid {
                    self.msgid = msg
                    showOTP()
                }
            }else{
               showSucceedTransfer()
            }
            
        }
    }
    
    func reopenVisaConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if confirmType == TransactionConfirmType.OTP.rawValue{
                if let msg = services?.msgid {
                    self.msgid = msg
                    showOTP()
                }
            }else{
                showSucceedTransfer()
            }
            
        }
    }
    
    
}
