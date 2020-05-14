//
//  NCBRegisterCreditCardViewController.swift
//  NCBApp
//
//  Created by Thuan on 9/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegisterCreditCardViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfName: NewNCBCommonTextField!
    @IBOutlet weak var tfCMT: NewNCBCommonTextField!
    @IBOutlet weak var tfPhone: NewNCBCommonTextField!
    @IBOutlet weak var tfBranch: NewNCBCommonTextField!
    @IBOutlet weak var tfProduct: NewNCBCommonTextField!
    @IBOutlet weak var lbForm: UILabel!
    @IBOutlet weak var cashFormBtn: NCBRadioButton!
    @IBOutlet weak var transferFormBtn: NCBRadioButton!
    @IBOutlet weak var tfBank: NewNCBCommonTextField!
    @IBOutlet weak var tfIncome: NCBIncomeTextField!
    @IBOutlet weak var tfCost: NCBIncomeTextField!
    @IBOutlet weak var tfLimit: NCBIncomeTextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    fileprivate var branchModel: NCBBranchModel?
    fileprivate var p: NCBRegisterCreditCardPresenter?
    fileprivate var products = [NCBGetListCardProductVisaModel]()
    fileprivate var cardProduct: NCBGetListCardProductVisaModel?
    fileprivate var indexProduct = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    @objc fileprivate func continueAction() {
//        if tfName.text!.isEmpty || tfCMT.text!.isEmpty || tfPhone.text!.isEmpty || tfBranch.text!.isEmpty || tfProduct.text!.isEmpty || (tfBank.text!.isEmpty && !tfBank.isHidden) || tfIncome.text!.isEmpty {
//            showAlert(msg: "Quý khách vui lòng nhập đầy đủ thông tin")
//            return
//        }
        
        if tfName.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardChooseName.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if tfCMT.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardChooseCMT.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if tfPhone.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardChoosePhone.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if !tfPhone.text!.isPhoneNumber {
            showAlert(msg: "Số điện thoại không hợp lệ")
            return
        }
        
        if tfBranch.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardReissueChooseBranch.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if tfProduct.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardChooseProduct.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if tfBank.text!.isEmpty && !tfBank.isHidden {
            showAlert(msg: ErrorConstant.crdCardChooseBank.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if tfIncome.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardChooseMonthlyIncome.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if tfCost.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardChooseMonthlyCost.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if tfLimit.text!.isEmpty {
            showAlert(msg: ErrorConstant.crdCardChooseCreditLimit.getMessage() ?? "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        var params: [String: Any] = [:]
        params["customerName"] = tfName.text
        params["legalId"] = tfCMT.text
        params["mobileNumber"] = tfPhone.text
        params["cardProduct"] = cardProduct?.cardProduct
        params["cardClass"] = cardProduct?.cardClass
        params["departCode"] = branchModel?.depart_code
        params["departName"] = branchModel?.depart_name
        params["salary"] = cashFormBtn.isSelected ? "Tiền mặt" : "Chuyển khoản"
        params["bank"] = tfBank.text
        params["limit"] = tfLimit.getAmount
        params["monthlyIncome"] = tfIncome.getAmount
        params["monthlyCost"] = tfCost.getAmount
        
        SVProgressHUD.show()
        p?.registerCardVisa(params: params)
    }
    
}

extension NCBRegisterCreditCardViewController {
    
    override func setupView() {
        super.setupView()
        
        hiddenBankView(true)
        
        lbForm.font = regularFont(size: 12)
        lbForm.textColor = ColorName.holderText.color
        
        tfBranch.addRightArrow()
        tfProduct.addRightArrow(true)
        
        tfPhone.keyboardType = .numberPad
        
        cashFormBtn.isSelected = true
        cashFormBtn.addTarget(self, action: #selector(changeForm(_:)), for: .touchUpInside)
        transferFormBtn.addTarget(self, action: #selector(changeForm(_:)), for: .touchUpInside)
        
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        
        tfCMT.delegate = self
        tfBranch.delegate = self
        tfProduct.delegate = self
        
        SVProgressHUD.show()
        p = NCBRegisterCreditCardPresenter()
        p?.delegate = self
        p?.getCardProducts()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Đăng ký thẻ tín dụng")
        
        tfName.placeholder = "Họ và tên"
        tfCMT.placeholder = "Số CMT/Hộ chiếu/CCCD"
        tfPhone.placeholder = "Số điện thoại"
        tfBranch.placeholder = "Chọn chi nhánh/PGD đăng ký phát hành thẻ"
        tfProduct.placeholder = "Sản phẩm thẻ"
        lbForm.text = "Hình thức trả lương"
        tfBank.placeholder = "Tại ngân hàng"
        tfIncome.placeholder = "Thu nhập bình quân tháng"
        tfCost.placeholder = "Chi phí hàng tháng"
        tfLimit.placeholder = "Hạn mức tín dụng mong muốn"
        cashFormBtn.setTitle("Tiền mặt", for: .normal)
        transferFormBtn.setTitle("Chuyển khoản", for: .normal)
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    @objc fileprivate func changeForm(_ sender: UIButton) {
        hiddenBankView(sender == cashFormBtn)
        cashFormBtn.isSelected = (sender == cashFormBtn)
        transferFormBtn.isSelected = (sender == transferFormBtn)
    }
    
    fileprivate func hiddenBankView(_ hidden: Bool) {
        tfBank.isHidden = hidden
        for constraint in tfBank.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfBank.text = ""
            tfBank.drawViewsForRect(tfBank.frame)
        }
    }
    
    fileprivate func showProductList() {
        var items = [BottomSheetStringItem]()
        for item in products {
            items.append(BottomSheetStringItem(title: item.getProductName(), isCheck: item.getProductName() == tfProduct.text))
        }
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.setData("Chọn sản phẩm thẻ", items: items, isHasOptionItem: true)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 300)
        }
    }
    
}

extension NCBRegisterCreditCardViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfProduct {
            showProductList()
            return false
        } else if textField == tfBranch {
            if let vc = R.storyboard.cardService.ncbBranchListViewController() {
                vc.delegate = self
                vc.strTitle = "Chọn địa điểm"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && textField == tfCMT {
            return false
        }
        return true
    }
    
}

extension NCBRegisterCreditCardViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        closeBottomSheet()
        tfProduct.text = item
        cardProduct = products[index]
    }
    
}

extension NCBRegisterCreditCardViewController: NCBBranchListViewControllerDelegate {
    
    func didSelectBranchItem(item: NCBBranchModel) {
        tfBranch.text = item.depart_name
        branchModel = item
    }
    
}

extension NCBRegisterCreditCardViewController: NCBRegisterCreditCardPresenterDelegate {
    
    func getCardProductsCompleted(_ products: [NCBGetListCardProductVisaModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Yêu cầu đăng ký mở thẻ tín dụng của Khách hàng sẽ được NCB tiếp nhận và liên hệ lại trong thời gian sớm nhất để hoàn tất thủ tục.")
        
        self.products = products ?? []
    }
    
    func registerCardVisaCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        let vc = NCBRegisterForLoanSuccessViewController()
        vc.isRegisterCardVisa = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
