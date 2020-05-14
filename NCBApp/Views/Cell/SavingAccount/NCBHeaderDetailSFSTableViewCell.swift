//
//  NCBHeaderDetailSFSTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 27/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBHeaderDetailSFSTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = regularFont(size: 12)
            titleLbl.textColor = UIColor(hexString: "414141")
        }
    }
    
    @IBOutlet weak var detailLb1: UILabel! {
        didSet {
            detailLb1.font = semiboldFont(size: 14)
            detailLb1.textColor = UIColor(hexString: "000000")
        }
    }
    
    @IBOutlet weak var detailLb2: UILabel! {
        didSet {
            detailLb2.font = semiboldFont(size: 12)
            detailLb2.textColor = UIColor(hexString: "414141")
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
