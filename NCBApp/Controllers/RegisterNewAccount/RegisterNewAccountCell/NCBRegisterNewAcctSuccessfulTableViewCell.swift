//
//  NCBRegisterNewAcctSuccessfulTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 8/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBRegisterNewAcctSuccessfulTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = regularFont(size: 14)
            titleLbl.textColor = UIColor.black
            
        }
    }
    
    @IBOutlet weak var contentLbl: UILabel! {
        didSet {
            contentLbl.font = regularFont(size: 14.0)
            contentLbl.textColor = UIColor.black
            
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
