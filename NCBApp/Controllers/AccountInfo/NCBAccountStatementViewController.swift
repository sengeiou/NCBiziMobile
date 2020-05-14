//
//  NCBAccountStatementViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/15/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBAccountStatementViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var accountView :NCBRoundedAndShadowView!
    
    @IBOutlet weak var accountTypeLbl : UILabel! {
        didSet {
            accountTypeLbl.font = regularFont(size: 12)
            accountTypeLbl.textColor = UIColor.white
        }
    }
    @IBOutlet weak var accountSerieLbl: UILabel! {
        didSet {
            accountSerieLbl.font = regularFont(size: 12)
            accountSerieLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var surplusLbl: NCBCurrencyLabel! {
        didSet {
            surplusLbl.font = boldFont(size: 18)
            surplusLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var lineLbl: UILabel! {
        didSet {
            lineLbl.backgroundColor = UIColor(hexString: "049BD4")
        }
    }
    
    @IBOutlet weak var balanceLbl: UILabel! {
        didSet {
            
            balanceLbl.font = regularFont(size: 12)
            balanceLbl.text = "Số dư tài khoản"
            balanceLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var detailAccountBtn: UIButton!{
        didSet {
            detailAccountBtn.setImage(UIImage(named: "ic_accountInfo_right"), for: .normal)
            detailAccountBtn.addTarget(self, action: #selector(showAccount(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var lbStartDateValue: UILabel!
    @IBOutlet weak var lbEndDate: UILabel!
    @IBOutlet weak var lbEndDateValue: UILabel!
    
    @IBOutlet weak var listStatementDealTbl: UITableView! {
        didSet {
            listStatementDealTbl.register(UINib(nibName: R.nib.ncbCreditCardGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier)
            listStatementDealTbl.delegate = self
            listStatementDealTbl.dataSource = self
            listStatementDealTbl.separatorStyle = .none
            listStatementDealTbl.estimatedRowHeight = 80
            listStatementDealTbl.rowHeight = UITableView.automaticDimension
        }
    }
    
    // MARK: - Properties
    
    var accountInfo: NCBDetailPaymentAccountModel?
    var listPaymentAccount: [NCBDetailPaymentAccountModel] = []
    var monthSet: Set<String> = []
    var listTransactionType = [NCBTransactionTypeModel]()
    var listDealStatement: [NCBDetailHistoryDealItemModel] = []
    var listMonthWithoutArrange: [[NCBDetailHistoryDealItemModel]] = []
    var pageIndex: Int = 0
    
    var p: NCBAccountStatementPresenter?
    fileprivate var refreshTokenPresenter: NCBOTPAuthenticationPresenter?
    
    fileprivate var isShowAccount = false
    var surplus: Double = 0.0 {
        didSet {
            surplusLbl.currencyLabel(with: surplus, and: "vi_VN")
        }
    }
    fileprivate var startDate: Date?
    fileprivate var endDate: Date?
    fileprivate var isChoosingStart = true
    fileprivate var isLoadingData = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func showAccount(_ sender: UIButton) {
        if isShowAccount == false {
//            isShowAccount = true
//            renderAccountView()
            showOriginalAccountList()
        } else{
//            if let _vc = R.storyboard.accountInfo.ncbDetailAccountViewController() {
//                _vc.viewAccountMode = .normal
//                _vc.accountInfoModel = self.accountInfo
//                self.navigationController?.pushViewController(_vc, animated: true)
//            }
        }
        
    }
    
    @IBAction func showStartDateAction(_ sender: Any) {
        isChoosingStart = true
        showDate()
    }
    
    @IBAction func showEndDateAction(_ sender: Any) {
        if startDate == nil {
            showAlert(msg: "ACCOUNTSTATEMENT-1".getMessage() ?? "Vui lòng chọn Từ ngày")
            return
        }
        isChoosingStart = false
        showDate()
    }
    
}

extension NCBAccountStatementViewController {
    
    override func setupView() {
        super.setupView()
        
        surplus = Double(accountInfo?.curBal ?? 0)
        accountTypeLbl.text = accountInfo?.categoryName ?? ""
        accountSerieLbl.text = accountInfo?.acctNo
        
        lbStartDate.font = semiboldFont(size: 12)
        lbStartDate.textColor = ColorName.blurNormalText.color
        lbStartDate.text = "Từ ngày:"
        
        lbStartDateValue.font = semiboldFont(size: 12)
        lbStartDateValue.textColor = UIColor(hexString: "959595")
        lbStartDateValue.text = "_ _ /_ _ /_ _"
        
        lbEndDate.font = semiboldFont(size: 12)
        lbEndDate.textColor = ColorName.blurNormalText.color
        lbEndDate.text = "Đến ngày:"
        
        lbEndDateValue.font = semiboldFont(size: 12)
        lbEndDateValue.textColor = UIColor(hexString: "959595")//ColorName.amountBlueText.color
        lbEndDateValue.text = "_ _ /_ _ /_ _"//ddMMyyyyFormatter.string(from: endDate)
        
        renderAccountView()
        
        for payment in listPaymentAccount {
            payment.isSelected = (payment.acctNo == accountInfo?.acctNo)
        }
        
        p = NCBAccountStatementPresenter()
        p?.delegate = self
        
        refreshTokenPresenter = NCBOTPAuthenticationPresenter()
        refreshTokenPresenter?.delegate = self
        
        SVProgressHUD.show()
        refreshTokenPresenter?.refreshToken()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("SAO KÊ TÀI KHOẢN")
    }

}

extension NCBAccountStatementViewController {
    
    func setupParams() -> [String : Any]{
        let params: [String : Any] = [
            "username"  : NCBShareManager.shared.getUser()?.username ?? "",
            "accountNo" : accountInfo?.acctNo ?? "",
            "cifno"     : accountInfo?.cifNo ?? 0,
            "startDate": (startDate != nil) ? ddMMyyyyFormatter.string(from: startDate!) : "",
            "endDate": ddMMyyyyFormatter.string(from: endDate ?? Date()),
            "pageSize"  : 10,
            "pageIndex" : pageIndex
        ]
        return params
    }
    
    func getMonthArray() {
        monthSet = []
        if listDealStatement.count > 0 {
            for dealStament in listDealStatement {
                monthSet.insert(dealStament.getMonthName())
            }
        }
        
        monthSet.reversed()
        listMonthWithoutArrange = Array(repeating: [], count: Array(monthSet).count)
    }
    
    func assignListDealFollowMonth() {
        for i in 0..<Array(monthSet).count {
            listMonthWithoutArrange[i] = listDealStatement.filter({ $0.getMonthName() == Array(monthSet)[i] })
        }
    }
    
    fileprivate func renderAccountView() {
        if !self.isShowAccount {
            self.lineLbl.isHidden = !self.isShowAccount
            self.surplusLbl.isHidden = !self.isShowAccount
            self.balanceLbl.isHidden = !self.isShowAccount
            self.changeImageForDetailAccountBtn()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            for constraint in self.accountView.constraints {
                if constraint.firstAttribute == .height {
                    constraint.constant = self.isShowAccount ? 158 : 56
                    break
                }
            }
            self.view.layoutIfNeeded()
        }) { (finish) in
            if self.isShowAccount {
                self.lineLbl.isHidden = !self.isShowAccount
                self.surplusLbl.isHidden = !self.isShowAccount
                self.balanceLbl.isHidden = !self.isShowAccount
                self.changeImageForDetailAccountBtn()
            }
        }
    }
    
    func changeImageForDetailAccountBtn()  {
        if !isShowAccount {
            self.detailAccountBtn.setImage(UIImage(named: "ic_accountInfo_bottom"), for: .normal)
        }else{
            detailAccountBtn.setImage(UIImage(named: "ic_accountInfo_right"), for: .normal)
        }
    }
    
    fileprivate func getStatementList() {
//        if isLoadingData {
//            return
//        }
        isLoadingData = true
        SVProgressHUD.show()
        p?.getListDealStatement(params: setupParams())
    }
    
    fileprivate func showDate() {
        let calendar = NCBDayFlowViewController()
        calendar.delegate = self
        calendar.dateSelected = isChoosingStart ? startDate : endDate
        showBottomSheet(controller: calendar, size: 530)
    }
    
    fileprivate func showOriginalAccountList() {
        if let controller = R.storyboard.bottomSheet.ncbSourceAccountViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listPaymentAccount)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if p?.lastPage == true {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height + 20 {
            if isLoadingData {
                return
            }
            pageIndex += 1
            getStatementList()
        }
    }
    
}

extension NCBAccountStatementViewController: NCBSourceAccountViewControllerDelegate {
    
    func didSelectSourceAccount(_ account: NCBDetailPaymentAccountModel) {
        closeBottomSheet()
        accountInfo = account
        accountTypeLbl.text = accountInfo?.categoryName ?? ""
        accountSerieLbl.text = accountInfo?.acctNo
        
        pageIndex = 0
        listDealStatement = []
        getStatementList()
    }
    
}

extension NCBAccountStatementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Array(monthSet).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMonthWithoutArrange[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbPaymentAccountStatementHeaderView.firstView(owner: self)!
        header.lbTitle.text = "Tháng \(Array(monthSet)[section])"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBCreditCardGeneralInfoTableViewCell
        let item = listMonthWithoutArrange[indexPath.section][indexPath.row]
        cell.setupDataForTopTen(item)
        cell.lbContent.text = item.getTransactionType(listTransactionType)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listMonthWithoutArrange[indexPath.section][indexPath.row]
        let popup = R.nib.ncbPaymentAccountHistoryDetailPopupView.firstView(owner: self)!
        popup.setData(item)
        showPopupView(sourceView: popup, size: 385)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension NCBAccountStatementViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func refreshTokenCompleted(error: String?) {
        SVProgressHUD.dismiss()
        getStatementList()
    }
    
}

extension NCBAccountStatementViewController: NCBAccountStatementPresenterDelegate {
    
    func getDealStatementCompleted(listDealStatement: [NCBDetailHistoryDealItemModel]?, error: String?) {
        SVProgressHUD.dismiss()
        isLoadingData = false
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        self.listDealStatement += listDealStatement ?? []
        
        getMonthArray()
        assignListDealFollowMonth()
        listStatementDealTbl.reloadData()
    }
    
}

extension NCBAccountStatementViewController: NCBDayFlowViewControllerDelegate {
    
    func dateDidSelect(_ date: Date) {
        pageIndex = 0
        listDealStatement = []
        if isChoosingStart {
            if let end = endDate, date > end {
                showAlert(msg: "Ngày không hợp lệ")
                return
            }
            
            lbStartDateValue.text = ddMMyy.string(from: date)
            lbStartDateValue.textColor = ColorName.amountBlueText.color
            startDate = date
        } else {
            if let start = startDate, start > date {
                showAlert(msg: "Ngày không hợp lệ")
                return
            }
            
            lbEndDateValue.text = ddMMyy.string(from: date)
            lbEndDateValue.textColor = ColorName.amountBlueText.color
            endDate = date
        }
        
        if startDate != nil && endDate != nil {
            getStatementList()
        }
    }
    
}
