//
//  NCBRegistrationATMViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation


class NCBRegistrationATMViewController: NCBBaseTransactionViewController {
    
    @IBOutlet weak var subViewAccount: UIView! {
        didSet {
           
        }
    }
    fileprivate var accountInfoView: NCBSourceAccountView?
    
    @IBOutlet weak var branchTf: NewNCBCommonTextField! {
        didSet {
            branchTf.addRightArrow()
            branchTf.delegate = self
        }
    }
    
    @IBOutlet weak var cardProductsTf: NewNCBCommonTextField! {
        didSet {
            cardProductsTf.addRightArrow(true)
             cardProductsTf.delegate = self
        }
    }
    
    @IBOutlet weak var cardClassTf: NewNCBCommonTextField! {
        didSet {
            cardClassTf.addRightArrow(true)
            cardClassTf.delegate = self
        }
    }
    
    @IBOutlet weak var serviceChargeLbl: UILabel! {
        didSet {
            serviceChargeLbl.text = ""
            serviceChargeLbl.font = regularFont(size: 12)
            serviceChargeLbl.textColor = UIColor(hexString: "0083DC")
        }
    }
    
    @IBOutlet weak var continueBtn: NCBCommonButton! {
        didSet {
           continueBtn.backgroundColor = UIColor(hexString: "D6DEE4")
        }
    }
    
    @IBAction func contiue(_ sender: Any) {
        if branchTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardReissueChooseBranch.getMessage() ?? "Vui lòng chọn chi nhánh /PGD nhận thẻ.")
            return
        }
        if cardProductsTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardChooseProduct.getMessage() ?? "Vui lòng chọn sản phẩm thẻ.")
            return
        }
        
        if cardClassTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardChooseRank.getMessage() ?? "Vui lòng chọn hạng thẻ.")
            return
        }
        if accNoModel.openATM() == true{
            showAlert(msg: ErrorConstant.crdCardRegNewOpened.getMessage() ?? "Quý khách đã có thẻ ATM. Trường hợp muốn mở lại thẻ, Quý khách vui lòng chọn Phát hành lại thẻ.")
            return
        }
        if accNoModel.isRequestOpenATM() == true{
            showAlert(msg: ErrorConstant.crdCardRegNewRequestedOpen.getMessage() ?? "Yêu cầu đăng ký phát hành thẻ của Quý khách đang được xử lý. NCB sẽ thông báo đến Quý khách khi thẻ được phát hành.")
            return
        }
        
//        if  let curBal = accNoModel.curBal {
//            let amount = getFeeCardModel.fee ?? 0.0
//            if curBal < amount {
//                showAlert(msg: "Tài khoản nguồn không đủ số dư.")
//                return
//            }
//        }
        
        SVProgressHUD.show()
        checkBalanceCard(debitAccountNo: accNoModel.acctNo ?? "", amount: getFeeCardModel.fee ?? 0.0)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        
        if result {
            if let vc = R.storyboard.cardService.ncbRegistrationATMVerifyViewController() {
                vc.setupData(getFeeCardModel: getFeeCardModel, branchModel: branchModel, cardProduct: cardProductsTf.text ?? "", cardClass: cardClassTf.text ?? "", accountName: accNoModel.acctNo ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
 
    fileprivate var listCard: [NCBCardModel] = []
    fileprivate var listProduct: [String] = []
    
    var getFeeCardModel:NCBGetFeeCardModel!
    var listAccNoModel: [NCBGetListAccNoModel] = []
    var accNoModel: NCBGetListAccNoModel!
    var presenter: NCBCardServicePresenter?
    var branchModel: NCBBranchModel!
    var isProductCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshToken()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }

}

extension NCBRegistrationATMViewController
{
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("Phát hành thẻ mới")
        branchTf.placeholder = "Chọn chi nhánh/phòng giao dịch nhận thẻ"
        cardProductsTf.placeholder = "Sản phẩm thẻ"
        cardClassTf.placeholder = "Hạng thẻ"
        continueBtn.setTitle("Tiếp tục", for: .normal)
        
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
        
        accountInfoView = R.nib.ncbSourceAccountView.firstView(owner: self)
        subViewAccount.addSubview(accountInfoView!)
        accountInfoView?.snp.makeConstraints {(make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        accountInfoView?.delegate = self
        accountInfoView?.setLbSourceAccount("Tài khoản nguồn")
    }
    
    func getFeeCard() {
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["classCard"] = cardClassTf.text
        params["product"] = cardProductsTf.text
        params["acctNo"] = accNoModel.acctNo
        
        print(params)
        SVProgressHUD.show()
        presenter?.getFeeCard(params: params)
    }
    
}

extension NCBRegistrationATMViewController {
    
    override func refreshTokenCompleted(error: String?) {
        var params: [String: Any] = [:]
       params["username"] = NCBShareManager.shared.getUser()!.username
       params["cifNo"] = NCBShareManager.shared.getUser()!.cif
    
       presenter?.getListAccNo(params: params)
    }
    
}

extension NCBRegistrationATMViewController: NCBCardServicePresenterDelegate {
    func getFeeCard(services: NCBGetFeeCardModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            getFeeCardModel = services!
            serviceChargeLbl.text = "Phí dịch vụ: "+getFeeCardModel.fee!.currencyFormatted
             continueBtn.drawGradient(horizontal: true)
        }
    }
    
    func getListBranch(services: [NCBBranchModel]?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
    }
    
    func getListCardProduct(services: [String]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            listProduct = services!
            var items = [BottomSheetStringItem]()
            for product in listProduct{
                items.append(BottomSheetStringItem(title: product, isCheck: cardProductsTf.text?.trim == product.trim))
            }
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Sản phẩm thẻ", items: items, isHasOptionItem: true)
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
        }
    }
    
    func getListCardClass(services: [String]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            var items = [BottomSheetStringItem]()
            for classItem in services!{
                items.append(BottomSheetStringItem(title: classItem, isCheck: cardClassTf.text?.trim == classItem.trim))
            }
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                
                vc.setData("Hạng thẻ", items: items, isHasOptionItem: true)
                
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
        }
    }
    func getListAccNo(services: [NCBGetListAccNoModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if let data = services, data.count > 0 {
                let sortedData = data.sorted() {
                    ($0.curBal ?? 0.0) > ($1.curBal ?? 0.0)
                }
                
                for item in sortedData {
                    if !item.openATM() {
                        listAccNoModel.append(item)
                    }
                }
                if listAccNoModel.count > 0 {
                    let item = listAccNoModel[0]
                    accNoModel = listAccNoModel[0]
                    item.isSelected = true
                    accountInfoView?.setSourceAccount(item.acName)
                    accountInfoView?.setSourceName(item.acctNo)
                    accountInfoView?.setSourceBalance(item.curBal)
                }else{
                    showError(msg: ErrorConstant.crdCardRegNewOpened.getMessage() ?? "Quý khách đã có thẻ ATM. Trường hợp muốn mở lại thẻ, Quý khách vui lòng chọn Phát hành lại thẻ.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

extension NCBRegistrationATMViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == branchTf{
            isProductCard = false
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return false
        }
        if textField == cardProductsTf{
            isProductCard = true
            var params: [String: Any] = [:]
            params["username"] = NCBShareManager.shared.getUser()!.username
            params["cifNo"] = NCBShareManager.shared.getUser()!.cif
            params["cardType"] = "DB"
            print(params)
            SVProgressHUD.show()
            presenter?.getListCardProduct(params: params)
            return false
        }
        if textField == cardClassTf{
            isProductCard = false
            if cardProductsTf.text == ""{
                showAlert(msg: "Vui lòng chọn sản phẩm thẻ trước khi chọn hạng thẻ")
                return false
            }
            
            var params: [String: Any] = [:]
            params["username"] = NCBShareManager.shared.getUser()!.username
            params["cifNo"] = NCBShareManager.shared.getUser()!.cif
            params["cardProduct"] = cardProductsTf.text
            print(params)
            presenter?.getListCardClass(params: params)
            return false
        }
        return true
    }
}

extension NCBRegistrationATMViewController:NCBBranchListViewControllerDelegate
{
    func didSelectBranchItem(item: NCBBranchModel) {
        branchModel = item
        branchTf.text = item.depart_name
        removeBottomSheet()  
    }
}

extension NCBRegistrationATMViewController: NCBBottomSheetListViewControllerDelegate {
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        if isProductCard == true{
            cardProductsTf.text = item.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }else{
            cardClassTf.text = item.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                getFeeCard()
        }
        removeBottomSheet()
    }
}

extension NCBRegistrationATMViewController: NCBSourceAccountViewDelegate {
    func sourceDidSelect() {
        showAccountRegister()
    }
    
    @objc fileprivate func showAccountRegister() {
        if let controller = R.storyboard.cardService.ncbListAccountRegistrationATMViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listAccNoModel)
        }
    }
    
   
}

extension NCBRegistrationATMViewController: NCBListAccountRegistrationATMViewControllerDelegate {
    func didSelectAccount(_ account: NCBGetListAccNoModel) {
        self.accountInfoView?.setSourceAccount(account.acctNo)
        self.accountInfoView?.setSourceName(account.acName)
        self.accountInfoView?.setSourceBalance(account.curBal)
        accNoModel = account
        closeBottomSheet()
    }
  
}
