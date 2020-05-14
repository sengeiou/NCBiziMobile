//
//  NCBSavingAccountSuccessfulFooterView.swift
//  NCBApp
//
//  Created by ADMIN on 8/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBSavingAccountSuccessfulFooterView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var noticeLbl: UILabel! {
        didSet {
            noticeLbl.font = italicFont(size: 12)
            noticeLbl.textColor = UIColor(hexString:"0083DC")
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
