//
//  NCBRegisterForLoanViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/27/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBRegisterForLoanViewController: NCBBaseViewController {
    
    //MARK : Outlets
    
    @IBOutlet weak var tfName: NewNCBCommonTextField!
    @IBOutlet weak var tfCMT: NewNCBCommonTextField!
    @IBOutlet weak var tfPhone: NewNCBCommonTextField!
    @IBOutlet weak var tfBranch: NewNCBCommonTextField!
    @IBOutlet weak var tfPurpose: NewNCBCommonTextField!
    @IBOutlet weak var lbForm: UILabel!
    @IBOutlet weak var containerOptionView: UIView!
    @IBOutlet weak var tfBank: NewNCBCommonTextField!
    @IBOutlet weak var tfIncome: NCBIncomeTextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    fileprivate var p: NCBRegisterForLoanPresenter?
    fileprivate var customerPresenter: NCBCustomerSupportPresenter?
    fileprivate var refreshTokenPresenter: NCBOTPAuthenticationPresenter?
    fileprivate var purposes = [NCBLoanPurposeModel]()
    fileprivate var payForms = [NCBLoanPayFormModel]()
    fileprivate var payFormButtons = [NCBRadioButton]()
    fileprivate var branchModel: NCBBranchModel?
    fileprivate var indexPurpose = 0
    fileprivate var indexPayForm = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBRegisterForLoanViewController {
    
    override func setupView() {
        super.setupView()
        
        hiddenBankView(true)
        
        if let user = NCBShareManager.shared.getUser() {
            customerPresenter = NCBCustomerSupportPresenter()
            customerPresenter?.delegate = self
            
            let params: [String : Any] = [
                "username": user.username ?? "",
                "cifno": user.cif ?? 0,
            ]
            customerPresenter?.getCustomerInfomation(params: params)
        }
        
        lbForm.font = regularFont(size: 12)
        lbForm.textColor = ColorName.holderText.color
        
        tfBranch.addRightArrow()
        tfPurpose.addRightArrow(true)
        
        tfPhone.keyboardType = .numberPad
        
        tfCMT.delegate = self
        tfPurpose.delegate = self
        tfBranch.delegate = self
        
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        
        p = NCBRegisterForLoanPresenter()
        p?.delegate = self
        
        refreshTokenPresenter = NCBOTPAuthenticationPresenter()
        refreshTokenPresenter?.delegate = self
        
        SVProgressHUD.show()
        refreshTokenPresenter?.refreshToken()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Đăng ký vay")
        
        tfName.placeholder = "Họ và tên"
        tfCMT.placeholder = "Số CMT/Hộ chiếu/CCCD"
        tfPhone.placeholder = "Số điện thoại"
        tfBranch.placeholder = "Chọn chi nhánh/PGD đăng ký vay"
        tfPurpose.placeholder = "Mục đích vay vốn"
        lbForm.text = "Hình thức trả lương"
        tfBank.placeholder = "Tại ngân hàng"
        tfIncome.placeholder = "Thu nhập bình quân tháng"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    @objc fileprivate func changeOption(_ sender: UIButton) {
        let tag = sender.tag
        hiddenBankView(tag == 0)
        indexPayForm = tag
        for button in payFormButtons {
            button.isSelected = (button.tag == tag)
        }
    }
    
    @objc fileprivate func continueAction() {
        if tfName.text!.isEmpty || tfCMT.text!.isEmpty || tfPhone.text!.isEmpty || tfBranch.text!.isEmpty || tfPurpose.text!.isEmpty || (tfBank.text!.isEmpty && !tfBank.isHidden) || tfIncome.text!.isEmpty {
            showAlert(msg: "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if !tfPhone.text!.isPhoneNumber {
            showAlert(msg: "Số điện thoại không hợp lệ")
            return
        }
        
        var params: [String: Any] = [:]
        params["customerName"] = tfName.text
        params["legalId"] = tfCMT.text
        params["phone"] = tfPhone.text
        params["compCode"] = branchModel?.depart_code
        params["compName"] = branchModel?.depart_name
        params["salaryCode"] = payForms[indexPayForm].name
        params["salaryBank"] = tfBank.text
        params["monthlyIncome"] = String(tfIncome.getAmount)
        params["reissueReason"] = purposes[indexPurpose].name
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["cif"] = NCBShareManager.shared.getUser()?.cif
        
        SVProgressHUD.show()
        p?.registerLoan(params: params)
    }
    
    fileprivate func setupPayForm() {
        let scroll = UIScrollView()
        containerOptionView.addSubview(scroll)
        
        scroll.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(-5)
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        var originX = 0
        var tag = 0
        var totalWidth: CGFloat = 0
        for form in payForms {
            let button = NCBRadioButton()
            button.tag = tag
            button.isSelected = (tag == 0)
            let title = form.name ?? ""
            let size = title.width(withConstrainedHeight: 30, font: regularFont(size: NumberConstant.smallFontSize)!) + 35
            totalWidth += size
            button.setTitle(form.name ?? "", for: .normal)
            button.frame = CGRect(x: originX, y: 0, width: Int(size), height: 30)
            originX += Int(size)
            tag += 1
            scroll.addSubview(button)
            
            payFormButtons.append(button)
            button.addTarget(self, action: #selector(changeOption(_:)), for: .touchUpInside)
        }
        
        scroll.contentSize = CGSize(width: totalWidth, height: 30)
    }
    
}

extension NCBRegisterForLoanViewController {
    
    fileprivate func showPurposeList() {
        var purposeItems = [BottomSheetStringItem]()
        for purpose in self.purposes {
            purposeItems.append(BottomSheetStringItem(title: purpose.name ?? "", isCheck: purpose.name == tfPurpose.text))
        }
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.setData("Mục đích vay vốn", items: purposeItems, isHasOptionItem: true)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 300)
        }
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
    
}

extension NCBRegisterForLoanViewController: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfPurpose {
            showPurposeList()
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

extension NCBRegisterForLoanViewController: NCBBranchListViewControllerDelegate {
    
    func didSelectBranchItem(item: NCBBranchModel) {
        tfBranch.text = item.depart_name
        branchModel = item
    }
    
}

extension NCBRegisterForLoanViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        closeBottomSheet()
        tfPurpose.text = item
        indexPurpose = index
    }
    
}

extension NCBRegisterForLoanViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func refreshTokenCompleted(error: String?) {
        p?.getPurposes()
    }
    
}

extension NCBRegisterForLoanViewController: NCBRegisterForLoanPresenterDelegate {
    
    func getPurposesCompleted(purposes: [NCBLoanPurposeModel]?, payForms: [NCBLoanPayFormModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Yêu cầu vay vốn của Khách hàng sẽ được NCB tiếp nhận và liên hệ lại trong thời gian sớm nhất để hoàn tất thủ tục.")
        
        self.purposes = purposes ?? []
        self.payForms = payForms ?? []
        setupPayForm()
    }
    
    func registerLoanCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        let vc = NCBRegisterForLoanSuccessViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NCBRegisterForLoanViewController: NCBCustomerSupportPresenterDelegate {
    
    func getCustomerInfomation(services: NCBCustomerInfomationModel?, error: String?) {
        if let _ = error {
//            showAlert(msg: _error)
            return
        }
        
        if let fullName = services?.cifname {
            tfName.text = fullName
            tfName.isEnabled = false
        }
        
        if let idno = services?.idno {
            tfCMT.text = idno
            tfCMT.isEnabled = false
        }
        
        if let mobile = NCBShareManager.shared.getUser()?.mobile {
            tfPhone.text = mobile
            tfPhone.isEnabled = false
        }
    }
    
}
