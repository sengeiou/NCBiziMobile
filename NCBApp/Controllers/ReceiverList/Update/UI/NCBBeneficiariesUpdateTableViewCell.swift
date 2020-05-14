//
//  NCBBeneficiariesUpdateTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 6/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

protocol NCBBeneficiariesUpdateTableViewCellDelegate {
    func textFieldValueChanged(_ cell: UITableViewCell, value: String)
    func textFieldDidSelect(_ cell: UITableViewCell, tag: Int)
    func textFieldDidEnd(_ cell: UITableViewCell, tag: Int)
}

class NCBBeneficiariesUpdateTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfValue: NewNCBCommonTextField!
    
    //MARK: Properties
    
    var delegate: NCBBeneficiariesUpdateTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tfValue.delegate = self
        tfValue.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupData(_ item: BeneficiaryInfoItem, isEdit: Bool, isCKNB: Bool) {
        switch item.type {
        case .acctName:
            tfValue.isEnabled = !isCKNB
            tfValue.placeholder = "Tên người nhận"
        case .memName:
            tfValue.placeholder = "Tên gợi nhớ"
        case .acctNo:
            tfValue.placeholder = "Số tài khoản"
        case .cardNo:
            tfValue.placeholder = "Số thẻ"
        case .bank:
            tfValue.placeholder = "Tại ngân hàng"
            tfValue.addRightArrow()
        case .province:
            tfValue.placeholder = "Tỉnh - Thành phố"
            tfValue.addRightArrow()
        case .branch:
            tfValue.placeholder = "Chi nhánh"
            tfValue.addRightArrow()
        }
        
        tfValue.isEnabled = isEdit
        tfValue.text = item.value
        tfValue.tag = item.type.rawValue
    }
    
    @objc func textFieldDidChange(_ tf: UITextField) {
        delegate?.textFieldValueChanged(self, value: tf.text ?? "")
    }
    
}

extension NCBBeneficiariesUpdateTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        if tag == BeneficiaryItemType.bank.rawValue || tag == BeneficiaryItemType.province.rawValue || tag == BeneficiaryItemType.branch.rawValue {
            delegate?.textFieldDidSelect(self, tag: tag)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag == BeneficiaryItemType.acctNo.rawValue {
            delegate?.textFieldDidEnd(self, tag: tag)
        }
    }
    
}
