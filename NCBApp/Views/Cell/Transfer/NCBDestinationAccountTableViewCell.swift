//
//  NCBDestinationAccountTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 4/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import DropDown

class NCBDestinationAccountTableViewCell: DropDownCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbAccountName: UILabel!
    @IBOutlet weak var lbAccountNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbAccountName.font = regularFont(size: 15)
        lbAccountNumber.font = regularFont(size: 15)
    }
    
}
