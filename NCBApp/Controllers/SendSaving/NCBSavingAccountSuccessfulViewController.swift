//
//  NCBSavingAccountSuccessfulViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
class NCBSavingAccountSuccessfulViewController: NCBTransactionSuccessfulViewController {
    
    fileprivate var type: TransactionType = .internalTransfer
    var savingFormType: SavingFormsType = .AccumulateSaving
    fileprivate var dataModels = [TransactionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBSavingAccountSuccessfulViewController {
    
    override func setupView() {
        
        super.setupView()
        
        lbAmountTitle.text = "Số tiền gửi "
        let sendAmountItem = dataModels[1]
        lbAmountValue.text = sendAmountItem.value
        
        let sendScheduleItem = dataModels[2]
        let interestItem = dataModels[4]
        
        lbFee.text = "Kỳ hạn "+sendScheduleItem.value+" | "+interestItem.value
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifySavingAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifySavingAccountTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
      
        updateHeightInfoView(self.view.frame.height*7/10)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        switch savingFormType {
        case .ISavingSaving:
            setHeaderTitle("Giao dịch chờ xử lý")
        default:
            setHeaderTitle("Giao dịch thành công")
        }
    }
    
    override func continueAction() {
//        self.navigationController?.popToRootViewController(animated: true)
        gotoSpecificallyController(NCBISavingsViewController.self)
    }
}


extension NCBSavingAccountSuccessfulViewController {
    
    func setData(_ dataModels: [TransactionModel], type: TransactionType) {
        self.dataModels = dataModels
        self.type = type
    }
}

extension NCBSavingAccountSuccessfulViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifySavingAccountTableViewCellID.identifier, for: indexPath) as! NCBVerifySavingAccountTableViewCell
        let  termInterestItem = dataModels[3]
        cell.termInterestLbl.text = "Kỳ lĩnh lãi: " + termInterestItem.value
        let  matureFormItem = dataModels[5]
        cell.matureFormLbl.text = "Hình thức đáo hạn: " + matureFormItem.value
        cell.destinationAccountsTitleLbl.text = "Tài khoản hưởng gốc, lãi"
        let accItem = dataModels[6]
        cell.destinationAccountsLbl.text = accItem.value
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        let accItem = dataModels[0]
        
        header?.lbSourceAccountValue.text = accItem.value
        header?.lbSourceAccount.text = "Từ tài khoản"
        if savingFormType == .ISavingSaving{
            header?.lbDestAccountValue.text = "Sổ tiết kiệm i-Savings"
        }else{
            header?.lbDestAccountValue.text = "Sổ tiết kiệm tích luỹ"
        }
        header?.lbDestAccount.text = "Tài khoản đến"
        header?.lbDestName.text = ""
        header?.lbBankName.text = ""
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = R.nib.ncbSavingAccountSuccessfulFooterView.firstView(owner: self)
        if savingFormType == .ISavingSaving{
             footerView?.noticeLbl.text = ""
        }else{
             footerView?.noticeLbl.text = "* Quý khách có thể gửi thêm tiền vào tài khoản tiết kiệm tích luỹ bất cứ lúc nào"
        }
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         return UITableView.automaticDimension
    }
}
