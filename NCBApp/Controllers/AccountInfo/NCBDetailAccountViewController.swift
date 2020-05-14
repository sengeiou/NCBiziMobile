//
//  NCBDetailAccountViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

enum ViewAccountMode: Int {
    case normal = 0
    case detailDealHistory
}

struct TransactionHistoryModel {
    var titles = ""
    var value = ""
}

class NCBDetailAccountViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var statementBtn: NCBStatementButton!
    @IBOutlet weak var detailAccountTbl: UITableView! {
        didSet {
            detailAccountTbl.register(UINib(nibName: R.nib.ncbCreditCardDetailTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCreditCardDetailTableViewCellID.identifier)
            detailAccountTbl.separatorStyle = .none
            detailAccountTbl.delegate = self
            detailAccountTbl.dataSource = self
        }
    }
    
    // MARK: - Properties
    
    var p: NCBDetailAccountPresenter?
    
    var sequenseNo: String = ""
    var accountNo: String = ""
    var detailTransactionHistoryModel: NCBDetailTransactionHistoryModel?
    var detailTransactionArr: [TransactionHistoryModel] = []
    
    var accountInfoModel: NCBDetailPaymentAccountModel?
    var historyDealItemModel: NCBDetailHistoryDealItemModel?
    var viewAccountMode = ViewAccountMode.normal
    var listPaymentAccount: [NCBDetailPaymentAccountModel] = []
    var listTransactionType = [NCBTransactionTypeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func goBackTop10Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension NCBDetailAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailTransactionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardDetailTableViewCellID.identifier, for: indexPath) as! NCBCreditCardDetailTableViewCell
        
        cell.lbTitle.text = detailTransactionArr[indexPath.row].titles
        cell.lbValue.text = detailTransactionArr[indexPath.row].value
        
        if indexPath.row == 0 {
            cell.lbValue.font = semiboldFont(size: 18)
        } else {
            cell.lbValue.font = semiboldFont(size: 14)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        }
        return 55
    }
}

extension NCBDetailAccountViewController {
    override func setupView() {
        super.setupView()
        
        statementBtn.setTitle("Sao kê tài khoản", for: .normal)
        statementBtn.addTarget(self, action: #selector(statementAction), for: .touchUpInside)
    
        switch viewAccountMode {
        case .normal:
            setHeaderTitle("CHI TIẾT TÀI KHOẢN")
            if accountInfoModel != nil {
                setupData()
            }
        case .detailDealHistory:
            setHeaderTitle("CHI TIẾT GIAO DỊCH")
            SVProgressHUD.show()
            
            
            let params: [String : Any] = [
                "seqno" : sequenseNo,
                "accountNo" : accountNo
            ]
            p = NCBDetailAccountPresenter()
            
            p?.getDetailTransactionHistory(params: params)
            p?.delegate = self
            
        }
    }
    
    @objc func statementAction() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: NCBAccountStatementViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return
            }
        }
        
        if let _vc = R.storyboard.accountInfo.ncbAccountStatementViewController() {
            _vc.accountInfo = self.accountInfoModel
            _vc.listPaymentAccount = listPaymentAccount
            _vc.listTransactionType = listTransactionType
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
    func setupData() {
        detailTransactionArr = []
        
        detailTransactionArr.append(TransactionHistoryModel(titles: "Tài khoản thanh toán", value: accountInfoModel?.acctNo ?? ""))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Loại tài khoản", value: accountInfoModel?.categoryName ?? ""))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Ngày mở", value: accountInfoModel?.opnDateFormat ?? ""))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Tên tài khoản", value: accountInfoModel?.acName ?? ""))
         detailTransactionArr.append(TransactionHistoryModel(titles: "Số dư khả dụng", value: (accountInfoModel?.curBal ?? 0.0).currencyFormatted))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Số tiền phong toả", value: (accountInfoModel?.lockBal ?? 0.0).currencyFormatted))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Hạn mức thấu chi", value: (accountInfoModel?.limit ?? 0.0).currencyFormatted))
        
        
        detailAccountTbl.reloadData()
    }
    
    func setupDetailTransactionHistory(with model: NCBDetailTransactionHistoryModel?) {
        detailTransactionHistoryModel = model
        detailTransactionArr.append(TransactionHistoryModel(titles: "Loại giao dịch", value: detailTransactionHistoryModel?.transTypeDesc ?? ""))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Tài khoản nguồn", value: detailTransactionHistoryModel?.resourceAcc ?? ""))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Tài khoản đích", value: detailTransactionHistoryModel?.destinationAcc ?? ""))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Người nhận", value: detailTransactionHistoryModel?.receiver ?? ""))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Số tiền", value: Double(detailTransactionHistoryModel?.amount ?? 0.0).currencyFormatted))
        detailTransactionArr.append(TransactionHistoryModel(titles: "Nội dung", value: detailTransactionHistoryModel?.message ?? ""))
        if detailTransactionHistoryModel?.transType?.lowercased() != "urt" {
            detailTransactionArr.append(TransactionHistoryModel(titles: "Tại", value: detailTransactionHistoryModel?.origin ?? ""))
        }
        detailAccountTbl.reloadData()
    }
}

extension NCBDetailAccountViewController: NCBDetailAccountPresenterDelegate {
    
    func getAccountDetailCompleted(error: String?) {
        
    }
    
    func getDetailTransactionHistoryCompleted(model: NCBDetailTransactionHistoryModel?, error: String?) {
        SVProgressHUD.dismiss()
        detailTransactionArr = []
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        setupDetailTransactionHistory(with: model)
    }
    
}
