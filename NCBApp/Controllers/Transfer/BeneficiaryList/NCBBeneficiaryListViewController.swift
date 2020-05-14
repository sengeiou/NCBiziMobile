//
//  NCBBeneficiaryListViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

fileprivate class BeneficiaryModel {
    var section1 = [NCBBeneficiaryModel]()
    var section2 =  [NCBBeneficiaryModel]()
}

enum BeneficiaryType: String {
    case CKNB
    case CKCITAD
    case CK247 = "CK247-CARD"
}

protocol NCBBeneficiaryListViewControllerDelegate: class {
    func didSelectBeneficiaryItem(item: NCBBeneficiaryModel)
}

class NCBBeneficiaryListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var dataItem = BeneficiaryModel()
    fileprivate var filteredItem = BeneficiaryModel()
    var type: TransactionType = .internalTransfer
    var viaAccountNumber: Bool = true
    var hasBankCode: String?
    weak var delegate: NCBBeneficiaryListViewControllerDelegate?
    
    fileprivate var p: NCBBeneficiaryListPresenter?
    var sourceAccount: NCBDetailPaymentAccountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBBeneficiaryListViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbBeneficiaryListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBeneficiaryListTableViewCellID.identifier)
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableView.automaticDimension
        tblView.delegate = self
        tblView.dataSource = self
        
        p = NCBBeneficiaryListPresenter()
        
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif ?? ""
        params["username"] = NCBShareManager.shared.getUser()!.username ?? ""
        if let source = sourceAccount {
            params["account"] = source.acctNo
        }
        switch type {
        case .internalTransfer:
            params["typeTransfer"] = BeneficiaryType.CKNB.rawValue
        case .citad, .fast247:
            if viaAccountNumber {
                params["typeTransfer"] = BeneficiaryType.CKCITAD.rawValue
            } else {
                params["typeTransfer"] = BeneficiaryType.CK247.rawValue
            }
        default:
            break
        }
        
        SVProgressHUD.show()
        p?.delegate = self
        p?.getBeneficiaryList(params: params)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
//        switch type {
//        case .fast247, .citad:
//            setHeaderTitle("CHUYỂN KHOẢN LIÊN NGÂN HÀNG")
//        default:
//            setHeaderTitle("CHUYỂN KHOẢN NỘI BỘ")
//        }
        
        setHeaderTitle("DANH SÁCH THỤ HƯỞNG")
        lbTitle.text = "Danh sách đã lưu"
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredItem.section1 = dataItem.section1.filter({ ($0.accountName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.memName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        
        filteredItem.section2 = dataItem.section2.filter({ ($0.accountName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.memName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        
        tblView.reloadData()
    }
    
    override func sectionIndexViewSelected(_ index: Int, string: String) {
        let row = (isFilter ? filteredItem.section2 : dataItem.section2).firstIndex(where: { string.lowercased() == ($0.accountName?.lowercased() ?? "").prefix(1) })
        if let row = row {
            tblView.scrollToRow(at: IndexPath(row: row, section: 1), at: .top, animated: false)
        }
    }
   
    fileprivate func getSection(_ row: Int, item: NCBBeneficiaryModel) -> String {
        let string = "\((item.accountName ?? "").prefix(1))"
        let section = (isFilter ? filteredItem.section2 : dataItem.section2).firstIndex(where: { string == ($0.accountName ?? "").prefix(1) })
        if section == row {
            return string
        }
        return ""
    }
    
}

extension NCBBeneficiaryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return (section == 0) ? filteredItem.section1.count : filteredItem.section2.count
        }
        return (section == 0) ? dataItem.section1.count : dataItem.section2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBeneficiaryListTableViewCellID.identifier, for: indexPath) as! NCBBeneficiaryListTableViewCell
        var item: NCBBeneficiaryModel!
        
        switch indexPath.section {
        case 0:
            if isFilter {
                item = filteredItem.section1[indexPath.row]
            } else {
                item = dataItem.section1[indexPath.row]
            }
        case 1:
            if isFilter {
                item = filteredItem.section2[indexPath.row]
            } else {
                item = dataItem.section2[indexPath.row]
            }
        default:
            break
        }
        
        cell.lbAccountName.text = item.accountName
        cell.lbAccountNumber.text = item.accountNo
        cell.lbMemName.text = item.memName?.trim
        if type == .internalTransfer {
            cell.lbBankName.text = ""
        } else {
            cell.lbBankName.text = item.benBankName
        }
        cell.lbSection.text = (indexPath.section == 0) ? "" : getSection(indexPath.row, item: item)
        cell.delegate = nil
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: NCBBeneficiaryModel!
        switch indexPath.section {
        case 0:
            if isFilter {
                item = filteredItem.section1[indexPath.row]
            } else {
                item = dataItem.section1[indexPath.row]
            }
        case 1:
            if isFilter {
                item = filteredItem.section2[indexPath.row]
            } else {
                item = dataItem.section2[indexPath.row]
            }
        default:
            break
        }
        delegate?.didSelectBeneficiaryItem(item: item)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NCBBeneficiaryListViewController: NCBBeneficiaryListPresenterDelegate {
    
    func loadBeneficiaryListCompleted(beneficiaryList: [NCBBeneficiaryModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let beneficiaryList = beneficiaryList, beneficiaryList.count > 0 {
            let dataModels = beneficiaryList.sorted(by: { $0.accountName?.lowercased() ?? "" < $1.accountName?.lowercased() ?? "" })
            
            if hasBankCode != nil {
                dataItem.section1 = dataModels.filter( { $0.benBank == hasBankCode } )
            }
            dataItem.section2 = dataModels
            tblView.reloadData()
            tblView.tableEmptyMessage(dataModels.count == 0)
        } else {
            showError(msg: "TRANSFER-6".getMessage() ?? "Quý khách chưa tạo danh sách thụ hưởng") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
