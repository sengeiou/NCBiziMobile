//
//  NCBVerifySavingAccountViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import LocalAuthentication

class NCBVerifySavingAccountViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties
    
    fileprivate var type: TransactionType = .internalTransfer
    fileprivate var dataModels = [TransactionModel]()
    var openSavingAccountModel: NCBOpenSavingAccountModel?
    var finalSattlementSavingAccount: NCBDetailSettlementSavingAccountModel?
    fileprivate var postFinalSettlementParamsWithoutOtp: [String : Any] = [:]
    var screenType: TransactionType = .openSavingAccount
    var savingFormType: SavingFormsType = .AccumulateSaving
    fileprivate var p: NCBVerifySavingAccountPresenter?
    
    var msgId: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBVerifySavingAccountViewController {
    
    override func setupView() {
        super.setupView()
        
        var item = dataModels.first(where: { $0.type == .amount })
        lbAmountValue.text = item?.value
        item = dataModels.first(where: { $0.type == .fee })
        
        lbAmountTitle.text = "Số tiền gửi"
        let sendAmountItem = dataModels[1]
        lbAmountValue.text = sendAmountItem.value
        
        let sendScheduleItem = dataModels[2]
        let interestItem = dataModels[4]
        
        lbFee.text = "Kỳ hạn "+sendScheduleItem.value+" | "+interestItem.value
        
        authenticateView.otpBtn.setTitle("Xác nhận", for: .normal)
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifySavingAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifySavingAccountTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
        hiddenBiometricView()
        
        p = NCBVerifySavingAccountPresenter()
        p?.delegate = self
        
        switch screenType {
        case .finalSettlementSavingAccount:
            p?.generateOTPFinalSettlementAccount(params: createGenerateOTPFinalSettlementParams())
        default:
            break
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Thông tin giao dịch")
    }
    
    override func verifyAction() {
        confirmOpenSavingAccount(savingFormType)
    }
    
}

extension NCBVerifySavingAccountViewController {
    
    func setData(_ dataModels: [TransactionModel], type: TransactionType) {
        self.dataModels = dataModels
        self.type = type
    }
    
    fileprivate func showSucceedSavingAccountAction(with accountName: String?) {
        
        switch screenType {
        case .openSavingAccount:
            if let vc = R.storyboard.sendSaving.ncbSavingAccountSuccessfulViewController() {
                vc.savingFormType = savingFormType
                vc.setData(dataModels, type: .openSavingAccount)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
        
    }
    
    fileprivate func confirmOpenSavingAccount(_ savingType: SavingFormsType) {
        
        self.savingFormType = savingType
        var params: [String: Any] = [:]
        guard let openSavingAccountInfo = openSavingAccountModel else {
            return
        }
        
        params["cifno"] = NCBShareManager.shared.getUser()!.cif ?? ""
        params["debitAcct"] = openSavingAccountInfo.debitAcct
        params["ccy"] = "VND"
        params["typeId"] = openSavingAccountInfo.typeId
        params["amount"] = openSavingAccountInfo.amount
        params["term"] = openSavingAccountInfo.term
        params["interest"] = openSavingAccountInfo.interest
        params["dest"] = openSavingAccountInfo.dest
        params["fdend"] = openSavingAccountInfo.fdend
        params["benAcct"] = openSavingAccountInfo.benAcct
        params["username"] = NCBShareManager.shared.getUser()!.username ?? ""
        
        SVProgressHUD.show()
        p?.confirmSavingAccountAction(params: params)
    }
    
    fileprivate func createGenerateOTPFinalSettlementParams() -> [String : Any] {
        if let _finalSattlementSavingAccount = finalSattlementSavingAccount,
            let _savingAcctNo                = _finalSattlementSavingAccount.acctNo,
            let _savingNo                    = _finalSattlementSavingAccount.savingNumber,
            let _typeId                      = _finalSattlementSavingAccount.typeId,
            let _amount                      = _finalSattlementSavingAccount.calAmt,
            let _userName                    = NCBShareManager.shared.getUser()?.username!,
            let _cif                         = NCBShareManager.shared.getUser()?.cif!,
            let _payoutPr                    = _finalSattlementSavingAccount.payoutPr
        {
            let params = [
                "username"     : _userName,
                "cifno"        : _cif,
                "amount"       : Double(_amount),
                "savingAcctNo" : _savingAcctNo,
                "savingNo"     : _savingNo,
                "typeId"       : _typeId,
                "payOutPr"     : _payoutPr
                ] as [String : Any]
            return params
        }
        return ["":""]
    }
    
    fileprivate func createPostFinalSettlementParams(add msgId: String) -> [String : Any] {
        var params = createGenerateOTPFinalSettlementParams()
        params["lang"] = TransactionLangType.VI.rawValue
        params["msgid"] = msgId
        
        self.msgId = msgId
        
        postFinalSettlementParamsWithoutOtp = params
        return params
    }
    
    fileprivate func createPostFinalSettlementFinalParams(add otp: String) -> [String : Any] {
        var params = postFinalSettlementParamsWithoutOtp
        params["opt"] = otp
        
        return params
    }
    
}

extension NCBVerifySavingAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifySavingAccountTableViewCellID.identifier, for: indexPath) as! NCBVerifySavingAccountTableViewCell
          let  termInterestItem = dataModels[3]
          cell.termInterestLbl.text = "Kỳ lĩnh lãi: " + termInterestItem.value
        let  matureFormItem = dataModels[5]
          cell.matureFormLbl.text = "Hình thức đáo hạn: " + matureFormItem.value
        cell.destinationAccountsTitleLbl.text = "Tài khoản hưởng gốc, lãi"
        cell.destinationAccountsLbl.text = openSavingAccountModel?.benAcct
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        let accItem = dataModels[0]
        
        header?.lbSourceAccountValue.text = accItem.value
        header?.lbSourceAccount.text = "Từ tài khoản"
        if savingFormType == .ISavingSaving{
          header?.lbDestAccountValue.text = "Sổ tiết kiệm i-Savings"
        }else{
        header?.lbDestAccountValue.text = "Sổ tiết kiệm tích luỹ"
        }
        header?.lbDestAccount.text = "Tài khoản đến"
        header?.lbDestName.text = ""
        header?.lbBankName.text = ""
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension NCBVerifySavingAccountViewController: NCBVerifySavingAccountPresenterDelegate {
    
    func generateOTPAcumulation(msgId: String?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        guard let _msgId = msgId else { return }
        self.postFinalSettlementParamsWithoutOtp = createPostFinalSettlementParams(add: _msgId)
    }
    
    func getMsgIdFromOTPCompleted(msgId: String?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        guard let _msgId = msgId else { return }
        self.postFinalSettlementParamsWithoutOtp = createPostFinalSettlementParams(add: _msgId)
    }
    
    func confirmSavingAccountActionCompleted(success: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showSucceedSavingAccountAction(with: success)
    }
    
}

