//
//  NCBServiceListViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBServiceListViewControllerDelegate {
    func didSelectServiceItem(service: NCBServiceModel)
}

class NCBServiceListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var dataModels = [NCBServiceModel]()
    fileprivate var filteredModels = [NCBServiceModel]()
    fileprivate var p: NCBPayPresenter?
    var delegate: NCBServiceListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBServiceListViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbBankListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBankListTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 40
        
        p = NCBPayPresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getServiceList(params: ["type": "1"])
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("DỊCH VỤ THANH TOÁN TỰ ĐỘNG")
        
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = dataModels.filter({ ($0.serviceName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
}

extension NCBServiceListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        var item: NCBServiceModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        cell.lbBankName.text = item.serviceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: NCBServiceModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        delegate?.didSelectServiceItem(service: item)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NCBServiceListViewController: NCBPayPresenterDelegate {
    
    func getServiceListCompleted(services: [NCBServiceModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let services = services {
            dataModels = services
            tblView.reloadData()
        }
    }
    
}
