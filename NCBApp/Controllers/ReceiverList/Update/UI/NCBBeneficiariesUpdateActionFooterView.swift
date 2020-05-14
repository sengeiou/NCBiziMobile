//
//  NCBBeneficiariesUpdateActionFooterView.swift
//  NCBApp
//
//  Created by Thuan on 7/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

typealias NCBBeneficiariesUpdateActionFooterViewEdit = () -> (Void)
typealias NCBBeneficiariesUpdateActionFooterViewDelete = () -> (Void)
typealias NCBBeneficiariesUpdateActionFooterViewTransfer = () -> (Void)

class NCBBeneficiariesUpdateActionFooterView: UIView {
    
    @IBOutlet weak var lbTransfer: UILabel!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var lbEdit: UILabel!
    @IBOutlet weak var lbDelete: UILabel!
    
    var edit: NCBBeneficiariesUpdateActionFooterViewEdit!
    var delete: NCBBeneficiariesUpdateActionFooterViewDelete!
    var transfer: NCBBeneficiariesUpdateActionFooterViewTransfer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTransfer.font = regularFont(size: 12)
        lbTransfer.textColor = ColorName.holderText.color
        lbTransfer.text = "Chuyển khoản"
        
        lbEdit.font = regularFont(size: 12)
        lbEdit.textColor = ColorName.holderText.color
        lbEdit.text = "Sửa"
        
        lbDelete.font = regularFont(size: 12)
        lbDelete.textColor = ColorName.holderText.color
        lbDelete.text = "Xoá"
    }
    
    @IBAction func transferAction(_ sender: Any) {
        transfer()
    }
    
    @IBAction func editAction(_ sender: Any) {
        edit()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        delete()
    }
    
}
