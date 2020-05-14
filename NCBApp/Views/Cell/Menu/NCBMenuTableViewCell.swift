//
//  NCBMenuTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 4/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBMenuTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTitle.font = regularFont(size: 14)
        lbTitle.textColor = ColorName.blackText.color
    }
    
}
