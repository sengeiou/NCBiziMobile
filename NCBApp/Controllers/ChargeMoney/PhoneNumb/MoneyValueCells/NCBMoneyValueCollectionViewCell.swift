//
//  NCBMoneyValueCollectionViewCell.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBMoneyValueCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bgImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        valueLbl.font = semiboldFont(size: 14)
        valueLbl.textColor = ColorName.blurNormalText.color
        
        bgImg.isHidden = true
        
        shadowView.clipsToBounds = true
        shadowView.layer.cornerRadius = 6
        shadowView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.black, opacity: 0.13, radius: 4)
    }

    func setDataForItem(_ item: NCBSendSavingItemModel, isSelected: Bool) {
        valueLbl.text = Double(item.value ?? "0.0")?.formattedWithDotSeparator
        
        if isSelected {
            valueLbl.textColor = UIColor.white
        } else {
            valueLbl.textColor = ColorName.blurNormalText.color
        }
        bgImg.isHidden = !isSelected
    }
}
