//
//  NCBSourceAccountViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/15/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum VerticalLocation: String {
    case bottom
    case top
}

protocol NCBSourceAccountViewControllerDelegate {
    func didSelectSourceAccount(_ account: NCBDetailPaymentAccountModel)
    
}

class NCBSourceAccountViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    var listPaymentAccount: [NCBDetailPaymentAccountModel] = []
    var delegate: NCBSourceAccountViewControllerDelegate?
    var titleStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = titleStr != "" ? titleStr : "Chọn tài khoản nguồn"
        
        tblView.register(UINib(nibName: R.nib.ncbSourceAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
    }
    
}

extension NCBSourceAccountViewController {
    
    func setupData(_ listPaymentAccount: [NCBDetailPaymentAccountModel]) {
        self.listPaymentAccount = listPaymentAccount
        tblView.reloadData()
    }
    
}

extension NCBSourceAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPaymentAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier, for: indexPath) as! NCBSourceAccountTableViewCell
        cell.selectionStyle = .none
        let item = listPaymentAccount[indexPath.row]
        cell.lbAccountNumberTitle.text = item.categoryName
        cell.lbAccountNumberValue.text = item.acctNo
        cell.lbBalance.currencyLabel(with: Double(item.curBal ?? 0))
        cell.checkbtn.isSelected = item.isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listPaymentAccount[indexPath.row]
//        if item.isSelected {
//            return
//        }
        
        delegate?.didSelectSourceAccount(item)
        
        for item in listPaymentAccount {
            item.isSelected = false
        }
        item.isSelected = true
        
        tblView.reloadData()
    }
    
}
