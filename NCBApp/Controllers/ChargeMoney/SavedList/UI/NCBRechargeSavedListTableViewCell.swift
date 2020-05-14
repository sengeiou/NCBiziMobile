//
//  NCBRechargeSavedListTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 8/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwipeCellKit

typealias NCBRechargeSavedListTableViewCellRecharge = () -> (Void)
typealias NCBRechargeSavedListTableViewCellEdit = () -> (Void)
typealias NCBRechargeSavedListTableViewCellDelete = () -> (Void)

class NCBRechargeSavedListTableViewCell: NCBBaseTableViewCell, SwipeTableViewCellDelegate {
    
    @IBOutlet weak var lbMemName: UILabel!
    @IBOutlet weak var lbBillNo: UILabel!
    @IBOutlet weak var lbPartner: UILabel!
    
    //MARK: Properties
    
    var recharge: NCBRechargeSavedListTableViewCellRecharge!
    var edit: NCBRechargeSavedListTableViewCellEdit!
    var delete: NCBRechargeSavedListTableViewCellDelete!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbMemName.font = semiboldFont(size: 14)
        lbMemName.textColor = ColorName.blackText.color
        
        lbBillNo.font = semiboldFont(size: 12)
        lbBillNo.textColor = ColorName.blackText.color
        
        lbPartner.font = regularFont(size: 12)
        lbPartner.textColor = ColorName.holderText.color
        
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
            self?.recharge()
        }
        
        transferAction.image = R.image.ic_action_charge()
        transferAction.backgroundColor = UIColor.white
        
        return [deleteAction, editAction, transferAction]
    }
    
}
