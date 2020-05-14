//
//  NCBVerifyTransactionViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import LocalAuthentication

struct TransactionModel {
    var title = ""
    var value = ""
    var type: TransactionFieldType?
    
    init(title: String, value: String, type: TransactionFieldType? = nil) {
        self.title = title
        self.value = value
        self.type = (type != nil) ? type : .other
    }
}

enum TransactionFieldType: Int {
    case fee = 0
    case amount
    case sourceAccount
    case destAccount
    case destName
    case bankName
    case other
}

enum TransactionType: Int {
    case internalTransfer = 0
    case fast247
    case citad
    case charity
    case finalSettlementSavingAccount
    case additionalSavingAccount
    case openSavingAccount
    case payBillingVNPAY
    case payBillingPayoo
    case payBillingNapas
    case topupPhoneNumb
    case topupAirPay
    case autoPaymentRegister
    case updateCardStatusUnlockApproval
    case cardActiveApproval
    case createAtmApproval
    case reopenAtmApproval
    case reissuePinApproval
    case creditCardPayment
    case registerEcom
    case openAccountOnline
    case autoDebtDeduction
    case registerSMSBanking
    case reopenVisaApproval
    case userRequest
    case softOTPRegister
    case softOTPResend
    case none
}

enum TransactionConfirmType: String {
    case OTP
    case TOUCHID
    case FACEID
}

enum TransactionLangType: String {
    case VI
    case EN
}

enum TransactionFooterType: Int {
    case verify = 0
    case confirm
}

class NCBVerifyTransactionViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties
    
    var transferInfo: NCBTransferInfoModel?
    fileprivate var dataModels = [TransactionModel]()
    fileprivate var type: TransactionType = .internalTransfer
    fileprivate var footerType: TransactionFooterType = .verify
    fileprivate var confirmInfo: NCBConfirmTransferInfoModel?
    fileprivate var p: NCBVerifyTransactionPresenter?
    fileprivate var confirmType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBVerifyTransactionViewController {
    
    override func setupView() {
        super.setupView()
        
        var item = dataModels.first(where: { $0.type == .amount })
        lbAmountValue.text = item?.value

        item = dataModels.first(where: { $0.type == .fee })
        lbFee.text = "*Phí dịch vụ: \(item?.value ?? "")"

        authenticateView.otpBtn.setTitle((footerType == .confirm) ? "Xác nhận" : "Xác thực OTP", for: .normal)
        if footerType == .confirm || exceedLimit {
            hiddenBiometricView()
        }
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifyTransactionOtherInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransactionOtherInfoTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
        p = NCBVerifyTransactionPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
//        switch type {
//        case .internalTransfer:
//            setHeaderTitle("CHUYỂN KHOẢN NỘI BỘ")
//        case .citad:
//            setHeaderTitle("CHUYỂN KHOẢN LIÊN NGÂN HÀNG")
//        case .charity:
//            setHeaderTitle("CHUYỂN TIỀN TỪ THIỆN")
//        case .fast247:
//            setHeaderTitle("CHUYỂN KHOẢN NHANH 24/7")
//        default:
//            break
//        }
        setHeaderTitle("Thông tin giao dịch")
    }
    
    override func verifyAction() {
        switch footerType {
        case .confirm:
            doConfirm("")
        case .verify:
            doConfirm(TransactionConfirmType.OTP.rawValue)
        }
    }
    
    override func verifyWithTouchID() {
        doConfirm(getConfirmType())
    }
    
    override func otpViewDidSelectAccept(_ otp: String) {
        doApproval(otp)
    }
    
    override func otpViewDidSelectResend() {
        doResendOTP()
    }
    
}

extension NCBVerifyTransactionViewController {
    
    func setData(_ dataModels: [TransactionModel], type: TransactionType, footerType: TransactionFooterType? = nil) {
        self.dataModels = dataModels
        self.type = type
        self.footerType = footerType ?? .verify
    }
    
    fileprivate func showSucceedTransfer(t24TimeOuted: Bool) {
        if let vc = R.storyboard.transaction.ncbTransactionCompletedViewController() {
            vc.setData(dataModels, type: type)
            vc.t24TimeOuted = t24TimeOuted
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doConfirm(_ confirmType: String) {
        guard let transferInfo = transferInfo else {
            return
        }
        
        self.confirmType = confirmType
        var params: [String: Any] = [:]
        
        if type == .charity {
            params["username"]    = NCBShareManager.shared.getUser()!.username ?? ""
            params["cifno"]       = NCBShareManager.shared.getUser()!.cif ?? ""
            params["debitacct"]   = transferInfo.debitAcct ?? ""
            params["amount"]      = transferInfo.amount ?? 0.0
            params["creditacct"]  = transferInfo.creditAcct ?? ""
            params["txntype"]     = transferInfo.txntype ?? ""
            params["bnkcode"]     = transferInfo.bnkcode ?? ""
            params["narrative"]   = transferInfo.narrative ?? ""
            params["lang"]        = TransactionLangType.VI.rawValue
        } else {
            params["username"]    = NCBShareManager.shared.getUser()!.username ?? ""
            params["cifno"]       = NCBShareManager.shared.getUser()!.cif ?? ""
            params["debitacct"]   = transferInfo.debitAcct ?? ""
            params["amount"]      = transferInfo.amount ?? 0.0
            params["memName"]     = transferInfo.memName ?? ""
            params["narrative"]   = transferInfo.narrative ?? ""
            params["lang"]        = TransactionLangType.VI.rawValue
            params["flagBenefit"] = (transferInfo.flagBenefit ?? true) ? 1 : 0
            
            switch type {
            case .internalTransfer:
                params["creditacct"]  = transferInfo.creditAcct ?? ""
            case .citad:
                params["creditacct"]  = transferInfo.creditAcct ?? ""
                params["creditName"]     = transferInfo.creditName ?? ""
                params["creditBank"]     = transferInfo.creditBankCode ?? ""
                params["creditProvince"] = transferInfo.creditProvinceCode ?? ""
                params["creditBranch"]   = transferInfo.creditBranchCode ?? ""
                params["duty"]           = transferInfo.duty ?? ""
            case .fast247:
                params["benBankCode"] = transferInfo.creditBankCode ?? ""
                params["benBankAcctCard"] = transferInfo.creditAcct ?? ""
                params["benName"] = transferInfo.creditName ?? ""
                params["typeTransfer"] = transferInfo.typeTransfer ?? ""
            default:
                break
            }
        }
        
        params["confirmType"] = confirmType
        if confirmType == getConfirmType() {
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
        } else {
            params["confirmValue"] = ""
        }
        
        SVProgressHUD.show()
        p?.confirmTransfer(params: params, type: type)
    }
    
    fileprivate func doApproval(_ otp: String) {
        guard let transferInfo = transferInfo else {
            return
        }
        
        guard let confirmInfo = confirmInfo else {
            return
        }
        
        var params: [String: Any] = [:]
        params["otpLevel"]  = confirmInfo.otpLevel ?? ""
        
        if type == .charity {
            params["username"]     = NCBShareManager.shared.getUser()!.username ?? ""
            params["cifno"]        = NCBShareManager.shared.getUser()!.cif ?? ""
            params["debitacct"]    = transferInfo.debitAcct ?? ""
            params["amount"]       = transferInfo.amount ?? 0.0
            params["creditacct"]   = transferInfo.creditAcct ?? ""
            params["txntype"]      = transferInfo.txntype ?? ""
            params["bnkcode"]      = transferInfo.bnkcode ?? ""
            params["narrative"]    = transferInfo.narrative ?? ""
            params["lang"]         = TransactionLangType.VI.rawValue
            params["confirmType"]  = confirmType
            params["confirmValue"] = otp
            params["msgid"] = confirmInfo.msgid ?? ""
        } else {
            params["username"] = NCBShareManager.shared.getUser()!.username ?? ""
            params["cifno"] = NCBShareManager.shared.getUser()!.cif ?? ""
            params["debitacct"] = transferInfo.debitAcct ?? ""
            params["amount"] = transferInfo.amount ?? 0.0
            params["memName"] = transferInfo.memName ?? ""
            params["narrative"] = transferInfo.narrative ?? ""
            params["msgid"] = confirmInfo.msgid ?? ""
            params["confirmType"] = confirmType ?? ""
            params["confirmValue"] = otp
            params["flagBenefit"] = (transferInfo.flagBenefit ?? true) ? 1 : 0
            
            switch type {
            case .internalTransfer:
                params["creditacct"] = transferInfo.creditAcct ?? ""
            case .citad:
                params["creditacct"] = transferInfo.creditAcct ?? ""
                params["creditName"] = transferInfo.creditName ?? ""
                params["creditBank"] = transferInfo.creditBankCode ?? ""
                params["creditProvince"] = transferInfo.creditProvinceCode ?? ""
                params["creditBranch"] = transferInfo.creditBranchCode ?? ""
                params["duty"] = transferInfo.duty ?? ""
            case .fast247:
                params["benBankCode"] = transferInfo.creditBankCode ?? ""
                params["benBankAcctCard"] = transferInfo.creditAcct ?? ""
                params["benName"] = transferInfo.creditName ?? ""
                params["typeTransfer"] = transferInfo.typeTransfer ?? ""
            default:
                break
            }
            
        }
        
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: type)
    }
    
    fileprivate func doResendOTP() {
        guard let transferInfo = transferInfo else {
            return
        }
        
        guard let confirmInfo = confirmInfo else {
            return
        }
        
        let params: [String: Any] = [
            "debitacct": confirmInfo.debitAcct ?? "",
            "amount": transferInfo.amount ?? 0.0,
            "fee": transferInfo.fee ?? 0.0,
            "creditacct": confirmInfo.creditAcct ?? "",
        ]
        otpResend(msgId: confirmInfo.msgid ?? "", params: params, type: type)
    }
    
}

extension NCBVerifyTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.filter({ $0.type == .other }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransactionOtherInfoTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransactionOtherInfoTableViewCell
        let item = dataModels.filter({ $0.type == .other })[indexPath.row]
        cell.lbTitle.text = item.title
        cell.lbValue.text = item.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        
        var item = dataModels.first(where: { $0.type == .sourceAccount })
        header?.lbSourceAccountValue.text = item?.value
        header?.lbSourceAccount.text = item?.title
        
        item = dataModels.first(where: { $0.type == .destAccount })
        header?.lbDestAccountValue.text = item?.value
        header?.lbDestAccount.text = item?.title
        
        item = dataModels.first(where: { $0.type == .destName })
        header?.lbDestName.text = item?.value
        
        item = dataModels.first(where: { $0.type == .bankName })
        header?.lbBankName.text = item?.value
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NCBVerifyTransactionViewController: NCBVerifyTransactionPresenterDelegate {
    
    func confirmTransferCompleted(info: NCBConfirmTransferInfoModel?, error: String?, code: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        confirmInfo = info
        if let transferInfo = transferInfo {
            if transferInfo.debitCif == transferInfo.creditCif {
                showSucceedTransfer(t24TimeOuted: code == ResponseCodeConstant.t24TimeOuted)
            } else {
                if confirmType == TransactionConfirmType.OTP.rawValue {
                    showTransferOTP(isAdvanced: info?.isAdvancedSoftOtp ?? false, code: info?.challenge)
                } else {
                    showSucceedTransfer(t24TimeOuted: code == ResponseCodeConstant.t24TimeOuted)
                }
            }
        }
    }
    
    override func otpAuthenticateSuccessfully() {
        showSucceedTransfer(t24TimeOuted: otpAuthPresenter?.approvalSuccessCode == ResponseCodeConstant.t24TimeOuted)
    }
    
}
