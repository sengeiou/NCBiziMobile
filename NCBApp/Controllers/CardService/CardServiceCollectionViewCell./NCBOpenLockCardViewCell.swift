//
//  NCBOpenLockCardViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 7/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

protocol NCBOpenLockCardViewCellDelegate {
    func callAction(data:NCBCardModel)
}

class NCBOpenLockCardViewCell: UITableViewCell {
    
    var delegate: NCBOpenLockCardViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var cardCodeLbl: UILabel! {
        didSet {
            cardCodeLbl.font = boldFont(size: 14.0)
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
    @IBOutlet weak var validfromTitleLbl: UILabel! {
        didSet {
            validfromTitleLbl.font = semiboldFont(size: 10.0)
            validfromTitleLbl.textColor = UIColor.black
            validfromTitleLbl.text = "VALID FROM"
            //validfromTitleLbl.textColor = UIColor(hexString: "A97E2C")
            validfromTitleLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var validDateTitleLbl: UILabel! {
        didSet {
            validDateTitleLbl.font = semiboldFont(size: 10.0)
            validDateTitleLbl.textColor = UIColor.white
            validDateTitleLbl.text = "VALID THRU"
            //validDateTitleLbl.textColor = UIColor(hexString: "A97E2C")
            validDateTitleLbl.textColor = UIColor.white
            
        }
    }
    @IBOutlet weak var   userCardNameLbl: UILabel! {
        didSet {
            userCardNameLbl.font = semiboldFont(size: 12.0)
            userCardNameLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var  cardImageView: UIImageView! {
        didSet {
            cardImageView.layer.borderColor = UIColor.clear.cgColor
            cardImageView.layer.masksToBounds = true
            cardImageView.layer.shadowColor = UIColor.gray.cgColor
            cardImageView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            cardImageView.layer.shadowRadius = 2.0
            cardImageView.layer.shadowOpacity = 1.0
        }
    }
    
    @IBOutlet weak var actionBtn: UIButton! {
        didSet {
            actionBtn.titleLabel?.font = semiboldFont(size: 12)
            actionBtn.cornerRadius = 17.0
            actionBtn.setTitleColor(UIColor.white, for: .normal)
            actionBtn.layer.masksToBounds = false
            actionBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            actionBtn.layer.shadowOpacity = 1.0
            actionBtn.layer.shadowRadius = 1.0
            actionBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
    
        }
    }
    @IBOutlet weak var cardView: UIView! {
        didSet {

             cardView.layer.cornerRadius = 10
             cardView.layer.borderWidth = 1.0
            
    
        }
    }
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            lineView.backgroundColor = UIColor(hexString: "02A9E9")
            
        }
    }
     var typeActive = CardServiceActiveType.open
     var data:NCBCardModel!
    
    // MARK: - Actions
    
    @IBAction func action(_ sender: Any) {
        delegate?.callAction(data: data)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
       
    }
    
    func setupData(_ item:NCBCardModel) {
        data = item
        let cardCodeConvert = item.getCardNo()
        cardCodeLbl.text = cardCodeConvert
        validfromLbl!.text = converDate(str: data.ctrDate!)
        validDateLbl!.text = converDate(str: data.lstDate!)
        userCardNameLbl!.text = item.cardname
        cardImageView.image = UIImage(named: "ic_cardService_default.pdf")

        let activeType = item.getActiveType()
        switch activeType {
        case .open:
            actionBtn.setTitle("Mở thẻ", for: .normal)
            actionBtn.backgroundColor = UIColor(hexString:"0083DC")
            break
        case .lock:
            actionBtn.setTitle("Khoá thẻ", for: .normal)
            actionBtn.backgroundColor = UIColor(hexString:"0083DC")
            break
        case .activate:
            actionBtn.setTitle("Kích hoạt", for: .normal)
             actionBtn.backgroundColor = UIColor(hexString:"9EBBD4")
            break
        default:
            break
        }
        
    }
    
    func setupCardReissueData(_ item:NCBCardModel) {
        data = item
        let cardCodeConvert = item.getCardNo()
        cardCodeLbl.text = cardCodeConvert
        validfromLbl!.text = converDate(str: data.ctrDate!)
        validDateLbl!.text = converDate(str: data.lstDate!)
        userCardNameLbl!.text = item.cardname
        cardImageView.image = UIImage(named: "ic_cardService_default.pdf")
        actionBtn.setTitle("Phát hành lại", for: .normal)
        actionBtn.backgroundColor = UIColor(hexString:"0083DC")
    }
    
    func setupResupplyPINData(_ item:NCBCardModel) {
        data = item
        let cardCodeConvert = item.getCardNo()
        cardCodeLbl.text = cardCodeConvert
        validfromLbl!.text = converDate(str: data.ctrDate!)
        validDateLbl!.text = converDate(str: data.lstDate!)
        userCardNameLbl!.text = item.cardname
        cardImageView.image = UIImage(named: "ic_cardService_default.pdf")
        actionBtn.setTitle("Cấp lại mã PIN", for: .normal)
        actionBtn.backgroundColor = UIColor(hexString:"0083DC")
    }
    
    
    func converDate(str:String) ->String  {
        let date = yyyyMMdd.date(from: str)
        if let date = date {
            return MMyy.string(from: date)
        }
        return ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
