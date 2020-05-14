//
//  NCBDetailSavingFinalSettlementTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 27/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBDetailSavingFinalSettlementTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl1: UILabel! {
        didSet {
            titleLbl1.font = regularFont(size: 12)
            titleLbl1.textColor = UIColor(hexString: "414141")
        }
    }
    
    @IBOutlet weak var detailLbl1: UILabel! {
        didSet {
            detailLbl1.font = semiboldFont(size: 12)
            detailLbl1.textColor = UIColor(hexString: "414141")
        }
    }
    
    @IBOutlet weak var titleLbl2: UILabel! {
        didSet {
            titleLbl2.font = semiboldFont(size: 14)
            titleLbl2.textColor = UIColor(hexString: "000000")
        }
    }
    
    @IBOutlet weak var detailLbl2: UILabel! {
        didSet {
            detailLbl2.font = semiboldFont(size: 12)
            detailLbl2.textColor = UIColor(hexString: "414141")
        }
    }
    
    var infos: DetailFinalSettlementInfo? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func setupData() {
        if let info = infos{
            titleLbl1.text = info.title1
            detailLbl1.text = info.value1
            titleLbl2.text = info.title2
            detailLbl2.text = info.value2
        }
    }
    
}
