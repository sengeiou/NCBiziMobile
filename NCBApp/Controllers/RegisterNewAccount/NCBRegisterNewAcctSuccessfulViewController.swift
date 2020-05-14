//
//  NCBRegisterNewAcctSuccessfulViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyAttributes

class NCBRegisterNewAcctSuccessfulViewController: NCBTransactionSuccessfulViewController {
    
    var isVid = true
    var newAcc = ""
    var accountName = ""
    var tailNumberModel:NCBTailNumberModel!
    var returnNumberModel: NCBReturnNumberModel!
    var product:NCBRegisterNewServiceProductModel!
    var presenter: NCBRegisterNewAcctPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBRegisterNewAcctSuccessfulViewController {
    
    override func setupView() {
        super.setupView()
        
        if !isVid {
            updateHeightInfoView(275)
        }
        
        infoTblView.register(UINib(nibName: R.nib.ncbRegistrationATMVerifyInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier)
        infoTblView.register(UINib(nibName: R.nib.ncbRegisterNewAcctSuccessfulTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRegisterNewAcctSuccessfulTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
        if isVid == false{
            hiddenHeaderView()
        }else{
            lbAmountTitle.text = "Phí dịch vụ"
            let fee = returnNumberModel.serviceFee ?? 0.0
            lbAmountValue.text = fee.currencyFormatted
        }
        
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Giao dịch thành công")
    }
    
    override func continueAction() {
        self.gotoSpecificallyController(NCBRegisterNewAccountViewController.self)
    }
}


extension NCBRegisterNewAcctSuccessfulViewController {
    
    func setupData(product: NCBRegisterNewServiceProductModel,
                   tailNumberModel: NCBTailNumberModel,
                   returnNumberModel: NCBReturnNumberModel, accountName: String) {
        isVid = true
        self.tailNumberModel = tailNumberModel
        self.returnNumberModel = returnNumberModel
        self.accountName = accountName
        self.product = product
    }
    
    func setupData(product: NCBRegisterNewServiceProductModel, newAcc: String) {
        isVid = false
        self.product = product
        self.newAcc = newAcc
    }
    
}

extension NCBRegisterNewAcctSuccessfulViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isVid == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegistrationATMVerifyInfoTableViewCellID.identifier, for: indexPath) as! NCBRegistrationATMVerifyInfoTableViewCell
            cell.locationLbl.text = "Loại tài khoản số đẹp:"
            cell.peeLbl.text = tailNumberModel.name
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegisterNewAcctSuccessfulTableViewCellID.identifier, for: indexPath) as! NCBRegisterNewAcctSuccessfulTableViewCell
        cell.titleLbl.text = "Quý khách đã đăng ký mở tài khoản thành công."
        let nameProduct = product.name ?? ""
//        cell.contentLbl.text = "Sản phẩm "+nameProduct+". Với số tài khoản 4837527275733."
        let attributedText = "Sản phẩm \(nameProduct).\nVới số tài khoản ".withFont(regularFont(size: 14)!) + newAcc.withFont(boldFont(size:14)!)
        cell.contentLbl.attributedText = attributedText
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        if isVid == true {
            header?.lbSourceAccountValue.text = self.accountName
            header?.lbSourceAccount.text = "Từ tài khoản"
            header?.lbDestAccountValue.text = returnNumberModel.accountNo
            header?.lbDestAccount.text = "Số tài khoản mới"
        }else{
            header?.lbSourceAccountValue.text = ""
            header?.lbSourceAccount.text = ""
            header?.lbDestAccountValue.text = ""
            header?.lbDestAccount.text = ""
        }
      
        header?.lbDestName .text = ""
        header?.lbBankName.text = ""

        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isVid == false{
            return 0
        }
        return UITableView.automaticDimension
    }
    
    
}

