//
//  NCBRegistrationCreditCardViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegistrationCreditCardViewController: NCBBaseViewController {
    
    @IBOutlet weak var branchTf: NewNCBCommonTextField! {
        didSet {
            branchTf.addRightArrow()
            branchTf.delegate = self
            branchTf.customDelegate = self
            branchTf.placeholder = "Chọn chi nhánh/phòng giao dịch nhận thẻ"
        }
    }
    @IBOutlet weak var productTf: NewNCBCommonTextField! {
        didSet {
            productTf.addRightArrow(true)
            productTf.placeholder = "Sản phẩm thẻ"
            productTf.delegate = self
            productTf.customDelegate = self
        }
    }
    @IBOutlet weak var salaryTitleLbl: UILabel! {
        didSet {
            
            salaryTitleLbl.font =  regularFont(size: 12.0)
            salaryTitleLbl.textColor = UIColor(hexString: ColorName.holderText.rawValue)
            salaryTitleLbl.text = "Hình thức trả lương của bạn?"
        }
    }
    @IBOutlet weak var cashBtn: UIButton! {
        didSet {
            cashBtn.setTitle(" Tiền mặt", for: .normal)
            cashBtn.titleLabel?.font = regularFont(size: 12.0)
            cashBtn.setTitleColor( UIColor(hexString: ColorName.holderText.rawValue), for: .normal)
        }
    }
    @IBOutlet weak var transferBtn: UIButton! {
        didSet {
            transferBtn.setTitle(" Chuyển khoản", for: .normal)
            transferBtn.titleLabel?.font = regularFont(size: 12.0)
            transferBtn.setTitleColor( UIColor(hexString: ColorName.holderText.rawValue), for: .normal)
            if isTransfer == false{
                transferBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
            }else{
                transferBtn.setImage(R.image.ic_radio_check(), for: .normal)
            }
        }
    }
    @IBOutlet weak var bankTf: NewNCBCommonTextField! {
        didSet {
           bankTf.placeholder = "Tại ngân hàng"
        }
    }
    @IBOutlet weak var creditLevelTf: NCBIncomeTextField! {
        didSet {
            creditLevelTf.placeholder = "Hạn mức tín dụng mong muốn"
        }
    }
    @IBOutlet weak var averageIncomeTf: NCBIncomeTextField! {
        didSet {
          averageIncomeTf.placeholder = "Thu nhập bình quân tháng"
        }
    }
    @IBOutlet weak var monthlyCostsTf: NCBIncomeTextField! {
        didSet {
            monthlyCostsTf.placeholder = "Chi phí hàng tháng"
        }
    }
    @IBOutlet weak var continueBtn: NCBCommonButton! {
        didSet {
            continueBtn.setTitle("Tiếp tục", for: .normal)
            continueBtn.backgroundColor = UIColor(hexString: "D6DEE4")
        }
    }
    var salary = ""
    var isCash = false
    var isTransfer = false
    fileprivate var listProduct: [NCBGetListCardProductVisaModel] = []
    var productVisa: NCBGetListCardProductVisaModel!
    var branchItem :NCBBranchModel!
    var isRegister = false
    
    
    @IBAction func cash(_ sender: Any) {
        if isCash == false{
            isCash = true
            cashBtn.setImage(R.image.ic_radio_check(), for: .normal)
            isTransfer = false
            transferBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        }else{
             cashBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
            isCash = false
        }
    }
    
     @IBAction func transfer(_ sender: Any) {
        if isTransfer == false{
            isTransfer = true
            isCash = false
            transferBtn.setImage(R.image.ic_radio_check(), for: .normal)
            cashBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
            isCash = false
        }else{
            transferBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
            isTransfer = false
        }
    }
    
    @IBAction func contiue(_ sender: Any) {
        
        if branchTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardReissueChooseBranch.getMessage() ?? "Vui lòng chọn chi nhánh/PGD")
            return
        }
        if productTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardChooseProduct.getMessage() ?? "Vui lòng chọn sản phẩm thẻ")
            return
        }
        if bankTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardChooseBank.getMessage() ?? "Vui lòng nhập tên ngân hàng")
            return
        }
        if creditLevelTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardChooseCreditLimit.getMessage() ?? "Vui lòng nhập hạn mức tín dụng mong muốn")
            return
        }
        if averageIncomeTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardChooseMonthlyIncome.getMessage() ?? "Vui lòng nhập thu nhập bình quân tháng")
            return
        }
        if monthlyCostsTf.text == "" {
            showAlert(msg: ErrorConstant.crdCardChooseMonthlyCost.getMessage() ?? "Vui lòng nhập chi phí hàng tháng")
            return
        }
        
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["cifNo"] = NCBShareManager.shared.getUser()!.cif
        params["cardProduct"] = productVisa.cardProduct
         params["cardClass"] = productVisa.cardClass
         params["departCode"] = branchItem.depart_code
         params["departName"] = branchItem.depart_name
        
        if isCash == true{
            salary = "Tiền mặt"
        }else{
            salary = "Chuyển khoản"
        }
         params["salary"] = salary
         params["bank"] = bankTf.text
         params["limit"] = creditLevelTf.getAmount
         params["monthlyIncome"] = averageIncomeTf.getAmount
         params["monthlyCost"] =  monthlyCostsTf.getAmount
        
        SVProgressHUD.show()
        presenter?.createCardVisa(params: params)
    }
    
    
    var presenter: NCBCardServicePresenter?
    fileprivate var refreshTokenPresenter: NCBOTPAuthenticationPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}
extension NCBRegistrationCreditCardViewController
{
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("Phát hành thẻ tín dụng mới")
        
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
        
        refreshTokenPresenter = NCBOTPAuthenticationPresenter()
        refreshTokenPresenter?.delegate = self
        
        SVProgressHUD.show()
        refreshTokenPresenter?.refreshToken()
    }
    /*
    func getFeeCard() {
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["classCard"] = cardClassTf.text
        params["product"] = cardProductsTf.text
        print(params)
        SVProgressHUD.show()
        presenter?.getFeeCard(params: params)
    }
    */
}

extension NCBRegistrationCreditCardViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func refreshTokenCompleted(error: String?) {
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["cifNo"] = NCBShareManager.shared.getUser()!.cif
        
        presenter?.checkCreateVisa(params: params)
    }
    
}

extension NCBRegistrationCreditCardViewController: NCBCardServicePresenterDelegate {
    func getFeeCard(services: NCBGetFeeCardModel?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }else{

        }
    }
   
    
    func getListBranch(services: [NCBBranchModel]?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
    }
    
    func getListCardProductVisa(services: [NCBGetListCardProductVisaModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            listProduct = services!
            var items = [BottomSheetStringItem]()
            for product in listProduct{
                let productStr = product.cardProduct ?? ""
                let classStr = product.cardClass ?? ""
                let title = productStr  + "-" + classStr
                items.append(BottomSheetStringItem(title:title , isCheck: false))
            }
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Sản phẩm thẻ", items: items, isHasOptionItem: true)
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
        }
    }
    
    func getListCardProduct(services: [String]?, error: String?) {
       SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
           
        }
    }
    
    func getListCardClass(services: [String]?, error: String?) {
       SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            var items = [BottomSheetStringItem]()
            for classItem in services!{
                items.append(BottomSheetStringItem(title: classItem, isCheck: false))
            }
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Hạng thẻ", items: items, isHasOptionItem: true)
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
        }
    }
    func createCardVisa(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if let vc = R.storyboard.cardService.ncbRegistrationCreditCardSuccessfulViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
   
    func checkCreateVisa(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        if services == nil{
            showError(msg: error ?? "") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension NCBRegistrationCreditCardViewController:NCBBranchListViewControllerDelegate
{
    func didSelectBranchItem(item: NCBBranchModel) {
        branchTf.text = item.depart_name
        branchItem = item
        closeBottomSheet()
    }
}

extension NCBRegistrationCreditCardViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == branchTf{
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return false
        }
        
        if textField == productTf{
            var params: [String: Any] = [:]
            params["username"] = NCBShareManager.shared.getUser()!.username
            params["cifNo"] = NCBShareManager.shared.getUser()!.cif
            //params["cardType"] = "VS"
            print(params)
            
            
           // SVProgressHUD.show()
            //presenter?.getListCardProduct(params: params)
            presenter?.getListCardProductVisa(params: params)
            return false
        }
        return true
    }
    
}

extension NCBRegistrationCreditCardViewController:NewNCBCommonTextFieldDelegate
{
    func textFieldDidSelectRightArrow(_ textField: UITextField) {
        
        if textField == branchTf{
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if textField == productTf{
            var params: [String: Any] = [:]
            params["username"] = NCBShareManager.shared.getUser()!.username
            params["cifNo"] = NCBShareManager.shared.getUser()!.cif
            //params["cardType"] = "VS"
            print(params)
            
            // SVProgressHUD.show()
            //presenter?.getListCardProduct(params: params)
            presenter?.getListCardProductVisa(params: params)
            return
        }
        
    }
    
   
}
extension NCBRegistrationCreditCardViewController: NCBBottomSheetListViewControllerDelegate {
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        let visa = listProduct[index]
        productVisa = visa
        productTf.text = item.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        closeBottomSheet()
    }
}
