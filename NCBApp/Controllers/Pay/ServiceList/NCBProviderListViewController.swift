//
//  NCBProviderListViewController.swift
//  NCBApp
//
//  Created by Thuan on 5/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBProviderListViewControllerDelegate {
    func didSelectProviderItem(provider: NCBServiceProviderModel)
}

class NCBProviderListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var dataModels = [NCBServiceProviderModel]()
    fileprivate var filteredModels = [NCBServiceProviderModel]()
    fileprivate var p: NCBProviderListPresenter?
    var serviceModel: NCBServiceModel?
    var delegate: NCBProviderListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func isShowIndexView() -> Bool {
        return false
    }
    
}

extension NCBProviderListViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbBankListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBankListTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 40
        
        p = NCBProviderListPresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getListProvider(code: serviceModel?.serviceCode ?? "")
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle(getServiceType(serviceModel?.serviceCode ?? ""))
        lbTitle.text = "Danh sách nhà cung cấp"
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = dataModels.filter({ ($0.providerName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
}

extension NCBProviderListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        var item: NCBServiceProviderModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        cell.lbBankName.text = item.providerName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: NCBServiceProviderModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        
        if let delegate = delegate {
            delegate.didSelectProviderItem(provider: item)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if let vc = R.storyboard.servicePayment.ncbServicePaymentViewController() {
            vc.serviceProvider = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBProviderListViewController: NCBProviderListPresenterDelegate {
    
    func getListProviderCompleted(providerList: [NCBServiceProviderModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let providerList = providerList {
            dataModels = providerList.sorted(by: { ($0.providerName ?? "").convertAlphaB() < ($1.providerName ?? "").convertAlphaB() })
            tblView.reloadData()
        }
    }
    
}
