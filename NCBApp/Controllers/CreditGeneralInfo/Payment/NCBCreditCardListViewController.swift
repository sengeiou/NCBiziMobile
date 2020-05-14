//
//  NCBCreditCardListViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBCreditCardListViewControllerDelegate {
    func didSelectItem(_ item: NCBCreditCardModel)
    
}

class NCBCreditCardListViewController: NCBBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    var listCredit: [NCBCreditCardModel] = []
    var delegate: NCBCreditCardListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = "Chọn thẻ tín dụng"
        
        tblView.register(UINib(nibName: R.nib.ncbSourceAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
    }
    
}

extension NCBCreditCardListViewController {
    
    func setupData(_ listCredit: [NCBCreditCardModel]) {
        self.listCredit = listCredit
        tblView.reloadData()
    }
    
}

extension NCBCreditCardListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCredit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSourceAccountTableViewCellID.identifier, for: indexPath) as! NCBSourceAccountTableViewCell
        cell.selectionStyle = .none
        let item = listCredit[indexPath.row]
        cell.lbAccountNumberTitle.text = "\(item.parCardProduct?.product ?? "") - \(item.parCardProduct?.class_ ?? "")"
        cell.lbAccountNumberValue.text = item.cardno?.cardHidden
//        cell.lbBalance.currencyLabel(with: item.amountAvailableToSpend ?? 0.0)
        cell.lbBalance.isHidden = true
        cell.checkbtn.isSelected = item.isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listCredit[indexPath.row]
//        if item.isSelected {
//            return
//        }
        
        delegate?.didSelectItem(item)
        
        for item in listCredit {
            item.isSelected = false
        }
        item.isSelected = true
        
        tblView.reloadData()
    }
    
}
