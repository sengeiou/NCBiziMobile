//
//  NCBPinDetailView.swift
//  NCBApp
//
//  Created by Thuan on 10/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBPinDetailView: UIView {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbName.font = semiboldFont(size: 14)
        lbName.textColor = ColorName.blackText.color
        
        lbAddress.font = regularFont(size: 12)
        lbAddress.textColor = ColorName.blurNormalText.color
        
        lbPhone.font = regularFont(size: 12)
        lbPhone.textColor = ColorName.blurNormalText.color
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
}
