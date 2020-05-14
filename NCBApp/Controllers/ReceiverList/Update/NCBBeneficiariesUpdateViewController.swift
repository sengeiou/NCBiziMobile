//
//  NCBBeneficiariesUpdateViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum BeneficiaryItemType: Int {
    case acctName = 0
    case memName
    case acctNo
    case cardNo
    case bank
    case province
    case branch
}

struct BeneficiaryInfoItem {
    var type: BeneficiaryItemType = .acctName
    var value = ""
}

class NCBBeneficiariesUpdateViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    var beneficiary: NCBBeneficiaryModel?
    fileprivate var dataModels = [BeneficiaryInfoItem]()
    fileprivate var p: NCBBeneficiariesUpdatePresenter?
    fileprivate var transferPresenter: NCBTransferPresenter?
    fileprivate var bankCodeItem = BankCodeItemModel(bankCode: "", provinceCode: "", creditBranch: "")
    fileprivate var isCKNB: Bool {
        return (beneficiary?.typeTransfer == BeneficiaryType.CKNB.rawValue)
    }
    fileprivate var isViaAccount: Bool {
        return (beneficiary?.typeTransfer == BeneficiaryType.CKCITAD.rawValue)
    }
    fileprivate var isActive = true
    var isEdit = false
    var onlyView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isActive = true
        setupData()
    }
    
    func editAction() {
        isEdit = true
        tblView.reloadData()
    }
    
}

extension NCBBeneficiariesUpdateViewController {
    
    override func setupView() {
        super.setupView()
        
        p = NCBBeneficiariesUpdatePresenter()
        p?.delegate = self
        
        transferPresenter = NCBTransferPresenter()
        transferPresenter?.delegate = self
        
        tblView.register(UINib(nibName: R.nib.ncbBeneficiariesUpdateTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBeneficiariesUpdateTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CHUYỂN KHOẢN")
    }
    
    fileprivate func setupData() {
        setCustomHeaderTitle(beneficiary?.getMemName()?.uppercased() ?? "")
        
        bankCodeItem.bankCode = beneficiary?.benBank ?? ""
        bankCodeItem.provinceCode = beneficiary?.province ?? ""
        bankCodeItem.creditBranch = beneficiary?.branch ?? ""
        
        dataModels.removeAll()
        dataModels.append(BeneficiaryInfoItem(type: .acctName, value: beneficiary?.accountName ?? ""))
        dataModels.append(BeneficiaryInfoItem(type: .memName, value: beneficiary?.memName ?? ""))
        dataModels.append(BeneficiaryInfoItem(type: (isViaAccount || isCKNB) ? .acctNo : .cardNo, value: beneficiary?.accountNo ?? ""))
        if !isCKNB {
            dataModels.append(BeneficiaryInfoItem(type: .bank, value: beneficiary?.benBankName ?? ""))
            
            if beneficiary?.benBank == StringConstant.agribankCode {
                dataModels.append(BeneficiaryInfoItem(type: .province, value: beneficiary?.provinceName ?? ""))
                dataModels.append(BeneficiaryInfoItem(type: .branch, value: beneficiary?.branchName ?? ""))
            }
        }
        tblView.reloadData()
    }
    
    @objc fileprivate func doUpdate() {
        if beneficiary?.accountNo == "" {
            showAlert(msg: (isViaAccount || isCKNB) ? "Vui lòng nhập thông tin tài khoản đích" : "Vui lòng nhập thông tin số thẻ")
            return
        }
        
        if beneficiary?.accountName == "" {
            showAlert(msg: "Vui lòng nhập tên người nhận")
            return
        }
        
        if bankCodeItem.bankCode == "" && !isCKNB {
            showAlert(msg: "Vui lòng chọn Ngân hàng nhận")
            return
        }
        
        if bankCodeItem.bankCode == StringConstant.agribankCode && !isCKNB {
            if bankCodeItem.provinceCode == "" {
                showAlert(msg: "Vui lòng chọn tỉnh thành")
                return
            }
            
            if bankCodeItem.creditBranch == "" {
                showAlert(msg: "Vui lòng chọn chi nhánh")
                return
            }
        }
        
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif ?? ""
        params["username"] = NCBShareManager.shared.getUser()!.username ?? ""
        params["benValue"] = beneficiary?.accountNo ?? ""
        params["memName"] = beneficiary?.memName ?? ""
        params["benName"] = beneficiary?.accountName ?? ""
        params["typeTransfer"] = beneficiary?.typeTransfer ?? ""
        params["benBankCode"] = bankCodeItem.bankCode
        params["provinceCode"] = bankCodeItem.provinceCode
        params["branchCode"] = bankCodeItem.creditBranch
        params["benId"] = beneficiary?.benId ?? 0
        
        SVProgressHUD.show()
        p?.update(params: params)
    }
    
    @objc fileprivate func doDelete() {
        showConfirm(msg: "Quý khách muốn xóa thông tin thụ hưởng?") { [weak self] in
            let params = [
                "cifno": NCBShareManager.shared.getUser()!.cif ?? "",
                "username": NCBShareManager.shared.getUser()!.username ?? "",
                "benValue": self?.beneficiary?.accountNo ?? "",
                "typeTransfer": self?.beneficiary?.typeTransfer ?? ""
                ] as [String: Any]
            
            SVProgressHUD.show()
            self?.p?.delete(params: params)
        }
    }
    
    fileprivate func showTransferScreen(_ type: InterbankTransferType) {
        if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
            vc.interbankType = type
            vc.beneficiary = beneficiary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showInternalTransfer() {
        isActive = false
        if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
            vc.beneficiary = beneficiary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showBankList(_ type: BankGetType) {
        if let vc = R.storyboard.transfer.ncbBankListViewController() {
            vc.delegate = self
            vc.getType = type
            vc.bankCodeItem = bankCodeItem
            vc.serviceType = .payment
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doCheckDestinationAccount() {
        if !isCKNB || !isActive {
            return
        }
        
        if beneficiary?.accountNo == "" {
            beneficiary?.accountName = ""
            setupData()
            return
        }
        
        let params = [
            "username": NCBShareManager.shared.getUser()!.username ?? "",
            "account": beneficiary?.accountNo ?? ""
            ] as [String: Any]
        
        SVProgressHUD.show()
        transferPresenter?.checkDestinationAccount(params: params)
    }
    
    fileprivate func switchTransfer() {
        if isCKNB {
            showInternalTransfer()
            return
        }
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Chọn loại chuyển khoản", items: [BottomSheetStringItem(title: "Chuyển khoản nhanh"), BottomSheetStringItem(title: "Chuyển khoản thường")], isHasOptionItem: false)
            showBottomSheet(controller: vc, size: 250)
        }
    }
    
}

extension NCBBeneficiariesUpdateViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        if index == 0 {
            showTransferScreen(.fast)
        } else if index == 1 {
            showTransferScreen(.normal)
        }
    }
    
}

extension NCBBeneficiariesUpdateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBeneficiariesUpdateTableViewCellID.identifier, for: indexPath) as! NCBBeneficiariesUpdateTableViewCell
        let item = dataModels[indexPath.row]
        cell.setupData(item, isEdit: isEdit, isCKNB: isCKNB)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if onlyView {
            return UIView()
        }
        
        if isEdit {
            let footer = UIView()
            let saveBtn = NCBCommonButton()
            saveBtn.layer.cornerRadius = 25
            saveBtn.setTitle("Lưu", for: .normal)
            saveBtn.addTarget(self, action: #selector(doUpdate), for: .touchUpInside)
            
            footer.addSubview(saveBtn)
            saveBtn.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.height.equalTo(50)
                make.top.equalToSuperview().offset(20)
            }
            
            return footer
        }
        
        let footer = R.nib.ncbBeneficiariesUpdateActionFooterView.firstView(owner: self)!
        
        footer.edit = { [weak self] in
            self?.editAction()
        }
        
        footer.delete = { [weak self] in
            self?.doDelete()
        }
        
        footer.transfer = { [weak self] in
            self?.switchTransfer()
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if onlyView {
            return 0
        }
        if isEdit {
            return 70
        }
        return 130
    }
    
}

extension NCBBeneficiariesUpdateViewController: NCBBankListViewControllerDelegate {
    
    func didSelectBankItem(item: NCBBankModel, type: BankGetType) {
        switch type {
        case .province:
            beneficiary?.province = item.pro_id
            beneficiary?.provinceName = item.shrtname
            bankCodeItem.provinceCode = item.pro_id ?? ""
        case .branch:
            beneficiary?.branch = item.citad_gt
            beneficiary?.branchName = item.chi_nhanh
            bankCodeItem.creditBranch = item.citad_gt ?? ""
        default:
            beneficiary?.benBank = item.bnk_code
            beneficiary?.benBankName = item.bnkname
            bankCodeItem.bankCode = item.bnk_code ?? ""
            
            beneficiary?.province = ""
            beneficiary?.provinceName = ""
            beneficiary?.branch = ""
            beneficiary?.branchName = ""
        }
        setupData()
    }
    
}

extension NCBBeneficiariesUpdateViewController: NCBBeneficiariesUpdateTableViewCellDelegate {
    
    func textFieldValueChanged(_ cell: UITableViewCell, value: String) {
        guard let indexPath = tblView.indexPath(for: cell) else {
            return
        }
        
        let item = dataModels[indexPath.row]
        switch item.type {
        case .acctName:
            beneficiary?.accountName = value
        case .memName:
            beneficiary?.memName = value
        case .acctNo, .cardNo:
            beneficiary?.accountNo = value
        default:
            break
        }
    }
    
    func textFieldDidSelect(_ cell: UITableViewCell, tag: Int) {
        switch tag {
        case BeneficiaryItemType.bank.rawValue:
            showBankList(.bank)
        case BeneficiaryItemType.province.rawValue:
            if bankCodeItem.bankCode == "" {
                showAlert(msg: "Hãy chọn ngân hàng nhận trước")
                return
            }
            showBankList(.province)
        case BeneficiaryItemType.branch.rawValue:
            if bankCodeItem.provinceCode == "" {
                showAlert(msg: "Hãy chọn tỉnh thành trước")
                return
            }
            showBankList(.branch)
        default:
            break
        }
    }
    
    func textFieldDidEnd(_ cell: UITableViewCell, tag: Int) {
        switch tag {
        case BeneficiaryItemType.acctNo.rawValue:
            doCheckDestinationAccount()
        default:
            break
        }
    }
    
}

extension NCBBeneficiariesUpdateViewController: NCBBeneficiariesUpdatePresenterDelegate {
    
    func updateBeneficiaryCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        isEdit = false
        setupData()
        tblView.reloadData()
    }
    
    func deleteBeneficiaryCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NCBBeneficiariesUpdateViewController: NCBTransferPresenterDelegate {
    
    func checkDestinationAccountCompleted(destAccount: NCBDestinationAccountModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            beneficiary?.accountName = ""
        } else {
            beneficiary?.accountName = destAccount?.accountName
        }
        
        setupData()
    }
    
}
