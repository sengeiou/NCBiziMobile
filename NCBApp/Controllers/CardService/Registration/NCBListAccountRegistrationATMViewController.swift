//
//  NCBListAccountRegistrationATMViewController.swift
//  NCBApp
//
//  Created by ADMIN on 9/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import UIKit

@objc protocol NCBListAccountRegistrationATMViewControllerDelegate {
    @objc optional func didSelectAccount(_ account: NCBGetListAccNoModel)
    @objc optional func didSelectPaymentAccount(_ account: NCBDetailPaymentAccountModel)
}

class NCBListAccountRegistrationATMViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    var listAccountRegisterATM: [NCBGetListAccNoModel] = []
    var listPaymentAccount:[NCBDetailPaymentAccountModel] = []
    var delegate: NCBListAccountRegistrationATMViewControllerDelegate?
    var isRegisterATM = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = "Chọn tài khoản đăng ký thẻ ATM"
        
        tblView.register(UINib(nibName: R.nib.ncbSourceAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
    }
}

extension NCBListAccountRegistrationATMViewController {
    func setupData(_ listAccountRegisterATM: [NCBGetListAccNoModel]) {
        isRegisterATM = true
        self.listAccountRegisterATM = listAccountRegisterATM
        tblView.reloadData()
    }
    func setupData(_ listPaymentAccount: [NCBDetailPaymentAccountModel]) {
        isRegisterATM = false
        self.listPaymentAccount = listPaymentAccount
        tblView.reloadData()
    }
    func setTitle(str:String){
        lbTitle.text = str
    }
    
}

extension NCBListAccountRegistrationATMViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRegisterATM == true{
          return listAccountRegisterATM.count
        }
        return listPaymentAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier, for: indexPath) as! NCBSourceAccountTableViewCell
        cell.selectionStyle = .none
        if isRegisterATM == true{
            let item = listAccountRegisterATM[indexPath.row]
            cell.lbAccountNumberTitle.text = item.categoryName
            cell.lbAccountNumberValue.text = item.acctNo
            cell.lbBalance.currencyLabel(with: Double(item.curBal ?? 0))
            cell.checkbtn.isSelected = item.isSelected
        }else{
            let item = listPaymentAccount[indexPath.row]
            cell.lbAccountNumberTitle.text = item.categoryName
            cell.lbAccountNumberValue.text = item.acctNo
            cell.lbBalance.currencyLabel(with: Double(item.curBal ?? 0))
            cell.checkbtn.isSelected = item.isSelected
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRegisterATM == true{
            let item = listAccountRegisterATM[indexPath.row]
//            if item.isSelected {
//                return
//            }
            delegate?.didSelectAccount?(item)
    
            for item in listAccountRegisterATM {
                item.isSelected = false
            }
            item.isSelected = true
        }else{
            let item = listPaymentAccount[indexPath.row]
//            if item.isSelected {
//                return
//            }
            delegate?.didSelectPaymentAccount?(item)
            for item in listPaymentAccount {
                item.isSelected = false
            }
            item.isSelected = true
        }
        tblView.reloadData()
    }
    
}
