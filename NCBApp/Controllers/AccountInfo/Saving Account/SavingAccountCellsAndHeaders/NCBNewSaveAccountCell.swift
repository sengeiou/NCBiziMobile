//
//  NCBNewSaveAccountCell.swift
//  NCBApp
//
//  Created by Tuan Pham Hai  on 8/28/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBNewSaveAccountCell: UITableViewCell {
    
    @IBOutlet weak var bgCornersView: UIView!
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgCornersView.clipsToBounds = true
        bgCornersView.layer.cornerRadius = 10
        bgCornersView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor.black, opacity: 0.13, radius: 4)
    }
    
    var model: NCBGeneralSavingAccountInfoModel? {
        didSet {
            setDataForSavingAccountSection()
        }
    }
    
    func setDataForSavingAccountSection() {
        accountNoLabel.text = model?.account
        balanceLabel.text = model?.getBalanceDisplay()
        dateLabel.text = "Ngày đáo hạn: \(model?.dueDate ?? "")"
        durationLabel.text = model?.termDest
    }
}
