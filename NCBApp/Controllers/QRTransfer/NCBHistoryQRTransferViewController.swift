//
//  NCBHistoryQRTransferViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBHistoryQRTransferViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var listQRTransferHistoryTbl: UITableView! {
        didSet {
            listQRTransferHistoryTbl.register(UINib.init(nibName: R.nib.ncbSubPaymentAccountTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.nib.ncbSubPaymentAccountTableViewCell.identifier)
            listQRTransferHistoryTbl.delegate = self
            listQRTransferHistoryTbl.dataSource = self
        }
    }
    
    // MARK: - Properties
    
    var qrListHistoryTransfers: [NCBQRTransferHistoryItemModel] = []
    var presenter: NCBHistoryQRTransferPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension NCBHistoryQRTransferViewController {
    override func setupView() {
        presenter = NCBHistoryQRTransferPresenter()
        let params: [String : Any] = [
            "cifno" : NCBShareManager.shared.getUser()?.cif ?? "",
            "username" : NCBShareManager.shared.getUser()?.username ?? ""
        ]
        presenter?.getQRHistoryTransferList(params: params)
        presenter?.delegate = self
    }
}

extension NCBHistoryQRTransferViewController: NCBHistoryQRTransferPresenterDelegate {
    func getListTransferHistoryCompleted(transferList: [NCBQRTransferHistoryItemModel]?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        
        self.qrListHistoryTransfers = transferList ?? []
        listQRTransferHistoryTbl.reloadData()
    }
}

extension NCBHistoryQRTransferViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qrListHistoryTransfers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.ncbSubPaymentAccountTableViewCell.identifier, for: indexPath) as! NCBSubPaymentAccountTableViewCell
        
        cell.setupDataForQRTransferHistory(qrListHistoryTransfers[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _vc = R.storyboard.qrTransfer.ncbDetailQRTransferViewController() {
            _vc.itemId = qrListHistoryTransfers[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
}
