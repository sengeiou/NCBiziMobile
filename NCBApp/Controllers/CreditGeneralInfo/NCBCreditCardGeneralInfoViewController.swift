//
//  NCBCreditCardGeneralInfoViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCreditCardGeneralInfoViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    var creditCardInfo: NCBCreditCardModel?
    fileprivate var p: NCBCreditCardGeneralInfoPresenter?
    fileprivate var historyList = [NCBCreditCardDealHistoryModel]()
    fileprivate var detailPresenter: NCBCardListPresenter?
    var needGetDetail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func detailAction(_ sender: Any) {
        if let _vc = R.storyboard.accountInfo.ncbCreditCardViewController() {
            _vc.creditCardInfo = creditCardInfo
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
    @IBAction func statementAction(_ sender: Any) {
        if let vc = R.storyboard.creditCard.ncbCreditCardStatementViewController() {
            vc.creditCardInfo = creditCardInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func paymentAction(_ sender: Any) {
        if let vc = R.storyboard.creditCard.ncbCreditCardPaymentViewController() {
            vc.creditCardInfo = creditCardInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBCreditCardGeneralInfoViewController {
    
    override func setupView() {
        super.setupView()
        
        commonCreditCardInfoView?.setData(creditCardInfo)
        
        tblView.register(UINib(nibName: R.nib.ncbCreditCardGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableView.automaticDimension
        
        p = NCBCreditCardGeneralInfoPresenter()
        p?.delegate = self
        
        if !needGetDetail {
            getHistory()
        } else {
            detailPresenter = NCBCardListPresenter()
            detailPresenter?.delegate = self
            getDetail()
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("THẺ TÍN DỤNG")
    }
    
    fileprivate func getHistory() {
        guard let cardInfo = creditCardInfo else {
            return
        }
        
        guard let closingDate = cardInfo.closingDate else {
            showError(msg: ErrorConstant.crdCardLocked.getMessage() ?? "Thẻ đang tạm khoá") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        var params: [String: Any] = [:]
        params["userId"] = NCBShareManager.shared.getUserID()
        params["cardNo"] = cardInfo.cardno ?? ""
        
        if closingDate == "00000000" {
            params["dateFrom"] = cardInfo.accountOpenDate ?? ""
        } else {
            if let date = yyyyMMdd.date(from: closingDate) {
                let appendDate = date.addingTimeInterval(24*60*60)
                params["dateFrom"] = yyyyMMdd.string(from: appendDate)
            }
        }
        
        params["dateTo"] = yyyyMMdd.string(from: Date())
        params["primarycard"] = cardInfo.primarycard ?? 0
        
        SVProgressHUD.show()
        p?.getHistory(params: params)
    }
    
    fileprivate func getDetail() {
        guard let cardInfo = creditCardInfo else {
            return
        }
        
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["cardType"] = CreditCardType.VS.rawValue
        params["cardNo"] = cardInfo.cardno
        
        SVProgressHUD.show()
        detailPresenter?.getCardList(params: params)
    }
    
    fileprivate func showHistoryPopupView(_ item: NCBCreditCardDealHistoryModel) {
        let popup = R.nib.ncbCreditCardHistoryPopupView.firstView(owner: self)!
        popup.setupData(item)
        showPopupView(sourceView: popup, size: 200)
    }
    
}

extension NCBCreditCardGeneralInfoViewController: NCBCreditCardGeneralInfoPresenterDelegate {
    
    func getHistoryCompleted(historyList: [NCBCreditCardDealHistoryModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let historyList = historyList {
            self.historyList = historyList
            tblView.reloadData()
        }
    }
    
}

extension NCBCreditCardGeneralInfoViewController: NCBCardListPresenterDelegate {
    
    func getCardListCompleted(cardList: [NCBCardModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let cardList = cardList, cardList.count > 0 {
            creditCardInfo = cardList[0]
            getHistory()
        }
    }
    
}

extension NCBCreditCardGeneralInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBCreditCardGeneralInfoTableViewCell
        cell.selectionStyle = .none
        
        let item = historyList[indexPath.row]
        cell.setupData(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbCreditCardGeneralInfoHeaderView.firstView(owner: self)!
        if creditCardInfo?.isPrimaryCard ?? true {
            header.lbLimitValue.currencyLabel(with: creditCardInfo?.amountAvailableToSpend ?? 0.0)
        } else {
            header.hiddenLimitView()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHistoryPopupView(historyList[indexPath.row])
    }

}
