//
//  NCBSearchTransactionViewController.swift
//  NCBApp
//
//  Created by Thuan on 10/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBSearchTransactionViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    fileprivate var accountPresenter: NCBGeneralAccountPresenter?
    fileprivate var p: NCBAccountInfoPresenter?
    fileprivate var transactions: [NCBDetailHistoryDealItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBSearchTransactionViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbCreditCardGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableView.automaticDimension
        
        p = NCBAccountInfoPresenter()
        p?.delegate = self
        
        accountPresenter = NCBGeneralAccountPresenter()
        accountPresenter?.delegate = self
        
        SVProgressHUD.show()
        accountPresenter?.findTransactionType()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Tra cứu trạng thái giao dịch")
    }
    
    fileprivate func searchTransaction() {
        let params: [String: Any] = [
            "cif": NCBShareManager.shared.getUser()?.cif ?? "",
        ]
        
        p?.searchTransactionByCif(params: params)
    }
    
}

extension NCBSearchTransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBCreditCardGeneralInfoTableViewCell
        let item = transactions[indexPath.row]
        cell.setupDataForTopTen(item)
        cell.lbContent.text = item.getTransactionType(accountPresenter?.listTransactionType ?? [])
        cell.paddingRightStackView.constant = 50
        cell.iconView.isHidden = false
        
        switch item.status {
        case "S", "R":
            cell.iconView.image = R.image.ic_transaction_statuc_success()
        case "W":
            cell.iconView.image = R.image.ic_transaction_statuc_wait()
        case "F":
            cell.iconView.image = R.image.ic_transaction_statuc_fail()
        default:
            cell.iconView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = transactions[indexPath.row]
        let popup = R.nib.ncbPaymentAccountHistoryDetailPopupView.firstView(owner: self)!
        popup.setData(item, showStatus: true)
        showPopupView(sourceView: popup, size: 385)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension NCBSearchTransactionViewController: NCBGeneralAccountPresenterDelegate {
    
    func findTransactionTypeCompleted(error: String?) {
        if let error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: error)
            return
        }
        
        searchTransaction()
    }
    
}

extension NCBSearchTransactionViewController: NCBAccountInfoPresenterDelegate {
    
    func searchTransactionByCifCompleted(listHistoryItems: [NCBDetailHistoryDealItemModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        transactions = listHistoryItems ?? []
        tblView.reloadData()
        
        if transactions.count == 0 {
            showAlert(msg: "Không tìm thấy giao dịch. Quý khách vui lòng thử lại.")
        }
        tblView.tableEmptyMessage(transactions.count == 0)
    }
    
}
