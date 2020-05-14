//
//  NCBDebtAccountTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 31/07/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBDebtAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var lineView: UIView!{
        didSet{
            lineView.backgroundColor = UIColor(hexString: "049BD4")
        }
    }
    @IBOutlet weak var titleLb1: UILabel!{
        didSet{
            titleLb1.font = regularFont(size: 12)
            titleLb1.textColor = UIColor.white
        }
    }
    @IBOutlet weak var titleLb2: UILabel! {
        didSet{
            titleLb2.font = regularFont(size: 12)
            titleLb2.textColor = UIColor.white
        }
    }
    @IBOutlet weak var detailLb1: UILabel! {
        didSet{
            detailLb1.font = semiboldFont(size: 14)
            detailLb1.textColor = UIColor.white
            detailLb1.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var detailLb2: UILabel! {
        didSet{
            detailLb2.font = semiboldFont(size: 14)
            detailLb2.textColor = UIColor.white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
