//
//  NCBRegisterNewAccountTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBRegisterNewAccountTableViewCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = semiboldFont(size: 14.0)
            titleLbl.textColor = UIColor.white
            
        }
    }
    
    @IBOutlet weak var addImgView: UIImageView! {
        didSet {
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor(hexString: ColorName.amountBlueText.rawValue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
