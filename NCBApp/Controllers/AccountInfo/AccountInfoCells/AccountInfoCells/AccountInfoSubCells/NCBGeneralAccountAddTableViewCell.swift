//
//  NCBGeneralAccountAddTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 7/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBGeneralAccountAddTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel? {
        didSet {
            titleLbl!.font = semiboldFont(size: 14)
            titleLbl!.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var addlBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(title: String) {
        self.backgroundColor = UIColor(hexString: "006EC8")
        if titleLbl != nil {
            titleLbl!.text = title
        }
    }
    
    
}
