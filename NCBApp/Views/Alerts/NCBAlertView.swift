//
//  NCBAlertView.swift
//  NCBApp
//
//  Created by Tuan Pham Hai  on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import UIKit

typealias NCBAlertViewConfirmCallback = () -> (Void)
typealias NCBAlertViewCancelCallback = () -> (Void)

class NCBAlertView: UIView {
    
    class func instantiateFromNib() -> NCBAlertView? {
        return Bundle.main.loadNibNamed("NCBAlertView", owner: nil, options: nil)?.first as? NCBAlertView
    }
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mesageLabel: UILabel!
    @IBOutlet var confirmButton: NCBStatementButton!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet var cancelButton: NCBStatementButton!
    @IBOutlet weak var cancelView: UIView!
    
    var cancelCallback: NCBAlertViewCancelCallback?
    var confirmCallback: NCBAlertViewConfirmCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        confirmButton.normalType()
        cancelButton.destructiveType()
    }
    
    func setTitle(title: String, message: String, confirmTitle: String = "", cancelTitle: String = "") {
        titleLabel.text = title
        mesageLabel.text = message
        
        confirmView.isHidden = (confirmTitle == "")
        cancelView.isHidden = (cancelTitle == "")
        
        UIView.performWithoutAnimation {
            cancelButton.setTitle(cancelTitle, for: .normal)
            cancelButton.layoutIfNeeded()
            confirmButton.setTitle(confirmTitle, for: .normal)
            confirmButton.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelCallback?()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        confirmCallback?()
    }
}
