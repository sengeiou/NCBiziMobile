//
//  NCBSavedListSlideCollectionViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBSavedListSlideCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbName.font = semiboldFont(size: 12)
        lbName.textColor = UIColor.white
        
        lbCode.font = regularFont(size: 12)
        lbCode.textColor = UIColor.white
    }

}
