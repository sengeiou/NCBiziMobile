//
//  NCBSourceAccountView.swift
//  NCBApp
//
//  Created by Thuan on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

protocol NCBSourceAccountViewDelegate {
    func sourceDidSelect()
}

class NCBSourceAccountView: UIView {
    
    @IBOutlet weak var lbSourceAccount: UILabel!
    @IBOutlet weak var lbSourceAccountValue: UILabel!
    @IBOutlet weak var lbAccountName: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var acessoryView: UIImageView!
    
    var delegate: NCBSourceAccountViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbSourceAccount.text = "Tài khoản nguồn"
        lbSourceAccount.font = regularFont(size: 12)
        lbSourceAccount.textColor = ColorName.holderText.color
        
        lbSourceAccountValue.font = semiboldFont(size: 14)
        lbSourceAccountValue.textColor = UIColor.black
        
        lbAccountName.font = regularFont(size: 12)
        lbAccountName.textColor = ColorName.holderText.color
        
        lbBalance.font = regularFont(size: 12)
        lbBalance.textColor = ColorName.holderText.color
        
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectSource))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func didSelectSource() {
        delegate?.sourceDidSelect()
    }
    func setLbSourceAccount(_ value: String?){
        lbSourceAccount.text = value
    }
    
    func setSourceAccount(_ value: String?) {
        lbSourceAccountValue.text = value
    }
    
    func getSourceAccount() -> String {
        return lbSourceAccountValue.text ?? ""
    }
    
    func setSourceName(_ value: String?) {
        lbAccountName.text = value
    }
    
    func setSourceBalance(_ value: Double?) {
        lbBalance.currencyLabel(with: value ?? 0.0)
    }

}


