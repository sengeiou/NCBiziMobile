//
//  NCBServicePaymentViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import DropDown

enum PartnerType: String {
    case PAYOO
    case VNPAY
    case NAPAS
}

class NCBServicePaymentViewController: NCBBaseSourceAccountViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfProvider: NewNCBCommonTextField!
    @IBOutlet weak var tfCode: NewNCBCommonTextField!
    @IBOutlet weak var tfCustomerName: NewNCBCommonTextField!
    @IBOutlet weak var tfMemName: NewNCBCommonTextField!
    @IBOutlet weak var amountView: NCBTransferAmountView! {
        didSet {
            amountView.textField.isEnabled = false
        }
    }
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    var serviceProvider: NCBServiceProviderModel?
    var serviceModel: NCBServiceModel?
    fileprivate var p: NCBServicePaymentPresenter?
    fileprivate var providerPresenter: NCBProviderListPresenter?
    fileprivate var flagBenefit = false
//    fileprivate var billValid = false
    fileprivate var tfCodeFocusing = false
    fileprivate var billInfoVNPAY: NCBBillInfoVNPAYModel?
    fileprivate var billInfoPayoo: NCBBillInfoPayooModel?
    fileprivate var billInfoNapas: NCBBillInfoNapasModel?
    
    fileprivate var transactionType: TransactionType {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if tfCode.text == "" {
            showAlert(msg: "BILL-1".getMessage() ?? "Vui lòng nhập mã khách hàng")
            return
        }
        
        if tfCodeFocusing {
            tfCode.resignFirstResponder()
            return
        }
        
//        if !billValid {
//            showAlert(msg: "Mã khách hàng không hợp lệ")
//            return
//        }
        
        if amountView.textField.text == "" {
            return
        }
        
        let amount = Double(amountView.textField.text!.removeSpecialCharacter) ?? 0.0
        
        if invalidTransferAmount(amount, type: transactionType, limitType: .min) {
            showAlert(msg: "TRANSFER-1".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối thiểu 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if invalidTransferAmount(amount, type: transactionType, limitType: .max) {
            showAlert(msg: "TRANSFER-2".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối đa 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceRechargeMoney(acctNo: sourceAccount?.acctNo ?? "", amt: amount)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        
        if result {
            var customerCode = ""
            var customerName = ""
            var address = ""
            var period = ""
            var amount = ""
            var sysTrace = ""
            
            if let payoo = billInfoPayoo, let detail = payoo.getBillDetail() {
                customerCode = detail.custId ?? ""
                customerName = detail.custName ?? ""
                address = detail.adress ?? ""
                period = payoo.getBillPeriod()
                amount = payoo.getAmount().currencyFormatted
                sysTrace = payoo.sysTrace ?? ""
            } else if let vnpay = billInfoVNPAY {
                customerCode = vnpay.customerCode ?? ""
                customerName = vnpay.fullname ?? ""
                address = vnpay.address ?? ""
                period = vnpay.getBillPeriod()
                amount = (vnpay.amount ?? 0.0).currencyFormatted
                sysTrace = vnpay.sysTrace ?? ""
            } else if let napas = billInfoNapas {
                customerCode = napas.customerCode ?? ""
                period = napas.getPeriod()
                amount = (napas.amount ?? 0.0).currencyFormatted
                sysTrace = napas.systemTrace ?? ""
            }
            
            showVerifyScreen(customerCode: customerCode, customerName: customerName, address: address, period: period, amount: amount, sysTrace: sysTrace, VNPAYInfo: billInfoVNPAY, payooInfo: billInfoPayoo, napasInfo: billInfoNapas)
        }
    }
    
}

extension NCBServicePaymentViewController {
    
    override func setupView() {
        super.setupView()
        
        tfProvider.text = serviceProvider?.providerName
        tfProvider.addRightArrow()
        tfCode.addRightView(R.image.ic_customer_code())
        tfMemName.addSaveButton()
        
        tfCustomerName.isEnabled = false
//        tfProvider.isEnabled = false
        tfProvider.delegate = self
    
        tfMemName.customDelegate = self
        tfCode.delegate = self
        tfCode.customDelegate = self
        
        hiddenCustomerName(true)
        hiddenNameReminiscentView(true)
        hiddenAmountView(true)
        
        p = NCBServicePaymentPresenter()
        p?.delegate = self
        
        if let customerCode = serviceProvider?.customerCode {
            tfCode.text = customerCode
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        if let _ = serviceModel {
            setHeaderTitle(getServiceType(PayType.DIEN.rawValue))
        } else {
            setHeaderTitle(getServiceType(serviceProvider?.serviceCode ?? ""))
        }
        
        tfProvider.placeholder = "Nhà cung cấp"
        tfCode.placeholder = "Mã khách hàng"
        tfCustomerName.placeholder = "Tên khách hàng"
        tfMemName.placeholder = "Lưu với tên hoá đơn"
        amountView.textField.placeholder = "Số tiền thanh toán"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    override func loadDefaultSourceAccount() {
        super.loadDefaultSourceAccount()
        
        if let service = serviceModel {
            providerPresenter = NCBProviderListPresenter()
            providerPresenter?.delegate = self
            
            SVProgressHUD.show()
            providerPresenter?.getListProvider(code: service.serviceCode ?? "")
        } else {
            getBillInfo()
        }
    }
    
}

extension NCBServicePaymentViewController: UITextFieldDelegate, NewNCBCommonTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfProvider {
            if serviceModel == nil {
                if let vc = R.storyboard.servicePayment.ncbProviderListViewController() {
                    vc.delegate = self
                    
                    let service = NCBServiceModel()
                    service.serviceCode = serviceProvider?.serviceCode
                    vc.serviceModel = service
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return false
        }
        tfCodeFocusing = (textField == tfCode)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfCode {
            tfCodeFocusing = false
            getBillInfo()
        }
    }
    
    func textFieldDidSelectRightArrow(_ textField: UITextField) {
        if let vc = R.storyboard.servicePayment.ncbPayBillSavedListViewController() {
            vc.delegate = self
            vc.serviceCode = serviceProvider?.serviceCode
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func textFieldDidChangeNameReminiscent(_ textField: UITextField, value: Bool) {
        flagBenefit = value
    }
    
}

extension NCBServicePaymentViewController: NCBProviderListViewControllerDelegate {
    
    func didSelectProviderItem(provider: NCBServiceProviderModel) {
        serviceProvider = provider
        tfProvider.text = provider.providerName
        getBillInfo()
    }
    
}

extension NCBServicePaymentViewController: NCBPayBillSavedListViewControllerDelegate {
    
    func savedListDidSelectItem(_ savedItem: NCBPayBillSavedModel) {
        tfProvider.text = savedItem.providerName
        tfCode.text = savedItem.billNo
        
        serviceProvider = NCBServiceProviderModel()
        serviceProvider?.partner = savedItem.partner
        serviceProvider?.providerCode = savedItem.providerCode
        serviceProvider?.providerName = savedItem.providerName
        serviceProvider?.serviceCode = savedItem.serviceCode
        serviceProvider?.status = savedItem.status
        
        getBillInfo()
    }
    
}

extension NCBServicePaymentViewController {
    
    fileprivate func hiddenCustomerName(_ hidden: Bool) {
        tfCustomerName.isHidden = hidden
        for constraint in tfCustomerName.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfCustomerName.drawViewsForRect(tfCustomerName.frame)
        }
    }
    
    fileprivate func hiddenNameReminiscentView(_ hidden: Bool) {
        tfMemName.isHidden = hidden
        for constraint in tfMemName.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfMemName.drawViewsForRect(tfMemName.frame)
        }
    }
    
    fileprivate func hiddenAmountView(_ hidden: Bool) {
        amountView.isHidden = hidden
        for constraint in amountView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
    }
    
    fileprivate func errorBill() {
//        billValid = false
        tfCode.text = ""
        hiddenCustomerName(true)
        tfCustomerName.text = ""
        hiddenNameReminiscentView(true)
        tfMemName.clear()
        hiddenAmountView(true)
    }
    
    fileprivate func getBillInfo() {
        if tfCode.text == "" {
            return
        }
        
        guard let serviceProvider = serviceProvider else {
            return
        }
        
        let params = [
            "acctNo": sourceAccountView?.getSourceAccount() ?? "",
            "custCode": tfCode.text ?? "",
            "channel": "IB",
            "provider": serviceProvider.providerCode ?? "",
            "serviceCode": serviceProvider.serviceCode ?? "",
            "userName": NCBShareManager.shared.getUser()?.username ?? "",
            "partner": serviceProvider.partner ?? ""
            ] as [String: Any]
        
        SVProgressHUD.show()
        switch serviceProvider.partner {
        case PartnerType.PAYOO.rawValue:
            p?.getBillInfoPayoo(params: params)
        case PartnerType.VNPAY.rawValue:
            p?.getBillInfoVNPAY(params: params)
        case PartnerType.NAPAS.rawValue:
            p?.getBillInfoNapas(params: params)
        default:
            break
        }
    }
    
    fileprivate func showVerifyScreen(customerCode: String, customerName: String, address: String, period: String, amount: String, sysTrace: String, VNPAYInfo: NCBBillInfoVNPAYModel?, payooInfo: NCBBillInfoPayooModel?, napasInfo: NCBBillInfoNapasModel?) {
        if let vc = R.storyboard.servicePayment.ncbVerifyServicePaymentViewController() {
            vc.setData(customerCode: customerCode , customerName: customerName, address: address, period: period, amount: amount, sysTrace: sysTrace, service: serviceModel, serviceProvider: serviceProvider, sourceAccount: sourceAccount, billInfoVNPAY: VNPAYInfo, billInfoPayoo: payooInfo, billInfoNapas: napasInfo)
            vc.flagBenefit = flagBenefit
            vc.memName = flagBenefit ? tfMemName.text ?? "" : ""
            vc.exceedLimit = exceedLimit(Double(amount.replacingOccurrences(of: "VND", with: "").trim.removeSpecialCharacter) ?? 0.0, type: transactionType)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBServicePaymentViewController: NCBServicePaymentPresenterDelegate {
    
    func getBillInfoPayooCompleted(billInfo: NCBBillInfoPayooModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            errorBill()
            return
        }
        
        if let billInfo = billInfo, let detail = billInfo.getBillDetail() {
            billInfoPayoo = billInfo
//            billValid = true
            hiddenCustomerName(false)
            tfCustomerName.text = detail.custName
            hiddenNameReminiscentView(false)
            hiddenAmountView(false)
            amountView.textField.text = String(billInfo.getAmount())
            amountView.moneyEditingChanged()
        }
    }
    
    func getBillInfoVNPAYCompleted(billInfo: NCBBillInfoVNPAYModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            errorBill()
            return
        }
        
        if let billInfo = billInfo {
            billInfoVNPAY = billInfo
//            billValid = true
            hiddenCustomerName(false)
            tfCustomerName.text = billInfo.fullname
            hiddenNameReminiscentView(false)
            hiddenAmountView(false)
            amountView.textField.text = String(billInfo.amount ?? 0.0)
            amountView.moneyEditingChanged()
        }
    }
    
    func getBillInfoNapasCompleted(billInfo: NCBBillInfoNapasModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            errorBill()
            return
        }
        
        if let billInfo = billInfo {
            billInfoNapas = billInfo
//            billValid = true
            billInfo.customerCode = tfCode.text
            hiddenNameReminiscentView(false)
            hiddenAmountView(false)
            amountView.textField.text = String(billInfo.amount ?? 0.0)
            amountView.moneyEditingChanged()
        }
    }
    
}

extension NCBServicePaymentViewController: NCBProviderListPresenterDelegate {
    
    func getListProviderCompleted(providerList: [NCBServiceProviderModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        getBillInfo()
        
        if let providerList = providerList {
            serviceProvider = providerList.first
            tfProvider.text = serviceProvider?.providerName
        }
    }
    
}
