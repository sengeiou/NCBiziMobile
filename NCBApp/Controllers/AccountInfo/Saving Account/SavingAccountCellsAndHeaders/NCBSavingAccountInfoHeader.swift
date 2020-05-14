//
//  NCBSavingAccountInfoHeader.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBSavingAccountInfoHeader: UIView {
    
    @IBOutlet weak var savingAccountNameLbl: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var topLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        expandBtn.isUserInteractionEnabled = false
        expandBtn.setImage(R.image.collapseClose(), for: .selected)
        expandBtn.setImage(R.image.collapseOpen(), for: .normal)
    }

}
