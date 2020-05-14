//
//  NCBBottomSheetListTableCell.swift
//  NCBApp
//
//  Created by Thuan on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBBottomSheetListTableCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var widthCheckBtn: NSLayoutConstraint!
    @IBOutlet weak var checkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTitle.font = semiboldFont(size: 12)
        lbTitle.textColor = ColorName.blurNormalText.color
        
        checkBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        checkBtn.setImage(R.image.ic_radio_check(), for: .selected)
        checkBtn.isUserInteractionEnabled = false
    }
    
    func isHiddenOption(_ isHidden: Bool) {
        if isHidden {
            checkBtn.isHidden = true
            widthCheckBtn.constant = 0
        }
    }
    
}
