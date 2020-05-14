//
//  NCBServiceCollectionViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbName.font = regularFont(size: 12)
        lbName.textColor = ColorName.blurNormalText.color
    }

}
