//
//  NCBBranchListViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
protocol NCBBranchListViewControllerDelegate: class {
    func didSelectBranchItem(item: NCBBranchModel)
}

class NCBBranchListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var dataModels = [NCBBranchModel]()
    fileprivate var filteredModels = [NCBBranchModel]()
    weak var delegate: NCBBranchListViewControllerDelegate?
    var strTitle = "Địa điểm nhận thẻ"
    
    var presenter = NCBCardServicePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func isShowIndexView() -> Bool {
        return false
    }
    
}

extension NCBBranchListViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbBranchListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBranchListTableViewCellID.identifier)
        tblView.estimatedRowHeight = 40
        tblView.rowHeight = UITableView.automaticDimension
        tblView.delegate = self
        tblView.dataSource = self
        
        presenter.delegate = self
        presenter.getListBranch(params: [:])
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle(strTitle)
        lbTitle.text = "Danh sách chi nhánh/PGD"
        
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = dataModels.filter({ ($0.depart_name?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.address?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
    override func sectionIndexViewSelected(_ index: Int, string: String) {
        let row = (isFilter ? filteredModels : dataModels).firstIndex(where: { string.lowercased() == ($0.depart_name?.lowercased() ?? "").prefix(1) })
        if let row = row {
            tblView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
        }
    }
    
    fileprivate func getSection(_ row: Int, item: NCBBranchModel) -> String {
        let string = "\((item.depart_name ?? "").prefix(1))"
        let section = (isFilter ? filteredModels : dataModels).firstIndex(where: { string == ($0.depart_name ?? "").prefix(1) })
        if section == row {
            return string
        }
        return ""
    }
    
}

extension NCBBranchListViewController: NCBCardServicePresenterDelegate {
    func getCrCardList(services: [NCBCardModel]?, error: String?) {
        
    }
    
    func updateCardStatusUnlockConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        
    }
    
    func updateCardStatusUnlockApproval(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        
    }
    
    func cardActiveConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        
    }
    
    func cardActiveApproval(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        
    }
    
    func getListBranch(services: [NCBBranchModel]?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        dataModels = services ?? []
        print(dataModels)
        tblView.reloadData()
    }
    
    func getListCardProduct(services: [String]?, error: String?) {
        
    }
    
    func getListCardClass(services: [String]?, error: String?) {
        
    }
    
    
}

extension NCBBranchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilter ? filteredModels.count : dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBranchListTableViewCellID.identifier, for: indexPath) as! NCBBranchListTableViewCell
        
         cell.branchNameLbl.text = isFilter ? filteredModels[indexPath.row].depart_name ?? "" : dataModels[indexPath.row].depart_name ?? ""
        cell.adressLbl.text =  isFilter ? filteredModels[indexPath.row].address ?? "" : dataModels[indexPath.row].address ?? ""
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectBranchItem(item: isFilter ? filteredModels[indexPath.row] : dataModels[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
