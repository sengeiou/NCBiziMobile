//
//  NCBCreditCardInfoView.swift
//  NCBApp
//
//  Created by Thuan on 8/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Kingfisher

class NCBCreditCardInfoView: UIView {
    
    var lbCardNumber: UILabel!
    var lbValidFrom: UILabel!
    var lbValidFromValue: UILabel!
    var lbValidThru: UILabel!
    var lbValidThruValue: UILabel!
    var lbCardName: UILabel!
    var bgImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    fileprivate func setupView() {
        clipsToBounds = true
        layer.cornerRadius = NumberConstant.commonRadius
        backgroundColor = UIColor.clear
        
        bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.backgroundColor = UIColor(hexString: "DEDEDE")
        addSubview(bgImageView)
        
        bgImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        lbCardNumber = UILabel()
        lbCardNumber.font = boldFont(size: 18)
        lbCardNumber.textColor = UIColor.white
        addSubview(lbCardNumber)
        
        lbCardNumber.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(20)
        }
        
        lbValidFrom = UILabel()
        lbValidFrom.font = semiboldFont(size: 8)
        lbValidFrom.textColor = UIColor.white
        lbValidFrom.text = "VALID\nFROM"
        lbValidFrom.numberOfLines = 2
        addSubview(lbValidFrom)
        
        lbValidFrom.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(lbCardNumber.snp.bottom).offset(2)
        }
        
        lbValidFromValue = UILabel()
        lbValidFromValue.font = semiboldFont(size: 10)
        lbValidFromValue.textColor = UIColor.white
        addSubview(lbValidFromValue)
        
        lbValidFromValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(lbValidFrom)
            make.leading.equalTo(lbValidFrom.snp.trailing).offset(5)
        }
        
        lbValidThru = UILabel()
        lbValidThru.font = semiboldFont(size: 8)
        lbValidThru.textColor = UIColor.white
        lbValidThru.text = "VALID\nTHRU"
        lbValidThru.numberOfLines = 2
        addSubview(lbValidThru)
        
        lbValidThru.snp.makeConstraints { (make) in
            make.leading.equalTo(lbValidFromValue.snp.trailing).offset(30)
            make.centerY.equalTo(lbValidFromValue)
        }
        
        lbValidThruValue = UILabel()
        lbValidThruValue.font = semiboldFont(size: 10)
        lbValidThruValue.textColor = UIColor.white
        addSubview(lbValidThruValue)
        
        lbValidThruValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(lbValidThru)
            make.leading.equalTo(lbValidThru.snp.trailing).offset(5)
        }
        
        lbCardName = UILabel()
        lbCardName.font = semiboldFont(size: 12)
        lbCardName.textColor = UIColor.white
        addSubview(lbCardName)
        
        lbCardName.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(lbValidFrom.snp.bottom).offset(2)
        }
    }
    
    func setData(_ creditCardInfo: NCBCreditCardModel?) {
        guard let creditCardInfo = creditCardInfo else {
            return
        }
        
//        lbValidThru.isHidden = (creditCardInfo.cardtype == CreditCardType.DB.rawValue)
//        lbValidThruValue.isHidden = (creditCardInfo.cardtype == CreditCardType.DB.rawValue)
        
        lbCardNumber.text = creditCardInfo.cardno?.cardHidden
        if let strDate = creditCardInfo.ctrDate, let date = yyyyMMdd.date(from: strDate) {
            lbValidFromValue.text = MMyy.string(from: date)
        }
        if let strDate = creditCardInfo.lstDate, let date = yyyyMMdd.date(from: strDate) {
            lbValidThruValue.text = MMyy.string(from: date)
        }
        lbCardName.text = creditCardInfo.cardname?.uppercased()
        
        if let imgUrl = URL(string: creditCardInfo.parCardProduct?.linkUlr?.replacingSpace ?? "") {
            bgImageView.kf.setImage(with: imgUrl)
        }
    }
    
}
