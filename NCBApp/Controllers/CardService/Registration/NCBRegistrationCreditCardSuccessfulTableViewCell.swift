//
//  NCBRegistrationCreditCardSuccessfulTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBRegistrationCreditCardSuccessfulTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel! {
        didSet {
            contentLbl.font =  regularFont(size: 12.0)
            contentLbl.textColor = UIColor.black
            contentLbl.text = "NCB đã tiếp nhận yêu cầu phát hành thẻ NCB Visa của quý khách. NCB sẽ liên hệ Quý khách trong thời gian sớm nhất để hoàn thành thủ tục.\n"+"\n"+" Cảm ơn Quý khách đã sử dụng dịch vụ NCB"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
