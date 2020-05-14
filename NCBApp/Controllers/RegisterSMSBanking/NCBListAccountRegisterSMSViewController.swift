//
//  NCBListAccountRegisterSMSViewController.swift
//  NCBApp
//
//  Created by Van Dong on 15/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

protocol NCBListAccountRegisterSMSViewControllerDelegate {
    func didSelectAccount(_ account: NCBAccountRegisterSMSModel)
    
}

class NCBListAccountRegisterSMSViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    var listAccountRegisterSMS: [NCBAccountRegisterSMSModel] = []
    var delegate: NCBListAccountRegisterSMSViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = "Chọn tài khoản đăng ký SMS Banking"
        
        tblView.register(UINib(nibName: R.nib.ncbSourceAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
    }
}

extension NCBListAccountRegisterSMSViewController {
    func setupData(_ listAccountRegisterSMS: [NCBAccountRegisterSMSModel]) {
        self.listAccountRegisterSMS = listAccountRegisterSMS
        tblView.reloadData()
    }
    
}

extension NCBListAccountRegisterSMSViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAccountRegisterSMS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier, for: indexPath) as! NCBSourceAccountTableViewCell
        cell.selectionStyle = .none
        let item = listAccountRegisterSMS[indexPath.row]
        cell.lbAccountNumberTitle.text = item.acName
        cell.lbAccountNumberValue.text = item.acctNo
        cell.lbBalance.currencyLabel(with: Double(item.curBal ?? 0))
        cell.checkbtn.isSelected = item.isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listAccountRegisterSMS[indexPath.row]
//        if item.isSelected {
//            return
//        }
        delegate?.didSelectAccount(item)
        for item in listAccountRegisterSMS {
            item.isSelected = false
        }
        item.isSelected = true
        tblView.reloadData()
    }
    
}
