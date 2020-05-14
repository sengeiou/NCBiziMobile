//
//  NCBCreditCardPaymentCardHolderViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCreditCardPaymentCardHolderViewController: NCBBaseSourceAccountViewController {
    
    @IBOutlet weak var containerCardNumber: UIView!
    @IBOutlet weak var lbAmountPaymentTitle: UILabel!
    @IBOutlet weak var debtEndPeriodbtn: NCBRadioButton!
    @IBOutlet weak var lbDebtEndPeriodValue: UILabel!
    @IBOutlet weak var minimumAmountBtn: NCBRadioButton!
    @IBOutlet weak var lbMiniumAmountValue: UILabel!
    @IBOutlet weak var otherBtn: NCBRadioButton!
    @IBOutlet weak var amountView: NCBTransferAmountView!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    @IBOutlet weak var containerOptionView: UIStackView!
    
    //MARK: Properties
    
    var creditCardInfo: NCBCreditCardModel?
    fileprivate var cardNumberView: NCBSourceAccountView?
    fileprivate var p: NCBCreditCardPaymentPresenter?
    fileprivate var firstLoad = true
    fileprivate var amount = 0.0
    fileprivate var listCreditCard: [NCBCreditCardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        removeAllNotification()
    }
    
    override func loadDefaultSourceAccount() {
        super.loadDefaultSourceAccount()
        
//        getBillDate()
        SVProgressHUD.show()
        getListCreditCard(CreditCardType.VS.rawValue)
    }
    
}

extension NCBCreditCardPaymentCardHolderViewController {
    
    override func setupView() {
        super.setupView()
        
        cardNumberView = R.nib.ncbSourceAccountView.firstView(owner: self)!
        cardNumberView?.lbBalance.isHidden = true
        cardNumberView?.lbSourceAccount.text = "Số thẻ"
//        cardNumberView?.lbSourceAccountValue.text = creditCardInfo?.cardno?.cardHidden
        cardNumberView?.lbAccountName.text = ""
        
        containerCardNumber.addSubview(cardNumberView!)
        
        cardNumberView!.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showCreditCardList))
        cardNumberView!.addGestureRecognizer(gesture)
        
        lbAmountPaymentTitle.font = regularFont(size: NumberConstant.smallFontSize)
        lbAmountPaymentTitle.textColor = ColorName.holderText.color
        
        debtEndPeriodbtn.titleLabel?.font = regularFont(size: NumberConstant.smallFontSize)
        debtEndPeriodbtn.setTitleColor(ColorName.holderText.color, for: .normal)
        debtEndPeriodbtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        debtEndPeriodbtn.isSelected = true
        
        minimumAmountBtn.titleLabel?.font = regularFont(size: NumberConstant.smallFontSize)
        minimumAmountBtn.setTitleColor(ColorName.holderText.color, for: .normal)
        minimumAmountBtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        
        otherBtn.titleLabel?.font = regularFont(size: NumberConstant.smallFontSize)
        otherBtn.setTitleColor(ColorName.holderText.color, for: .normal)
        otherBtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        
        lbDebtEndPeriodValue.font = semiboldFont(size: NumberConstant.commonFontSize)
        lbDebtEndPeriodValue.textColor = ColorName.blurNormalText.color
//        lbDebtEndPeriodValue.text = (creditCardInfo?.ledBalance ?? 0.0).formattedWithDotSeparator
//        amount = creditCardInfo?.ledBalance ?? 0.0
        
        lbMiniumAmountValue.font = semiboldFont(size: NumberConstant.commonFontSize)
        lbMiniumAmountValue.textColor = ColorName.blurNormalText.color
        
        hiddenAmountView(true)
        updateData()
        
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        
        p = NCBCreditCardPaymentPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        lbAmountPaymentTitle.text = "Số tiền thanh toán (VND)"
        debtEndPeriodbtn.setTitle("Dư nợ cuối kỳ", for: .normal)
        minimumAmountBtn.setTitle("Số tiền tối thiểu", for: .normal)
        otherBtn.setTitle("Khác", for: .normal)
        amountView.textField.placeholder = "Nhập số tiền"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        if result {
            var amt = 0.0
            if otherBtn.isSelected {
                amt = Double(amountView.textField.text!.removeSpecialCharacter) ?? 0.0
            } else {
                amt = amount
            }
            
            let vc = NCBVerifyCreditCardPaymentViewController()
            vc.creditCardInfo = creditCardInfo
            vc.sourceAccount = sourceAccount
            vc.amount = amt
            vc.exceedLimit = exceedLimit(amt, type: .creditCardPayment)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func continueAction() {
        if otherBtn.isSelected && amountView.textField.text == "" {
            showAlert(msg: ErrorConstant.crdCardNoEnterAmount.getMessage() ?? "Vui lòng nhập số tiền")
            return
        }
        
        if !otherBtn.isSelected && amount == 0 {
            showAlert(msg: "Vui lòng chọn số tiền khác")
            return
        }
        
        var amt = 0.0
        if otherBtn.isSelected {
            amt = Double(amountView.textField.text!.removeSpecialCharacter) ?? 0.0
        } else {
            amt = amount
        }
        
        if amt > creditCardInfo?.creditLimit ?? 0.0 * 2 {
            showAlert(msg: ErrorConstant.crdCardPaymentMoreThan200.getMessage() ?? "Số tiền thanh toán chỉ cho phép tối đa 200% hạn mức tín dụng. Quý khách vui lòng kiểm tra lại.")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceCard(debitAccountNo: sourceAccount?.acctNo ?? "", amount: amt)
    }
    
    @objc fileprivate func chooseOption(_ sender: NCBRadioButton) {
        if sender.isSelected {
            return
        }
        
        debtEndPeriodbtn.isSelected = (sender == debtEndPeriodbtn)
        minimumAmountBtn.isSelected = (sender == minimumAmountBtn)
        otherBtn.isSelected = (sender == otherBtn)
        amountView.clear()
        amount = (sender == debtEndPeriodbtn) ? Double(lbDebtEndPeriodValue.text!.removeSpecialCharacter) ?? 0.0 : Double(lbMiniumAmountValue.text!.removeSpecialCharacter) ?? 0.0
        hiddenAmountView(!(sender == otherBtn))
    }
    
    fileprivate func updateData() {
        cardNumberView?.lbSourceAccountValue.text = creditCardInfo?.cardno?.cardHidden
        lbDebtEndPeriodValue.text = (creditCardInfo?.ledBalance ?? 0.0).formattedWithDotSeparator
        lbMiniumAmountValue.text = (0.0).formattedWithDotSeparator
        amount = creditCardInfo?.ledBalance ?? 0.0
    }
    
    fileprivate func hiddenAmountView(_ hidden: Bool) {
        amountView.isHidden = hidden
        for constraint in amountView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            amountView.textField.drawViewsForRect(amountView.frame)
        }
    }
    
    fileprivate func hiddenOptionView(_ hidden: Bool) {
        containerOptionView.isHidden = hidden
        for constraint in containerOptionView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : 50
            }
        }
        
        hiddenAmountView(!hidden)
        if hidden {
            otherBtn.isSelected = true
            debtEndPeriodbtn.isSelected = false
            minimumAmountBtn.isSelected = false
        }
    }
    
    @objc fileprivate func showCreditCardList() {
        if let controller = R.storyboard.creditCard.ncbCreditCardListViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listCreditCard)
        }
    }
    
}

extension NCBCreditCardPaymentCardHolderViewController: NCBCreditCardListViewControllerDelegate {
    
    func didSelectItem(_ item: NCBCreditCardModel) {
        closeBottomSheet()
        creditCardInfo = item
        cardNumberView?.lbSourceAccountValue.text = creditCardInfo?.cardno?.cardHidden
        
        chooseOption(debtEndPeriodbtn)
        updateData()
        
        SVProgressHUD.show()
        getBillDate()
    }
    
}

extension NCBCreditCardPaymentCardHolderViewController {
    
    fileprivate func getBillDate() {
//        SVProgressHUD.show()
        
        let params: [String: Any] = [
            "username": NCBShareManager.shared.getUserID(),
            "cifNo": NCBShareManager.shared.getUser()?.cif ?? "",
            "cardNo": creditCardInfo?.cardno ?? ""
        ]
        
        p?.getBillDate(params: params)
    }
    
    fileprivate func getPaymentOptional(_ billDate: String) {
//        SVProgressHUD.show()
        
        let params: [String: Any] = [
            "username": NCBShareManager.shared.getUserID(),
            "cifNo": NCBShareManager.shared.getUser()?.cif ?? "",
            "cardNo": creditCardInfo?.cardno ?? "",
            "billDate": billDate
        ]
        
        p?.getPaymentOptional(params: params)
    }
    
}

extension NCBCreditCardPaymentCardHolderViewController: NCBCreditCardPaymentPresenterDelegate {
    
    func getBillDateCompleted(billDate: String?, error: String?) {
//        SVProgressHUD.dismiss()
        
        if let error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: error)
            return
        }
        
        if let billDate = billDate, let date = yyyyMMdd.date(from: billDate) {
            cardNumberView?.lbAccountName.text = "Kỳ thanh toán: \(ddMMyyyyFormatter.string(from: date))"
            getPaymentOptional(billDate)
        } else {
            hiddenOptionView(true)
            SVProgressHUD.dismiss()
        }
    }
    
    func getPaymentOptionalCompleted(optional: NCBCreditCardPaymentOptionalModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            hiddenOptionView(true)
            return
        }
        
        if let optional = optional {
            amount = optional.endPeriodValue ?? 0.0
            let endPeriodValue = optional.endPeriodValue ?? 0.0
            let minDue = optional.mindue ?? 0.0
            lbDebtEndPeriodValue.text = endPeriodValue.formattedWithDotSeparator
            lbMiniumAmountValue.text = minDue.formattedWithDotSeparator
            hiddenOptionView(endPeriodValue == 0.0 && minDue == 0.0)
        }
    }
    
}

extension NCBCreditCardPaymentCardHolderViewController {
    
    func getListCreditCardCompleted(listCreditCard: [NCBCreditCardModel]?, error: String?) {
        if let error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: error)
            return
        }
        
        self.listCreditCard = listCreditCard ?? []
        if self.listCreditCard.count == 0 {
            SVProgressHUD.dismiss()
            return
        }
        if creditCardInfo == nil {
            var result = self.listCreditCard.sorted() {
                ($0.amountAvailableToSpend ?? 0) > ($1.amountAvailableToSpend ?? 0)
            }
            self.listCreditCard = result
            creditCardInfo = result[0]
            updateData()
        }
        
        let item = self.listCreditCard.first(where: { $0.cardno == creditCardInfo?.cardno })
        item?.isSelected = true
        getBillDate()
    }
    
}
