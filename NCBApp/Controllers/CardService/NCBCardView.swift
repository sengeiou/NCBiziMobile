//
//  NCBCardView.swift
//  NCBApp
//
//  Created by ADMIN on 7/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBCardView: UIView {

    // MARK: - Outlets
    
    @IBOutlet weak var cardCodeLbl: UILabel! {
        didSet {
            cardCodeLbl.font = boldFont(size: 18.0)
            cardCodeLbl.textColor = UIColor.white
            
        }
    }
    @IBOutlet weak var validfromLbl: UILabel! {
        didSet {
            validfromLbl.font = semiboldFont(size: 10.0)
            validfromLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var validDateLbl: UILabel! {
        didSet {
            validDateLbl.font = semiboldFont(size: 10.0)
            validDateLbl.textColor = UIColor.white
        }
    }
    @IBOutlet weak var   userCardNameLbl: UILabel! {
        didSet {
            userCardNameLbl.font = semiboldFont(size: 14.0)
            userCardNameLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var  cardImageView: UIImageView! {
        didSet {
         
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(_ item:NCBCardModel) {
        
        cardCodeLbl.text = item.cardno
        validfromLbl!.text = item.ctrDate
        validDateLbl!.text = item.lstDate
        userCardNameLbl!.text = item.cardname
        cardImageView.image = UIImage(named: "ic_cardService_default.pdf")
        //cardImageView.image = UIImage(named: item.parCardProduct!.fileName!)
    }

}

