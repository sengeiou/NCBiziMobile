//
//  NCBDebtAccountViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

enum DebtAccountType: Int {
    case expiredAccount = 0
    case outOfDateAccount
}

struct DebtAccountInfoModel {
    var title1: String
    var title2: String
    var value1: String
    var value2: String
    
    init(title1: String = "", title2: String = "", value1: String = "", value2: String = "") {
        self.title1 = title1
        self.title2 = title2
        self.value1 = value1
        self.value2 = value2
    }
}

class NCBDebtAccountViewController: NCBBaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var debtAccountTbl: UITableView! {
        didSet {
            debtAccountTbl.register(UINib(nibName: R.nib.ncbDebtAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.nib.ncbDebtAccountTableViewCell.identifier)
            debtAccountTbl.allowsSelection = false
            debtAccountTbl.tableFooterView = UIView(frame: CGRect.zero)
            debtAccountTbl.backgroundColor = UIColor.clear
            debtAccountTbl.delegate = self
            debtAccountTbl.dataSource = self
        }
    }
    
    
    // MARK: - Properties
    var debtAccountType = DebtAccountType.expiredAccount
    fileprivate var listDebtAccountInfo: [DebtAccountInfoModel] = []
    var debExpiredAccountModel: NCBDebtExpiredAccountModel? {
        didSet {
            assignDebtExpiredData()
        }
    }
    var contractNo: String = ""
    var detailDebtAccountPresenter: NCBDebtAccountPresenter?
    
    var debtOutOfDateAccountModel: NCBDebtOutOfDateAccountModel? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc func buttonAction() {
        print("Submitted")
    }
    
    
}

extension NCBDebtAccountViewController {
    override func setupView() {
        setHeaderTitle("Tài khoản vay")
        
        detailDebtAccountPresenter = NCBDebtAccountPresenter()
        
        switch debtAccountType {
        case .expiredAccount:
            detailDebtAccountPresenter?.getDetailExpiredDebtAccount(params: createGetDetailDebtAccountParams())
        case .outOfDateAccount:
            detailDebtAccountPresenter?.getDetailOutOfDateDebtAccount(params: createGetDetailDebtAccountParams())
        }
        detailDebtAccountPresenter?.delegate = self
    }
    
    func assignDebtExpiredData() {
        listDebtAccountInfo = []
        
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Số hợp đồng", title2: "", value1: debExpiredAccountModel?.contractNo ?? "", value2: ""))
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Nợ gốc còn lại",title2: "Lãi suất vay", value1: Double(debExpiredAccountModel?.orgCurBalance ?? 0).currencyFormatted, value2: String(format: "%.01f", debExpiredAccountModel?.interestRate ?? 0.0) + "%"))
    
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Ngày giải ngân lần đầu", title2: "Ngày đáo hạn", value1: debExpiredAccountModel?.fstReleaseDate ?? "", value2: debExpiredAccountModel?.matDate ?? ""))
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Gốc phải trả kỳ tới", title2: "Ngày trả nợ gốc", value1: Double(debExpiredAccountModel?.nextPaymentAmount ?? 0).currencyFormatted, value2: debExpiredAccountModel?.paymentDate ?? ""))
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Lãi phải trả kỳ tới", title2: "Ngày trả nợ lãi", value1: Double(debExpiredAccountModel?.nextInterestAmount ?? 0).currencyFormatted, value2: debExpiredAccountModel?.interestPaymentDate ?? ""))
        
        debtAccountTbl.reloadData()
        
    }
    func assignDebtOutOfDateData() {
        listDebtAccountInfo = []
        
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Số hợp đồng",title2: "", value1: debtOutOfDateAccountModel?.contractNo ?? "", value2: ""))
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Nợ gốc quá hạn",title2: "Ngày trả nợ", value1: Double(debtOutOfDateAccountModel?.overduedAmount ?? 0).currencyFormatted, value2: debtOutOfDateAccountModel?.paymentDate ?? ""))
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Lãi quá hạn", title2: "", value1: Double(debtOutOfDateAccountModel?.overduedInterest ?? 0).currencyFormatted, value2: ""))
        listDebtAccountInfo.append(DebtAccountInfoModel.init(title1: "Lãi phạt", title2: "", value1: Double(debtOutOfDateAccountModel?.penaltyAmount ?? 0).currencyFormatted, value2: ""))
        
        debtAccountTbl.reloadData()
    }
    
    func createGetDetailDebtAccountParams() -> [String : Any] {
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0,
            "contno" : contractNo
        ]
        
        return params
    }
}

extension NCBDebtAccountViewController: NCBDebtAccountPresenterDelegate {
    func getDetailExpiredDebtAccountCompleted(expiredDebtAccount: NCBDebtExpiredAccountModel?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        self.debExpiredAccountModel = expiredDebtAccount
        assignDebtExpiredData()
    }
    
    func getDetailOutOfDateDebtAccountCompleted(outOfDateDebtAccount: NCBDebtOutOfDateAccountModel?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        self.debtOutOfDateAccountModel = outOfDateDebtAccount
        assignDebtOutOfDateData()
    }
    
    
}

extension NCBDebtAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDebtAccountInfo.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        }else{
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbDebtAccountTableViewCell.identifier, for: indexPath) as! NCBDebtAccountTableViewCell
        cell.titleLb1.text = listDebtAccountInfo[indexPath.row].title1
        cell.detailLb1.text = listDebtAccountInfo[indexPath.row].value1
        cell.titleLb2.text = listDebtAccountInfo[indexPath.row].title2
        cell.detailLb2.text = listDebtAccountInfo[indexPath.row].value2
        cell.backgroundColor = .clear
        if indexPath.row == 0 {
            cell.detailLb1.font = semiboldFont(size: 18)
            cell.detailLb2.isHidden = true
        }else{
            cell.detailLb1.font = semiboldFont(size: 14)
            cell.detailLb2.font = semiboldFont(size: 14)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
