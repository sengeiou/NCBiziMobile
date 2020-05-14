//
//  NCBChargeAirpayViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import DropDown

class NCBChargeAirpayViewController: NCBBaseSourceAccountViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var listAirpayNumbTxtF: NewNCBCommonTextField!
    @IBOutlet weak var nameTextField: NewNCBCommonTextField! {
        didSet {
            nameTextField.keyboardType = .default
        }
    }
    @IBOutlet weak var saveNameLineView: UIView!
    @IBOutlet weak var amountView: NCBTransferAmountView!
    @IBOutlet weak var saveEWalletNumbBtn: UIButton! {
        didSet {
            saveEWalletNumbBtn.setImage(R.image.switch_on(), for: .selected)
            saveEWalletNumbBtn.setImage(R.image.switch_off(), for: .normal)
        }
    }
    
    @IBOutlet weak var continueBtn: NCBCommonButton! {
        didSet {
            continueBtn.setTitle("Tiếp tục", for: .normal)
        }
    }
    
    // MARK: - Properties
    
    var memName: String?
    var billNo: String?
    
    fileprivate var p: NCBProviderListPresenter?
    
    var provider: NCBServiceProviderModel?
    
    var amountValue: String?
    
    var saveUser: Bool = false

    fileprivate var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearData()
        isFirstLoad = false
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    @IBAction func saveUser(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        saveUser = sender.isSelected
        nameTextField.isHidden = !saveUser
        saveNameLineView.isHidden = !saveUser
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        
        if listAirpayNumbTxtF.text == "" {
            showAlert(msg: "Vui lòng nhập hoặc chọn số ví cần nạp")
            return
        }
        
        if amountView.textField.text == "" {
            showAlert(msg: "Vui lòng nhập số tiền cần nạp")
            return
        }
        
        guard let _amtNumb = Double(amountView.textField.text!.removeSpecialCharacter) else {
            return
        }
        
        if invalidTransferAmount(_amtNumb, type: .topupAirPay, limitType: .min) {
            showAlert(msg: "TRANSFER-1".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối thiểu 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if invalidTransferAmount(_amtNumb, type: .topupAirPay, limitType: .max) {
            showAlert(msg: "TRANSFER-2".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối đa 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceRechargeMoney(acctNo: sourceAccount?.acctNo ?? "", amt: _amtNumb)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        
        if result {
            guard let _amtNumb = Double(amountView.textField.text!.removeSpecialCharacter) else {
                return
            }
            
            let params: [String : Any] = [
                "userName" : NCBShareManager.shared.getUser()?.username ?? "",
                "acctNo" : self.sourceAccount?.acctNo ?? "",
                "billNo" : listAirpayNumbTxtF.text ?? "",
                "partner" : provider?.partner ?? "",
                "amt" : _amtNumb,
                "mobile" : NCBShareManager.shared.getUser()?.mobile ?? "",
                "typeId" : TransType.rechargeAirpay.rawValue
            ]
            
            let _vc = NCBChargeMoneyGenerateOTPViewController()
            _vc.sourceAccount = sourceAccount
            _vc.amount = _amtNumb.currencyFormatted
            _vc.targetNumber = listAirpayNumbTxtF.text ?? ""
            _vc.params = params
            _vc.transactionType = .topupAirPay
            _vc.didSaveUser = saveUser
            _vc.memName = nameTextField.text
            _vc.exceedLimit = exceedLimit(_amtNumb, type: .topupAirPay)
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
}

extension NCBChargeAirpayViewController {
    
    override func setupView() {
        super.setupView()
        
        amountView.textField.placeholder = "Số tiền nạp"
        
        listAirpayNumbTxtF.placeholder = "Số ví Airpay"
        listAirpayNumbTxtF.addRightView(R.image.contacts())
        listAirpayNumbTxtF.customDelegate = self
        
        p = NCBProviderListPresenter()
        SVProgressHUD.show()
        p?.getListProvider(code: "TOPUP-VI")
        p?.delegate = self
        
        listAirpayNumbTxtF.text = billNo
        if let memName = memName {
            nameTextField.text = memName
            saveUser(saveEWalletNumbBtn)
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setCustomHeaderTitle("Nạp ví điện tử Airpay")
    }
    fileprivate func clearData() {
        if NCBShareManager.shared.areTrading || isFirstLoad {
            return
        }
        
        listAirpayNumbTxtF.text = ""
        saveUser = false
        saveEWalletNumbBtn.isSelected = saveUser
        nameTextField.isHidden = !saveUser
        saveNameLineView.isHidden = !saveUser
        amountView.clear()
    }
    
    fileprivate func showBillNoList() {
        let controller = NCBRechargeSavedListViewController()
        controller.onlyAirpay = true
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension NCBChargeAirpayViewController: NCBProviderListPresenterDelegate {
    func getListProviderCompleted(providerList: [NCBServiceProviderModel]?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        
        if let providerList = providerList {
            if providerList.count > 0 {
                self.provider = providerList[0]
            }
        }
    }
}

extension NCBChargeAirpayViewController: NewNCBCommonTextFieldDelegate {
    
    func textFieldDidSelectRightArrow(_ textField: UITextField) {
        showBillNoList()
    }
    
}

extension NCBChargeAirpayViewController: NCBRechargeSavedListViewControllerDelegate {
    
    func phoneItemDidSelect(_ item: NCBBenfitPhoneModel) {
        listAirpayNumbTxtF.text = item.billNo
        if let memName = item.menName {
            nameTextField.text = memName
            saveUser(saveEWalletNumbBtn)
        }
    }
    
}
