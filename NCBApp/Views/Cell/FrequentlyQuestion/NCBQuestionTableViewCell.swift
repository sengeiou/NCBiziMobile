//
//  NCBQuestionTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 07/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBQuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var numberQuestion: UILabel!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbAnswer: UILabel!
    @IBOutlet weak var viewBound: UIView!{
        didSet{
            viewBound.layer.cornerRadius = viewBound.frame.size.width / 2
        }
    }
    @IBOutlet weak var checkbtn: UIButton!

    var index: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        numberQuestion.font = semiboldFont(size: 12)
        lbQuestion.font = semiboldFont(size: 14)
        lbAnswer.font = regularFont(size: 14)
        lbAnswer.textColor = UIColor(hexString: "414141")
        
        checkbtn.setImage(R.image.ic_accessory_arrow_bottom(), for: .normal)
        checkbtn.setImage(R.image.ic_accessory_arrow_top(), for: .selected)
        
    }
    
    func setupData(_ data: NCBQuestionAnswerModel){
        lbQuestion.text = data.question?.withoutHtmlTags
        lbAnswer.attributedText = data.isOpened ? "<span style='color:#414141;font-size:14px;font-family:SFProText-Regular'>\(data.answer ?? "")</span>".htmlToAttributedString : NSAttributedString(string: "")
        checkbtn.isSelected = data.isOpened
        if !data.isOpened {
            lbQuestion.textColor = UIColor(hexString: "242424")
        }else{
            lbQuestion.textColor = UIColor(hexString: "006EC8")
        }
    }
    
}
