//
//  NCBVerifyTransferViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SVProgressHUD

struct TransactionModel {
    var title = ""
    var value = ""
}

enum TransactionType: Int {
    case internalTransfer = 0
    case fast247
    case citad
    case charity
    case finalSettlementSavingAccount
    case openSavingAccount
    case none
}

enum TransactionConfirmType: String {
    case OTP
    case TOUCHID
}

enum TransactionLangType: String {
    case VI
    case EN
}

enum TransactionFooterType: Int {
    case verify = 0
    case confirm
}

class NCBVerifyTransactionViewController: NCBBaseVerifyTransactionViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    var transferInfo: NCBTransferInfoModel?
    fileprivate var dataModels = [TransactionModel]()
    fileprivate var type: TransactionType = .internalTransfer
    fileprivate var footerType: TransactionFooterType = .verify
    fileprivate var verifyFooter: NCBVerifyTransferFooterView?
    fileprivate var confirmFooter: NCBConfirmTransferFooterView?
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
        
        tblView.register(UINib(nibName: R.nib.ncbVerifyTransferTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransferTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        
        p = NCBVerifyTransactionPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        switch type {
        case .internalTransfer:
            setHeaderTitle("CHUYỂN KHOẢN NỘI BỘ")
        case .fast247, .citad:
            setHeaderTitle("CHUYỂN KHOẢN LIÊN NGÂN HÀNG")
        case .charity:
            setHeaderTitle("CHUYỂN TIỀN TỪ THIỆN")
        default:
            break
        }
    }
    
}

extension NCBVerifyTransactionViewController {
    
    func setData(_ dataModels: [TransactionModel], type: TransactionType, footerType: TransactionFooterType? = nil) {
        self.dataModels = dataModels
        self.type = type
        self.footerType = footerType ?? .verify
    }
    
    fileprivate func showSucceedTransfer() {
        guard let transferInfo = transferInfo else {
            return
        }
        
        if let vc = R.storyboard.transaction.ncbTransactionCompletedViewController() {
            vc.setData([TransactionModel(title: "Số tài khoản", value: transferInfo.debitAcct ?? ""), TransactionModel(title: "Tên người nhận", value: transferInfo.creditAcct ?? ""), TransactionModel(title: "Số tiền", value: "\((transferInfo.amount ?? 0.0).currencyFormatted)"), TransactionModel(title: "Nội dung", value: transferInfo.narrative ?? ""), TransactionModel(title: "Phí dịch vụ", value: "\((Double(transferInfo.fee ?? "") ?? 0.0).currencyFormatted)")], type: type)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showOTP() {
        let otpView = R.nib.ncbVerifyOTPView.firstView(owner: self)!
        otpView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(otpView)
        otpView.animShow(self.view)
        
        otpView.hide = { [unowned self] in
            otpView.animHide(self.view)
        }
        
        otpView.accept = { [unowned self] otp in
            if otp == "" {
                self.showAlert(msg: "Xin vui lòng nhập mã OTP")
                return
            }
            
            self.doApproval(otp)
        }
        
        otpView.resend = { [unowned self] in
            self.doResendOTP()
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
            params["creditacct"]  = transferInfo.creditAcct ?? ""
            params["memName"]     = transferInfo.memName ?? ""
            params["narrative"]   = transferInfo.narrative ?? ""
            params["lang"]        = TransactionLangType.VI.rawValue
            params["confirmType"] = confirmType
            params["flagBenefit"] = (transferInfo.flagBenefit ?? true) ? 1 : 0
            
            if confirmType == TransactionConfirmType.TOUCHID.rawValue {
                params["confirmValue"] = "abc"
            }
            
            if type == .citad {
                params["creditName"]     = transferInfo.creditName ?? ""
                params["creditBank"]     = transferInfo.creditBankCode ?? ""
                params["creditProvince"] = transferInfo.creditProvinceCode ?? ""
                params["creditBranch"]   = transferInfo.creditBranchCode ?? ""
                params["duty"]           = transferInfo.duty ?? ""
            }
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
            params["confirmType"] = confirmType
            params["confirmValue"] = otp
            params["msgid"] = confirmInfo.msgid ?? ""
        } else {
            var params: [String: Any] = [:]
            params["username"] = NCBShareManager.shared.getUser()!.username ?? ""
            params["cifno"] = NCBShareManager.shared.getUser()!.cif ?? ""
            params["debitacct"] = transferInfo.debitAcct ?? ""
            params["amount"] = transferInfo.amount ?? 0.0
            params["creditacct"] = transferInfo.creditAcct ?? ""
            params["memName"] = transferInfo.memName ?? ""
            params["narrative"] = transferInfo.narrative ?? ""
            params["msgid"] = confirmInfo.msgid ?? ""
            params["confirmType"] = confirmType ?? ""
            params["confirmValue"] = otp
            params["flagBenefit"] = (transferInfo.flagBenefit ?? true) ? 1 : 0
            
            if type == .citad {
                params["creditName"] = transferInfo.creditName ?? ""
                params["creditBank"] = transferInfo.creditBankCode ?? ""
                params["creditProvince"] = transferInfo.creditProvinceCode ?? ""
                params["creditBranch"] = transferInfo.creditBranchCode ?? ""
                params["duty"] = transferInfo.duty ?? ""
            }
        }
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: type)
    }
    
    fileprivate func doResendOTP() {
        guard let confirmInfo = confirmInfo else {
            return
        }
        
        otpResend(msgId: confirmInfo.msgid ?? "")
    }
    
}

extension NCBVerifyTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransferTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransferTableViewCell
        cell.selectionStyle = .none
        let item = dataModels[indexPath.row]
        cell.lbTitle.text = item.title
        cell.lbValue.text = item.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if footerType == .confirm {
            confirmFooter = NCBConfirmTransferFooterView()
            confirmFooter?.confirm = { [weak self] in
                self?.doConfirm("")
            }
            return confirmFooter
        }
        
        verifyFooter = R.nib.ncbVerifyTransferFooterView.firstView(owner: self)!
        
        verifyFooter?.verifyOTP = { [weak self] in
            self?.doConfirm(TransactionConfirmType.OTP.rawValue)
        }
        
        verifyFooter?.useBiometric = { [weak self] touchMe in
            touchMe.authenticateUser() { [weak self] message in
                if let message = message {
                    self?.showAlert(msg: message)
                } else {
                    self?.doConfirm(TransactionConfirmType.TOUCHID.rawValue)
                }
            }
        }
        
        return verifyFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 90
    }
    
}

extension NCBVerifyTransactionViewController: NCBVerifyTransactionPresenterDelegate {
    
    func confirmTransferCompleted(info: NCBConfirmTransferInfoModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        confirmInfo = info
        if let transferInfo = transferInfo {
            if transferInfo.debitCif == transferInfo.creditCif {
                showSucceedTransfer()
            } else {
                if confirmType == TransactionConfirmType.OTP.rawValue {
                    showOTP()
                } else {
                    showSucceedTransfer()
                }
            }
        }
    }
    
    override func otpAuthenticateSuccessfully() {
        showSucceedTransfer()
    }
    
}
