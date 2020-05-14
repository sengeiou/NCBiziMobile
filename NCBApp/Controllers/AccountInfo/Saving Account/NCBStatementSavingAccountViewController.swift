//
//  NCBStatementSavingAccountViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SnapKit

class NCBStatementSavingAccountViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var accountView: NCBRoundedAndShadowView!
    
    @IBOutlet weak var accountTypeLbl : UILabel! {
        didSet {
            accountTypeLbl.font = regularFont(size: 12)
            accountTypeLbl.textColor = UIColor.white
            accountTypeLbl.text = "Tài khoản tiết kiệm"
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
            balanceLbl.text = "Số dư hiện tại"
            balanceLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var detailAccountBtn: UIButton!{
        didSet {
            detailAccountBtn.setImage(UIImage(named: "ic_accountInfo_right"), for: .normal)
            detailAccountBtn.addTarget(self, action: #selector(showAccount(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var lbDateFrom: UILabel!
    @IBOutlet weak var lbDateFromValue: UILabel!
    @IBOutlet weak var lbDateTo: UILabel!
    @IBOutlet weak var lbDateToValue: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    // MARK: - Properties
    
    var generalSavingAccountInfo: NCBGeneralSavingAccountInfoModel?
    fileprivate var listSavingAccount: [NCBGeneralSavingAccountInfoModel] = []
    var p: NCBStatementSavingAccountPresenter?
    var savingPresenter: NCBSavingAccountPresenter?
    fileprivate var isShowAccount = false
    
    fileprivate var pageIndex: Int = 0
    fileprivate var startDate: Date?
    fileprivate var endDate: Date?
    fileprivate var isChoosingStart = true
    fileprivate var isLoadingData = false
    fileprivate var historyList = [NCBDetailStatementSavingAccountModel]()
    fileprivate var listMonthWithoutArrange: [[NCBDetailStatementSavingAccountModel]] = []
    fileprivate var monthSet: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        pageIndex = 0
        historyList = []
    }
    
    @IBAction func showDateStartAction(_ sender: Any) {
        isChoosingStart = true
        showDate()
    }
    
    @IBAction func showDateEndAction(_ sender: Any) {
        if startDate == nil {
            showAlert(msg: "Vui lòng chọn Từ ngày")
            return
        }
        isChoosingStart = false
        showDate()
    }
    
}

extension NCBStatementSavingAccountViewController {
    
    override func setupView() {
        super.setupView()
        
        accountSerieLbl.text = generalSavingAccountInfo?.account
        surplusLbl.text = Double(generalSavingAccountInfo?.balance ?? 0).currencyFormatted
        
        renderAccountView()
        
        lbDateFrom.font = semiboldFont(size: 12)
        lbDateFrom.textColor = ColorName.blurNormalText.color
        
        lbDateFromValue.font = semiboldFont(size: 12)
        lbDateFromValue.textColor = UIColor(hexString: "959595")
        lbDateFromValue.text = "_ _ /_ _ /_ _"
        
        lbDateTo.font = semiboldFont(size: 12)
        lbDateTo.textColor = ColorName.blurNormalText.color
        
        lbDateToValue.font = semiboldFont(size: 12)
        lbDateToValue.textColor = UIColor(hexString: "959595")//ColorName.amountBlueText.color
        lbDateToValue.text = "_ _ /_ _ /_ _"//ddMMyyyyFormatter.string(from: endDate)
        
        tblView.register(UINib(nibName: R.nib.ncbStatmentSavingAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbStatmentSavingAccountTableViewCell.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        
        p = NCBStatementSavingAccountPresenter()
        p?.delegate = self
        getHistory()
        
        savingPresenter = NCBSavingAccountPresenter()
        savingPresenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("SAO KÊ TÀI KHOẢN TIẾT KIỆM")
        lbDateFrom.text = "Từ ngày:"
        lbDateTo.text = "Đến:"
    }
    
    @objc func showAccount(_ sender: UIButton) {
        if isShowAccount == false {
//            isShowAccount = true
//            renderAccountView()
            showlistSavingAccount()
        }else{
//            if let _vc = R.storyboard.accountInfo.ncbDetailSavingAccountInfoViewController() {
//                _vc.generalSavingAccountInfoModel = generalSavingAccountInfo
//                self.navigationController?.pushViewController(_vc, animated: true)
//            }
        }
        
    }
    
    fileprivate func getHistory() {
        let params: [String: Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "acctNo": generalSavingAccountInfo?.account ?? "",
            "savingNo": generalSavingAccountInfo?.savingNumber ?? "",
            "fromDate": (startDate != nil) ? ddMMyyyyFormatter.string(from: startDate!) : "",
            "toDate": ddMMyyyyFormatter.string(from: endDate ?? Date()),
            "pageSize"  : 10,
            "pageIndex" : pageIndex
        ]
        
        isLoadingData = true
        SVProgressHUD.show()
        p?.getSavingHistory(params: params)
    }
    
    fileprivate func getSavingAccountList() {
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
        ]
        
        savingPresenter?.getListSavingAccount(params: params)
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
    
    fileprivate func showDate() {
        let calendar = NCBDayFlowViewController()
        calendar.delegate = self
        calendar.dateSelected = isChoosingStart ? startDate : endDate
        showBottomSheet(controller: calendar, size: 530)
    }
    
    fileprivate func getMonthArray() {
        monthSet = []
        if historyList.count > 0 {
            for dealStament in historyList {
                monthSet.insert(dealStament.getMonthName())
            }
        }
        monthSet.reversed()
        listMonthWithoutArrange = Array(repeating: [], count: Array(monthSet).count)
    }
    
    fileprivate func assignListFollowMonth() {
        for i in 0..<Array(monthSet).count {
            listMonthWithoutArrange[i] = historyList.filter({ $0.getMonthName() == Array(monthSet)[i] })
        }
    }
    
    @objc fileprivate func showlistSavingAccount() {
        if let controller = R.storyboard.bottomSheet.ncbListSavingAccountViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listSavingAccount)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (pageIndex + 1) >= p?.totalPage ?? 0 {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height + 20 {
            if isLoadingData {
                return
            }
            pageIndex += 1
            getHistory()
        }
    }
    
}

extension NCBStatementSavingAccountViewController: NCBListSavingAccountViewControllerDelegate {
    
    func didSelectAccount(_ account: NCBGeneralSavingAccountInfoModel) {
        closeBottomSheet()
        
        generalSavingAccountInfo = account
        accountSerieLbl.text = generalSavingAccountInfo?.account
        surplusLbl.text = Double(generalSavingAccountInfo?.balance ?? 0).currencyFormatted
        
        pageIndex = 0
        historyList = []
        getHistory()
    }
    
}

extension NCBStatementSavingAccountViewController: NCBDayFlowViewControllerDelegate {
    
    func dateDidSelect(_ date: Date) {
        pageIndex = 0
        historyList = []
        if isChoosingStart {
            if let end = endDate, date > end {
                showAlert(msg: "Ngày không hợp lệ")
                return
            }
            
            lbDateFromValue.text = ddMMyy.string(from: date)
            lbDateFromValue.textColor = ColorName.amountBlueText.color
            startDate = date
        } else {
            if let start = startDate, start > date {
                showAlert(msg: "Ngày không hợp lệ")
                return
            }
            
            lbDateToValue.text = ddMMyy.string(from: date)
            endDate = date
        }
        
        if startDate != nil && endDate != nil {
            getHistory()
        }
    }
    
}

extension NCBStatementSavingAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Array(monthSet).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMonthWithoutArrange[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbStatmentSavingAccountTableViewCell.identifier, for: indexPath) as! NCBStatmentSavingAccountTableViewCell
        
        let item = listMonthWithoutArrange[indexPath.section][indexPath.row]
        cell.setupData(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white
        
        let lbTitle = UILabel()
        lbTitle.font = semiboldFont(size: 10)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = "Tháng \(Array(monthSet)[section])"
        header.addSubview(lbTitle)
        
        lbTitle.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "959595")
        header.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview()
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}

extension NCBStatementSavingAccountViewController: NCBStatementSavingAccountPresenterDelegate {
    
    func getSavingHistoryCompleted(historyList: [NCBDetailStatementSavingAccountModel]?, error: String?) {
        isLoadingData = false
        
        if let error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: error)
            return
        }
        
        self.historyList += historyList ?? []
        
        getMonthArray()
        assignListFollowMonth()
        tblView.reloadData()
        if listSavingAccount.count == 0 {
            getSavingAccountList()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
}

extension NCBStatementSavingAccountViewController: NCBSavingAccountPresenterDelegate{
    
    func getListSavingAccount(services: [NCBGeneralSavingAccountInfoModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let data = services, data.count > 0 {
            let sortedData = data.sorted() {
                $0.getDueDate() < $1.getDueDate()
            }
            
            self.listSavingAccount = sortedData
            
            let item = listSavingAccount.first(where: { $0.account == generalSavingAccountInfo?.account })
            item?.isSelected = true
        }
    }
    
}
