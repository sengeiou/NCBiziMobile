//
//  NCBOptionTransferViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBOptionTransferViewController: NCBBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBOptionTransferViewController {
    
    override func setupView() {
        super.setupView()
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = "Chọn loại chuyển khoản"
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
}
