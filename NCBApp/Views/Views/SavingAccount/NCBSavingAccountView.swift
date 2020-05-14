//
//  NCBSavingAccountView.swift
//  NCBApp
//
//  Created by Van Dong on 21/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

protocol NCBSavingAccountViewDelegate{
    func savingAccountDidSelect()
}

class NCBSavingAccountView: UIView {

    @IBOutlet weak var tittleSavingAccount: UILabel!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var termDest: UILabel!
    
    var delegate: NCBSavingAccountViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tittleSavingAccount.font = regularFont(size: 12)
        tittleSavingAccount.textColor = ColorName.holderText.color
        
        account.text = "Chọn tài khoản tiết kiệm"
        account.font = semiboldFont(size: 14)
        account.textColor = ColorName.holderText.color
        
        balance.font = regularFont(size: 12)
        balance.textColor = ColorName.holderText.color
        
        dueDate.font = regularFont(size: 12)
        dueDate.textColor = ColorName.holderText.color
        
        termDest.font = regularFont(size: 12)
        termDest.textColor = ColorName.holderText.color
        
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectSaving))
        self.addGestureRecognizer(gesture)
    }
    @objc func didSelectSaving() {
        delegate?.savingAccountDidSelect()
    }
    
    func setTittleSavingAccount(_ value: String?){
        tittleSavingAccount.text = value
    }
    
    func setAccount(_ value: String?){
        account.text = value
    }
    func setBalance(_ value: String?) {
        balance.text = value
    }

    
    func setDueDate(_ value: String?){
        dueDate.text = value
    }
    
    func setTermDest(_ value: String?){
        termDest.text = value
    }

}
