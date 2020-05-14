//
//  NCBBaseSourceAccountViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit
import DropDown

class NCBBaseSourceAccountViewController: NCBBaseTransactionViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var containerSourceView: UIView!
    
    //MARK: Properties
    
    var sourceAccountView: NCBSourceAccountView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSourceAccountPaymentList()
    }
    
}

extension NCBBaseSourceAccountViewController {
    
    override func setupView() {
        super.setupView()
        
        for constraint in containerSourceView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = 90
            }
        }
        
        sourceAccountView = R.nib.ncbSourceAccountView.firstView(owner: self)!
        containerSourceView.addSubview(sourceAccountView!)
        
        sourceAccountView!.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        sourceAccountView!.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    override func loadDefaultSourceAccount() {
        super.loadDefaultSourceAccount()
        
        guard let sourceAccount = sourceAccount else {
            return
        }
        
        sourceAccountView?.setSourceAccount(sourceAccount.acctNo)
        sourceAccountView?.setSourceName(sourceAccount.acName)
        sourceAccountView?.setSourceBalance(sourceAccount.curBal)
    }
    
    @objc func showOriginalAccountList() {
        if let controller = R.storyboard.bottomSheet.ncbSourceAccountViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listPaymentAccount)
        }
    }
    
    @objc func viewDidSelectSourceAccount(_ account: NCBDetailPaymentAccountModel) {
        closeBottomSheet()
        self.sourceAccountView?.setSourceAccount(account.acctNo)
        self.sourceAccountView?.setSourceName(account.acName)
        self.sourceAccountView?.setSourceBalance(account.curBal)
        self.sourceAccount = account
        self.sourceAccount?.isSelected = true
    }
    
}

extension NCBBaseSourceAccountViewController: NCBSourceAccountViewDelegate {
    
    func sourceDidSelect() {
        showOriginalAccountList()
    }
    
}

extension NCBBaseSourceAccountViewController: NCBSourceAccountViewControllerDelegate {
    
    func didSelectSourceAccount(_ account: NCBDetailPaymentAccountModel) {
        viewDidSelectSourceAccount(account)
    }
    
}
