//
//  NCBMailboxTableViewCell.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwipeCellKit


@objc protocol NCBMailboxTableViewCellDelegate {
    @objc optional func deleteAction(item:NCBMailboxModel,indx:Int)
}


class NCBMailboxTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel! {
        didSet {
            timeLbl.font = regularFont(size: 12)
            timeLbl.textColor = UIColor(hexString: ColorName.holderText.rawValue)
        }
    }
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = semiboldFont(size: 14)
            titleLbl.textColor = UIColor.black
        }
    }
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            lineView.backgroundColor = UIColor(hexString:"D9D9D9")
        }
    }
    
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var mailData:NCBMailboxModel!
    var customDelegate:NCBMailboxTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:NCBMailboxModel)  {
        mailData = data
        self.titleLbl.text = data.contentTitle
        self.timeLbl.text = data.getCreatedDate()
        if mailData.isRead(){
            titleLbl.textColor = UIColor.black
        } else {
            titleLbl.textColor = UIColor(hexString:"1A4C98")
        }
        delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension NCBMailboxTableViewCell: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.customDelegate?.deleteAction?(item: self.mailData,indx: indexPath.row)
        }
        deleteAction.hidesWhenSelected = true
        deleteAction.backgroundColor = UIColor.white
        deleteAction.image = R.image.ic_action_delete()

        return [deleteAction]
    }
    
}
