//
//  NCBDetailQRTransferViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

struct QRTransferHistory {
    var name: String?
    var value: String?
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

class NCBDetailQRTransferViewController: NCBBaseViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var detailQRTransferTbl: UITableView! {
        didSet {
            detailQRTransferTbl.register(UINib.init(nibName: R.nib.ncbAccountDetailTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.nib.ncbAccountDetailTableViewCell.identifier)
            detailQRTransferTbl.delegate = self
            detailQRTransferTbl.dataSource = self
        }
    }
    
    // MARK: - Properties
    
    var listHistoryTransferInfo: [QRTransferHistory] = []
    
    var itemId: String = ""
    var presenter: NCBDetailHistoryQRTransferPresenter?
    var detailQRTransferHistoryModel: NCBQRTransferHistoryDetailModel? {
        didSet {
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension NCBDetailQRTransferViewController {
    
    override func setupView() {
        
        presenter = NCBDetailHistoryQRTransferPresenter()
        let params: [String : Any] = [
            "id" : itemId
        ]
        presenter?.getQRHistoryTransferList(params: params)
        presenter?.delegate = self
    }
    
    func setData() {
        if let _detailQRTransferHistoryModel = detailQRTransferHistoryModel {
            listHistoryTransferInfo.append(QRTransferHistory(name: "Tài khoản nguồn", value: _detailQRTransferHistoryModel.accountNo ?? ""))
            listHistoryTransferInfo.append(QRTransferHistory(name: "Thanh toán cho", value: _detailQRTransferHistoryModel.marchantName ?? ""))
            listHistoryTransferInfo.append(QRTransferHistory(name: "Tên điểm bán", value: _detailQRTransferHistoryModel.recevingAddr ?? ""))
            listHistoryTransferInfo.append(QRTransferHistory(name: "Mã điểm bán", value: _detailQRTransferHistoryModel.merchantNo ?? ""))
            listHistoryTransferInfo.append(QRTransferHistory(name: "Số hoá đơn", value: _detailQRTransferHistoryModel.billNo ?? ""))
            listHistoryTransferInfo.append(QRTransferHistory(name: "Số tiền thanh toán", value: Double(_detailQRTransferHistoryModel.amount ?? "0.0")?.currencyFormatted ?? ""))
            listHistoryTransferInfo.append(QRTransferHistory(name: "Thời gian giao dịch", value: _detailQRTransferHistoryModel.bookDate ?? ""))
            
            detailQRTransferTbl.reloadData()
        }
    }
}

extension NCBDetailQRTransferViewController: NCBDetailHistoryQRTransferPresenterDelegate {
    func getDetailTransferHistoryCompleted(transferInfo: NCBQRTransferHistoryDetailModel?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        
        detailQRTransferHistoryModel = transferInfo
    }
}

extension NCBDetailQRTransferViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistoryTransferInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.ncbAccountDetailTableViewCell.identifier, for: indexPath) as! NCBAccountDetailTableViewCell
        
        cell.titleLbl.text = listHistoryTransferInfo[indexPath.row].name
        cell.detailLbl.text = listHistoryTransferInfo[indexPath.row].value
        
        return cell
    }
}
