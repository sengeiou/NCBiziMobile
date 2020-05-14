//
//  NCBRegisterNewAccMainTableViewCel.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBRegisterNewAccMainTableViewCell: NCBBaseTableViewCell {
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
    
    @IBOutlet weak var rowView: UIView! {
        didSet {
            rowView.layer.cornerRadius = 8
            rowView.layer.masksToBounds = true
            rowView.layer.masksToBounds = false
            rowView.backgroundColor = UIColor(hexString: ColorName.amountBlueText.rawValue)
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
