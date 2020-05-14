//
//  NCBRegistrationATMSuccessfulViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegistrationATMSuccessfulViewController: NCBTransactionSuccessfulViewController {
    var accountName = ""
    var branch = ""
    var cardProducts = ""
    var cardClass = ""
    var pee:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
}

extension NCBRegistrationATMSuccessfulViewController {
    
    override func setupView() {
        super.setupView()
        
        infoTblView.register(UINib(nibName: R.nib.ncbRegistrationATMVerifyInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        hiddenHeaderView()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Giao dịch thành công")
    }
    
    override func continueAction() {
        gotoSpecificallyController(NCBCardServiceViewController.self)
    }
}


extension NCBRegistrationATMSuccessfulViewController {
    
    func setData(branch: String, cardProduct: String, cardClass: String, pee:Double,accountName:String) {
        self.branch = branch
        self.cardProducts = cardProduct
        self.cardClass = cardClass
        self.pee = pee
        self.accountName = accountName
    }
}

extension NCBRegistrationATMSuccessfulViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier, for: indexPath) as! NCBRegistrationATMVerifyInfoTableViewCell
        
        cell.locationLbl.text = "Địa điểm nhận thẻ: "+self.branch
        cell.peeLbl.text =  "Phí dịch vụ: "+self.pee.currencyFormatted
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        header?.lbSourceAccountValue.text = self.accountName
        header?.lbSourceAccount.text = "Tài khoản mở thẻ"
        header?.lbDestAccountValue.text = self.cardProducts
        header?.lbDestAccount.text = "Sản phẩm thẻ"
        header?.lbDestName.text = "Hạng thẻ: \(self.cardClass)"
        header?.lbBankName.text = ""
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
 
    
}
