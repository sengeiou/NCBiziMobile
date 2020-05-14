//
//  NCBBeneficiariesCreateViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBBeneficiariesCreateViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var scrollButtonView: UIScrollView!
    @IBOutlet weak var inNCBBtn: UIButton!
    @IBOutlet weak var outNCBBtn: UIButton!
    @IBOutlet weak var cardOutNCBBtn: UIButton!
    @IBOutlet weak var tfBank: NewNCBCommonTextField!
    @IBOutlet weak var containerBankBranchView: UIView!
    @IBOutlet weak var tfProvince: NewNCBCommonTextField!
    @IBOutlet weak var tfBranch: NewNCBCommonTextField!
    @IBOutlet weak var tfAccountNo: NewNCBCommonTextField!
    @IBOutlet weak var tfAccountName: NewNCBCommonTextField!
    @IBOutlet weak var tfMemName: NewNCBCommonTextField!
    @IBOutlet weak var saveBtn: NCBCommonButton!
    
    //MARK: Properties
    
    fileprivate var bankCodeItem = BankCodeItemModel(bankCode: "", provinceCode: "", creditBranch: "")
    fileprivate var typeTransfer: String {
        if outNCBBtn.isSelected {
            return BeneficiaryType.CKCITAD.rawValue
        } else if cardOutNCBBtn.isSelected {
            return BeneficiaryType.CK247.rawValue
        }
        
        return BeneficiaryType.CKNB.rawValue
    }
    
    fileprivate var isViaAccount: Bool {
        return outNCBBtn.isSelected
    }
    
    fileprivate var isCKNB: Bool {
        return inNCBBtn.isSelected
    }
    
    fileprivate var p: NCBBeneficiariesCreatePresenter?
    fileprivate var transferPresenter: NCBTransferPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.size.height {
            case 568:
                scrollButtonView.contentSize = CGSize(width: self.view.frame.width + 20, height: scrollButtonView.frame.height)
            default:
                break
            }
        }
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if isViaAccount && tfBank.text == "" {
            showAlert(msg: "Vui lòng chọn Ngân hàng nhận")
            return
        }
        
        if bankCodeItem.bankCode == StringConstant.agribankCode {
            if tfProvince.text == "" {
                showAlert(msg: "Vui lòng chọn tỉnh thành")
                return
            }
            
            if tfBranch.text == "" {
                showAlert(msg: "Vui lòng chọn chi nhánh")
                return
            }
        }
        
        if tfAccountNo.text == "" {
            showAlert(msg: (isViaAccount || isCKNB) ? "Vui lòng nhập thông tin số tài khoản" : "Vui lòng nhập thông tin số thẻ")
            return
        }
        
        if tfAccountName.text == "" {
            showAlert(msg: "Vui lòng nhập tên người nhận")
            return
        }
        
        let params = [
            "cifno": NCBShareManager.shared.getUser()!.cif ?? "",
            "username": NCBShareManager.shared.getUser()!.username ?? "",
            "benValue": tfAccountNo.text ?? "",
            "memName": tfMemName.text ?? "",
            "benName": tfAccountName.text ?? "",
            "typeTransfer": typeTransfer,
            "benBankCode": bankCodeItem.bankCode,
            "provinceCode": bankCodeItem.provinceCode,
            "branchCode": bankCodeItem.creditBranch
            ] as [String: Any]
        
        SVProgressHUD.show()
        p?.create(params: params)
    }
    
}

extension NCBBeneficiariesCreateViewController {
    
    override func setupView() {
        super.setupView()
        
        p = NCBBeneficiariesCreatePresenter()
        p?.delegate = self
        
        transferPresenter = NCBTransferPresenter()
        transferPresenter?.delegate = self
        
        inNCBBtn.layer.cornerRadius = 18
        inNCBBtn.setTitle("Tại NCB", for: .normal)
        inNCBBtn.titleLabel?.font = regularFont(size: 12)
        inNCBBtn.setTitleColor(ColorName.blackText.color, for: .normal)
        inNCBBtn.setTitleColor(UIColor(hexString: "0083DC"), for: .selected)
        inNCBBtn.backgroundColor = UIColor(hexString: "D8EAFA")
        inNCBBtn.isSelected = true
        
        outNCBBtn.layer.cornerRadius = 18
        outNCBBtn.setTitle("Ngoài NCB", for: .normal)
        outNCBBtn.titleLabel?.font = regularFont(size: 12)
        outNCBBtn.setTitleColor(ColorName.blackText.color, for: .normal)
        outNCBBtn.setTitleColor(UIColor(hexString: "0083DC"), for: .selected)
        outNCBBtn.backgroundColor = UIColor(hexString: "EDEDED")
        
        cardOutNCBBtn.layer.cornerRadius = 18
        cardOutNCBBtn.setTitle("Đến thẻ ngoài NCB", for: .normal)
        cardOutNCBBtn.titleLabel?.font = regularFont(size: 12)
        cardOutNCBBtn.setTitleColor(ColorName.blackText.color, for: .normal)
        cardOutNCBBtn.setTitleColor(UIColor(hexString: "0083DC"), for: .selected)
        cardOutNCBBtn.backgroundColor = UIColor(hexString: "EDEDED")

        inNCBBtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        outNCBBtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        cardOutNCBBtn.addTarget(self, action: #selector(chooseOption(_:)), for: .touchUpInside)
        
        tfBank.addRightArrow()
        tfProvince.addRightArrow()
        tfBranch.addRightArrow()
        
        tfBank.delegate = self
        tfProvince.delegate = self
        tfBranch.delegate = self
        tfAccountNo.delegate = self
        
        hiddenBankView(true)
        hiddenBankBranchView(true)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Thêm mới danh sách thụ hưởng")
        
        tfBank.placeholder = "Ngân hàng nhận"
        tfProvince.placeholder = "Tỉnh - Thành phố"
        tfBranch.placeholder = "Chi nhánh"
        tfAccountNo.placeholder = "Số tài khoản"
        tfAccountName.placeholder = "Tên người nhận"
        tfMemName.placeholder = "Tên gợi nhớ"
        saveBtn.setTitle("Lưu", for: .normal)
    }
    
    @objc func chooseOption(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        if sender == outNCBBtn {
            inNCBBtn.isSelected = false
            outNCBBtn.isSelected = true
            cardOutNCBBtn.isSelected = false
            tfAccountNo.placeholder = "Số tài khoản"
        } else if sender == cardOutNCBBtn {
            inNCBBtn.isSelected = false
            outNCBBtn.isSelected = false
            cardOutNCBBtn.isSelected = true
            tfAccountNo.placeholder = "Số thẻ"
        } else if sender == inNCBBtn {
            inNCBBtn.isSelected = true
            outNCBBtn.isSelected = false
            cardOutNCBBtn.isSelected = false
            tfAccountNo.placeholder = "Số tài khoản"
        }
        
        tfBank.text = ""
        tfProvince.text = ""
        tfBranch.text = ""
        tfAccountName.isEnabled = !isCKNB
        bankCodeItem.bankCode = ""
        bankCodeItem.creditBranch = ""
        bankCodeItem.provinceCode = ""
        tfAccountNo.text = ""
        tfAccountName.text = ""
        tfMemName.text = ""
        
        hiddenBankBranchView(true)
        hiddenBankView(!outNCBBtn.isSelected)
        
        inNCBBtn.backgroundColor = inNCBBtn.isSelected ? UIColor(hexString: "D8EAFA") : UIColor(hexString: "EDEDED")
        outNCBBtn.backgroundColor = outNCBBtn.isSelected ? UIColor(hexString: "D8EAFA") : UIColor(hexString: "EDEDED")
        cardOutNCBBtn.backgroundColor = cardOutNCBBtn.isSelected ? UIColor(hexString: "D8EAFA") : UIColor(hexString: "EDEDED")
    }
    
}

extension NCBBeneficiariesCreateViewController {
    
    fileprivate func hiddenBankView(_ hidden: Bool) {
        tfBank.isHidden = hidden
        for constraint in tfBank.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField
            }
        }
        
        if hidden {
            tfBank.drawViewsForRect(tfBank.frame)
        }
    }
    
    fileprivate func hiddenBankBranchView(_ hidden: Bool) {
        containerBankBranchView.isHidden = hidden
        for constraint in containerBankBranchView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (hidden) ? 0 : NumberConstant.commonHeightTextField*2
            }
        }
    }
    
    fileprivate func showBankList(_ type: BankGetType) {
        if let vc = R.storyboard.transfer.ncbBankListViewController() {
            vc.delegate = self
            vc.getType = type
            vc.bankCodeItem = bankCodeItem
            vc.serviceType = .payment
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doCheckDestinationAccount() {
        if !isCKNB {
            return
        }
        
        if tfAccountNo.text == "" {
            tfAccountName.text = ""
            return
        }
        
        let params = [
            "username": NCBShareManager.shared.getUser()!.username ?? "",
            "account": tfAccountNo.text!
            ] as [String: Any]
        
        SVProgressHUD.show()
        transferPresenter?.checkDestinationAccount(params: params)
    }
    
}

extension NCBBeneficiariesCreateViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfAccountNo {
            doCheckDestinationAccount()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfBank {
            showBankList(.bank)
            return false
        } else if textField == tfProvince {
            showBankList(.province)
            return false
        } else if textField == tfBranch {
            if tfProvince.text == "" {
                showAlert(msg: "Hãy chọn tỉnh thành trước")
            } else {
                showBankList(.branch)
            }
            return false
        }
        
        return true
    }
    
}

extension NCBBeneficiariesCreateViewController: NCBBankListViewControllerDelegate {
    
    func didSelectBankItem(item: NCBBankModel, type: BankGetType) {
        switch type {
        case .province:
            tfProvince.text = item.shrtname
            bankCodeItem.provinceCode = item.pro_id ?? ""
        case .branch:
            tfBranch.text = item.chi_nhanh
            bankCodeItem.creditBranch = item.citad_gt ?? ""
        default:
            tfBank.text = item.bnkname
            hiddenBankBranchView(!(item.bnk_code == StringConstant.agribankCode))
            bankCodeItem.bankCode = item.bnk_code ?? ""
        }
    }
    
}

extension NCBBeneficiariesCreateViewController: NCBBeneficiariesCreatePresenterDelegate {
    
    func createBeneficiaryCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NCBBeneficiariesCreateViewController: NCBTransferPresenterDelegate {
    
    func checkDestinationAccountCompleted(destAccount: NCBDestinationAccountModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            tfAccountName.text = ""
            return
        }
        
        tfAccountName.text = destAccount?.accountName
    }
    
}
