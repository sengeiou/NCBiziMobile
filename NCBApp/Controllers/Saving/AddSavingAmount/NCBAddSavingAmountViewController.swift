//
//  NCBAddSavingAmountViewController.swift
//  NCBApp
//
//  Created by Van Dong on 20/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBAddSavingAmountViewController: NCBBaseTransactionViewController {
    @IBOutlet weak var sourceAccountView: UIView!
    @IBOutlet weak var savingAccountView: UIView!
    @IBOutlet weak var transferAmountView: NCBTransferAmountView!
    @IBOutlet weak var lbInterestRate: UILabel! {
        didSet{
            lbInterestRate.textColor = UIColor(hexString: "0083DC")
            lbInterestRate.font = regularFont(size: 12)
        }
    }
    @IBOutlet weak var btContinue: UIButton!{
        didSet{
            btContinue.setTitle("Tiếp tục", for: .normal)
        }
    }
    
    
    @IBOutlet weak var heightSavingAccountView: NSLayoutConstraint!
    
    fileprivate var sourceAccountInfoView: NCBSourceAccountView?
    fileprivate var savingAccountInfoView: NCBSavingAccountView?
    fileprivate var listSavingAccount: [NCBGeneralSavingAccountInfoModel] = []
    fileprivate var savingAccount: NCBGeneralSavingAccountInfoModel?
    var p: NCBSavingAccountPresenter?
    fileprivate var interstRate = ""
    fileprivate var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSourceAccountPaymentList()
        clearData()
        isFirstLoad = false
    }
    
    @IBAction func clickContinue(_ sender: Any) {
        if savingAccountInfoView?.account.text == "Chọn tài khoản tiết kiệm"{
            showAlert(msg: "Vui lòng chọn tài khoản tiết kiệm")
            return
        }
        if transferAmountView.textField.text == "" {
            showAlert(msg: "Vui lòng nhập số tiền")
            return
        }
        
        let amount = Double(transferAmountView.textField.text!.removeSpecialCharacter) ?? 0.0
        
        if invalidTransferAmount(amount, type: .additionalSavingAccount, limitType: .min) {
            showAlert(msg: "TRANSFER-1".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối thiểu 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if invalidTransferAmount(amount, type: .additionalSavingAccount, limitType: .max) {
            showAlert(msg: "TRANSFER-2".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối đa 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceRechargeMoney(acctNo: sourceAccount?.acctNo ?? "", amt: amount)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        
        if result {
            if let vc = R.storyboard.saving.ncbTransferInfoSavingViewController(){
                vc.transferInfomation = TransferInfomationModel(amount: self.transferAmountView.textField!.text, interest: interstRate, sourceAccount: sourceAccountInfoView?.lbSourceAccountValue.text, balSourceAcount: savingAccountInfoView?.balance.text, savingAccount: savingAccountInfoView?.account.text, termDest: savingAccountInfoView?.termDest.text)
                vc.exceedLimit = exceedLimit(Double(transferAmountView.textField.text!.removeSpecialCharacter) ?? 0.0, type: .additionalSavingAccount)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
extension NCBAddSavingAmountViewController {
    override func setupView() {
        super.setupView()
        
        sourceAccountInfoView = R.nib.ncbSourceAccountView.firstView(owner: self)
        sourceAccountView.addSubview(sourceAccountInfoView!)
        sourceAccountInfoView?.snp.makeConstraints {(make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        sourceAccountInfoView?.delegate = self
        
        savingAccountInfoView = R.nib.ncbSavingAccountView.firstView(owner: self)
        savingAccountView.addSubview(savingAccountInfoView!)
        savingAccountInfoView?.snp.makeConstraints {(make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        savingAccountInfoView?.delegate = self
        savingAccountInfoView?.tittleSavingAccount.isHidden = true
        savingAccountInfoView?.balance.isHidden = true
        savingAccountInfoView?.dueDate.isHidden = true
        savingAccountInfoView?.termDest.isHidden = true
        heightSavingAccountView.constant = CGFloat(60)
        
        transferAmountView.textField.placeholder = "Số tiền gửi"
        lbInterestRate.text = ""
        
        p = NCBSavingAccountPresenter()
        p?.delegate = self
    }
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Nộp thêm tiết kiệm tích luỹ")
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func loadDefaultSourceAccount() {
        super.loadDefaultSourceAccount()
        
        guard let sourceAccount = sourceAccount else {
                return
            }
        sourceAccountInfoView?.setSourceAccount(sourceAccount.acctNo)
        sourceAccountInfoView?.setSourceName(sourceAccount.acName)
        sourceAccountInfoView?.setSourceBalance(sourceAccount.curBal)
        
        SVProgressHUD.show()
        p?.getListSavingAccount(params: getSavingAccountParams())
    }
    
    func getSavingAccountParams() -> [String : Any] {
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0,
        ]
        return params
    }
    func createRequestDetailSavingAccountParams() -> [String : Any]{
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0,
            "acctNo" : savingAccount?.account ?? "",
            "savingNo" : savingAccount?.savingNumber ?? "",
        ]
        return params
    }
    
    fileprivate func clearData() {
        if NCBShareManager.shared.areTrading || isFirstLoad {
            return
        }
        
        transferAmountView.clear()
        defaultSourceAccount()
    }

}
extension NCBAddSavingAmountViewController: NCBSourceAccountViewDelegate,NCBSavingAccountViewDelegate{
    func savingAccountDidSelect() {
        showlistSavingAccount()
    }
    
    func sourceDidSelect() {
        showOriginalAccountList()
    }
    
    @objc fileprivate func showOriginalAccountList() {
        if let controller = R.storyboard.bottomSheet.ncbSourceAccountViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listPaymentAccount)
        }
    }
    
    @objc fileprivate func showlistSavingAccount() {
        if listSavingAccount.count == 0 {
            showError(msg: "Quý khách không có tài khoản tiết kiệm nào") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        if let controller = R.storyboard.bottomSheet.ncbListSavingAccountViewController() {
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listSavingAccount)
        }
    }

}
extension NCBAddSavingAmountViewController:  NCBSourceAccountViewControllerDelegate, NCBListSavingAccountViewControllerDelegate {
    func didSelectAccount(_ account: NCBGeneralSavingAccountInfoModel) {
        savingAccountInfoView?.tittleSavingAccount.text = "Đến tài khoản tiết kiệm"
        savingAccountInfoView?.account.textColor = UIColor.black
        savingAccountInfoView?.tittleSavingAccount.isHidden = false
        savingAccountInfoView?.balance.isHidden = false
        savingAccountInfoView?.dueDate.isHidden = false
        savingAccountInfoView?.termDest.isHidden = false
        heightSavingAccountView.constant = CGFloat(90)
        self.savingAccountInfoView?.setAccount(account.account)
        self.savingAccountInfoView?.setBalance(account.getBalanceDisplay())
        self.savingAccountInfoView?.setDueDate("Ngày đáo hạn: \(account.dueDate ?? "")")
        self.savingAccountInfoView?.setTermDest(account.termDest)
        self.savingAccount = account
        p?.getCurrentRate(params: ["savingAcctNo": account.account ?? ""])
        closeBottomSheet()
    }

    func didSelectSourceAccount(_ account: NCBDetailPaymentAccountModel) {
        self.sourceAccountInfoView?.setSourceAccount(account.acctNo)
        self.sourceAccountInfoView?.setSourceName(account.acName)
        self.sourceAccountInfoView?.setSourceBalance(account.curBal)
        self.sourceAccount = account
        closeBottomSheet()
    }

}
extension NCBAddSavingAmountViewController: NCBSavingAccountPresenterDelegate{
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
            let item = listSavingAccount[0]
            item.isSelected = true
            savingAccount = item
            didSelectAccount(item)
        } else {
            showError(msg: "Quý khách không có tài khoản tiết kiệm nào") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getCurrentRateCompleted(rate: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        interstRate = rate ?? ""
        lbInterestRate.text = "Lãi suất gửi hiện tại: \(rate ?? "")%"
    }
    
}
