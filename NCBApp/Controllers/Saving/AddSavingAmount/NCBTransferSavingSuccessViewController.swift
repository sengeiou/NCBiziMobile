//
//  NCBTransferSavingSuccessViewController.swift
//  NCBApp
//
//  Created by Van Dong on 26/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBTransferSavingSuccessViewController: NCBTransactionSuccessfulViewController {
    var transferInfomation: TransferInfomationModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
extension NCBTransferSavingSuccessViewController{
    override func setupView() {
        super.setupView()
        
        lbAmountTitle.text = "Số tiền gửi"
        lbAmountValue.text = "\(transferInfomation?.amount ?? "") VND"
        lbFee.text = "lãi suất gửi hiện tại: \(transferInfomation?.interest ?? "")%"
        
        infoTblView.register(UINib(nibName: R.nib.ncbTransferInfoSavingTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbTransferInfoSavingTableViewCell.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Giao dịch thành công")
    }
    
    override func continueAction() {
        self.gotoSpecificallyController(NCBAddSavingAmountViewController.self)
    }
}
extension NCBTransferSavingSuccessViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbTransferInfoSavingTableViewCell.identifier, for: indexPath) as! NCBTransferInfoSavingTableViewCell
        cell.lbContent.text = "* Quý khách có thể gửi thêm tiền vào tài khoản tiết kiệm tích luỹ bất cứ lúc nào"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        
        header?.lbSourceAccount.text = "Từ tài khoản"
        header?.lbSourceAccountValue.text = transferInfomation?.sourceAccount
        
        header?.lbDestAccount.text = "Đến tài khoản tiết kiệm"
        header?.lbDestAccountValue.text = transferInfomation?.savingAccount
        
        header?.lbDestName.text = "Kỳ hạn gửi: \(transferInfomation?.termDest ?? "")"
        header?.lbBankName.text = "Số dư hiện tại: \(transferInfomation?.balSourceAcount ?? "")"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
