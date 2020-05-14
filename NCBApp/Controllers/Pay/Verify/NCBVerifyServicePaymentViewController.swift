//
//  NCBVerifyServicePaymentViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum PayBillingStatus: String {
    case ACTIVE = "Active"
    case CLOSE = "Close"
}

enum PayBillOTPType: Int {
    case payBill = 0
    case autoPayBill
}

class NCBVerifyServicePaymentViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties
    
    fileprivate var verifyFooter: NCBVerifyTransferFooterView?
    fileprivate var serviceProvider: NCBServiceProviderModel?
    fileprivate var service: NCBServiceModel?
    fileprivate var sourceAccount: NCBDetailPaymentAccountModel?
    fileprivate var billInfoVNPAY: NCBBillInfoVNPAYModel?
    fileprivate var billInfoPayoo: NCBBillInfoPayooModel?
    fileprivate var billInfoNapas: NCBBillInfoNapasModel?
    fileprivate var p: NCBVerifyServicePaymentPresenter?
    fileprivate var msgId: String?
    var flagBenefit: Bool = false
    var memName = ""
    fileprivate var customerCode = ""
    fileprivate var customerName = ""
    fileprivate var address = ""
    fileprivate var period = ""
    fileprivate var amount = ""
    fileprivate var systemTrace = ""
    
    fileprivate var transactionType: TransactionType {
        if isAutoPaymentRegister {
            return .autoPaymentRegister
        }
        
        switch serviceProvider?.partner?.uppercased() {
        case PartnerType.PAYOO.rawValue:
            return .payBillingPayoo
        case PartnerType.VNPAY.rawValue:
            return .payBillingVNPAY
        case PartnerType.NAPAS.rawValue:
            return .payBillingNapas
        default:
            return .none
        }
    }
    
//    fileprivate var serviceType: String {
//        if isAutoPaymentRegister {
//            return "DỊCH VỤ THANH TOÁN TỰ ĐỘNG"
//        }
//
//        return serviceProvider?.serviceCode ?? ""
//    }
    
    fileprivate var isAutoPaymentRegister: Bool {
        return (billInfoPayoo == nil && billInfoVNPAY == nil && billInfoNapas == nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func verifyAction() {
        createOTPCode()
    }
    
    override func verifyWithTouchID() {
        payService(nil)
    }
    
    override func otpViewDidSelectAccept(_ otp: String) {
        payService(otp)
    }
    
    override func otpViewDidSelectResend() {
        doResendOTP()
    }
    
}

extension NCBVerifyServicePaymentViewController {
    
    override func setupView() {
        super.setupView()
        
        if isAutoPaymentRegister {
            hiddenHeaderView()
        } else {
            lbAmountTitle.text = "Số tiền thanh toán"
            lbAmountValue.text = amount
            
            if period != "" {
                lbFee.text = "Kỳ hoá đơn: Tháng \(period)"
            }
            
            let str = lbFee.text ?? ""
            let height = str.height(withConstrainedWidth: self.view.frame.width - 50, font: regularFont(size: 12)!)
            updateHeightHeaderView(height - 15)
        }
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifyTransactionGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
        p = NCBVerifyServicePaymentPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
//        setHeaderTitle(getServiceType(serviceType))
        setHeaderTitle("Thông tin giao dịch")
    }
    
}

extension NCBVerifyServicePaymentViewController {
    
    func setData(customerCode: String, customerName: String, address: String, period: String, amount: String, sysTrace: String, service: NCBServiceModel?, serviceProvider: NCBServiceProviderModel?, sourceAccount: NCBDetailPaymentAccountModel?, billInfoVNPAY: NCBBillInfoVNPAYModel?, billInfoPayoo: NCBBillInfoPayooModel?, billInfoNapas: NCBBillInfoNapasModel?) {
        
        self.customerCode = customerCode
        self.customerName = customerName
        self.address = address
        self.period = period
        self.amount = amount
        self.systemTrace = sysTrace
        self.service = service
        self.serviceProvider = serviceProvider
        self.sourceAccount = sourceAccount
        self.billInfoVNPAY = billInfoVNPAY
        self.billInfoPayoo = billInfoPayoo
        self.billInfoNapas = billInfoNapas
    }
    
    fileprivate func doResendOTP() {
//        guard let msgId = msgId else {
//            return
//        }
//
//        otpResend(msgId: msgId)
        createOTPCode()
    }
    
    fileprivate func createOTPCode() {
        guard let sourceAccount = sourceAccount  else {
            return
        }
        
        guard let provider = serviceProvider else {
            return
        }

        var params: [String: Any] = [:]
        if isAutoPaymentRegister {
            params["providerCode"] = provider.providerCode
            params["providerName"] = provider.providerName
            params["serviceCode"] = service?.serviceCode
            params["serviceName"] = service?.serviceName
            params["billNo"] = customerCode
            params["channel"] = "IB"
        } else {
            if let _ = billInfoPayoo {
                params = getCreateOTPCodeParamsFromPayooInfo()
            } else if let _ = billInfoVNPAY {
                params = getCreateOTPCodeParamsFromVNPAYInfo()
            } else if let _ = billInfoNapas {
                params = getCreateOTPCodeParamsFromNapasInfo()
            }
            params["merchantName"] = provider.providerName ?? ""
        }
        params["userName"] = NCBShareManager.shared.getUser()!.username ?? ""
        params["acctNo"] = sourceAccount.acctNo ?? ""
        params["msgId"] = msgId
        
        SVProgressHUD.show()
        p?.createOTPCode(params: params, type: (isAutoPaymentRegister) ? .autoPayBill : .payBill)
    }
    
    fileprivate func getCreateOTPCodeParamsFromPayooInfo() -> [String: Any] {
        var params: [String: Any] = [:]
        params["billNo"] = customerCode
        params["benName"] = customerName
        params["receivingAddr"] = address
        params["billDate"] = period
        params["amt"] = billInfoPayoo?.getAmount()
        params["systemTrace"] = systemTrace
        return params
    }
    
    fileprivate func getCreateOTPCodeParamsFromVNPAYInfo() -> [String: Any] {
        var params: [String: Any] = [:]
        params["billNo"] = customerCode
        params["benName"] = customerName
        params["receivingAddr"] = address
        params["billDate"] = period
        params["amt"] = billInfoVNPAY?.amount
        params["systemTrace"] = systemTrace
        return params
    }
    
    fileprivate func getCreateOTPCodeParamsFromNapasInfo() -> [String: Any] {
        var params: [String: Any] = [:]
        params["billNo"] = customerCode
        params["benName"] = customerName
        params["receivingAddr"] = ""
        params["billDate"] = period
        params["amt"] = billInfoNapas?.amount
        params["systemTrace"] = systemTrace
        return params
    }
    
    fileprivate func payService(_ otp: String?) {
        guard let sourceAccount = sourceAccount  else {
            return
        }
        
        guard let provider = serviceProvider else {
            return
        }
        
        var params: [String: Any] = [:]
        
        if isAutoPaymentRegister {
            params["providerCode"] = provider.providerCode
            params["providerName"] = provider.providerName
            params["serviceCode"] = service?.serviceCode
            params["serviceName"] = service?.serviceName
            params["billNo"] = customerCode
        } else {
            if let _ = billInfoPayoo {
                params = getPayServiceParamsFromPayooInfo()
            } else if let _ = billInfoVNPAY {
                params = getPayServiceParamsFromVNPAYInfo()
            } else if let _ = billInfoNapas {
                params = getPayServiceParamsFromNapasInfo()
            }
            params["merchantName"] = provider.providerName ?? ""
            params["provider"] = provider.providerCode ?? ""
        }
        
        if let otp = otp {
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = otp
            params["msgId"] = msgId
        } else {
            params["confirmType"] = getConfirmType()
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
            params["msgId"] = ""
        }
        
        params["userName"] = NCBShareManager.shared.getUser()!.username ?? ""
        params["acctNo"] = sourceAccount.acctNo ?? ""
        params["channel"] = "IB"
        
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: transactionType)
    }
    
    fileprivate func getPayServiceParamsFromPayooInfo() -> [String: Any] {
        var params: [String: Any] = [:]
        params["billNo"] = customerCode
        params["benName"] = customerName
        params["receivingAddr"] = address
        params["billDate"] = period
        params["amt"] = billInfoPayoo?.getAmount()
        params["systemTrace"] = systemTrace
        params["billInfo"] = billInfoPayoo?.toJSON()
        params["serviceCode"] = serviceProvider?.serviceCode ?? ""
        return params
    }
    
    fileprivate func getPayServiceParamsFromVNPAYInfo() -> [String: Any] {
        var params: [String: Any] = [:]
        params["billNo"] = customerCode
        params["benName"] = customerName
        params["receivingAddr"] = address
        params["billDate"] = period
        params["amt"] = billInfoVNPAY?.amount
        params["systemTrace"] = systemTrace
        params["serviceCode"] = serviceProvider?.serviceCode ?? ""
        return params
    }
    
    fileprivate func getPayServiceParamsFromNapasInfo() -> [String: Any] {
        var params: [String: Any] = [:]
        params["billNo"] = customerCode
        params["benName"] = customerName
        params["receivingAddr"] = ""
        params["billDate"] = period
        params["amt"] = billInfoNapas?.amount
        params["systemTrace"] = systemTrace
        params["serviceCode"] = serviceProvider?.providerCode ?? ""
        return params
    }
    
    fileprivate func saveService() {
        if !flagBenefit {
            return
        }
        
        guard let provider = serviceProvider else {
            return
        }
        
        p?.saveService(providerCode: provider.providerCode ?? "", serviceCode: provider.serviceCode ?? "", customerCode: customerCode, memName: memName, isActive: true)
    }
    
    fileprivate func showSucceedPayBill(customerCode: String, customerName: String, address: String, period: String, amount: String) {
        if let vc = R.storyboard.servicePayment.ncbServicePaymentCompletedViewController() {
            vc.setData(customerCode: customerCode, customerName: customerName, address: address, period: period, amount: amount, serviceProvider: serviceProvider, sourceAccount: sourceAccount)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showSucceedAutoPayBill() {
        if let vc = R.storyboard.servicePayment.ncbServicePaymentCompletedViewController() {
            vc.setData(customerCode: customerCode, customerName: customerName, address: address, period: period, amount: amount, serviceProvider: serviceProvider, sourceAccount: sourceAccount)
            vc.isAutoPaymentRegister = isAutoPaymentRegister
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBVerifyServicePaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if customerName == "" && !isAutoPaymentRegister {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransactionGeneralInfoTableViewCell
        if isAutoPaymentRegister {
            cell.lbContent.text = "Đăng ký thanh toán hoá đơn tự động"
        } else {
            cell.lbContent.text = "Tên khách hàng: \(customerName)\nĐịa chỉ: \(address)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        
        header?.lbSourceAccount.text = "Từ tài khoản"
        header?.lbSourceAccountValue.text = sourceAccount?.acctNo
        
        header?.lbDestAccount.text = serviceProvider?.billName
        header?.lbDestAccountValue.text = customerCode
        
        header?.lbDestName.text = serviceProvider?.providerName
        header?.lbBankName.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NCBVerifyServicePaymentViewController: NCBVerifyServicePaymentPresenterDelegate {
    
    func createOTPCodeCompleted(msgId: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let _ = self.msgId {
            showAlert(msg: "Gửi lại mã xác thực OTP thành công!")
        } else {
            self.msgId = msgId
            showOTP()
        }
    }
    
    override func otpAuthenticateSuccessfully() {
        if isAutoPaymentRegister {
            showSucceedAutoPayBill()
            return
        }
        
        saveService()
        
        showSucceedPayBill(customerCode: customerCode, customerName: customerName, address: address, period: period, amount: amount)
    }
    
}

