//
//  NCBRechargeDetailViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRechargeDetailViewController: NCBBaseViewController {
    
    @IBOutlet weak var tfName: NewNCBCommonTextField!
    @IBOutlet weak var tfPhone: NewNCBCommonTextField!
    @IBOutlet weak var containerActionView: UIView!
    @IBOutlet weak var updateBtn: NCBCommonButton!
    
    //MARK: Properties
    
    var benfit: NCBBenfitPhoneModel?
    fileprivate var isEdit: Bool = false {
        didSet {
            containerActionView.isHidden = isEdit
            updateBtn.isHidden = !isEdit
            tfName.isEnabled = isEdit
            tfPhone.isEnabled = isEdit
        }
    }
    fileprivate var updatePresenter: NCBChargeMoneyPhoneNumberPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBRechargeDetailViewController {
    
    override func setupView() {
        super.setupView()
        
        tfName.placeholder = "Tên đã lưu"
        tfName.text = benfit?.menName
        tfName.isEnabled = false
        
        tfPhone.placeholder = "Số điện thoại"
        tfPhone.text = benfit?.billNo
        tfPhone.isEnabled = false
        
        updateBtn.setTitle("Cập nhật thông tin", for: .normal)
        updateBtn.isHidden = true
        updateBtn.addTarget(self, action: #selector(updateAction), for: .touchUpInside)
        
        let actionView = R.nib.ncbBeneficiariesUpdateActionFooterView.firstView(owner: self)!
        actionView.lbTransfer.text = "Nạp tiền"
        actionView.transferBtn.setImage(R.image.ic_action_charge(), for: .normal)
        containerActionView.addSubview(actionView)
        
        actionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        actionView.edit = { [weak self] in
            self?.isEdit = true
        }
        
        actionView.delete = { [weak self] in
            self?.showConfirm(msg: "Quý khách muốn xóa thông tin đã lưu?") { [weak self] in
                self?.updateService(false)
            }
        }
        
        actionView.transfer = { [weak self] in
            guard let item = self?.benfit else {
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
        
        updatePresenter = NCBChargeMoneyPhoneNumberPresenter()
        updatePresenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Chi tiết đã lưu")
    }
    
    @objc fileprivate func updateAction() {
        updateService(true)
    }
    
    fileprivate func updateService(_ isActive: Bool) {
        guard let benfit = benfit else {
            return
        }
        
        SVProgressHUD.show()
        updatePresenter?.saveService(memName: tfName.text ?? "", providerCode: benfit.providerCode ?? "", serviceCode: benfit.serviceCode ?? "", billNo: tfPhone.text ?? "", type: benfit.type ?? "", isActive: isActive)
    }
    
}

extension NCBRechargeDetailViewController: NCBChargeMoneyPhoneNumberPresenterDelegate {
    
    func saveServiceCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if isEdit {
            showAlert(msg: "Cập nhật thông tin thành công")
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
        isEdit = false
    }
    
}
