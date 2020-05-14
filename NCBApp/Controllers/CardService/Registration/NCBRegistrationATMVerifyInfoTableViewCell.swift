//
//  NCBRegistrationATMVerifyInfoTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 7/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBRegistrationATMVerifyInfoTableViewCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var locationLbl: UILabel! {
        didSet {
            locationLbl.font =  regularFont(size: 12.0)
            locationLbl.textColor = UIColor.black
        }
    }
    @IBOutlet weak var peeLbl: UILabel! {
        didSet {
            peeLbl.font =  regularFont(size: 12.0)
            peeLbl.textColor = UIColor.black
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
