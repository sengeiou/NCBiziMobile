//
//  NCBCreditCardPaymentOtherCardViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCreditCardPaymentOtherCardViewController: NCBBaseSourceAccountViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfCardNumber: NewNCBCommonTextField!
    @IBOutlet weak var tfName: NewNCBCommonTextField!
    @IBOutlet weak var amountView: NCBTransferAmountView!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    fileprivate var p: NCBCreditCardPaymentPresenter?
    fileprivate var creditCardInfo: NCBCreditCardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        removeAllNotification()
    }
    
}

extension NCBCreditCardPaymentOtherCardViewController {
    
    override func setupView() {
        super.setupView()
        
        tfName.isEnabled = false
        tfCardNumber.delegate = self
        tfCardNumber.keyboardType = .numberPad
        hiddenNameView(true)
        
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        
        p = NCBCreditCardPaymentPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        tfCardNumber.placeholder = "Số thẻ"
        tfName.placeholder = "Tên chủ thẻ"
        amountView.textField.placeholder = "Số tiền thanh toán"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    @objc func continueAction() {
        if tfName.isHidden {
            return
        }
        
        if amountView.textField.text == "" {
            showAlert(msg: ErrorConstant.crdCardNoEnterAmount.getMessage() ?? "Vui lòng nhập số tiền")
            return
        }
        
        let amt = Double(amountView.textField.text!.removeSpecialCharacter) ?? 0.0
        
        if amt > creditCardInfo?.creditLimit ?? 0.0 * 2 {
            showAlert(msg: ErrorConstant.crdCardPaymentMoreThan200.getMessage() ?? "Số tiền thanh toán chỉ cho phép tối đa 200% hạn mức tín dụng. Quý khách vui lòng kiểm tra lại.")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceCard(debitAccountNo: sourceAccount?.acctNo ?? "", amount: amt)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        
        if result {
            let vc = NCBVerifyCreditCardPaymentViewController()
            vc.creditCardInfo = creditCardInfo
            vc.sourceAccount = sourceAccount
            vc.amount = Double(amountView.textField.text!.removeSpecialCharacter) ?? 0.0
            vc.exceedLimit = exceedLimit(Double(amountView.textField.text!.removeSpecialCharacter) ?? 0.0, type: .creditCardPayment)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBCreditCardPaymentOtherCardViewController {
    
    fileprivate func hiddenNameView(_ hidden: Bool) {
        tfName.isHidden = hidden
        for constraint in tfName.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfName.drawViewsForRect(tfName.frame)
        }
    }
    
    fileprivate func getCardInfo() {
        if tfCardNumber.text == "" {
            hiddenNameView(true)
            return
        }
        
        SVProgressHUD.show()
        
        let params: [String: Any] = [
            "cifNo": NCBShareManager.shared.getUser()?.cif ?? "",
            "userId": NCBShareManager.shared.getUserID(),
            "cardNo": tfCardNumber.text ?? ""
        ]
        p?.getCardInfo(params: params)
    }
    
}
extension NCBCreditCardPaymentOtherCardViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        getCardInfo()
    }
    
}

extension NCBCreditCardPaymentOtherCardViewController: NCBCreditCardPaymentPresenterDelegate {
    
    func getCardInfoCompleted(card: NCBCreditCardModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        hiddenNameView((card == nil))
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        creditCardInfo = card
        tfName.text = card?.cardname
    }
    
}
