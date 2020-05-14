//
//  NCBCardCollectionViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 7/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import Kingfisher

class NCBCardCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var cardInfoView: NCBCreditCardInfoView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupData(_ item: NCBCardModel) {
        cardInfoView.setData(item)
    }

}
