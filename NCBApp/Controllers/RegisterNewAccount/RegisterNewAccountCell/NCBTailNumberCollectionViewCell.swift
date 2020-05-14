//
//  NCBTailNumberCollectionViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBTailNumberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = semiboldFont(size: 23.0)
            titleLbl.textColor = UIColor.black
            titleLbl.layer.cornerRadius = 22
            titleLbl.layer.masksToBounds = true
            titleLbl.layer.borderWidth = 2
            titleLbl.layer.borderColor = UIColor(hexString:"9EBBD4").cgColor
        }
    }
    
    func setBackgroundSelect() {
        titleLbl.backgroundColor = UIColor(hexString: ColorName.amountBlueText.rawValue)
        titleLbl.textColor = UIColor.white
    }
    
    func setBackgroundNormal() {
        titleLbl.backgroundColor = UIColor.white
        titleLbl.textColor = UIColor.black
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

}
