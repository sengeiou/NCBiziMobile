//
//  NCBRegisterAutoDebtDeductionViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

fileprivate let minimumDueStr = "Thanh toán số tiền tối thiểu"
fileprivate let totalBalanceStr = "Toàn bộ dư nợ"

class NCBRegisterAutoDebtDeductionViewController: NCBBaseSourceAccountViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfLevel: NewNCBCommonTextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    var card: NCBCardModel?
    var type: VerifyAutoDebtDeductionType = .register
    fileprivate let items = [minimumDueStr, totalBalanceStr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBRegisterAutoDebtDeductionViewController {
    
    override func setupView() {
        super.setupView()
        
        commonCreditCardInfoView?.setData(card)
        
        tfLevel.text = items[0]
        tfLevel.addRightArrow(true)
        tfLevel.delegate = self
        
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        switch type {
        case .register:
            setHeaderTitle("Đăng ký trích nợ tự động")
        case .unregister:
            setHeaderTitle("Huỷ dịch vụ trích nợ tự động")
        case .update:
            setHeaderTitle("Thay đổi thông tin trích nợ")
        }
        
        tfLevel.placeholder = "Mức trích nợ tự động"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    @objc func continueAction() {
        let level = tfLevel.text ?? ""
        if card?.getRepayModeType() == RepayModeType.MinimumDue && level == minimumDueStr {
            showAlert(msg: ErrorConstant.crdCardChangeInfoDebtDeduction.getMessage() ?? "Vui lòng thay đổi thông tin trích nợ")
            return
        }
        
        if card?.getRepayModeType() == RepayModeType.TotalBalance && level == totalBalanceStr {
            showAlert(msg: ErrorConstant.crdCardChangeInfoDebtDeduction.getMessage() ?? "Vui lòng thay đổi thông tin trích nợ")
            return
        }
        
        let vc = NCBVerifyRegisterAutoDebtDeductionViewController()
        vc.sourceAccount = sourceAccount
        vc.card = card
        vc.level = level
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NCBRegisterAutoDebtDeductionViewController {
    
    fileprivate func showLevel() {
        var models = [BottomSheetStringItem]()
        for item in items {
            models.append(BottomSheetStringItem(title: item, isCheck: item == tfLevel.text!))
        }
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Chọn mức trích nợ tự động", items: models, isHasOptionItem: true)
            showBottomSheet(controller: vc, size: 250)
        }
    }
    
}

extension NCBRegisterAutoDebtDeductionViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        closeBottomSheet()
        tfLevel.text = item
    }
    
}

extension NCBRegisterAutoDebtDeductionViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showLevel()
        return false
    }
    
}
