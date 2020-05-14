//
//  NCBAccountInfoViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBAccountInfoViewController: NCBBaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var accountView :NCBRoundedAndShadowView!
    
    @IBOutlet weak var accountTypeLbl : UILabel! {
        didSet {
            accountTypeLbl.text = accountTypeName
            accountTypeLbl.font = regularFont(size: 12)
            accountTypeLbl.textColor = UIColor.white
        }
    }
    @IBOutlet weak var accountSerieLbl: UILabel! {
        didSet {
            accountSerieLbl.text = accountSerie
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
    
    @IBOutlet weak var statementBtn: NCBStatementButton! {
        didSet {
            statementBtn.setTitle("Sao kê tài khoản", for: .normal)
        }
    }
    
    
    
    @IBOutlet weak var tenNewestDealsLbl: UILabel! {
        didSet {
            tenNewestDealsLbl.text = "10 giao dịch gần nhất"
            tenNewestDealsLbl.font =  semiboldFont(size: 14)
            tenNewestDealsLbl.textColor = UIColor(hexString: "959595")
            
        }
    }
    @IBOutlet weak var searchLbl: UILabel! {
        didSet {
            searchLbl.text = "Tìm giao dịch"
            searchLbl.font =  regularFont(size: 12)
            searchLbl.textColor = UIColor(hexString: "414141")
            
        }
    }
    
    @IBOutlet weak var listNewestDealTbl: UITableView! {
        didSet {
            listNewestDealTbl.register(UINib(nibName: R.nib.ncbCreditCardGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier)
            listNewestDealTbl.delegate = self
            listNewestDealTbl.dataSource = self
            listNewestDealTbl.separatorStyle = .none
            listNewestDealTbl.estimatedRowHeight = 80
            listNewestDealTbl.rowHeight = UITableView.automaticDimension
        }
    }
    
    @IBOutlet weak var detailAccountBtn: UIButton!{
        didSet {
            let img = UIImage(named: "ic_accountInfo_right.pdf")
            detailAccountBtn.setImage(img, for: .normal)
            detailAccountBtn.addTarget(self, action: #selector(showAccount(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var searchBtn: UIButton! {
        didSet {
            searchBtn.setImage(R.image.ic_accountInfo_search(), for: .normal)
            searchBtn.setImage(R.image.ic_accountInfo_search_cancel(), for: .selected)
            searchBtn.addTarget(self, action: #selector(searchDeal(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Properties
    var accountTypeName: String = ""
    var accountSerie: String = ""
    var surplus: Double = 0.0 {
        didSet {
            surplusLbl.currencyLabel(with: surplus, and: "vi_VN")
        }
    }
    
    var topTenDeals: [NCBDetailHistoryDealItemModel] = []
    
    var accountInfoModel: NCBDetailPaymentAccountModel?
    var listPaymentAccount: [NCBDetailPaymentAccountModel] = []
    
    fileprivate var p: NCBAccountInfoPresenter?
    fileprivate var isShowAccount = true
    fileprivate var isSearching = false
    var listTransactionType = [NCBTransactionTypeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchDeal(_ sender: UIButton) {
        if isSearching {
            SVProgressHUD.show()
            p?.getTopTenDeal(params: createTopTenDealParams())
            return
        }
        
        if isShowAccount {
            isShowAccount = false
            renderAccountView()
        }
        
        if let vc = R.storyboard.accountInfo.ncbSearchTransactionPaymentAccountViewController() {
            vc.delegate = self
            vc.accountInfoModel = accountInfoModel
            showBottomSheet(controller: vc, size: 570, disablePanGesture: false, dismissOnBackgroundTap: false)
        }
    }
    
    @IBAction func showAccount(_ sender: UIButton) {
        if isShowAccount == false {
            isShowAccount = true
            renderAccountView()
        }else{
            if let _vc = R.storyboard.accountInfo.ncbDetailAccountViewController() {
                _vc.viewAccountMode = .normal
                _vc.accountInfoModel = self.accountInfoModel
                _vc.listPaymentAccount = listPaymentAccount
                _vc.listTransactionType = listTransactionType
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        }
        
   }
    
    @IBAction func statementAccount(_ sender: UIButton) {
        if let _vc = R.storyboard.accountInfo.ncbAccountStatementViewController() {
            _vc.accountInfo = self.accountInfoModel
            _vc.listPaymentAccount = listPaymentAccount
            _vc.listTransactionType = listTransactionType
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
    func changeImageForDetailAccountBtn()  {
        if !isShowAccount {
            self.detailAccountBtn.setImage(UIImage(named: "ic_accountInfo_bottom"), for: .normal)
        }else{
            detailAccountBtn.setImage(UIImage(named: "ic_accountInfo_right"), for: .normal)
        }
    }
    
    func reloadView() {
        searchBtn.isSelected = isSearching
        tenNewestDealsLbl.text = isSearching ? "Kết quả tìm kiếm" : "10 giao dịch gần nhất"
        searchLbl.text = isSearching ? "Huỷ tìm kiếm" : "Tìm giao dịch"
    }
}

extension NCBAccountInfoViewController {
    
    override func setupView() {
        super.setupView()
        
        surplus = Double(accountInfoModel?.curBal ?? 0)
        accountTypeLbl.text = accountInfoModel?.categoryName ?? ""
        accountSerieLbl.text = accountInfoModel?.acctNo
        
        p = NCBAccountInfoPresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getTopTenDeal(params: createTopTenDealParams())
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Tài khoản thanh toán")
    }
    
    func createTopTenDealParams() -> [String : Any] {
        if let _accountInfoModel = accountInfoModel {
            var params: [String : Any] = [
                "accountNo" : _accountInfoModel.acctNo ?? "",
                "cifno" : _accountInfoModel.cifNo ?? 0
            ]
            if let storedUserInfo = NCBShareManager.shared.getUser() {
                params["username"] = storedUserInfo.username
            }
            return params
        } else {
            return ["": ""]
        }
    }
    
    fileprivate func renderAccountView() {
        if !self.isShowAccount {
            self.lineLbl.isHidden = !self.isShowAccount
            self.surplusLbl.isHidden = !self.isShowAccount
            self.balanceLbl.isHidden = !self.isShowAccount
            self.statementBtn.isHidden = !self.isShowAccount
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
                self.statementBtn.isHidden = !self.isShowAccount
                self.changeImageForDetailAccountBtn()
            }
        }
    }
    
}

extension NCBAccountInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTenDeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCreditCardGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBCreditCardGeneralInfoTableViewCell
        let item = topTenDeals[indexPath.row]
        cell.setupDataForTopTen(item)
        cell.lbContent.text = item.getTransactionType(listTransactionType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = topTenDeals[indexPath.row]
        let popup = R.nib.ncbPaymentAccountHistoryDetailPopupView.firstView(owner: self)!
        popup.setData(item)
        showPopupView(sourceView: popup, size: 385)
    }
}

extension NCBAccountInfoViewController: NCBSearchTransactionPaymentAccountViewControllerDelegate {
    
    func searchDidSelect(params: [String : Any]) {
        closeBottomSheet()
        SVProgressHUD.show()
        p?.searchTransaction(params: params)
    }
    
    func showDate(_ controller: UIViewController) {
        showBottomSheet(controller: controller, size: 530)
    }
    
}

extension NCBAccountInfoViewController: NCBAccountInfoPresenterDelegate {
    
    func getTopTenDealCompleted(listHistoryItems: [NCBDetailHistoryDealItemModel]?, error: String?) {
        isSearching = false
        reloadView()
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        topTenDeals = listHistoryItems ?? []
        listNewestDealTbl.reloadData()
        
        listNewestDealTbl.tableEmptyMessage(topTenDeals.count == 0)
    }
    
    func searchTransactionCompleted(listHistoryItems: [NCBDetailHistoryDealItemModel]?, error: String?) {
        isSearching = true
        reloadView()
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        topTenDeals = listHistoryItems ?? []
        listNewestDealTbl.reloadData()
        
        if topTenDeals.count == 0 {
            showAlert(msg: "Không tìm thấy giao dịch. Quý khách vui lòng thử lại.")
        }
        listNewestDealTbl.tableEmptyMessage(topTenDeals.count == 0)
    }

}
