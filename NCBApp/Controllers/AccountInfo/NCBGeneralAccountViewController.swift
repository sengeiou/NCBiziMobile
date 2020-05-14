//
//  NCBGeneralAccountViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwipeCellKit

fileprivate let heightForCellWithTitle: CGFloat = 80
fileprivate let heightForCellWithoutTitle: CGFloat = 60

class NCBGeneralAccountViewController: NCBBaseViewController {
    
    @IBOutlet weak var heightGeneralAccountTbl: NSLayoutConstraint!
    @IBOutlet weak var generalAccountTbl: UITableView! {
        didSet {
            generalAccountTbl.register(UINib(nibName: R.nib.ncbSubPaymentAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSubPaymentAccountTableViewCell.identifier)
            generalAccountTbl.register(UINib(nibName: R.nib.ncbGeneralAccountAddTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbGeneralAccountAddTableViewCell.identifier)
            generalAccountTbl.delegate = self
            generalAccountTbl.dataSource = self
            generalAccountTbl.separatorStyle = .none
            generalAccountTbl.clipsToBounds = true
            generalAccountTbl.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var heightSavingTbl: NSLayoutConstraint!
    @IBOutlet weak var savingTbl: UITableView! {
        didSet {
            savingTbl.register(UINib(nibName: R.nib.ncbSavingAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSavingAccountTableViewCell.identifier)
            savingTbl.register(UINib(nibName: R.nib.ncbGeneralAccountAddTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbGeneralAccountAddTableViewCell.identifier)
            savingTbl.delegate = self
            savingTbl.dataSource = self
            savingTbl.separatorStyle = .none
            savingTbl.layer.cornerRadius = 10
            savingTbl.clipsToBounds = true
        }
    }
    @IBOutlet weak var heightCreditTbl: NSLayoutConstraint!
    @IBOutlet weak var creditTbl: UITableView! {
        didSet {
            creditTbl.register(UINib(nibName: R.nib.ncbSubPaymentAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSubPaymentAccountTableViewCell.identifier)
            creditTbl.register(UINib(nibName: R.nib.ncbGeneralAccountAddTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbGeneralAccountAddTableViewCell.identifier)
            creditTbl.delegate = self
            creditTbl.dataSource = self
            creditTbl.separatorStyle = .none
            creditTbl.layer.cornerRadius = 10
            creditTbl.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var heightLoanTbl: NSLayoutConstraint!
    @IBOutlet weak var loanTbl: UITableView! {
        didSet {
            loanTbl.register(UINib(nibName: R.nib.ncbSubPaymentAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbSubPaymentAccountTableViewCell.identifier)
            loanTbl.register(UINib(nibName: R.nib.ncbGeneralAccountAddTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbGeneralAccountAddTableViewCell.identifier)
            loanTbl.delegate = self
            loanTbl.dataSource = self
            loanTbl.separatorStyle = .none
            loanTbl.clipsToBounds = true
            loanTbl.layer.cornerRadius = 10
        }
    }
    
    var accountPresenter: NCBGeneralAccountPresenter?
    
    
    var cifNo: Int = 0
    var listPaymentAccountCA: [NCBDetailPaymentAccountModel] = []
    var listSavingAccount: [NCBSavingAccountModel] = []
    var listDebtAccount: [NCBDebtAccountModel] = []
    var listCreditCard: [NCBCreditCardModel] = []
    
    var isGetSaving = false
    var isGetDebt = false
    var isGetCreaditCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        accountPresenter?.getListPaymentAccount(.INFO)
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBGeneralAccountViewController {
    
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("Thông tin tài khoản")
        
        accountPresenter = NCBGeneralAccountPresenter()
        accountPresenter?.delegate = self
        
        accountPresenter?.findTransactionType()
    }
    
}

extension NCBGeneralAccountViewController {
    
    func createSavingAccountParams() -> [String : Any] {
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0
        ]
        return params
    }
    
    func createDebtAccountParams() -> [String : Any] {
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0
        ]
        return params
    }
    
    func createCreditCardParams() -> [String : Any] {
        let params: [String : Any] = [
            "userId": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0,
            "cardType": CreditCardType.VD.rawValue
        ]
        return params
    }
    
    fileprivate func getHeightTblView(_ tblView: UITableView) -> CGFloat {
        switch tblView {
        case generalAccountTbl:
            return CGFloat(listPaymentAccountCA.count) * heightForCellWithTitle
        case savingTbl:
            return heightForCellWithTitle//(listSavingAccount.count == 0) ? heightForCellWithTitle : CGFloat(listSavingAccount.count)*heightForCellWithoutTitle
        case creditTbl:
            let count = listCreditCard.count
            if count > 1 {
                return heightForCellWithTitle + (CGFloat((count - 1))*heightForCellWithoutTitle)
            } else {
                return heightForCellWithTitle
            }
        case loanTbl:
            let count = listDebtAccount.count
            if count > 1 {
                return heightForCellWithTitle + (CGFloat((count - 1))*heightForCellWithoutTitle)
            } else {
                return heightForCellWithTitle
            }
        default:
            return 0
        }
    }
    
    fileprivate func showInternalTransfer(_ paymentAccount: NCBDetailPaymentAccountModel) {
        if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
            vc.referPaymentAccount = paymentAccount
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showInterbankTransfer(_ paymentAccount: NCBDetailPaymentAccountModel) {
        if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
            vc.referPaymentAccount = paymentAccount
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showStatementScreen(_ creditCardInfo: NCBCreditCardModel) {
        if let vc = R.storyboard.creditCard.ncbCreditCardStatementViewController() {
            vc.creditCardInfo = creditCardInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showPaymentScreen(_ creditCardInfo: NCBCreditCardModel) {
        if let vc = R.storyboard.creditCard.ncbCreditCardPaymentViewController() {
            vc.creditCardInfo = creditCardInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showSavingProductsSheet() {
        var items = [BottomSheetDetailStringItem]()
        items.append(BottomSheetDetailStringItem(title: "Tiết kiệm thường/Tiền gửi có kỳ hạn", detail: "Lãi suất hấp dẫn cao hơn tiết kiệm truyền thống", isCheck: false))
        items.append(BottomSheetDetailStringItem(title: "Tiết kiệm tích luỹ ", detail: "Có thể nộp thêm tiền vài tào khoản tiết kiệm tích lũy bất cứ lúc nào", isCheck: false))
        if let vc = R.storyboard.sendSaving.ncbBottomSheetDetailListViewController() {
            vc.setData("Chọn sản phẩm tiết kiệm", items: items, isHasOptionItem: true)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 330)
        }
    }
    
}



extension NCBGeneralAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case generalAccountTbl:
            return listPaymentAccountCA.count
        case savingTbl:
            if isGetSaving {
                return 1//listSavingAccount.count == 0 ? 1 : listSavingAccount.count
            }
            return 0
        case creditTbl:
            if isGetCreaditCard {
                return listCreditCard.count == 0 ? 1 : listCreditCard.count
            }
            return 0
        case loanTbl:
            if isGetDebt {
                return listDebtAccount.count == 0 ? 1 : listDebtAccount.count
            }
            return 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case generalAccountTbl:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSubPaymentAccountTableViewCell.identifier, for: indexPath) as! NCBSubPaymentAccountTableViewCell
            
            let item = listPaymentAccountCA[indexPath.row]
            cell.setDataForPaymentAccountSection(item)
            cell.seperatorView.isHidden = (indexPath.row == listPaymentAccountCA.count - 1)
            
            cell.internalTransfer = { [weak self] in
                self?.showInternalTransfer(item)
            }
            
            cell.interbankTransfer = { [weak self] in
                self?.showInterbankTransfer(item)
            }
            
            return cell
        case savingTbl:
              if listSavingAccount.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSavingAccountTableViewCell.identifier, for: indexPath) as! NCBSavingAccountTableViewCell
//                cell.savingAccountModel = listSavingAccount[indexPath.row]
                cell.listSavingAccount = listSavingAccount
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbGeneralAccountAddTableViewCell.identifier, for: indexPath) as! NCBGeneralAccountAddTableViewCell
                cell.setTitle(title: "Mở tài khoản tiết kiệm")
                return cell
            }
        case creditTbl:
            if listCreditCard.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSubPaymentAccountTableViewCell.identifier, for: indexPath) as! NCBSubPaymentAccountTableViewCell
                
                let item = listCreditCard[indexPath.row]
                cell.setupDataForCreditCard(item, indexPath: indexPath)
                cell.seperatorView.isHidden = (indexPath.row == listCreditCard.count - 1)
                
                cell.statement = { [weak self] in
                    self?.showStatementScreen(item)
                }
                
                cell.payment = { [weak self] in
                    self?.showPaymentScreen(item)
                }

                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbGeneralAccountAddTableViewCell.identifier, for: indexPath) as! NCBGeneralAccountAddTableViewCell
                cell.setTitle(title: "Đăng ký mở thẻ tín dụng")
                return cell
            }
        case loanTbl:
            if listDebtAccount.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSubPaymentAccountTableViewCell.identifier, for: indexPath) as! NCBSubPaymentAccountTableViewCell
                cell.setupDataForDebtAccount(listDebtAccount[indexPath.row], indexPath: indexPath)
                cell.seperatorView.isHidden = (indexPath.row == listDebtAccount.count - 1)

                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbGeneralAccountAddTableViewCell.identifier, for: indexPath) as! NCBGeneralAccountAddTableViewCell
                cell.setTitle(title: "Đăng ký khoản vay")
                return cell

            }
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case generalAccountTbl:
            return  heightForCellWithTitle
        case savingTbl:
            return heightForCellWithTitle//(listSavingAccount.count == 0) ? heightForCellWithTitle : heightForCellWithTitle
        case creditTbl:
            if indexPath.row == 0 {
                return heightForCellWithTitle
            } else {
                return heightForCellWithoutTitle
            }
        case loanTbl:
            if indexPath.row == 0 {
                return heightForCellWithTitle
            } else {
                return heightForCellWithoutTitle
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case generalAccountTbl:
            if listPaymentAccountCA.count > 0 {
                if let _vc = R.storyboard.accountInfo.ncbAccountInfoViewController() {
                    _vc.accountInfoModel = self.listPaymentAccountCA[indexPath.row]
                    _vc.listPaymentAccount = listPaymentAccountCA
                    _vc.listTransactionType = accountPresenter?.listTransactionType ?? []
                    self.navigationController?.pushViewController(_vc, animated: true)
                }
            } else {
                
            }
        case creditTbl:
            if listCreditCard.count > 0 {
                if let _vc = R.storyboard.creditCard.ncbCreditCardGeneralInfoViewController() {
                    _vc.creditCardInfo = listCreditCard[indexPath.row]
                    _vc.needGetDetail = true
                    self.navigationController?.pushViewController(_vc, animated: true)
                }
            } else {
                if let vc = R.storyboard.cardService.ncbRegistrationCreditCardViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        case loanTbl:
            if listDebtAccount.count > 0 {
                if let _vc = R.storyboard.accountInfo.ncbDebtAccountViewController() {
                    if let _contractNo = listDebtAccount[indexPath.row].acctno{
                        if _contractNo.hasPrefix("PD") {
                            _vc.debtAccountType = .outOfDateAccount
                        } else {
                            _vc.debtAccountType = .expiredAccount
                        }
                        _vc.contractNo = _contractNo
                    }
                    self.navigationController?.pushViewController(_vc, animated: true)
                }
            } else {
                if let vc = R.storyboard.registerNewService.ncbRegisterForLoanViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        case savingTbl:
            if listSavingAccount.count > 0 {
                if let _vc = R.storyboard.accountInfo.ncbSavingAccountInfoViewController() {
                    self.navigationController?.pushViewController(_vc, animated: true)
                }
            } else {
                showSavingProductsSheet()
            }
         
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension NCBGeneralAccountViewController: NCBGeneralAccountPresenterDelegate {
    
    func getListPaymentAccountCompleted(listPaymentAccount: [NCBDetailPaymentAccountModel]?, error: String?) {
        if let _ = error {
//            SVProgressHUD.dismiss()
//            showAlert(msg: error)
            accountPresenter?.getListSavingAccount(params: createSavingAccountParams())
            return
        }
        
        self.listPaymentAccountCA = listPaymentAccount ?? []
        generalAccountTbl.reloadData()
        heightGeneralAccountTbl.constant = getHeightTblView(generalAccountTbl)
        accountPresenter?.getListSavingAccount(params: createSavingAccountParams())
    }
    
    func getListSavingAccountFollowMoneyUnitCompleted(savingAccount: [NCBSavingAccountModel]?, error: String?) {
        if let _ = error {
//            SVProgressHUD.dismiss()
//            showAlert(msg: error)
            accountPresenter?.getListCreditCard(params: createCreditCardParams())
            return
        }
        
        self.listSavingAccount = savingAccount ?? []
        isGetSaving = true
        savingTbl.reloadData()
        heightSavingTbl.constant = getHeightTblView(savingTbl)
        accountPresenter?.getListCreditCard(params: createCreditCardParams())
    }
    
    func getListCreditCardCompleted(listCreditCard: [NCBCreditCardModel]?, error: String?) {
        if let _ = error {
//            SVProgressHUD.dismiss()
//            showAlert(msg: error)
            accountPresenter?.getListDebtAccount(params: createDebtAccountParams())
            return
        }
        
        self.listCreditCard = listCreditCard ?? []
        isGetCreaditCard = true
        heightCreditTbl.constant = getHeightTblView(creditTbl)
        creditTbl.reloadData()
        accountPresenter?.getListDebtAccount(params: createDebtAccountParams())
    }
    
    func getListDebtAccountCompleted(listDebtAccount: [NCBDebtAccountModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.listDebtAccount = listDebtAccount ?? []
        isGetDebt = true
        heightLoanTbl.constant = getHeightTblView(loanTbl)
        loanTbl.reloadData()
    }
    
}
extension NCBGeneralAccountViewController: NCBBottomSheetDetailListViewControllerDelegate {
    
    func bottomSheetDetailListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        if index  == 0 {
            if let vc = R.storyboard.sendSaving.ncbiSavingsViewController() {
                vc.savingFormType = .ISavingSaving
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = R.storyboard.sendSaving.ncbiSavingsViewController() {
                vc.savingFormType = .AccumulateSaving
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


