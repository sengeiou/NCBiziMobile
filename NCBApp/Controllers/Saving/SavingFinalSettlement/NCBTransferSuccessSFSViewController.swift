//
//  NCBTransferSuccessSFSViewController.swift
//  NCBApp
//
//  Created by Van Dong on 27/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBTransferSuccessSFSViewController: NCBTransactionSuccessfulViewController {
    
    var transferInfomation: TransferInfomationModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension NCBTransferSuccessSFSViewController{
    override func setupView() {
        super.setupView()
        
        lbAmountTitle.text = "Số tiền gửi"
        lbAmountValue.text = "\(transferInfomation?.amount ?? "")"
        
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
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: NCBSavingAccountViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension NCBTransferSuccessSFSViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransactionGeneralInfoTableViewCell
        cell.lbContent.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionInfoTableViewCell.firstView(owner: self)
        
        header?.tittleLb1.text = "Từ tài khoản tiết kiệm"
        header?.accountNo1.text = transferInfomation?.savingAccount
        header?.label1.text = "Ngày đến hạn: \(transferInfomation?.termDest ?? "")"
        
        header?.tittleLb2.text = "Tài khoản hưởng gốc, lãi"
        header?.accountNo2.text = transferInfomation?.sourceAccount
        
        header?.label2.text = ""
        header?.label3.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
}
