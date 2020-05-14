//
//  NCBCharityTransferViewController.swift
//  NCBApp
//
//  Created by Thuan on 5/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCharityTransferViewController: NCBBaseSourceAccountViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfCharityOrganization: NewNCBCommonTextField!
    @IBOutlet weak var transferAmountView: NCBTransferAmountView!
    @IBOutlet weak var tfContent: NCBContentTextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    var destinationAcc: NCBCharityOrganizationModel?
    var presenter: NCBTransferPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearData()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    @IBAction func continueACtion(_ sender: Any) {
        view.endEditing(true)
        if tfCharityOrganization.text == "" {
            showAlert(msg: "TRANSFER_DONATE-1".getMessage() ?? "Vui lòng chọn tổ chức từ thiện")
            return
        }
        
        if transferAmountView.textField.text == "" {
            showAlert(msg: "TRANSFER-5".getMessage() ?? "Vui lòng nhập số tiền")
            return
        }
        
//        if let source = sourceAccount, let curBal = source.curBal {
//            let total = Double(curBal)
//            let amount = Double(transferAmountView.textField.text!.removeSpecialCharacter) ?? 0.0
//            if total < amount {
//                showAlert(msg: "Tài khoản nguồn không đủ số dư")
//                return
//            }
//        }
        
        guard let destinationAcc = destinationAcc else {
            return
        }
        
        var transTypeID: TransactionType = .internalTransfer
        if destinationAcc.txntype == "CKCITAD" {
            transTypeID = .citad
        }
        
        let amount = Double(transferAmountView.textField.text!.removeSpecialCharacter) ?? 0.0
        
        if invalidTransferAmount(amount, type: transTypeID, limitType: .min) {
            showAlert(msg: "TRANSFER-1".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối thiểu 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if invalidTransferAmount(amount, type: transTypeID, limitType: .max) {
            showAlert(msg: "TRANSFER-2".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối đa 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceTransfer(sourceAcct: sourceAccount?.acctNo ?? "", destAcct: destinationAcc.accno ?? "", amount: amount, transType: (transTypeID == .internalTransfer) ? TransType.internalTransfer.rawValue : TransType.citad.rawValue, flagCharity: true)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        if !result {
            SVProgressHUD.dismiss()
            return
        }
        
        presenter?.pushTransferInfo(params: createPushTransferParams(), type: .charity)
    }
    
}

extension NCBCharityTransferViewController {
    
    override func setupView() {
        super.setupView()
        
        tfCharityOrganization.addRightArrow()
        tfCharityOrganization.delegate = self
        
        presenter = NCBTransferPresenter()
        presenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CHUYỂN TIỀN TỪ THIỆN")
        tfCharityOrganization.placeholder = "Đến tổ chức từ thiện"

        tfContent.placeholder = "Nội dung chuyển tiền"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    fileprivate func createPushTransferParams() -> [String : Any] {
        
        if let _sourceAccount = sourceAccount, let _destinationAccount = destinationAcc {
            let params: [String : Any] = [
                "username" : NCBShareManager.shared.getUser()?.username ?? "",
                "cifno" : NCBShareManager.shared.getUser()?.cif ?? "",
                "debitacct" : _sourceAccount.acctNo ?? "",
                "amount" : transferAmountView.textField.text!.removeSpecialCharacter,
                "creditacct" : _destinationAccount.accno ?? "",
                "txntype" : _destinationAccount.txntype ?? "",
                "bnkcode" : _destinationAccount.bnkcode ?? "",
                "narrative" : tfContent.text ?? ""
            ]
            
            return params
        }
        
        return [:]
    }
}

extension NCBCharityTransferViewController {
    
    fileprivate func clearData() {
        if NCBShareManager.shared.areTrading {
            return
        }
        
        tfCharityOrganization.text = ""
        transferAmountView.clear()
        tfContent.text = ""
        defaultSourceAccount()
    }
    
    fileprivate func showCharityOrgazination() {
        if let vc = R.storyboard.transfer.ncbCharityOrganizationListViewController() {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBCharityTransferViewController : NCBTransferPresenterDelegate {
    
    func pushTransferInfoCompleted(info: NCBTransferInfoModel?, error: String?) {
        
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let vc = R.storyboard.transaction.ncbVerifyTransactionViewController() {
            vc.transferInfo = info
            
            if let _info = info {
                vc.transferInfo?.bnkcode = _info.bnkcode
                vc.setData([
                    TransactionModel(title: "Từ tài khoản", value: _info.debitAcct ?? "", type: .sourceAccount),
                    TransactionModel(title: "Đến số tài khoản nhận", value: _info.creditAcct ?? "", type: .destAccount),
                    TransactionModel(title: "Tổ chức từ thiện", value: _info.creditName ?? "", type: .destName),
                    TransactionModel(title: "Tại ngân hàng", value: _info.creditBankName ?? "", type: .bankName),
                    TransactionModel(title: "Số tiền", value: Double(_info.amount ?? 0.0).currencyFormatted, type: .amount),
                    TransactionModel(title: "Nội dung chuyển tiền", value: _info.narrative ?? ""),
                    TransactionModel(title: "Phí dịch vụ", value: (_info.fee ?? 0.0).currencyFormatted, type: .fee)], type: .charity)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}

extension NCBCharityTransferViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCharityOrganization {
            showCharityOrgazination()
            return false
        }
        return true
    }
    
}

extension NCBCharityTransferViewController: NCBCharityOrganizationListViewControllerDelegate {
    
    func didSelectCharityItem(item: NCBCharityOrganizationModel) {
        tfCharityOrganization.text = item.accname
        self.destinationAcc = item
    }
}
