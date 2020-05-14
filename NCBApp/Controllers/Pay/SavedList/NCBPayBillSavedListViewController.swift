//
//  NCBPayBillSavedListViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBPayBillSavedListViewControllerDelegate {
    func savedListDidSelectItem(_ savedItem: NCBPayBillSavedModel)
}

class NCBPayBillSavedListViewController: NCBBaseSearchListViewController {
    
    //MARK: Properties
    
    fileprivate var p: NCBPayBillSavedListPresenter?
    fileprivate var dataModels = [NCBPayBillSavedModel]()
    fileprivate var filteredModels = [NCBPayBillSavedModel]()
    fileprivate var verifyPaymentPresenter: NCBVerifyServicePaymentPresenter?
    var delegate: NCBPayBillSavedListViewControllerDelegate?
    var serviceCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func isShowIndexView() -> Bool {
        return false
    }
    
}

extension NCBPayBillSavedListViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbPayBillSavedListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbPayBillSavedListTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 85
        
        verifyPaymentPresenter = NCBVerifyServicePaymentPresenter()
        verifyPaymentPresenter?.delegate = self
        
        p = NCBPayBillSavedListPresenter()
        p?.delegate = self
        
        getSavedList(showProgress: true)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Danh sách hoá đơn")
        lbTitle.text = "Danh sách đã lưu"
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = dataModels.filter({ ($0.billNo?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.serviceName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
    fileprivate func getSavedList(showProgress: Bool) {
        if showProgress {
            SVProgressHUD.show()
        }
        p?.getSavedList(params: ["cifNo": NCBShareManager.shared.getUser()!.cif ?? ""])
    }
    
}

extension NCBPayBillSavedListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        var item: NCBPayBillSavedModel!
        if isFilter {
            item = filteredModels[indexPath.row]
        } else {
            item = dataModels[indexPath.row]
        }
        cell.setData(item, isAutoPaymentRegister: false)
        
        if delegate != nil {
            cell.delegate = nil
        }
        
        cell.pay = { [weak self] in
            self?.showPaymentScreen(item)
        }
        
        cell.delete = { [weak self] in
            self?.showConfirm(msg: "Quý khách muốn thực hiện xóa thông tin dịch vụ đã lưu?", completionHandler: { [weak self] in
                self?.deleteSavedPayment(item, index: indexPath.row)
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            var item: NCBPayBillSavedModel!
            if isFilter {
                item = filteredModels[indexPath.row]
            } else {
                item = dataModels[indexPath.row]
            }
            delegate?.savedListDidSelectItem(item)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension NCBPayBillSavedListViewController {
    
    fileprivate func showPaymentScreen(_ item: NCBPayBillSavedModel) {
        let provider = NCBServiceProviderModel()
        provider.partner = item.partner
        provider.providerCode = item.providerCode
        provider.providerName = item.providerName
        provider.serviceCode = item.serviceCode
        provider.status = item.status
        provider.customerCode = item.billNo
        
        if let vc = R.storyboard.servicePayment.ncbServicePaymentViewController() {
            vc.serviceProvider = provider
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func deleteSavedPayment(_ item: NCBPayBillSavedModel, index: Int) {
        SVProgressHUD.show()
        verifyPaymentPresenter?.saveService(providerCode: item.providerCode ?? "", serviceCode: item.serviceCode ?? "", customerCode: item.billNo ?? "", memName: "", isActive: false)
    }
    
}

extension NCBPayBillSavedListViewController: NCBPayBillSavedListPresenterDelegate {
    
    func getSavedListCompleted(savedList: [NCBPayBillSavedModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        dataModels = savedList ?? []
        
        if let serviceCode = serviceCode {
            dataModels = (savedList ?? []).filter( { $0.serviceCode == serviceCode })
        }
//        tblView.reloadData()
        self.textFieldDidChange(tfSearch)
    }
    
}

extension NCBPayBillSavedListViewController: NCBVerifyServicePaymentPresenterDelegate {
    
    func saveServiceCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        getSavedList(showProgress: false)
        showAlert(msg: "Xóa thông tin dịch vụ thành công")
    }
    
}
