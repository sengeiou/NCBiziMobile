//
//  NCBCharityOrganizationListViewController.swift
//  NCBApp
//
//  Created by Thuan on 5/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBCharityOrganizationListViewControllerDelegate: class {
    func didSelectCharityItem(item: NCBCharityOrganizationModel)
}

class NCBCharityOrganizationListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var dataModels = [NCBCharityOrganizationModel]()
    fileprivate var filteredModels = [NCBCharityOrganizationModel]()
    weak var delegate: NCBCharityOrganizationListViewControllerDelegate?
    
    fileprivate var presenter: NCBCharityOrgationListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBCharityOrganizationListViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbBankListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBankListTableViewCellID.identifier)
        tblView.estimatedRowHeight = 40
        tblView.rowHeight = UITableView.automaticDimension
        tblView.delegate = self
        tblView.dataSource = self
        
        presenter = NCBCharityOrgationListPresenter()
        let params = [
            "username" : NCBShareManager.shared.getUser()?.username ?? "",
        ]
        presenter?.getCharityFundList(params: params)
        presenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CHUYỂN TIỀN TỪ THIỆN")
        lbTitle.text = "Danh sách quỹ từ thiện"
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = dataModels.filter({ ($0.accname?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
    override func sectionIndexViewSelected(_ index: Int, string: String) {
        let row = (isFilter ? filteredModels : dataModels).firstIndex(where: { string.lowercased() == ($0.accname?.lowercased() ?? "").prefix(1) })
        if let row = row {
            tblView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
        }
    }
    
    fileprivate func getSection(_ row: Int, item: NCBCharityOrganizationModel) -> String {
        let string = "\((item.accname ?? "").prefix(1))"
        let section = (isFilter ? filteredModels : dataModels).firstIndex(where: { string == ($0.accname ?? "").prefix(1) })
        if section == row {
            return string
        }
        return ""
    }
    
}

extension NCBCharityOrganizationListViewController: NCBCharityOrgationListPresenterDelegate {
    func loadCharityFundListCompleted(charityFundList: [NCBCharityOrganizationModel]?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        
        if let charityFundList = charityFundList {
            dataModels = charityFundList.sorted(by: { $0.accname?.lowercased() ?? "" < $1.accname?.lowercased() ?? "" })
        }
        
        tblView.reloadData()
    }
}

extension NCBCharityOrganizationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilter ? filteredModels.count : dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBankListTableViewCellID.identifier, for: indexPath) as! NCBBankListTableViewCell

        cell.lbBankName.text = isFilter ? filteredModels[indexPath.row].accname ?? "" : dataModels[indexPath.row].accname ?? ""
        cell.lbSection.text = getSection(indexPath.row, item: isFilter ? filteredModels[indexPath.row] : dataModels[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCharityItem(item: isFilter ? filteredModels[indexPath.row] : dataModels[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
