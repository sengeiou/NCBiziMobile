//
//  NCBDetailSavingAccountInfoViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

struct DetailSavingAccountModel {
    var titles = ""
    var value = ""
    var amount: Double?
    var ccy: String?
    var title2: String?
    var value2: String?
    
    func getAmountDisplay() -> String {
        if let amount = amount {
            return amount.currencyFormatted
        }
        return ""
    }
    
    init(titles: String, value: String, amount: Double? = nil, ccy: String? = nil, title2: String = "", value2: String = "") {
        self.titles = titles
        self.value = value
        self.amount = amount
        self.ccy = ccy
        self.title2 = title2
        self.value2 = value2
    }
}

class NCBDetailSavingAccountInfoViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var detailSavingAccountInfoTbl: UITableView! {
        didSet {
            
            detailSavingAccountInfoTbl.register(UINib.init(nibName: R.nib.ncbDetailSavingAccountCell.name, bundle: nil), forCellReuseIdentifier: R.nib.ncbDetailSavingAccountCell.identifier)
            
            detailSavingAccountInfoTbl.register(UINib.init(nibName: R.nib.ncbCreditCardDetailTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.nib.ncbCreditCardDetailTableViewCell.identifier)
            
            detailSavingAccountInfoTbl.allowsSelection = false
            detailSavingAccountInfoTbl.delegate = self
            detailSavingAccountInfoTbl.dataSource = self
            detailSavingAccountInfoTbl.rowHeight = UITableView.automaticDimension
            detailSavingAccountInfoTbl.estimatedRowHeight = 50
        }
    }
    
    @IBOutlet weak var settlementView: UIView! {
        didSet {
            settlementView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var settlementButton: UIButton!
    @IBOutlet weak var statementView: UIView! {
        didSet {
            statementView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var statementButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Properties
    
    var detailSavingAccountArr: [Any] = []
    var savingAccountInfoModel: NCBDetailSavingAccountModel?
    var generalSavingAccountInfoModel: NCBGeneralSavingAccountInfoModel?
    
    var p: NCBDetailSavingAccountInfoPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func statementButtonClicked(_ sender: Any) {
        if let _vc = R.storyboard.accountInfo.ncbStatementSavingAccountViewController() {
            _vc.generalSavingAccountInfo = generalSavingAccountInfoModel
            navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
    @IBAction func settlementButtonClicked(_ sender: Any) {
        if let model = savingAccountInfoModel, let vc = R.storyboard.saving.ncbDetailSavingFinalSettlementAccountViewController() {
            vc.acctNo = model.account
            vc.savingNo = model.savingNumber
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupData(with model: NCBDetailSavingAccountModel?) {
        detailSavingAccountArr = []
        detailSavingAccountArr.append(DetailSavingAccountModel.init(titles: "Số tài khoản tiết kiệm", value: model?.account ?? ""))
        detailSavingAccountArr.append(DetailSavingAccountModel.init(titles: "Số dư hiện tại", value: "", amount: model?.balance, ccy: model?.ccy))
        
        detailSavingAccountArr.append(DetailSavingAccountModel.init(titles: "Ngày mở", value: model?.openDate ?? "", title2: "Ngày đáo hạn", value2: model?.matDate ?? ""))
        
        detailSavingAccountArr.append(DetailSavingAccountModel.init(titles: "Lãi suất", value: (model?.interst != nil) ? "\(model?.interst ?? 0.0)%/năm" : ""))
        detailSavingAccountArr.append(DetailSavingAccountModel.init(titles: "Sản phẩm", value: model?.prodName ?? ""))
        detailSavingAccountArr.append(DetailSavingAccountModel.init(titles: "Kênh thực hiện", value: model?.channel ?? ""))
        
        detailSavingAccountInfoTbl.reloadData()
    }
}

extension NCBDetailSavingAccountInfoViewController {
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("TÀI KHOẢN TIẾT KIỆM")
        
        settlementView.isHidden = true
        statementView.isHidden = true
        
        if let saving = generalSavingAccountInfoModel {
            if let type = saving.type, type.lowercased() == "ac" {
                statementView.isHidden = false
            }
            
            if saving.accountType == "2" {
                settlementView.isHidden = false
            }
        }
        
        SVProgressHUD.show()
        p = NCBDetailSavingAccountInfoPresenter()
        p?.getDetailSavingAccount(params: createRequestDetailSavingAccountParams())
        p?.delegate = self
    }
}

extension NCBDetailSavingAccountInfoViewController: NCBDetailSavingAccountInfoPresenterDelegate {
    
    func getDetailSavingAccountCompleted(savingAccount: NCBDetailSavingAccountModel?, error: String?) {
        
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }
        
        savingAccountInfoModel = savingAccount
        setupData(with: savingAccount)
    }
    func createRequestDetailSavingAccountParams() -> [String : Any]{
        let params: [String : Any] = [
            "username" : NCBShareManager.shared.getUser()?.username ?? "",
            "cifno" : NCBShareManager.shared.getUser()?.cif ?? 0,
            "acctNo" : generalSavingAccountInfoModel?.account ?? 0,
            "savingNo" : generalSavingAccountInfoModel?.savingNumber ?? 0
        ]
        
        return params
    }
}

extension NCBDetailSavingAccountInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailSavingAccountArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let model = detailSavingAccountArr[indexPath.row] as? DetailSavingAccountModel {
            if let title2 = model.title2, !title2.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbDetailSavingAccountCell.identifier, for: indexPath) as! NCBDetailSavingAccountCell
                
                cell.lbTitle.text = model.titles
                cell.lbValue.text = model.value
                
                cell.lbTitle2.text = model.title2
                cell.lbValue2.text = model.value2
                
                return cell
                
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardDetailTableViewCellID.identifier, for: indexPath) as! NCBCreditCardDetailTableViewCell
                
                cell.lbTitle.text = model.titles
                cell.lbValue.text = model.value
                
                if indexPath.row == 0 {
                    cell.lbValue.font = semiboldFont(size: 18)
                } else {
                    cell.lbValue.font = semiboldFont(size: 14)
                }
                
                if let _ = model.amount {
                    cell.lbValue.text = model.getAmountDisplay()
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
