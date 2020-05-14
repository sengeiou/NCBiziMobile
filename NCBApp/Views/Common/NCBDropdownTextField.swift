//
//  NCBDropdownTextField.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBDropdownTextFieldDelegate{
    func didSelectTerm(with text: String?, of textField: NCBDropdownTextField?)
}

class NCBDropdownTextField: NCBCommonTextField{
    
    var title: String = ""
    var listSelect: [String]?
    var dropdownTxtFDelegate: NCBDropdownTextFieldDelegate?
    
    override func initView() {
        super.initView()
        
        placeholder = "Vui lòng chọn"
        addArrowIcon(false)
        self.delegate = self
    }
    
    func setupDropdown() {
        ActionSheetStringPicker.show(withTitle: title, rows: listSelect, initialSelection: 0, doneBlock: { [weak self] (picker, indexes, values) in
            if self?.listSelect?.count ?? 0 <= 0 {
                return
            }
            self?.text = self?.listSelect?[indexes]
            self?.dropdownTxtFDelegate?.didSelectTerm(with: self?.text, of: self)
            }, cancel: { ActionSheetStringPicker in return }, origin: self)
    }
    
}
extension NCBDropdownTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        superview?.superview?.superview?.endEditing(true)
        setupDropdown()
        return false
    }
    
}
