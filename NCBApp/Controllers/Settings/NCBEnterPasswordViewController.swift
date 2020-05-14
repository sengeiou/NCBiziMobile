//
//  NCBEnterPasswordViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/21/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBEnterPasswordViewControllerDelegate {
    func enterPasswordCancel()
    func enterPasswordContinue(pass: String)
}

class NCBEnterPasswordViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfPword: UITextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    //MARK: Properties
    
    var delegate: NCBEnterPasswordViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.enterPasswordCancel()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if tfPword.text == "" {
            return
        }
        delegate?.enterPasswordContinue(pass: tfPword.text ?? "")
    }
    
}

extension NCBEnterPasswordViewController {
    
    override func setupView() {
        super.setupView()
        
        tfPword.font = semiboldFont(size: 14)
        tfPword.textAlignment = .center
        tfPword.becomeFirstResponder()
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        
        UIView.performWithoutAnimation {
            continueBtn.setTitle("Tiếp tục", for: .normal)
            continueBtn.layoutIfNeeded()
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        lbTitle.text = "Nhập mật khẩu đăng nhập"
    }
    
}
