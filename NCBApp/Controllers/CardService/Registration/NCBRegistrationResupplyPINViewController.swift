//
//  NCBRegistrationResupplyPINViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegistrationResupplyPINViewController: NCBBaseSourceAccountViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var  branchTf: NewNCBCommonTextField! {
        didSet {
            branchTf.addRightArrow()
            branchTf.customDelegate = self
            branchTf.delegate = self
            
        }
    }

    @IBOutlet weak var peeLbl: UILabel! {
        didSet {
            peeLbl.text = ""
            peeLbl.font = regularFont(size: 12)
            peeLbl.textColor = UIColor(hexString: "0083DC")
        }
    }
    
    @IBOutlet weak var continueBtn: NCBCommonButton! {
        didSet {
            continueBtn.backgroundColor = UIColor(hexString: "D6DEE4")
        }
    }
    
    @IBAction func contiue(_ sender: Any) {
        if branchTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardResupplyPinChooseBranch.getMessage() ?? "Vui lòng chọn chi nhánh /PGD nhận PIN")
            return
        }
        
        if cardData.isExpired == true {
            showAlert(msg: ErrorConstant.crdCardExpired.getMessage() ?? "")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceCard(debitAccountNo: sourceAccount?.acctNo ?? "", amount: feePinModel.fee ?? 0.0)
    }
    
    
    // MARK: - Properties
    
    var cardData: NCBCardModel!
    var branchModel: NCBBranchModel!
    var presenter: NCBCardServicePresenter?
    var feePinModel:NCBGetFeeCardModel!
    var reasonReopenAtm: [NCBReasonAcctReopenAtmModel] = []
    var isGetFee = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        
        if result {
            if let vc = R.storyboard.cardService.ncbRegistrationResupplyPINVerifyViewController() {
                vc.setData(data: cardData, branchModel: branchModel, feePinModel: feePinModel, accountName: sourceAccountView?.lbAccountName.text ?? "",accNo:sourceAccountView?.lbSourceAccountValue.text ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func defaultSourceAccount() {
        if listPaymentAccount.count == 0 {
            return
        }
//        if cardData.cardno == nil{
//            showError(msg: "Số tài khoản của quý khách không tồn tại, vui lòng chọn tài khoản khác") {
//                self.navigationController?.popViewController(animated: true)
//            }
//            return
//        }
        
        if let sourceAccount = sourceAccount {
            sourceAccount.isSelected = true
            sourceAccountView?.setSourceAccount(sourceAccount.acctNo)
            sourceAccountView?.setSourceName(sourceAccount.acName)
            sourceAccountView?.setSourceBalance(sourceAccount.curBal)
            
            getFee()
            return
        }
        
        if cardData.cardtype?.uppercased() == "DB" || cardData.cardtype?.uppercased() == "CR"
        {
            var isExistAcc = false
            for item in listPaymentAccount {
                if item.acctNo == cardData.acctno{
                    sourceAccount = item
                    isExistAcc = true
                    break
                }
            }
            if isExistAcc == false {
                showError(msg: ErrorConstant.crdCardReissueNotExist.getMessage() ?? "Số tài khoản của quý khách không tồn tại, vui lòng chọn tài khoản khác") {
                    if self.cardData.cardtype?.uppercased() == "DB" {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else{
            let result = listPaymentAccount.sorted() {
                ($0.curBal ?? 0.0) > ($1.curBal ?? 0.0)
            }
            listPaymentAccount = result
            sourceAccount = result[0]
        }
        
        sourceAccount?.isSelected = true
        sourceAccountView?.setSourceAccount(sourceAccount?.acctNo)
        sourceAccountView?.setSourceName(sourceAccount?.acName)
        sourceAccountView?.setSourceBalance(sourceAccount?.curBal)
        
        getFee()
    }
    
    func setupData(data:NCBCardModel) {
        cardData = data
    }
    
    fileprivate func getFee() {
        var params: [String: Any] = [:]
        params["cifNo"] = NCBShareManager.shared.getUser()!.cif
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["acctNo"] = sourceAccountView?.getSourceAccount() ?? ""
        params["prdcode"] = cardData.prdcode
        print(params)
        presenter?.getFeePin(params: params)
    }
    
    override func viewDidSelectSourceAccount(_ account: NCBDetailPaymentAccountModel) {
        super.viewDidSelectSourceAccount(account)
        getFee()
    }
    
}


extension NCBRegistrationResupplyPINViewController {
    override func setupView() {
        super.setupView()
        
        branchTf.placeholder = "Chọn chi nhánh/phòng giao dịch nhận thẻ"
        continueBtn.setTitle("Tiếp tục", for: .normal)
        
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
        
        commonCreditCardInfoView?.setData(cardData)
 
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Cấp lại PIN thẻ")
        //drawGradient(self.view, horizontal: false)
    }
    
    func converDate(str:String) ->String  {
        let date = yyyyMMdd.date(from: str)
        if let date = date {
            return MMyy.string(from: date)
        }
        return ""
    }
    
}

extension NCBRegistrationResupplyPINViewController:NCBLockCardConfirmViewControllerDelegate{
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func lock() {
        
    }
    
    func refuse() {
        
    }
}

extension NCBRegistrationResupplyPINViewController: NCBCardServicePresenterDelegate {
    func getFeePin(services: NCBGetFeeCardModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if isGetFee == true{
                return
            }
            feePinModel = services
            peeLbl.text = "Phí dịch vụ: "+(feePinModel.fee ?? 0.0).currencyFormatted
           
        }
    }
    
    func updateCardStatusUnlockApproval(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        
    }
    
    func cardActiveConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }
        
    }
    

    func updateCardStatusUnlockConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
    }
    
    func getCrCardList(services: [NCBCardModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }
    }
    
    func getListBranch(services: [NCBBranchModel]?, error: String?) {
        
    }

    
    
    
}

extension NCBRegistrationResupplyPINViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == branchTf{
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return false
        }
        return true
    }
}
extension NCBRegistrationResupplyPINViewController:NewNCBCommonTextFieldDelegate
{
    func textFieldDidSelectRightArrow(_ textField: UITextField) {
        if textField == branchTf{
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func textFieldDidChangeNameReminiscent(_ textField: UITextField, value: Bool) {
        if textField == branchTf{
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension NCBRegistrationResupplyPINViewController:NCBBranchListViewControllerDelegate
{
    func didSelectBranchItem(item: NCBBranchModel) {
        branchTf.text = item.depart_name
        branchModel = item
        closeBottomSheet()
    }
}

