//
//  NCBSavingAccountViewController.swift
//  NCBApp
//
//  Created by Van Dong on 21/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

protocol NCBListSavingAccountViewControllerDelegate {
    func didSelectAccount(_ account: NCBGeneralSavingAccountInfoModel)
    
}

class NCBListSavingAccountViewController: NCBBaseViewController {
    @IBOutlet weak var tittleBottomSheet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var listSavingAccount: [NCBGeneralSavingAccountInfoModel] = []
    var delegate: NCBListSavingAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
extension NCBListSavingAccountViewController {
    override func setupView() {
        super.setupView()
        tittleBottomSheet.font = semiboldFont(size: 14)
        tittleBottomSheet.textColor = ColorName.blurNormalText.color
        tittleBottomSheet.text = "Chọn tài khoản tiết kiệm"
        
        tableView.register(UINib(nibName: R.nib.ncbListSavingAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbListSavingAccountTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
}
extension NCBListSavingAccountViewController {
    func setupData(_ listSavingAccount: [NCBGeneralSavingAccountInfoModel]) {
        self.listSavingAccount = listSavingAccount
        tableView.reloadData()
    }
    
}
extension NCBListSavingAccountViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSavingAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbListSavingAccountTableViewCell.identifier, for: indexPath) as! NCBListSavingAccountTableViewCell
        cell.selectionStyle = .none
        let item = listSavingAccount[indexPath.row]
        cell.account.text = item.account
        cell.balance.text = item.getBalanceDisplay()
        cell.dueDate.text = "Ngày đáo hạn: " + item.dueDate!
        cell.termDest.text = item.termDest
        cell.checkbtn.isSelected = item.isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listSavingAccount[indexPath.row]
//        if item.isSelected {
//            return
//        }
        delegate?.didSelectAccount(item)
        for item in listSavingAccount {
            item.isSelected = false
        }
        item.isSelected = true
        tableView.reloadData()
    }
}
