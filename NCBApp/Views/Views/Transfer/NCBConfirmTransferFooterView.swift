//
//  NCBConfirmTransferFooterView.swift
//  NCBApp
//
//  Created by Thuan on 5/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

typealias NCBConfirmTransferFooterViewConfirm = () -> (Void)

class NCBConfirmTransferFooterView: UIView {
    
    var confirm: NCBConfirmTransferFooterViewConfirm!
    var button: NCBCommonButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    fileprivate func initView() {
        button = NCBCommonButton()
        button!.setTitle("XÁC NHẬN", for: .normal)
        addSubview(button!)
        
        button!.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        button!.addTarget(self, action: #selector(doConfirm), for: .touchUpInside)
    }
    
    @objc func doConfirm() {
        confirm()
    }
    
}
