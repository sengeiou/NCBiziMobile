//
//  NCBInternalTransferViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

let placeHolderContent = "Nội dung"

class NCBInternalTransferViewController: NCBBaseSourceAccountViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfDestAccount: NewNCBCommonTextField!
    @IBOutlet weak var tfDestName: NewNCBCommonTextField!
    @IBOutlet weak var tfNameReminiscent: NewNCBCommonTextField!
    @IBOutlet weak var transferAmountView: NCBTransferAmountView!
    @IBOutlet weak var tfTransferContent: NCBContentTextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    fileprivate var transferPresenter: NCBTransferPresenter?
    fileprivate var destinationAccount: NCBDestinationAccountModel?
    fileprivate var tfDestAccountFocusing = false
    var beneficiary: NCBBeneficiaryModel?
    fileprivate var isSaveBeneficiary: Bool {
        return !tfNameReminiscent.isHidden
    }
    var referPaymentAccount: NCBDetailPaymentAccountModel?
    var mofinTransferData: MofinTransferDataModel?
    fileprivate var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearData()
        isFirstLoad = false
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func loadDefaultSourceAccount() {
        guard let referPaymentAccount = referPaymentAccount else {
            super.loadDefaultSourceAccount()
            
            if let mofin = mofinTransferData, mofin.toaccount.count > 0 {
                doCheckDestinationAccount()
            }
            return
        }
        
        sourceAccount?.isSelected = false
        sourceAccount = referPaymentAccount
        let item = listPaymentAccount.first(where: { $0.acctNo == sourceAccount?.acctNo })
        item?.isSelected = true
        super.loadDefaultSourceAccount()
    }
    
    override func openFunctionFromURLScheme(_ notification: Notification) {
        let url = notification.object as? String
        let data = getTransferDataFromUrl(url)
        if data?.bankcode == StringConstant.ncbCode {
            mofinTransferData = data
            fillMofinData(mofinTransferData)
        } else {
            if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
                vc.mofinTransferData = data
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if tfDestAccountFocusing {
            tfDestAccount.resignFirstResponder()
            return
        }
        
        view.endEditing(true)
        if tfDestAccount.text == "" {
            showAlert(msg: "TRANSFER-4".getMessage() ?? "Vui lòng nhập thông tin tài khoản đích")
            return
        }
        
        if sourceAccountView?.getSourceAccount() == tfDestAccount.text {
            showAlert(msg: "Tài khoản nguồn và tài khoản đích trùng nhau. Vui lòng thử lại")
            return
        }
        
        if transferAmountView.textField.text == "" {
            showAlert(msg: "TRANSFER-5".getMessage() ?? "Vui lòng nhập số tiền")
            return
        }
        
        let amount = Double(transferAmountView.textField.text!.removeSpecialCharacter) ?? 0.0
        
        if String(sourceAccount?.cifNo ?? 0) != destinationAccount?.cif {
            if invalidTransferAmount(amount, type: .internalTransfer, limitType: .min) {
                showAlert(msg: "TRANSFER-1".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối thiểu 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
                return
            }
            
            if invalidTransferAmount(amount, type: .internalTransfer, limitType: .max) {
                showAlert(msg: "TRANSFER-2".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối đa 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
                return
            }
        }
    
        SVProgressHUD.show()
        checkBalanceTransfer(sourceAcct: sourceAccount?.acctNo ?? "", destAcct: tfDestAccount.text!, amount: amount, transType: TransType.internalTransfer.rawValue)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        if !result {
            SVProgressHUD.dismiss()
            return
        }
        
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()!.username ?? ""
        params["cifno"] = NCBShareManager.shared.getUser()!.cif ?? ""
        if let source = sourceAccount {
            params["debitacct"] = source.acctNo
        }
        params["amount"] = transferAmountView.textField.text!.removeSpecialCharacter
        params["creditacct"] = tfDestAccount.text!
        params["narrative"] = tfTransferContent.text!
        params["flagBenefit"] = isSaveBeneficiary ? 1 : 0
        
        SVProgressHUD.show()
        transferPresenter?.pushTransferInfo(params: params, type: .internalTransfer)
    }
    
}

extension NCBInternalTransferViewController {
    
    override func setupView() {
        super.setupView()
        
        tfDestAccount.addTarget(self, action: #selector(destAccountEditingChanged), for: .editingChanged)
        tfDestAccount.keyboardType = .numberPad
        tfDestAccount.addRightView(R.image.ic_dest_account())
        tfDestName.addSaveButton()
        hiddenReceiverNameView(true)
        
        tfDestAccount.delegate = self
        tfDestAccount.customDelegate = self
        tfDestName.customDelegate = self
        tfDestName.delegate = self
        tfNameReminiscent.delegate = self
        transferAmountView.textField.delegate = self
        
        transferPresenter = NCBTransferPresenter()
        transferPresenter?.delegate = self
        
        if let mofin = mofinTransferData {
            fillMofinData(mofin)
        } else if let beneficiary = beneficiary {
            didSelectBeneficiaryItem(item: beneficiary)
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CHUYỂN KHOẢN NỘI BỘ")
        
        tfDestAccount.placeholder = "Số tài khoản nhận"
        tfDestName.placeholder = "Tên người nhận"
        tfNameReminiscent.placeholder = "Tên gợi nhớ"
        tfTransferContent.placeholder = "Nội dung chuyển tiền"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
}

extension NCBInternalTransferViewController {
    
    @objc fileprivate func destAccountEditingChanged() {
        transferAmountView.clear()
        tfTransferContent.text = ""
        hiddenReceiverNameView(true)
    }
    
    fileprivate func clearData() {
        if NCBShareManager.shared.areTrading || isFirstLoad {
            return
        }
        
        tfDestAccount.text = ""
        transferAmountView.clear()
        tfTransferContent.text = ""
        hiddenReceiverNameView(true)
        defaultSourceAccount()
    }
    
    fileprivate func fillMofinData(_ mofin: MofinTransferDataModel?) {
        guard let mofin = mofin else {
            return
        }
        
        tfDestAccount.text = mofin.toaccount
        transferAmountView.textField.text = mofin.amount
        transferAmountView.moneyEditingChanged()
        tfTransferContent.text = mofin.remark

        tfDestAccount.isEnabled = false
        tfDestName.isEnabled = false
        tfNameReminiscent.isEnabled = false
        transferAmountView.textField.isEnabled = false
        tfTransferContent.isEnabled = false
    }
    
    fileprivate func hiddenReceiverNameView(_ hidden: Bool) {
        tfDestName.clear()
        hiddenNameReminiscentView(hidden)
        tfDestName.isHidden = hidden
        for constraint in tfDestName.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfDestName.text = ""
            tfDestName.drawViewsForRect(tfDestName.frame)
        }
    }
    
    fileprivate func hiddenNameReminiscentView(_ hidden: Bool) {
        if !hidden {
            tfDestName.isOnSaveBeneficiary()
        }
        tfNameReminiscent.isHidden = hidden
        for constraint in tfNameReminiscent.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfNameReminiscent.text = ""
            tfNameReminiscent.drawViewsForRect(tfNameReminiscent.frame)
        }
    }
    
    fileprivate func showBeneficiaryList() {
        if tfDestAccountFocusing {
            tfDestAccount.resignFirstResponder()
            return
        }
        
        if let vc = R.storyboard.transfer.ncbBeneficiaryListViewController() {
            vc.delegate = self
            vc.sourceAccount = sourceAccount
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doCheckDestinationAccount() {
        if tfDestAccount.text == "" {
            tfDestName.text = ""
            hiddenReceiverNameView(true)
            return
        }
        
        let params = [
            "username": NCBShareManager.shared.getUser()!.username ?? "",
            "account": tfDestAccount.text!
        ] as [String: Any]
        
        SVProgressHUD.show()
        transferPresenter?.checkDestinationAccount(params: params)
    }
    
    fileprivate func showTransferInfo(_ info: NCBTransferInfoModel) {
        if let vc = R.storyboard.transaction.ncbVerifyTransactionViewController() {
            vc.setData([TransactionModel(title: "Từ tài khoản", value: info.debitAcct ?? "", type: .sourceAccount), TransactionModel(title: "Đến số tài khoản nhận", value: info.creditAcct ?? "", type: .destAccount), TransactionModel(title: "Tên người nhận", value: info.creditName ?? "", type: .destName), TransactionModel(title: "Số tiền", value: "\((info.amount ?? 0.0).currencyFormatted)", type: .amount), TransactionModel(title: "Nội dung chuyển tiền", value: info.narrative ?? ""),
                TransactionModel(title: "Phí dịch vụ", value: "\((info.fee ?? 0.0).currencyFormatted)", type: .fee)], type: .internalTransfer, footerType: (info.creditCif == info.debitCif) ? .confirm : .verify)
            vc.transferInfo = info
            vc.exceedLimit = exceedLimit(info.amount ?? 0.0, type: .internalTransfer)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBInternalTransferViewController: UITextFieldDelegate, NewNCBCommonTextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfDestAccount {
            tfDestAccountFocusing = false
            doCheckDestinationAccount()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfDestName {
            return false
        } else if textField == transferAmountView.textField {
            if tfDestAccountFocusing {
                tfDestAccount.resignFirstResponder()
            }
            return !tfDestName.isHidden
        }
        tfDestAccountFocusing = (textField == tfDestAccount)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        if string.count > 1 {
            return true
        }
        
        var currentText = textField.text ?? ""
        
        if textField == tfDestAccount {
            if string == "" {
                return true
            }
            
            let set = NSCharacterSet.alphanumerics.inverted
            if string.rangeOfCharacter(from: set) == nil {
                currentText = currentText.folding(options: .diacriticInsensitive, locale: .current)
                textField.text = currentText + string
            }
            
            return false
        } else if textField == tfNameReminiscent {
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 20
        }
        return true
    }
    
    func textFieldDidSelectRightArrow(_ textField: UITextField) {
        if textField == tfDestAccount {
            showBeneficiaryList()
        }
    }
    
    func textFieldDidChangeNameReminiscent(_ textField: UITextField, value: Bool) {
        if textField == tfDestName {
            hiddenNameReminiscentView(!value)
        }
    }
    
}

extension NCBInternalTransferViewController: NCBBeneficiaryListViewControllerDelegate {
    
    func didSelectBeneficiaryItem(item: NCBBeneficiaryModel) {
        hiddenReceiverNameView(false)
        if let memName = item.memName {
            tfDestName.isOnSaveBeneficiary()
            tfNameReminiscent.text = memName
            hiddenNameReminiscentView(false)
        }
        tfDestAccount.text = item.accountNo
        tfDestName.text = item.accountName
        doCheckDestinationAccount()
    }
    
}

extension NCBInternalTransferViewController: NCBTransferPresenterDelegate {
    
    func checkDestinationAccountCompleted(destAccount: NCBDestinationAccountModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            transferAmountView.clear()
            tfDestName.text = ""
            hiddenReceiverNameView(true)
            return
        }
        
        destinationAccount = destAccount
        tfDestName.text = destAccount?.accountName
        hiddenReceiverNameView(false)
    }
    
    func pushTransferInfoCompleted(info: NCBTransferInfoModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let info = info {
            info.memName = tfNameReminiscent.text
            showTransferInfo(info)
        }
    }
    
}
