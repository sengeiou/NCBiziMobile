//
//  NCBVerifySavingAccountTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 8/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBVerifySavingAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstLineView: UIView! {
        didSet {
            
            firstLineView.backgroundColor = UIColor(hexString: "EDEDED")
            
        }
    }
    @IBOutlet weak var termInterestLbl: UILabel! {
        didSet {
            termInterestLbl.font = regularFont(size: 12)
            termInterestLbl.textColor = UIColor.black
            
        }
    }
    @IBOutlet weak var matureFormLbl: UILabel! {
        didSet {
            matureFormLbl.font = regularFont(size: 12.0)
            matureFormLbl.textColor = UIColor.black
            
        }
    }
    @IBOutlet weak var lineView: UIView! {
        didSet {
         
            lineView.backgroundColor = UIColor(hexString: "EDEDED")
            
        }
    }
    @IBOutlet weak var destinationAccountsTitleLbl: UILabel! {
        didSet {
            destinationAccountsTitleLbl.font = regularFont(size: 12.0)
            destinationAccountsTitleLbl.textColor = UIColor.black
            
        }
    }
    @IBOutlet weak var destinationAccountsLbl: UILabel! {
        didSet {
            destinationAccountsLbl.font = semiboldFont(size: 14.0)
            destinationAccountsLbl.textColor = UIColor.black
            
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
