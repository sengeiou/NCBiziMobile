//
//  NCBInterbankTransferChildViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum InterbankTransferType: Int {
    case fast = 0
    case normal
}

enum DutyType: String {
    case N
    case Y
}

enum TransferOption: String {
    case ACCT
    case CARD
}

struct BankCodeItemModel {
    var bankCode: String = ""
    var provinceCode: String = ""
    var creditBranch: String = ""
}

class NCBInterbankTransferChildViewController: NCBBaseSourceAccountViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var accountNumberBtn: UIButton!
    @IBOutlet weak var cardNumberBtn: UIButton!
    @IBOutlet weak var containerCardNumberView: UIView!
    @IBOutlet weak var tfDestAccount: NewNCBCommonTextField!
    @IBOutlet weak var tfDestAccountName: NewNCBCommonTextField!
    @IBOutlet weak var tfNameReminiscent: NewNCBCommonTextField!
    @IBOutlet weak var tfBank: NewNCBCommonTextField!
    @IBOutlet weak var containerBankBranchView: UIView!
    @IBOutlet weak var tfBankProvince: NewNCBCommonTextField!
    @IBOutlet weak var tfBankBranch: NewNCBCommonTextField!
    @IBOutlet weak var transferAmountView: NCBTransferAmountView!
    @IBOutlet weak var feeContainerView: UIView!
    @IBOutlet weak var transferPayBtn: UIButton!
    @IBOutlet weak var receiverPayBtn: UIButton!
    @IBOutlet weak var tfTransferContent: NCBContentTextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    fileprivate var interbankType: InterbankTransferType = .fast
    fileprivate var destinationAccount: NCBAccountInfo247Model?
    fileprivate var bankCodeItem = BankCodeItemModel(bankCode: "", provinceCode: "", creditBranch: "")
    fileprivate var p: NCBTransferPresenter?
    fileprivate var tfDestAccountFocusing = false
    fileprivate var beneficiary: NCBBeneficiaryModel?
    fileprivate var isSaveBeneficiary: Bool {
        return !tfNameReminiscent.isHidden
    }
    
    fileprivate var transactionType: TransactionType {
        return (interbankType == .fast) ? .fast247 : .citad
    }
    
    fileprivate var isViaAccount: Bool {
        return accountNumberBtn.isSelected
    }
    fileprivate var referPaymentAccount: NCBDetailPaymentAccountModel?
    fileprivate var isFirstLoad = true
    
    override var getSourcePaymentCode: PaymentControlCode {
        if interbankType == .fast {
            return .CK247
        }
        return .CKCITAD
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        removeAllNotification()
        clearData()
        isFirstLoad = false
    }
    
    override func loadDefaultSourceAccount() {
        guard let referPaymentAccount = referPaymentAccount else {
            super.loadDefaultSourceAccount()
            
            if bankCodeItem.bankCode != "" && tfDestAccount.text != "" {
                doGetInfoAccount247()
            }
            return
        }
        
        sourceAccount?.isSelected = false
        sourceAccount = referPaymentAccount
        let item = listPaymentAccount.first(where: { $0.acctNo == sourceAccount?.acctNo })
        item?.isSelected = true
        super.loadDefaultSourceAccount()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if tfDestAccountFocusing {
            tfDestAccount.resignFirstResponder()
            return
        }
        
        view.endEditing(true)
        
        if tfBank.isEnabled && isViaAccount && tfBank.text == "" {
            showAlert(msg: "CTAD-TRANSFER-2".getMessage() ?? "Vui lòng chọn Ngân hàng nhận")
            return
        }
        
        if tfDestAccount.text == "" {
            showAlert(msg: (isViaAccount || interbankType == .normal) ? "TRANSFER-4".getMessage() ?? "Vui lòng nhập thông tin tài khoản đích" : "TRANSFER-247-1".getMessage() ?? "Vui lòng nhập số thẻ")
            return
        }
        
        if interbankType == .normal && tfDestAccountName.text == "" {
            showAlert(msg: "CTAD-TRANSFER-1".getMessage() ?? "Vui lòng nhập tên người nhận")
            return
        }
        
        if bankCodeItem.bankCode == StringConstant.agribankCode && transactionType == .citad {
            if tfBankProvince.text == "" {
                showAlert(msg: "Vui lòng chọn tỉnh thành")
                return
            }
            
            if tfBankBranch.text == "" {
                showAlert(msg: "Vui lòng chọn chi nhánh")
                return
            }
        }
        
        if transactionType == .fast247 && tfDestAccountName.text == "" {
            showAlert(msg: "Không tìm thấy thông tin tài khoản")
            return
        }
        
        if transferAmountView.textField.text == "" {
            showAlert(msg: "TRANSFER-5".getMessage() ?? "Vui lòng nhập số tiền")
            return
        }
        
        let amount = Double(transferAmountView.textField.text!.removeSpecialCharacter) ?? 0.0
        
        if invalidTransferAmount(amount, type: (interbankType == .normal) ? .citad : .fast247, limitType: .min) {
            showAlert(msg: "TRANSFER-1".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối thiểu 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if invalidTransferAmount(amount, type: (interbankType == .normal) ? .citad : .fast247, limitType: .max) {
            showAlert(msg: "TRANSFER-2".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối đa 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceTransfer(sourceAcct: sourceAccount?.acctNo ?? "", destAcct: tfDestAccount.text!, amount: amount, transType: interbankType == .fast ? TransType.fast247.rawValue : TransType.citad.rawValue)
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
        params["narrative"] = tfTransferContent.text!
        params["flagBenefit"] = isSaveBeneficiary ? 1 : 0
        
        if interbankType == .fast {
            params["memName"] = tfNameReminiscent.text ?? ""
            params["benBankCode"] = bankCodeItem.bankCode
            params["benBankAcctCard"] = tfDestAccount.text ?? ""
            params["typeTransfer"] = isViaAccount ? TransferOption.ACCT.rawValue : TransferOption.CARD.rawValue
        } else if interbankType == .normal {
            params["creditacct"] = tfDestAccount.text!
            params["creditName"] = tfDestAccountName.text!
            params["creditBank"] = bankCodeItem.bankCode
            params["creditProvince"] = bankCodeItem.provinceCode
            params["creditBranch"] = bankCodeItem.creditBranch
            params["duty"] = (transferPayBtn.isSelected) ? DutyType.N.rawValue : DutyType.Y.rawValue
        }
        
        SVProgressHUD.show()
        p?.pushTransferInfo(params: params, type: transactionType)
    }
    
}

extension NCBInterbankTransferChildViewController {
    
    override func setupView() {
        super.setupView()
        
        accountNumberBtn.titleLabel?.font = regularFont(size: 12)
        accountNumberBtn.setTitleColor(ColorName.holderText.color, for: .normal)
        accountNumberBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        accountNumberBtn.setImage(R.image.ic_radio_check(), for: .selected)
        accountNumberBtn.isSelected = true
        
        cardNumberBtn.titleLabel?.font = regularFont(size: 12)
        cardNumberBtn.setTitleColor(ColorName.holderText.color, for: .normal)
        cardNumberBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        cardNumberBtn.setImage(R.image.ic_radio_check(), for: .selected)
        
        transferPayBtn.titleLabel?.font = regularFont(size: 12)
        transferPayBtn.setTitleColor(ColorName.holderText.color, for: .normal)
        transferPayBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        transferPayBtn.setImage(R.image.ic_radio_check(), for: .selected)
        transferPayBtn.isSelected = true
        
        receiverPayBtn.titleLabel?.font = regularFont(size: 12)
        receiverPayBtn.setTitleColor(ColorName.holderText.color, for: .normal)
        receiverPayBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        receiverPayBtn.setImage(R.image.ic_radio_check(), for: .selected)
        
        tfDestAccount.addRightView(R.image.ic_dest_account())
        tfDestAccountName.addSaveButton()
        tfBank.addRightArrow()
        tfBankProvince.addRightArrow()
        tfBankBranch.addRightArrow()
        
        accountNumberBtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        cardNumberBtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        
        transferPayBtn.addTarget(self, action: #selector(choosePayer(_:)), for: .touchUpInside)
        receiverPayBtn.addTarget(self, action: #selector(choosePayer(_:)), for: .touchUpInside)
        
        tfDestAccount.delegate = self
        tfDestAccount.customDelegate = self
        tfBank.delegate = self
        tfBankProvince.delegate = self
        tfBankBranch.delegate = self
        tfDestAccountName.delegate = self
        tfDestAccountName.customDelegate = self
        tfNameReminiscent.delegate = self
        transferAmountView.textField.delegate = self
        
        hiddenBankBranchView(true)
        
        p = NCBTransferPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        tfDestAccount.placeholder = (isViaAccount) ? "Số tài khoản nhận" : "Số thẻ"
        tfDestAccountName.placeholder = "Tên người nhận"
        tfNameReminiscent.placeholder = "Tên gợi nhớ"
        tfTransferContent.placeholder = "Nội dung chuyển tiền"
        tfBank.placeholder = "Ngân hàng nhận"
        tfBankProvince.placeholder = "Tỉnh thành"
        tfBankBranch.placeholder = "Chi nhánh"
        tfNameReminiscent.placeholder = "Tên gợi nhớ"
        accountNumberBtn.setTitle("Đến số tài khoản", for: .normal)
        cardNumberBtn.setTitle(" Đến số thẻ", for: .normal)
        transferPayBtn.setTitle("Phí người chuyển trả", for: .normal)
        receiverPayBtn.setTitle("Phí người nhận trả", for: .normal)
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    func reloadView(_ type: InterbankTransferType, beneficiary: NCBBeneficiaryModel?, referPaymentAccount: NCBDetailPaymentAccountModel?, mofin: MofinTransferDataModel?) {
        self.interbankType = type
        self.referPaymentAccount = referPaymentAccount
        if let mofin = mofin {
            fillMofinData(mofin)
        }
        
        hiddenOptionalView()
//        hiddenReceiverNameView((interbankType == .fast))
        hiddenReceiverNameView(true)
        
        if let beneficiary = beneficiary {
            didSelectBeneficiaryItem(item: beneficiary)
            
            if beneficiary.isCard {
                accountNumberBtn.isSelected = false
                cardNumberBtn.isSelected = true
                
                renderBankNameView()
            }
        }
        
        tfTransferContent.limitValue = (interbankType == .fast) ? 79 : 100
    }
    
    @objc func chooseOption(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        tfDestAccount.resignFirstResponder()
        if sender == accountNumberBtn {
            accountNumberBtn.isSelected = true
            cardNumberBtn.isSelected = false
            tfDestAccount.keyboardType = .default
        } else if sender == cardNumberBtn {
            accountNumberBtn.isSelected = false
            cardNumberBtn.isSelected = true
            tfDestAccount.keyboardType = .numberPad
        }
        
        tfDestAccount.text = ""
        tfDestAccountName.text = ""
        hiddenReceiverNameView(true)
        tfBank.text = ""
        tfBankProvince.text = ""
        tfBankBranch.text = ""
        bankCodeItem.bankCode = ""
        bankCodeItem.creditBranch = ""
        bankCodeItem.provinceCode = ""
        renderBankNameView()
        tfDestAccount.placeholder = (isViaAccount || transactionType == .citad) ? "Số tài khoản nhận" : "Số thẻ"
    }
    
    @objc func choosePayer(_ sender: UIButton) {
        if sender == transferPayBtn {
            transferPayBtn.isSelected = true
            receiverPayBtn.isSelected = false
        } else if sender == receiverPayBtn {
            transferPayBtn.isSelected = false
            receiverPayBtn.isSelected = true
        }
    }
    
    fileprivate func hiddenOptionalView() {
        containerCardNumberView.isHidden = !(interbankType == .fast)
        for constraint in containerCardNumberView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (interbankType == .fast) ? 30 : 0
            }
        }
        
        feeContainerView.isHidden = (interbankType == .fast)
        for constraint in feeContainerView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (interbankType == .normal) ? 55 : 0
            }
        }
    }
    
    fileprivate func hiddenBankBranchView(_ hidden: Bool) {
        containerBankBranchView.isHidden = hidden
        for constraint in containerBankBranchView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField*2
            }
        }
    }
    
    fileprivate func renderBankNameView() {
        let hidden = (!isViaAccount && transactionType == .fast247)
        tfBank.isHidden = hidden
        for constraint in tfBank.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = hidden ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfBank.text = ""
            tfBank.drawViewsForRect(tfBank.frame)
        }
    }
    
    fileprivate func hiddenReceiverNameView(_ hidden: Bool) {
        tfDestAccountName.clear()
        hiddenNameReminiscentView(hidden)
        tfDestAccountName.isHidden = hidden
        for constraint in tfDestAccountName.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfDestAccountName.text = ""
            tfDestAccountName.drawViewsForRect(tfDestAccountName.frame)
        }
    }
    
    fileprivate func hiddenNameReminiscentView(_ hidden: Bool) {
        if !hidden {
            tfDestAccountName.isOnSaveBeneficiary()
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
    
    fileprivate func clearData() {
        if NCBShareManager.shared.areTrading || isFirstLoad {
            return
        }
        
        transferAmountView.clear()
        tfTransferContent.text = ""
        tfDestAccount.text = ""
        tfDestAccountName.text = ""
        hiddenReceiverNameView(true)
        tfBank.text = ""
        tfBankProvince.text = ""
        tfBankBranch.text = ""
        bankCodeItem.bankCode = ""
        bankCodeItem.creditBranch = ""
        bankCodeItem.provinceCode = ""
        renderBankNameView()
        hiddenBankBranchView(true)
        defaultSourceAccount()
    }
    
    fileprivate func fillMofinData(_ mofin: MofinTransferDataModel) {
        chooseOption(accountNumberBtn)
        tfDestAccount.text = mofin.toaccount
        transferAmountView.textField.text = mofin.amount
        transferAmountView.moneyEditingChanged()
        tfBank.text = mofin.bankname
        bankCodeItem.bankCode = mofin.bankcode
        tfTransferContent.text = mofin.remark

        accountNumberBtn.isUserInteractionEnabled = false
        cardNumberBtn.isUserInteractionEnabled = false
        tfDestAccount.isEnabled = false
        tfDestAccountName.isEnabled = false
        transferAmountView.textField.isEnabled = false
        tfBank.isEnabled = false
        tfTransferContent.isEnabled = false
    }
    
}

extension NCBInterbankTransferChildViewController: UITextFieldDelegate, NewNCBCommonTextFieldDelegate {
    
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
        
        if textField == tfNameReminiscent {
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 20
        } else if textField == tfDestAccount || textField == tfDestAccountName {
            if string == "" {
                return true
            }
            var set: CharacterSet!
            switch textField {
            case tfDestAccount:
                set = CharacterSet.alphanumerics.inverted
            case tfDestAccountName:
                set = CharacterSet(charactersIn: StringConstant.specialCharacters)
            default:
                break
            }
            
            if string.rangeOfCharacter(from: set) == nil {
                currentText = currentText.folding(options: .diacriticInsensitive, locale: .current)
                textField.text = currentText + string
            }
            
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfDestAccount {
            tfDestAccountFocusing = false
            if interbankType == .normal {
                hiddenReceiverNameView(tfDestAccount.text == "")
                return
            }
            doGetInfoAccount247()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfBank {
            showBankList(.bank)
            return false
        } else if textField == tfBankProvince {
            showBankList(.province)
            return false
        } else if textField == tfBankBranch {
            if tfBankProvince.text == "" {
                showAlert(msg: "Hãy chọn tỉnh thành trước")
            } else {
                showBankList(.branch)
            }
            return false
        } else if textField == tfDestAccount && isViaAccount && interbankType == .fast && bankCodeItem.bankCode == "" {
            showAlert(msg: "Hãy chọn ngân hàng nhận trước")
            return false
        } else if textField == tfDestAccountName && interbankType == .fast {
            return false
        } else if textField == transferAmountView.textField && interbankType == .fast {
            if tfDestAccountFocusing {
                tfDestAccount.resignFirstResponder()
            }
            return !tfDestAccountName.isHidden
        }
        tfDestAccountFocusing = (textField == tfDestAccount)
        return true
    }
    
    func textFieldDidSelectRightArrow(_ textField: UITextField) {
        if textField == tfDestAccount {
            showBeneficiaryList()
        }
    }
    
    func textFieldDidChangeNameReminiscent(_ textField: UITextField, value: Bool) {
        if textField == tfDestAccountName {
            hiddenNameReminiscentView(!value)
        }
    }
    
}

extension NCBInterbankTransferChildViewController {
    
    fileprivate func showBeneficiaryList() {
        if tfDestAccountFocusing {
            tfDestAccount.resignFirstResponder()
            return
        }
        
        if let vc = R.storyboard.transfer.ncbBeneficiaryListViewController() {
            vc.delegate = self
            vc.sourceAccount = sourceAccount
            vc.type = transactionType
            vc.viaAccountNumber = isViaAccount
            vc.hasBankCode = bankCodeItem.bankCode
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showBankList(_ type: BankGetType) {
        if tfDestAccountFocusing {
            tfDestAccount.resignFirstResponder()
            return
        }
        
        if let vc = R.storyboard.transfer.ncbBankListViewController() {
            vc.delegate = self
            vc.getType = type
            vc.bankCodeItem = bankCodeItem
            vc.serviceType = (interbankType == .fast) ? .payment : .fundTransfer
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showTransferInfo(_ info: NCBTransferInfoModel) {
        if let vc = R.storyboard.transaction.ncbVerifyTransactionViewController() {
            var dataModels = [TransactionModel]()
            dataModels.append(TransactionModel(title: "Từ tài khoản", value: info.debitAcct ?? "", type: .sourceAccount))
            dataModels.append(TransactionModel(title: (interbankType == .normal || isViaAccount) ? "Đến số tài khoản nhận" : "Đến số thẻ", value: info.creditAcct ?? "", type: .destAccount))
            dataModels.append(TransactionModel(title: "Tên người nhận", value: info.creditName ?? "", type: .destName))
            
            if (interbankType == .fast && isViaAccount) || interbankType == .normal {
                var bankStr = info.creditBankName ?? ""
                if bankCodeItem.bankCode == StringConstant.agribankCode {
                    if let province = info.creditProvinceName {
                        bankStr = bankStr + "\n" + province
                    }
                    
                    if let branch = info.creditBranchName {
                        bankStr = bankStr + "\n" + branch
                    }
                }
                
                dataModels.append(TransactionModel(title: "Ngân hàng", value: bankStr, type: .bankName))
            }
            
            dataModels.append(TransactionModel(title: "Số tiền", value: "\((info.amount ?? 0.0).currencyFormatted)", type: .amount))
            dataModels.append(TransactionModel(title: "Nội dung chuyển tiền", value: info.narrative ?? ""))
            dataModels.append(TransactionModel(title: "Phí dịch vụ", value: "\((info.fee ?? 0.0).currencyFormatted)", type: .fee))
            
            vc.setData(dataModels, type: transactionType, footerType: (info.creditCif == info.debitCif) ? .confirm : .verify)
            vc.transferInfo = info
            vc.exceedLimit = exceedLimit(info.amount ?? 0.0, type: transactionType)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doGetInfoAccount247() {
        if interbankType == .normal {
            return
        }
        
        if tfDestAccount.text == "" {
            tfDestAccountName.text = ""
            hiddenReceiverNameView(true)
            return
        }
        
        let params = [
            "username": NCBShareManager.shared.getUser()!.username ?? "",
            "debitAccountNo": sourceAccount?.acctNo ?? "",
            "benBankCode": bankCodeItem.bankCode,
            "benBankAcctCard": tfDestAccount.text ?? "",
            "typeTransfer": isViaAccount ? TransferOption.ACCT.rawValue : TransferOption.CARD.rawValue,
            ] as [String: Any]
        
        SVProgressHUD.show()
        p?.getInfoAccount247(params: params)
    }
    
}

extension NCBInterbankTransferChildViewController: NCBBeneficiaryListViewControllerDelegate {
    
    func didSelectBeneficiaryItem(item: NCBBeneficiaryModel) {
        tfDestAccount.text = item.accountNo
        tfDestAccountName.text = item.accountName
        tfDestAccountName.text = item.accountName
        tfBank.text = item.benBankName
        tfBankProvince.text = item.provinceName
        tfBankBranch.text = item.branchName
        
        bankCodeItem.bankCode = item.benBank ?? ""
        bankCodeItem.provinceCode = item.province ?? ""
        bankCodeItem.creditBranch = item.branch ?? ""
        
        hiddenReceiverNameView(false)
        tfNameReminiscent.text = item.memName
        
        hiddenBankBranchView(!(item.benBank == StringConstant.agribankCode && transactionType == .citad))
        doGetInfoAccount247()
    }
    
}

extension NCBInterbankTransferChildViewController: NCBBankListViewControllerDelegate {
    
    func didSelectBankItem(item: NCBBankModel, type: BankGetType) {
        switch type {
        case .province:
            tfBankProvince.text = item.shrtname
            bankCodeItem.provinceCode = item.pro_id ?? ""
        case .branch:
            tfBankBranch.text = item.chi_nhanh
            bankCodeItem.creditBranch = item.citad_gt ?? ""
        default:
            tfBank.text = item.bnkname
            hiddenBankBranchView(!(item.bnk_code == StringConstant.agribankCode && transactionType == .citad))
            bankCodeItem.bankCode = item.bnk_code ?? ""
        }
    }
    
}

extension NCBInterbankTransferChildViewController: NCBTransferPresenterDelegate {
    
    func pushTransferInfoCompleted(info: NCBTransferInfoModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let info = info {
            info.memName = tfNameReminiscent.text
            info.typeTransfer = isViaAccount ? TransferOption.ACCT.rawValue : TransferOption.CARD.rawValue
            if tfTransferContent.text == "" {
                info.narrative = ""
            }
            showTransferInfo(info)
        }
    }
    
    func getInfoAccount247Completed(infoAccount: NCBAccountInfo247Model?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            destinationAccount = nil
            tfDestAccountName.text = ""
            hiddenReceiverNameView(true)
            return
        }
        
        destinationAccount = infoAccount
        tfDestAccountName.text = infoAccount?.toAcctName
        hiddenReceiverNameView(false)
    }
    
}
