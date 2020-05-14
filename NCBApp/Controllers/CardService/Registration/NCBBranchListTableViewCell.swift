//
//  NCBBranchListTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 7/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBBranchListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var branchNameLbl: UILabel! {
        didSet {
            branchNameLbl.font =  semiboldFont(size: 14.0)
            branchNameLbl.textColor = UIColor.black
            
        }
    }
    
    @IBOutlet weak var adressLbl: UILabel! {
        didSet {
            adressLbl.font =  regularFont(size: 12)
            adressLbl.textColor = UIColor(hexString: ColorName.holderText.rawValue)
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
