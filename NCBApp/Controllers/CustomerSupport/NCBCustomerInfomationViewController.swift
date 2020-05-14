//
//  NCBCustomerInfomationViewController.swift
//  NCBApp
//
//  Created by Van Dong on 06/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

struct CustomerInfomationModel {
    var title1: String
    var title2: String?
    var value1: String
    var value2: String?
    
    init(title1: String , title2: String?, value1: String = "", value2: String?) {
        self.title1 = title1
        self.title2 = title2
        self.value1 = value1
        self.value2 = value2
    }
}

class NCBCustomerInfomationViewController: NCBBaseViewController {
    
    @IBOutlet weak var customerInfoTbl: UITableView! {
        didSet {
            customerInfoTbl.register(UINib(nibName: R.nib.ncbDebtAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.nib.ncbDebtAccountTableViewCell.identifier)
            customerInfoTbl.allowsSelection = false
            customerInfoTbl.tableFooterView = UIView(frame: CGRect.zero)
            customerInfoTbl.backgroundColor = UIColor.clear
            customerInfoTbl.delegate = self
            customerInfoTbl.dataSource = self
        }
    }
    
    var p: NCBCustomerSupportPresenter?
    fileprivate var customerInfomationModel: [CustomerInfomationModel] = []
    fileprivate var customerInfomation: NCBCustomerInfomationModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("Thông tin khách hàng")
        
        p = NCBCustomerSupportPresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getCustomerInfomation(params: getCustomerInfomationParams())
    }
    
    func getCustomerInfomationParams() -> [String : Any] {
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
        ]
        return params
    }

    func customerInfomationData() {
        customerInfomationModel = []
        customerInfomationModel.append(CustomerInfomationModel.init(title1: "Họ tên khách hàng", title2: "", value1: customerInfomation?.cifname ?? "", value2: ""))
        customerInfomationModel.append(CustomerInfomationModel.init(title1: "CIF", title2: "", value1: customerInfomation?.cifno ?? "", value2: ""))
        customerInfomationModel.append(CustomerInfomationModel.init(title1: "Gói dịch vụ", title2: "", value1: NCBShareManager.shared.getUser()?.cifType ?? "", value2: ""))
        customerInfomationModel.append(CustomerInfomationModel.init(title1: "Ngày sinh", title2: "", value1: toDate(date: customerInfomation?.birthday ?? "") ?? "", value2: ""))
        customerInfomationModel.append(CustomerInfomationModel.init(title1: "Email", title2: "", value1: customerInfomation?.email ?? "", value2: ""))
        customerInfomationModel.append(CustomerInfomationModel.init(title1: "CMT/Hộ chiếu", title2: "Ngày cấp", value1: customerInfomation?.idno ?? "", value2: toDate(date:customerInfomation?.iddate ?? "")))
        customerInfoTbl.reloadData()
    }
}

extension NCBCustomerInfomationViewController: NCBCustomerSupportPresenterDelegate{
    func getCustomerInfomation(services: NCBCustomerInfomationModel?, error: String?) {
        SVProgressHUD.dismiss()

        if let _error = error {
            showAlert(msg: _error)
            return
        }
//        if let data = services {
//            customerInfomation = data
//        }
        self.customerInfomation = services
        customerInfomationData()
    }
}

extension NCBCustomerInfomationViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerInfomationModel.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        }else{
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbDebtAccountTableViewCell.identifier, for: indexPath) as! NCBDebtAccountTableViewCell
        cell.titleLb1.text = customerInfomationModel[indexPath.row].title1
        cell.detailLb1.text = customerInfomationModel[indexPath.row].value1
        cell.titleLb2.text = customerInfomationModel[indexPath.row].title2
        cell.detailLb2.text = customerInfomationModel[indexPath.row].value2
        cell.backgroundColor = .clear
        if indexPath.row == 0 {
            cell.detailLb1.font = semiboldFont(size: 18)
            cell.detailLb2.isHidden = true
        }else{
            cell.detailLb1.font = semiboldFont(size: 14)
            cell.detailLb2.font = semiboldFont(size: 14)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func toDate(date: String)-> String?{
        let date = yyyyMMddHHmmssFormatter.date(from: date)
        if let date = date {
            return ddMMyyyyFormatter.string(from: date)
        }
        return ""
    }
}
