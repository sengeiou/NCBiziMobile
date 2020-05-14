//
//  NCBTransactionCompletedViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBTransactionCompletedViewController: NCBTransactionSuccessfulViewController {
    
    //MARK: Properties
    
    fileprivate var type: TransactionType = .internalTransfer
    var savingFormType: SavingFormsType = .AccumulateSaving
    fileprivate var dataModels = [TransactionModel]()
    var t24TimeOuted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func continueAction() {
        switch type {
        case .internalTransfer:
            gotoSpecificallyController(NCBInternalTransferViewController.self)
        case .fast247, .citad:
            gotoSpecificallyController(NCBInterbankTransferViewController.self)
        case .charity:
            gotoSpecificallyController(NCBCharityTransferViewController.self)
        default:
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension NCBTransactionCompletedViewController {
    
    override func setupView() {
        super.setupView()
        
        var item = dataModels.first(where: { $0.type == .amount })
        lbAmountValue.text = item?.value
        
        item = dataModels.first(where: { $0.type == .fee })
        lbFee.text = "*Phí dịch vụ: \(item?.value ?? "")"
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifyTransactionOtherInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransactionOtherInfoTableViewCellID.identifier)
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
        
        setHeaderTitle(t24TimeOuted ? "Giao dịch chờ xử lý" : "Giao dịch thành công")
    }
    
}

extension NCBTransactionCompletedViewController {
    
    func setData(_ dataModels: [TransactionModel], type: TransactionType) {
        self.dataModels = dataModels
        self.type = type
    }
    
}

extension NCBTransactionCompletedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.filter({ $0.type == .other }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransactionOtherInfoTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransactionOtherInfoTableViewCell
        let item = dataModels.filter({ $0.type == .other })[indexPath.row]
        cell.lbTitle.text = item.title
        cell.lbValue.text = item.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        
        var item = dataModels.first(where: { $0.type == .sourceAccount })
        header?.lbSourceAccountValue.text = item?.value
        header?.lbSourceAccount.text = item?.title
        
        item = dataModels.first(where: { $0.type == .destAccount })
        header?.lbDestAccountValue.text = item?.value
        header?.lbDestAccount.text = item?.title
        
        item = dataModels.first(where: { $0.type == .destName })
        header?.lbDestName.text = item?.value
        
        item = dataModels.first(where: { $0.type == .bankName })
        header?.lbBankName.text = item?.value
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
