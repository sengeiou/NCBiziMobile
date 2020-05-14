//
//  NCBBeneficiaryListTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 4/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwipeCellKit

typealias NCBBeneficiaryListTableViewCellTransfer = () -> (Void)
typealias NCBBeneficiaryListTableViewCellEdit = () -> (Void)
typealias NCBBeneficiaryListTableViewCellDelete = () -> (Void)

class NCBBeneficiaryListTableViewCell: SwipeTableViewCell, SwipeTableViewCellDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbSection: UILabel!
    @IBOutlet weak var lbAccountName: UILabel!
    @IBOutlet weak var lbAccountNumber: UILabel!
    @IBOutlet weak var lbBankName: UILabel!
    @IBOutlet weak var lbMemName: UILabel!
    
    var transfer: NCBBeneficiaryListTableViewCellTransfer!
    var edit: NCBBeneficiaryListTableViewCellEdit!
    var delete: NCBBeneficiaryListTableViewCellDelete!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbSection.font = semiboldFont(size: 11)
        lbSection.textColor = UIColor(hexString: "797979")
        
        lbAccountName.font = semiboldFont(size: NumberConstant.commonFontSize)
        lbAccountName.textColor = ColorName.blackText.color
        
        lbMemName.font = regularFont(size: NumberConstant.smallFontSize)
        lbMemName.textColor = ColorName.holderText.color
        
        lbAccountNumber.font = semiboldFont(size: NumberConstant.commonFontSize)
        lbAccountNumber.textColor = ColorName.blackText.color
        
        lbBankName.font = regularFont(size: NumberConstant.smallFontSize)
        lbBankName.textColor = ColorName.holderText.color
        
        delegate = self
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
            self?.delete()
        }
        
        deleteAction.image = R.image.ic_action_delete()
        deleteAction.backgroundColor = UIColor.white
        
        let editAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
            self?.edit()
        }
        
        editAction.image = R.image.ic_action_edit()
        editAction.backgroundColor = UIColor.white
        
        let transferAction = SwipeAction(style: .default, title: nil) { [weak self]  action, indexPath in
            self?.transfer()
        }
        
        transferAction.image = R.image.ic_action_transfer()
        transferAction.backgroundColor = UIColor.white
        
        return [deleteAction, editAction, transferAction]
    }
    
}
