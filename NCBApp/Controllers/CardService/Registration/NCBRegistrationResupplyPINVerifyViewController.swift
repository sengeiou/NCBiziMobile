//
//  NCBRegistrationResupplyPINVerifyViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import LocalAuthentication

class NCBRegistrationResupplyPINVerifyViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties
    
    fileprivate var confirmType: String?
    
 
    var accountName = ""
    var accNo = ""
    var branch = ""
    var cardProducts = ""
    var cardClass = ""
    var pee:Double = 0.0
    
    var cardData: NCBCardModel!
    var branchModel: NCBBranchModel!
    var feePinModel:NCBGetFeeCardModel!
    var presenter: NCBCardServicePresenter?
    
    var opt = ""
    var msgid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBRegistrationResupplyPINVerifyViewController {
    
    override func setupView() {
        super.setupView()
        
        infoTblView.register(UINib(nibName: R.nib.ncbRegistrationATMVerifyTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
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
        
        /*
        if let vc = R.storyboard.cardService.ncbOpenLockCardComplementViewController() {
            vc.setupData(data: cardData)
            vc.setupTypeComplement(type: CardComplementType.resupplyPIN)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        */
        
    }
    
    override func verifyWithTouchID() {
        confirmType = getConfirmType()
        doConfirm(confirmType ?? "")
    }
    
}

extension NCBRegistrationResupplyPINVerifyViewController {
  
    func setData(data:NCBCardModel, branchModel: NCBBranchModel, feePinModel:NCBGetFeeCardModel,accountName:String,accNo:String) {
        self.cardData = data
        self.branchModel = branchModel
        self.feePinModel = feePinModel
        
        self.cardProducts = data.parCardProduct?.product ?? ""
        self.cardClass = data.parCardProduct?.class_ ?? ""
        self.accountName = accountName
        self.pee = feePinModel.fee ?? 0.0
        self.accNo = accNo
        
    }
    
    func setCardData(data:NCBCardModel) {
        self.cardData = data
        
    }
    
    fileprivate func showSucceedTransfer() {
        
        if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
            vc.setData(cardData, type: .resupplyPIN)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    fileprivate func doConfirm(_ confirmType: String) {
        var params: [String: Any] = [:]
        params["cifNo"] = NCBShareManager.shared.getUser()!.cif
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["acctNo"] = accNo
        params["cardNo"] = cardData.cardno
        params["codeFee"] = feePinModel.codeFee
        params["fee"] = feePinModel.fee
        params["departCode"] = branchModel.depart_code
        params["lang"] = "VI"
        params["msgid"] = ""
        
        if confirmType == getConfirmType() {
            params["confirmType"] = confirmType
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
            
        }else{
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = opt
        }
        SVProgressHUD.show()
        print(params)
        presenter?.reissuePinConfirm(params: params)
    }
    
    fileprivate func doApproval(_ otp: String) {
        var params: [String: Any] = [:]
        params["cifNo"] = NCBShareManager.shared.getUser()!.cif
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["acctNo"] = accNo
        params["cardNo"] = cardData.cardno
        params["codeFee"] = feePinModel.codeFee
        params["fee"] = feePinModel.fee
        params["departCode"] = branchModel.depart_code
        params["lang"] = "VI"
        params["msgid"] = msgid
        
        if confirmType == TransactionConfirmType.OTP.rawValue{
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = otp
            
        }
        
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: TransactionType.reissuePinApproval)
    }
    
    fileprivate func doResendOTP() {
//        otpResend(msgId: msgid)
        
        let params: [String: Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "userId": NCBShareManager.shared.getUserID(),
            "acctNo": accNo,
            "fee": feePinModel.fee ?? 0.0
        ]
        otpResend(msgId: msgid, params: params, type: .reissuePinApproval)
    }
    
}

extension NCBRegistrationResupplyPINVerifyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyTableViewCellID.identifier, for: indexPath) as! NCBRegistrationATMVerifyTableViewCell
        cell.accountTitleLbl.text = "Sản phẩm thẻ"
        cell.accountLbl.text = (self.cardData.cardno ?? "").cardHidden
        cell.productTitleLbl.text  = self.cardProducts
        cell.productLbl.text = "Địa điểm nhận PIN: " + branchModel.depart_name!
        cell.productLbl.font =  regularFont(size: 12.0)

        cell.classLbl.text = "Phí dịch vụ : " + (feePinModel.fee ?? 0.0).currencyFormatted
        cell.locationLbl.text = "Tài khoản thu phí dịch vụ"
        cell.peeLbl.text = accNo
        return cell
    }
}

extension NCBRegistrationResupplyPINVerifyViewController {
    
    override func otpAuthenticateSuccessfully() {
        showSucceedTransfer()
    }
    
}

extension NCBRegistrationResupplyPINVerifyViewController {
    
    override func otpViewDidSelectAccept(_ otp: String) {
        doApproval(otp)
    }
    
    override func otpViewDidSelectResend() {
        doResendOTP()
    }
    
}
extension NCBRegistrationResupplyPINVerifyViewController: NCBCardServicePresenterDelegate {
    func reissuePinConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
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
