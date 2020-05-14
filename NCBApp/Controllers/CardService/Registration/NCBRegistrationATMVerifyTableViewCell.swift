//
//  NCBRegistrationATMVerifyTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 7/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBRegistrationATMVerifyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountTitleLbl: UILabel! {
        didSet {
            accountTitleLbl.font =  regularFont(size: 12.0)
            accountTitleLbl.textColor = UIColor.black
        }
    }
    @IBOutlet weak var accountLbl: UILabel! {
        didSet {
            accountLbl.font =  semiboldFont(size: 14.0)
            accountLbl.textColor = UIColor.black
        }
    }
    @IBOutlet weak var accountLineView: UIView! {
        didSet {
            accountLineView.backgroundColor = UIColor(hexString: "D8D8D8")
        }
    }
    @IBOutlet weak var productTitleLbl: UILabel! {
        didSet {
            productTitleLbl.font =  regularFont(size: 12.0)
            productTitleLbl.textColor = UIColor(hexString:ColorName.holderText.rawValue)
        }
    }
    @IBOutlet weak var productLbl: UILabel! {
        didSet {
            productLbl.font =  semiboldFont(size: 14.0)
            productLbl.textColor = UIColor.black
        }
    }
    @IBOutlet weak var classLbl: UILabel! {
        didSet {
            classLbl.font =  regularFont(size: 12.0)
            classLbl.textColor = UIColor.black
        }
    }
    @IBOutlet weak var productLineView: UIView! {
        didSet {
            productLineView.backgroundColor = UIColor(hexString: "D8D8D8")
        }
    }
    @IBOutlet weak var locationLbl: UILabel! {
        didSet {
            locationLbl.font =  regularFont(size: 12.0)
            locationLbl.textColor = UIColor.black
        }
    }
    @IBOutlet weak var peeLbl: UILabel! {
        didSet {
            peeLbl.font =  semiboldFont(size: 12.0)
            peeLbl.textColor = UIColor.black
        }
    }
    @IBOutlet weak var connectWireImgView: UIImageView! {
        didSet {
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
