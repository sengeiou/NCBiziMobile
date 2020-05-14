//
//  NCBRegistrationCardReissueViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegistrationCardReissueViewController: NCBBaseSourceAccountViewController  {
    
    // MARK: - Outlets
    
    @IBOutlet weak var  branchTf: NewNCBCommonTextField! {
        didSet {
            branchTf.delegate = self
            branchTf.addRightArrow()
        }
    }
    
    @IBOutlet weak var  reasonTf: NewNCBCommonTextField! {
        didSet {
            reasonTf.delegate = self
            reasonTf.addRightArrow(true)
        }
    }
    
    @IBOutlet weak var continueBtn: NCBCommonButton! {
        didSet {
            continueBtn.backgroundColor = UIColor(hexString: "D6DEE4")
        }
    }
    
    @IBAction func contiue(_ sender: Any) {
        
        if branchTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardReissueChooseBranch.getMessage() ?? "Vui lòng chọn chi nhánh /PGD nhận thẻ")
            return
        }
        
        if reasonTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardReissueChooseReason.getMessage() ?? "Vui lòng chọn lý do yêu cầu phát hành lại thẻ")
            return
        }
        if cardData.isExpired == true {
             showAlert(msg: ErrorConstant.crdCardReissueNotExist.getMessage() ?? "Số tài khoản thẻ của Quý khách không tồn tại, Vui lòng liên hệ 18006166 để biết thêm chi tiết")
            return
        }
        if typeCard == CreditCardType.DB {
            var params: [String: Any] = [:]
            params["cifNo"] = NCBShareManager.shared.getUser()!.cif
            params["username"] = NCBShareManager.shared.getUser()!.username
            params["prdcode"] = cardData.prdcode
            params["acctNo"] = cardData.acctno
            SVProgressHUD.show()
            print(params)
            presenter?.getFeeAcctReopenAtm(params: params)
        } else {
            if let vc = R.storyboard.cardService.ncbRegistrationCardReissueVerifyViewController() {
                vc.setData(data: cardData, branchModel: branchModel, accountName: sourceAccountView?.getSourceAccount() ?? "",reason: reason)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
     
      
    }

    
    // MARK: - Properties
    
    var cardData: NCBCardModel!
    var branchModel: NCBBranchModel!
    var presenter: NCBCardServicePresenter?
    var getFeeAcctReopenAtmModel:NCBGetFeeAcctReopenAtmModel!
    var reasonReopenAtm: [NCBReasonAcctReopenAtmModel] = []
    var typeCard:CreditCardType!
    var reason:NCBReasonAcctReopenAtmModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func loadDefaultSourceAccount() {
        super.loadDefaultSourceAccount()
        
        var params: [String: Any] = [:]
        params["cifNo"] = NCBShareManager.shared.getUser()!.cif
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["cardNo"] = cardData.cardno
        
        SVProgressHUD.show()
        presenter?.checkReopenCard(params: params)
    }
    
    func setupData(data:NCBCardModel) {
        cardData = data
        typeCard = cardData.getCardType()
    }
    
}

extension NCBRegistrationCardReissueViewController {
    override func setupView() {
        super.setupView()
        
        branchTf.placeholder = "Chọn chi nhánh/phòng giao dịch nhận thẻ"
        reasonTf.placeholder = "Lý do yêu cầu phát hành lại thẻ"
      
        continueBtn.setTitle("Tiếp tục", for: .normal)

        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
        
        commonCreditCardInfoView?.setData(cardData)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Đăng ký phát hành lại thẻ")
    }
    
    func converDate(str:String) ->String  {
        let date = yyyyMMdd.date(from: str)
        if let date = date {
            return MMyy.string(from: date)
        }
        return ""
    }
    
}

extension NCBRegistrationCardReissueViewController:NCBLockCardConfirmViewControllerDelegate{
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func lock() {
        
    }
    
    func refuse() {
        
    }
}

extension NCBRegistrationCardReissueViewController: NCBCardServicePresenterDelegate {
    func getFeeAcctReopenAtm(services: NCBGetFeeAcctReopenAtmModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
            
        }else{
            getFeeAcctReopenAtmModel = services
            
            if let vc = R.storyboard.cardService.ncbRegistrationCardReissueVerifyViewController() {
                vc.setData(data: cardData, branchModel: branchModel, feeAcctReopenAtmModel: getFeeAcctReopenAtmModel, accountName: sourceAccountView?.getSourceAccount() ?? "",reason: reason)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    func getReasonAcctReopenAtm(services: [NCBReasonAcctReopenAtmModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            reasonReopenAtm = services ?? []
            var items = [BottomSheetStringItem]()
            for reason in reasonReopenAtm {
                items.append(BottomSheetStringItem(title: reason.value ?? "", isCheck: reasonTf.text == reason.value))
            }
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Lý do yêu cầu phát hành lại thẻ", items: items, isHasOptionItem: true)
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
        }
    }
    func checkReopenCard(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let error = error {
            showError(msg: error) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension NCBRegistrationCardReissueViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == branchTf{
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return false
        }
        
        if textField == reasonTf{
            SVProgressHUD.show()
            var params: [String: Any] = [:]
            params["cifNo"] = NCBShareManager.shared.getUser()!.cif
            params["username"] = NCBShareManager.shared.getUser()!.username
            presenter?.getReasonAcctReopenAtm(params: params)
            
            
            /*
            var items = [BottomSheetStringItem]()
            items.append(BottomSheetStringItem(title: "Mất thẻ ", isCheck: false))
            items.append(BottomSheetStringItem(title: "Hỏng thẻ", isCheck: false))
            items.append(BottomSheetStringItem(title: "Hết hạn", isCheck: false))
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Lý do yêu cầu phát hành lại thẻ", items: items, isHasOptionItem: true)
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
            */
            return false
        }
       
        
        return true
    }
}

extension NCBRegistrationCardReissueViewController:NCBBranchListViewControllerDelegate
{
    func didSelectBranchItem(item: NCBBranchModel) {
        branchTf.text = item.depart_name
        branchModel = item
        closeBottomSheet()
    }
}

extension NCBRegistrationCardReissueViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        reasonTf.text = item
        reason = reasonReopenAtm[index]
        closeBottomSheet()
        
    }
    
}
