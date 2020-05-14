//
//  NCBRechargeSavedListViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBRechargeSavedListViewControllerDelegate {
    func phoneItemDidSelect(_ item: NCBBenfitPhoneModel)
}

enum BenfitSection: Int {
    case phone = 0
    case boss
}

class NCBRechargeSavedListViewController: NCBBaseSearchListViewController {
    
    fileprivate var p: NCBRechargeSavedListPresenter?
    fileprivate var phoneList = [NCBBenfitPhoneModel]()
    fileprivate var filterPhoneList = [NCBBenfitPhoneModel]()
    fileprivate var walletList = [NCBBenfitPhoneModel]()
    fileprivate var filterWalletList = [NCBBenfitPhoneModel]()
    fileprivate var updatePresenter: NCBChargeMoneyPhoneNumberPresenter?
    
    var onlyMobile = false
    var onlyAirpay = false
    var delegate: NCBRechargeSavedListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        p?.getBenitTopup(params: ["cifNo": NCBShareManager.shared.getUser()?.cif ?? ""])
    }
    
    override func isShowIndexView() -> Bool {
        return false
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filterPhoneList = phoneList.filter({ ($0.billNo?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.menName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        filterWalletList = walletList.filter({ ($0.billNo?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) || ($0.menName?.lowercased() ?? "").contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
}

extension NCBRechargeSavedListViewController {
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = UIColor.white
        hiddenHeaderView()
        
        tblView.register(UINib(nibName: R.nib.ncbRechargeSavedListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRechargeSavedListTableViewCellID.identifier)
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableView.automaticDimension
        tblView.delegate = self
        tblView.dataSource = self
        
        p = NCBRechargeSavedListPresenter()
        p?.delegate = self
        
        updatePresenter = NCBChargeMoneyPhoneNumberPresenter()
        updatePresenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Danh sách đã lưu")
    }
    
    fileprivate func updateService(_ benfit: NCBBenfitPhoneModel?) {
        guard let benfit = benfit else {
            return
        }
        
        SVProgressHUD.show()
        updatePresenter?.saveService(memName: benfit.menName ?? "", providerCode: benfit.providerCode ?? "", serviceCode: benfit.serviceCode ?? "", billNo: benfit.billNo ?? "", type: benfit.type ?? "", isActive: false)
    }
    
}

extension NCBRechargeSavedListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case BenfitSection.phone.rawValue:
            return onlyAirpay ? 0 : (isFilter ? filterPhoneList : phoneList).count
        case BenfitSection.boss.rawValue:
            return onlyMobile ? 0 : (isFilter ? filterWalletList : walletList).count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbRechargeSavedListHeaderView.firstView(owner: self)
        switch section {
        case BenfitSection.phone.rawValue:
            header?.lbTitle.text = "Số điện thoại"
        default:
            header?.lbTitle.text = "Ví điện tử"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case BenfitSection.phone.rawValue:
            return onlyAirpay ? 0 : 40
        case BenfitSection.boss.rawValue:
            return onlyMobile ? 0 : 40
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRechargeSavedListTableViewCellID.identifier, for: indexPath) as! NCBRechargeSavedListTableViewCell
        var item: NCBBenfitPhoneModel?
        switch indexPath.section {
        case BenfitSection.phone.rawValue:
            item = (isFilter ? filterPhoneList : phoneList)[indexPath.row]
            cell.lbPartner.text = ""
        default:
            item = (isFilter ? filterWalletList : walletList)[indexPath.row]
            cell.lbPartner.text = item?.partner
        }
        
        cell.lbMemName.text = item?.menName
        cell.lbBillNo.text = item?.billNo
        
        if onlyMobile || onlyAirpay {
            cell.delegate = nil
        }
        
        cell.edit = { [weak self] in
            if let vc = R.storyboard.chargeMoney.ncbRechargeDetailViewController() {
                vc.benfit = item
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        cell.delete = { [weak self] in
            self?.showConfirm(msg: "Quý khách muốn xóa thông tin đã lưu?") { [weak self] in
                self?.updateService(item)
            }
        }
        
        cell.recharge = { [weak self] in
            guard let item = item else {
                return
            }
            if item.isTopupCard {
                if let _vc = R.storyboard.chargeMoney.ncbChargeMoneyPhoneNumberViewController() {
                    _vc.memName = item.menName
                    _vc.billNo = item.billNo
                    self?.navigationController?.pushViewController(_vc, animated: true)
                }
            } else {
                if let _vc = R.storyboard.chargeMoney.ncbChargeAirpayViewController() {
                    _vc.memName = item.menName
                    _vc.billNo = item.billNo
                    self?.navigationController?.pushViewController(_vc, animated: true)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if onlyMobile && indexPath.section == BenfitSection.phone.rawValue {
            delegate?.phoneItemDidSelect((isFilter ? filterPhoneList : phoneList)[indexPath.row])
        } else if onlyAirpay && indexPath.section == BenfitSection.boss.rawValue {
            delegate?.phoneItemDidSelect((isFilter ? filterWalletList : walletList)[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }

}

extension NCBRechargeSavedListViewController: NCBRechargeSavedListPresenterDelegate {
    
    func getBenitTopup(benitTopup: NCBBenitTopupModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        phoneList = benitTopup?.benfitPhone ?? []
        walletList = benitTopup?.benfitBoss ?? []
        self.textFieldDidChange(tfSearch)
    }
    
}

extension NCBRechargeSavedListViewController: NCBChargeMoneyPhoneNumberPresenterDelegate {
    
    func saveServiceCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        p?.getBenitTopup(params: ["cifNo": NCBShareManager.shared.getUser()?.cif ?? ""])
        showAlert(msg: "Xoá thông tin thành công")
    }
    
}
