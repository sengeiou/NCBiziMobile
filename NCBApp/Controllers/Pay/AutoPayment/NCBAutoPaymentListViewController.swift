//
//  NCBAutoPaymentListViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBAutoPaymentListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var p: NCBAutoPaymentListPresenter?
    fileprivate var dataModels = [NCBPayBillSavedModel]()
    fileprivate var filteredModels = [NCBPayBillSavedModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func isShowIndexView() -> Bool {
        return false
    }
    
    override func addNewAction() {
        if let vc = R.storyboard.servicePayment.ncbAutoPaymentRegisterViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        p?.getAutoPayBillList(params: ["userName": NCBShareManager.shared.getUser()!.username ?? ""])
    }
    
}

extension NCBAutoPaymentListViewController {
    
    override func setupView() {
        super.setupView()
        
        showAddNewView()
        
        tblView.register(UINib(nibName: R.nib.ncbPayBillSavedListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbPayBillSavedListTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 85
        
        p = NCBAutoPaymentListPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("THANH TOÁN TỰ ĐỘNG")
        lbTitle.text = "Danh sách đã lưu"
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = dataModels.filter({ ($0.billNo?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.serviceName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
}

extension NCBAutoPaymentListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbPayBillSavedListTableViewCellID.identifier, for: indexPath) as! NCBPayBillSavedListTableViewCell
        cell.selectionStyle = .none
        var item: NCBPayBillSavedModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        cell.setData(item, isAutoPaymentRegister: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: NCBPayBillSavedModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        
        if let vc = R.storyboard.servicePayment.ncbAutoPaymentDetailViewController() {
            vc.bill = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBAutoPaymentListViewController: NCBAutoPaymentListPresenterDelegate {
    
    func getAutoPayBillListCompleted(autoPayBillList: [NCBPayBillSavedModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let autoPayBillList = autoPayBillList {
            dataModels = autoPayBillList
            tblView.reloadData()
        }
    }
    
}
