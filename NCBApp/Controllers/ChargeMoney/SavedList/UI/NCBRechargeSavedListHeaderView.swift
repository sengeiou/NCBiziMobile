//
//  NCBRechargeSavedListHeaderView.swift
//  NCBApp
//
//  Created by Thuan on 8/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRechargeSavedListHeaderView: UIView {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var addNewBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = UIColor(hexString: "959595")
        
        addNewBtn.titleLabel?.font = semiboldFont(size: 12)
        addNewBtn.setTitleColor(ColorName.blurNormalText.color, for: .normal)
        addNewBtn.setTitle("Thêm mới", for: .normal)
    }
    
}
