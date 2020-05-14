//
//  NCBCreditCardViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import Kingfisher

struct CreditCardItem {
    var title = ""
    var value = ""
}

class NCBCreditCardViewController: NCBBaseViewController {
    
    //MARK: Outlets

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var heightContentView: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var creditCardInfo: NCBCreditCardModel?
    fileprivate var dataModels = [CreditCardItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension NCBCreditCardViewController {
    
    override func setupView() {
        super.setupView()
        
        commonCreditCardInfoView?.setData(creditCardInfo)
        
        if !(creditCardInfo?.isPrimaryCard ?? true) {
            heightContentView.constant = 340
        } else if UIScreen.main.bounds.size.height <= 568 /*size iphone 5/5s*/ {
            heightContentView.constant = 400
        }
        
        tblView.register(UINib(nibName: R.nib.ncbCreditCardDetailTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCreditCardDetailTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        
        setupData()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        if creditCardInfo?.cardtype == CreditCardType.DB.rawValue {
            setHeaderTitle("Thẻ ghi nợ nội địa")
        } else {
            setHeaderTitle("THẺ TÍN DỤNG")
        }
    }
    
    func setupData() {
        if creditCardInfo?.isPrimaryCard ?? true && creditCardInfo?.cardtype != CreditCardType.DB.rawValue {
            dataModels.append(CreditCardItem(title: "Hạn mức tín dụng", value: (creditCardInfo?.creditLimit ?? 0.0).currencyFormatted))
            dataModels.append(CreditCardItem(title: "Dư nợ hiện tại", value: (creditCardInfo?.authorisedAmount ?? 0).currencyFormatted))
            dataModels.append(CreditCardItem(title: "Hạn mức còn lại", value: (creditCardInfo?.amountAvailableToSpend ?? 0).currencyFormatted))
        } else if creditCardInfo?.cardtype == CreditCardType.DB.rawValue {
            dataModels.append(CreditCardItem(title: "Tài khoản thanh toán", value: creditCardInfo?.acctno ?? ""))
        }
        dataModels.append(CreditCardItem(title: "Sản phẩm thẻ", value: "\(creditCardInfo?.parCardProduct?.product ?? "") - \(creditCardInfo?.parCardProduct?.class_ ?? "")"))
        dataModels.append(CreditCardItem(title: "Chi nhánh mở thẻ", value: creditCardInfo?.daoName ?? ""))
        tblView.reloadData()
    }
}

extension NCBCreditCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardDetailTableViewCellID.identifier, for: indexPath) as! NCBCreditCardDetailTableViewCell

        let item = dataModels[indexPath.row]
        cell.lbTitle.text = item.title
        cell.lbValue.text = item.value
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}
