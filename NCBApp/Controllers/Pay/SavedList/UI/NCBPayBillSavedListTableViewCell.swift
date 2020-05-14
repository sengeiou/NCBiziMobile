//
//  NCBPayBillSavedListTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwipeCellKit

typealias NCBPayBillSavedListTableViewCellPay = () -> (Void)
typealias NCBPayBillSavedListTableViewCellDelete = () -> (Void)

class NCBPayBillSavedListTableViewCell: NCBBaseTableViewCell, SwipeTableViewCellDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbMemName: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbServiceName: UILabel!
    @IBOutlet weak var lbProviderName: UILabel!
    
    //MARK: Properties
    
    var pay: NCBPayBillSavedListTableViewCellPay!
    var delete: NCBPayBillSavedListTableViewCellDelete!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbMemName.font = semiboldFont(size: 14)
        lbMemName.textColor = ColorName.blackText.color
        
        lbCode.font = semiboldFont(size: 12)
        lbCode.textColor = ColorName.blackText.color
        
        lbServiceName.font = regularFont(size: 12)
        lbServiceName.textColor = ColorName.holderText.color
        
        lbProviderName.font = regularFont(size: 12)
        lbProviderName.textColor = ColorName.holderText.color
    }
    
    func setData(_ item: NCBPayBillSavedModel, isAutoPaymentRegister: Bool) {
        lbMemName.text = item.memName
        lbCode.text = item.billNo
        lbServiceName.text = item.serviceName
        lbProviderName.text = item.providerName
        
        if isAutoPaymentRegister {
            delegate = nil
        } else {
            delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
            self?.delete()
        }
        
        deleteAction.image = R.image.ic_action_delete()
        deleteAction.backgroundColor = UIColor.white
        
        let transferAction = SwipeAction(style: .default, title: nil) { [weak self]  action, indexPath in
            self?.pay()
        }
        
        transferAction.image = R.image.ic_action_charge()
        transferAction.backgroundColor = UIColor.white
        
        return [deleteAction, transferAction]
    }
    
}
