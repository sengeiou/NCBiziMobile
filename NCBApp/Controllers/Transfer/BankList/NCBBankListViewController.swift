//
//  NCBBankListViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum BankGetType: Int {
    case bank = 0
    case province
    case branch
}

enum BankServiceType: Int {
    case fundTransfer = 0
    case payment
}

protocol NCBBankListViewControllerDelegate: class {
    func didSelectBankItem(item: NCBBankModel, type: BankGetType)
}

class NCBBankListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var dataModels = [NCBBankModel]()
    fileprivate var filteredModels = [NCBBankModel]()
    weak var delegate: NCBBankListViewControllerDelegate?
    fileprivate var p: NCBBankListPresenter?
    var getType: BankGetType = .bank
    var bankCodeItem: BankCodeItemModel?
    var serviceType: BankServiceType = .fundTransfer
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBBankListViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbBankListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBankListTableViewCellID.identifier)
        tblView.estimatedRowHeight = 40
        tblView.rowHeight = UITableView.automaticDimension
        tblView.delegate = self
        tblView.dataSource = self
        
        p = NCBBankListPresenter()
        p?.delegate = self
        
        if let username = NCBShareManager.shared.getUser()?.username {
            SVProgressHUD.show()
            switch getType {
            case .province:
                p?.getBankProvinces(params: ["username": username])
            case .branch:
                var params: [String: Any] = [:]
                params["username"] = username
                if let bankCodeItem = bankCodeItem {
                    params["bankCode"] = bankCodeItem.bankCode
                    params["provinceCode"] = bankCodeItem.provinceCode
                }
                p?.getBankBranchs(params: params)
            default:
                p?.getBanks(params: ["username": username], type: serviceType)
            }
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CHUYỂN KHOẢN LIÊN NGÂN HÀNG")
        
        switch getType {
        case .province:
            lbTitle.text = "Danh sách tỉnh thành"
        case .branch:
            lbTitle.text = "Danh sách chi nhánh"
        default:
            lbTitle.text = "Danh sách ngân hàng nhận"
        }
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        switch getType {
        case .province:
            filteredModels = dataModels.filter({ ($0.shrtname?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        case .branch:
            filteredModels = dataModels.filter({ ($0.chi_nhanh?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        default:
            filteredModels = dataModels.filter({ ($0.getBankFullName().lowercased()).contains(tf.text!.trim.lowercased()) || ($0.name_en?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        }
        tblView.reloadData()
    }
    
    override func sectionIndexViewSelected(_ index: Int, string: String) {
        switch getType {
        case .bank:
            let row = (isFilter ? filteredModels : dataModels).firstIndex(where: { string == $0.getBankFullName().prefix(1) })
            if let row = row {
                tblView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
            }
        case .province:
            let row = (isFilter ? filteredModels : dataModels).firstIndex(where: { string.lowercased() == ($0.shrtname?.lowercased() ?? "").prefix(1) })
            if let row = row {
                tblView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
            }
        case .branch:
            let row = (isFilter ? filteredModels : dataModels).firstIndex(where: { string.lowercased() == ($0.chi_nhanh?.lowercased() ?? "").prefix(1) })
            if let row = row {
                tblView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
            }
        }
    }
    
    fileprivate func getSection(_ row: Int, item: NCBBankModel) -> String {
        let string = "\(item.getBankFullName().prefix(1))"
        let section = (isFilter ? filteredModels : dataModels).firstIndex(where: { string == $0.getBankFullName().prefix(1) })
        if section == row {
            return string
        }
        return ""
    }
    
}

extension NCBBankListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return filteredModels.count
        }
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBankListTableViewCellID.identifier, for: indexPath) as! NCBBankListTableViewCell
        var item: NCBBankModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        switch getType {
        case .province:
            cell.lbBankName.text = item.shrtname
        case .branch:
            cell.lbBankName.text = item.chi_nhanh
        default:
            cell.lbBankName.text = item.getBankFullName()
            cell.lbSection.text = getSection(indexPath.row, item: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: NCBBankModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        delegate?.didSelectBankItem(item: item, type: getType)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NCBBankListViewController: NCBBankListPresenterDelegate {
    
    func getListCompleted(list: [NCBBankModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let list = list {
            switch getType {
            case .bank:
                dataModels = list.sorted(by: { $0.getBankFullName().convertAlphaB() < $1.getBankFullName().convertAlphaB() })
            case .province:
                dataModels = list.sorted(by: { ($0.shrtname ?? "").convertAlphaB() < ($1.shrtname ?? "").convertAlphaB() })
            case .branch:
                dataModels = list.sorted(by: { ($0.chi_nhanh ?? "").convertAlphaB() < ($1.chi_nhanh ?? "").convertAlphaB() })
            }
//            if getType == .bank {
//                dataModels = list.sorted(by: { $0.getBankFullName() < $1.getBankFullName() })
//            } else {
//                dataModels = list
//            }
            
            tblView.reloadData()
        }
    }
    
}
