//
//  NCBPaymentAccountInfoHeader.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBPaymentAccountInfoHeader: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var headerIconImg: UIImageView!
    
    @IBOutlet weak var headerTitleLbl: UILabel! {
        didSet {
            headerTitleLbl.text = "Tài khoản thanh toán"
            headerTitleLbl.font = boldFont(size: 15.0)
        }
    }

    override func awakeFromNib() {
        
    }

}
