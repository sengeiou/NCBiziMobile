//
//  NCBAutoPaymentDetailViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBAutoPaymentDetailViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    
    fileprivate var p: NCBAutoPaymentDetailPresenter?
    var bill: NCBPayBillSavedModel?
    fileprivate var dataModels = [TransactionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBAutoPaymentDetailViewController {
    
    override func setupView() {
        super.setupView()
        
        tblView.register(UINib(nibName: R.nib.ncbAutoPaymentDetailTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbAutoPaymentDetailTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        
        p = NCBAutoPaymentDetailPresenter()
        p?.delegate = self
        
        let params = [
            "userName": NCBShareManager.shared.getUser()!.username ?? "",
            "billNo": bill?.billNo ?? ""
        ] as [String: Any]
        
        SVProgressHUD.show()
        p?.getDetail(params: params)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("THANH TOÁN TỰ ĐỘNG")
    }
    
    @objc fileprivate func cancelAutoPayBill() {
        guard let bill = bill else {
            return
        }
        
        showConfirm(msg: "Quý khách muốn Hủy đăng ký dịch vụ thanh toán tự động?") { [weak self] in
            let params = [
                "userName": NCBShareManager.shared.getUser()!.username ?? "",
                "billNo": bill.billNo ?? ""
                ] as [String: Any]
            
            SVProgressHUD.show()
            self?.p?.delete(params: params)
        }
    }
    
}

extension NCBAutoPaymentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbAutoPaymentDetailTableViewCellID.identifier, for: indexPath) as! NCBAutoPaymentDetailTableViewCell
        let item = dataModels[indexPath.row]
        cell.lbTitle.text = item.title
        cell.lbValue.text = item.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        let cancelBtn = NCBCommonButton()
        cancelBtn.setTitle("Huỷ đăng ký", for: .normal)
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 25
        footer.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelAutoPayBill), for: .touchUpInside)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
}

extension NCBAutoPaymentDetailViewController: NCBAutoPaymentDetailPresenterDelegate {
    
    func getDetailCompleted(detail: NCBAutoPayBillDetailModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: detail?.acctNo ?? ""))
        dataModels.append(TransactionModel(title: "Tên tài khoản", value: detail?.acctName ?? ""))
        dataModels.append(TransactionModel(title: "Mã khách hàng", value: detail?.billNo ?? ""))
        dataModels.append(TransactionModel(title: "Dịch vụ", value: detail?.serviceName ?? ""))
        dataModels.append(TransactionModel(title: "Nhà cung cấp", value: detail?.providerName ?? ""))
        
        if let time = yyyyMMddHHmmssFormatter.date(from: detail?.timeDky ?? "") {
            dataModels.append(TransactionModel(title: "Ngày đăng ký", value: ddMMyyyyFormatter.string(from: time)))
        }
        
        tblView.reloadData()
    }
    
    func deleteCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
