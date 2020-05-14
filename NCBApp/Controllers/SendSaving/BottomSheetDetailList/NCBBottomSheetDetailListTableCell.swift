//
//  NCBBottomSheetDetailListTableCell.swift
//  NCBApp
//
//  Created by ADMIN on 8/20/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBBottomSheetDetailListTableCell: NCBBaseTableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var widthCheckBtn: NSLayoutConstraint!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var lineView: UIView!{
        didSet{
            lineView.backgroundColor = UIColor(hexString:"EDEDED")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = semiboldFont(size: 14)
        titleLbl.textColor = ColorName.blurNormalText.color
        
        detailLbl.font = regularFont(size: 12)
        detailLbl.textColor = ColorName.holderText.color
        
        checkBtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        checkBtn.setImage(R.image.ic_radio_check(), for: .selected)
    }

    func isHiddenOption(_ isHidden: Bool) {
        if isHidden {
            checkBtn.isHidden = true
            widthCheckBtn.constant = 0
            }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
