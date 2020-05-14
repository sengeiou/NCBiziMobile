//
//  NCBPaymentAccountHistoryDetailHeaderView.swift
//  NCBApp
//
//  Created by Thuan on 10/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBPaymentAccountHistoryDetailHeaderView: UIView {
    
    var lbAmount: UILabel!
    var lbAmountValue: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    fileprivate func setupView() {
        lbAmount = UILabel()
        lbAmount.font = regularFont(size: 12)
        lbAmount.textColor = ColorName.blurNormalText.color
        lbAmount.text = "Số tiền giao dịch"
        addSubview(lbAmount)
        
        lbAmount.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        lbAmountValue = UILabel()
        lbAmountValue.font = boldFont(size: 18)
        lbAmountValue.adjustsFontSizeToFitWidth = true
        addSubview(lbAmountValue)
        
        lbAmountValue.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lbAmount.snp.bottom).offset(5)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "EDEDED")
        addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
