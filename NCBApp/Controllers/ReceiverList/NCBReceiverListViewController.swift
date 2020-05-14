//
//  NCBReceiverListViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBReceiverListViewController: NCBBaseSearchListViewController {
    
    // MARK: - Properties
    
    var beneficiaryModels = [NCBBeneficiaryModel]()
    fileprivate var filteredModels = [NCBBeneficiaryModel]()
    var presenter: NCBReceiverListPresenter?
    fileprivate var updatePresenter: NCBBeneficiariesUpdatePresenter?
    fileprivate var beneficiarySelected: NCBBeneficiaryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getBeneficiaries(showProgress: true)
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func addNewAction() {
        if let vc = R.storyboard.receiverList.ncbBeneficiariesCreateViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NCBReceiverListViewController {
    
    override func setupView() {
        super.setupView()
        
        showAddNewView()
        
        tblView.register(UINib(nibName: R.nib.ncbBeneficiaryListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBeneficiaryListTableViewCellID.identifier)
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableView.automaticDimension
        tblView.delegate = self
        tblView.dataSource = self
        
        presenter = NCBReceiverListPresenter()
        presenter?.delegate = self
        
        updatePresenter = NCBBeneficiariesUpdatePresenter()
        updatePresenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("DANH SÁCH NGƯỜI NHẬN")
        lbTitle.text = "Danh sách đã lưu"
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = beneficiaryModels.filter({ ($0.accountName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.memName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
    override func sectionIndexViewSelected(_ index: Int, string: String) {
        let row = (isFilter ? filteredModels : beneficiaryModels).firstIndex(where: { string.lowercased() == ($0.accountName?.lowercased() ?? "").prefix(1) })
        if let row = row {
            tblView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
        }
    }
    
    fileprivate func getSection(_ row: Int, item: NCBBeneficiaryModel) -> String {
        let string = "\((item.accountName ?? "").prefix(1))"
        let section = (isFilter ? filteredModels : beneficiaryModels).firstIndex(where: { string == ($0.accountName ?? "").prefix(1) })
        if section == row {
            return string
        }
        return ""
    }
    
    fileprivate func deleteBeneficiary(_ beneficiary: NCBBeneficiaryModel?) {
        showConfirm(msg: "Quý khách muốn xóa thông tin thụ hưởng?") { [weak self] in
            let params = [
                "cifno": NCBShareManager.shared.getUser()!.cif ?? "",
                "username": NCBShareManager.shared.getUser()!.username ?? "",
                "benValue": beneficiary?.accountNo ?? "",
                "typeTransfer": beneficiary?.typeTransfer ?? ""
                ] as [String: Any]
            
            SVProgressHUD.show()
            self?.updatePresenter?.delete(params: params)
        }
    }
    
    fileprivate func getBeneficiaries(showProgress: Bool) {
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["account"] = ""
        params["typeTransfer"] = ""
        
        if showProgress {
            SVProgressHUD.show()
        }
        presenter?.getBeneficiaryList(params: params)
    }
    
    fileprivate func switchTransfer(_ beneficiary: NCBBeneficiaryModel) {
        if beneficiary.typeTransfer == BeneficiaryType.CKNB.rawValue {
            showInternalTransfer(beneficiary)
            return
        }
        
        beneficiarySelected = beneficiary
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Chọn loại chuyển khoản", items: [BottomSheetStringItem(title: "Chuyển khoản nhanh"), BottomSheetStringItem(title: "Chuyển khoản thường")], isHasOptionItem: false)
            showBottomSheet(controller: vc, size: 250)
        }
    }
    
    fileprivate func showTransferScreen(_ type: InterbankTransferType, beneficiary: NCBBeneficiaryModel) {
        if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
            vc.interbankType = type
            vc.beneficiary = beneficiary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showInternalTransfer(_ beneficiary: NCBBeneficiaryModel) {
        if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
            vc.beneficiary = beneficiary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBReceiverListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return filteredModels.count
        }
        return beneficiaryModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBeneficiaryListTableViewCellID.identifier, for: indexPath) as! NCBBeneficiaryListTableViewCell
        let item: NCBBeneficiaryModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = beneficiaryModels[indexPath.row]
        }
        
        cell.lbAccountName.text = item.accountName?.trim
        cell.lbAccountNumber.text = item.accountNo?.trim
        cell.lbMemName.text = item.memName?.trim
        cell.lbBankName.text = item.benBankName?.trim
        cell.lbSection.text = getSection(indexPath.row, item: item)
        
        cell.selectionStyle = .none
        
        cell.edit = { [weak self] in
            if let vc = R.storyboard.receiverList.ncbBeneficiariesUpdateViewController() {
                vc.beneficiary = item
                vc.isEdit = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        cell.delete = { [weak self] in
            self?.deleteBeneficiary(item)
        }
        
        cell.transfer = { [weak self] in
            self?.switchTransfer(item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: NCBBeneficiaryModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = beneficiaryModels[indexPath.row]
        }
        
        if let vc = R.storyboard.receiverList.ncbBeneficiariesUpdateViewController() {
            vc.beneficiary = item
            vc.onlyView = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NCBReceiverListViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        guard let beneficiary = beneficiarySelected else {
            return
        }
        
        if index == 0 {
            showTransferScreen(.fast, beneficiary: beneficiary)
        } else if index == 1 {
            showTransferScreen(.normal, beneficiary: beneficiary)
        }
    }
    
}

extension NCBReceiverListViewController: NCBReceiverListPresenterDelegate {
    
    func loadBeneficiaryListCompleted(beneficiaryList: [NCBBeneficiaryModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
        }
        
        if let beneficiaryList = beneficiaryList {
            beneficiaryModels = beneficiaryList.sorted(by: { $0.accountName?.lowercased() ?? "" < $1.accountName?.lowercased() ?? "" })
        }

        self.textFieldDidChange(tfSearch)
        tblView.tableEmptyMessage(beneficiaryModels.count == 0)
//        tblView.reloadData()
    }
    
}

extension NCBReceiverListViewController: NCBBeneficiariesUpdatePresenterDelegate {
    
    func updateBeneficiaryCompleted(error: String?) {
        
    }
    
    func deleteBeneficiaryCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        getBeneficiaries(showProgress: false)
        showAlert(msg: "Xoá thụ hưởng thành công")
    }
    
}

