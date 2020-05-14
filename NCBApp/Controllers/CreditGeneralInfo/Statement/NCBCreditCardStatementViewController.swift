//
//  NCBCreditCardStatementViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBCreditCardStatementViewController: NCBBaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var lbCardNumberTitle: UILabel!
    @IBOutlet weak var lbCardNumberValue: UILabel!
    @IBOutlet weak var lbStatementPeriodTitle: UILabel!
    @IBOutlet weak var lbStatementPeriodValue: UILabel!
    @IBOutlet weak var containerDebtView: UIView!
    @IBOutlet weak var lbDebtBeginTitle: UILabel!
    @IBOutlet weak var lbDebtBeginValue: UILabel!
    @IBOutlet weak var lbDebtEndTitle: UILabel!
    @IBOutlet weak var lbDebtEndValue: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bgDefaultCard: UIImageView!
    
    //MARK: Properties
    
    var creditCardInfo: NCBCreditCardModel?
    var p: NCBCreditCardStatementPresenter?
    fileprivate var billList = [NCBBillStatementModel]()
    fileprivate var accountStatement: NCBAccountStatementModel?
    fileprivate var statementList = [NCBCreditCardDealHistoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showBillStatement(_ sender: Any) {
        var items = [BottomSheetStringItem]()
        for item in billList {
            if let date = yyyyMMdd.date(from: item.bildate ?? "") {
                let title = monthYearFormatter.string(from: date)
                items.append(BottomSheetStringItem(title: title, isCheck: (title == lbStatementPeriodValue.text)))
            }
        }
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.setData("Sao kê thẻ tín dụng", items: items, isHasOptionItem: true)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 300)
        }
    }
    
}

extension NCBCreditCardStatementViewController {
    
    override func setupView() {
        super.setupView()
        
        if let imgUrl = URL(string: creditCardInfo?.parCardProduct?.linkUlr?.replacingSpace ?? "") {
            bgDefaultCard.kf.setImage(with: imgUrl)
        }
        
        lbCardNumberTitle.font = regularFont(size: 12)
        lbCardNumberTitle.textColor = UIColor.white
        
        lbCardNumberValue.font = regularFont(size: 12)
        lbCardNumberValue.textColor = UIColor.white
        lbCardNumberValue.text = creditCardInfo?.cardno?.cardHidden
        
        lbStatementPeriodTitle.font = semiboldFont(size: 12)
        lbStatementPeriodTitle.textColor = ColorName.blurNormalText.color
        
        lbStatementPeriodValue.font = semiboldFont(size: 12)
        lbStatementPeriodValue.textColor = ColorName.amountBlueText.color
        
        lbDebtBeginTitle.font = semiboldFont(size: 10)
        lbDebtBeginTitle.textColor = ColorName.blurNormalText.color
        lbDebtBeginValue.font = semiboldFont(size: 10)
        lbDebtBeginValue.textColor = ColorName.blurNormalText.color
        
        lbDebtEndTitle.font = semiboldFont(size: 10)
        lbDebtEndTitle.textColor = ColorName.blurNormalText.color
        lbDebtEndValue.font = semiboldFont(size: 10)
        lbDebtEndValue.textColor = ColorName.blurNormalText.color
        
        if let creditCard = creditCardInfo, !creditCard.isPrimaryCard {
            containerDebtView.isHidden = true
            for constraint in containerDebtView.constraints {
                if constraint.firstAttribute == .height {
                    constraint.constant = 0
                    break
                }
            }
        }
        
        tblView.register(UINib(nibName: R.nib.ncbCreditCardGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableView.automaticDimension
        
        p = NCBCreditCardStatementPresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getBillStatementList(creditCardInfo?.cardno ?? "")
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Sao kê thẻ tín dụng")
        
        lbStatementPeriodTitle.text = "Chọn kỳ sao kê:"
        lbStatementPeriodValue.text = "..."
        lbCardNumberTitle.text = "Số thẻ"
        lbDebtBeginTitle.text = "Dư nợ đầu kỳ"
        lbDebtEndTitle.text = "Dư nợ cuối kỳ"
    }
    
    fileprivate func getAccountStatementList(_ bill: NCBBillStatementModel) {
        guard let date = yyyyMMdd.date(from: bill.bildate ?? "") else {
            return
        }
        
        let params: [String: Any] = [
            "userId": NCBShareManager.shared.getUserID(),
            "cardNo": creditCardInfo?.cardno ?? "",
            "statementMonth": statementMonthDf.string(from: date),
            "primarycard": creditCardInfo?.primarycard ?? 0,
            "cifno": NCBShareManager.shared.getUser()?.cif ?? ""
        ]
        
        SVProgressHUD.show()
        p?.getAccountStatementList(params)
    }
    
}
extension NCBCreditCardStatementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBCreditCardGeneralInfoTableViewCell
        cell.selectionStyle = .none
        
        let item = statementList[indexPath.row]
        cell.setupData(item)
        
        return cell
    }
    
}

extension NCBCreditCardStatementViewController: NCBCreditCardStatementPresenterDelegate {
    
    func getBillStatementListCompleted(_ billList: [NCBBillStatementModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let billList = billList {
            self.billList = billList
            if let item = billList.first {
                if let date = yyyyMMdd.date(from: item.bildate ?? "") {
                    let title = monthYearFormatter.string(from: date)
                    lbStatementPeriodValue.text = title
                }
                
                getAccountStatementList(item)
            } else {
                showError(msg: ErrorConstant.crdCardNoStatement.getMessage() ?? "Thẻ của quý khách chưa phát sinh sao kê") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func getAccountStatementListCompleted(_ statement: NCBAccountStatementModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        accountStatement = statement
        lbDebtBeginValue.text = statement?.getOpeningBalance
        lbDebtEndValue.text = statement?.getClosingBalance
        
//        if let statementList = statement?.lstPreCrCardHistory {
//            self.statementList = statementList
//            tblView.reloadData()
//        }
        
        self.statementList = statement?.lstPreCrCardHistory ?? []
        tblView.reloadData()
        
        if self.statementList.count == 0 {
            showAlert(msg: ErrorConstant.crdCardNoStatementData.getMessage() ?? "")
        }
    }
    
}

extension NCBCreditCardStatementViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        closeBottomSheet()
        lbStatementPeriodValue.text = item
        getAccountStatementList(billList[index])
    }
    
}
