//
//  NCBListAccountRegisterSMSView.swift
//  NCBApp
//
//  Created by Van Dong on 15/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
@objc protocol NCBListAccountRegisterSMSViewDelegate {
    @objc optional func accountDidSelect()
}

class NCBListAccountRegisterSMSView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var acctNo: UILabel!
    @IBOutlet weak var acName: UILabel!
    @IBOutlet weak var curBal: UILabel!
    @IBOutlet var curCode: UILabel!
    
    var delegate: NCBListAccountRegisterSMSViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.text = "Tài khoản đăng ký nhận SMS biến động số dư"
        title.font = regularFont(size: 12)
        title.textColor = ColorName.holderText.color
        
        acctNo.font = semiboldFont(size: 14)
        acctNo.textColor = UIColor.black
        
        acName.font = regularFont(size: 12)
        acName.textColor = ColorName.holderText.color
        
        curBal.font = regularFont(size: 12)
        curBal.textColor = ColorName.holderText.color
        
        curCode.font = regularFont(size: 12)
        curCode.textColor = ColorName.holderText.color
        
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectAccount))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func didSelectAccount() {
        delegate?.accountDidSelect!()
    }
    func setTitle(_ value: String?){
        title.text = value
    }
    
    func setAcctNo(_ value: String?) {
        acctNo.text = value
    }
    
    func getAcctNo() -> String {
        return acctNo.text ?? ""
    }
    
    func setAcName(_ value: String?) {
        acName.text = value
    }
    
    func setCurBal(_ value: Double?) {
        curBal.currencyLabel(with: value ?? 0.0)
    }
    
    func setCurCode(_ value: String?){
        curCode.text = value
    }
}
