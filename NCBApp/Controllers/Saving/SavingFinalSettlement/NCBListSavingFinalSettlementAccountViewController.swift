//
//  NCBListSavingFinalSettlementAccountViewController.swift
//  NCBApp
//
//  Created by Van Dong on 27/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

//protocol NCBListSavingFinalSettlementAccountViewControllerDelegate {
//    func didSelectAccount(_ account: NCBFinalSettlementSavingAccountModel)
//
//}
class NCBListSavingFinalSettlementAccountViewController: NCBBaseViewController {
    @IBOutlet weak var tittleBottomSheet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var listSavingAccount: [NCBFinalSettlementSavingAccountModel] = []
//    var delegate: NCBListSavingFinalSettlementAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
extension NCBListSavingFinalSettlementAccountViewController {
    override func setupView() {
        super.setupView()
        tittleBottomSheet.font = semiboldFont(size: 14)
        tittleBottomSheet.textColor = ColorName.blurNormalText.color
        tittleBottomSheet.text = "Tài khoản tiết kiệm có thể tất toán"
        
        tableView.register(UINib(nibName: R.nib.ncbListSavingAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbListSavingAccountTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
}
extension NCBListSavingFinalSettlementAccountViewController {
    func setupData(_ listSavingAccount: [NCBFinalSettlementSavingAccountModel]) {
        self.listSavingAccount = listSavingAccount
        tableView.reloadData()
    }
    
}
extension NCBListSavingFinalSettlementAccountViewController: UITableViewDelegate,UITableViewDataSource {
    
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
        cell.balance.text = item.getBalance()
        cell.dueDate.text = "Ngày đáo hạn: \(item.dueDate ?? "")"
        cell.termDest.text = item.termDest
        cell.checkbtn.isSelected = item.isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = R.storyboard.saving.ncbDetailSavingFinalSettlementAccountViewController() {
            vc.acctNo = listSavingAccount[indexPath.row].account
            vc.savingNo = listSavingAccount[indexPath.row].savingNumber
            self.navigationController?.pushViewController(vc, animated: true)
        }
        removeBottomSheet()
    }
}
