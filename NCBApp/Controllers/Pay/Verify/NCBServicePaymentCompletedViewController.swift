//
//  NCBServicePaymentCompletedViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBServicePaymentCompletedViewController: NCBTransactionSuccessfulViewController {
    
    fileprivate var serviceProvider: NCBServiceProviderModel?
    fileprivate var sourceAccount: NCBDetailPaymentAccountModel?
    fileprivate var customerCode = ""
    fileprivate var customerName = ""
    fileprivate var address = ""
    fileprivate var period = ""
    fileprivate var amount = ""
    var isAutoPaymentRegister: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func continueAction() {
        if isAutoPaymentRegister {
            gotoSpecificallyController(NCBAutoPaymentListViewController.self)
            return
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension NCBServicePaymentCompletedViewController {
    
    override func setupView() {
        super.setupView()
        
        if isAutoPaymentRegister {
            hiddenHeaderView()
        } else {
            lbAmountTitle.text = "Số tiền thanh toán"
            lbAmountValue.text = amount
            
            if period != "" {
                lbFee.text = "Kỳ hoá đơn: Tháng \(period)"
                
                let str = lbFee.text ?? ""
                let height = str.height(withConstrainedWidth: self.view.frame.width - 50, font: regularFont(size: 12)!)
                updateHeightHeaderView(height - 15)
            }
        }
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifyTransactionGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier)
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
    
    func setData(customerCode: String, customerName: String, address: String, period: String, amount: String, serviceProvider: NCBServiceProviderModel?, sourceAccount: NCBDetailPaymentAccountModel?) {
        
        self.customerCode = customerCode
        self.customerName = customerName
        self.address = address
        self.period = period
        self.amount = amount
        self.serviceProvider = serviceProvider
        self.sourceAccount = sourceAccount
    }
    
}

extension NCBServicePaymentCompletedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if customerName == "" && !isAutoPaymentRegister {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransactionGeneralInfoTableViewCell
        if isAutoPaymentRegister {
            cell.lbContent.text = "Đăng ký thanh toán hoá đơn tự động"
        } else {
            cell.lbContent.text = "Tên khách hàng: \(customerName)\nĐịa chỉ: \(address)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        
        header?.lbSourceAccount.text = "Từ tài khoản"
        header?.lbSourceAccountValue.text = sourceAccount?.acctNo
        
        header?.lbDestAccount.text = serviceProvider?.billName
        header?.lbDestAccountValue.text = customerCode
        
        header?.lbDestName.text = serviceProvider?.providerName
        header?.lbBankName.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
