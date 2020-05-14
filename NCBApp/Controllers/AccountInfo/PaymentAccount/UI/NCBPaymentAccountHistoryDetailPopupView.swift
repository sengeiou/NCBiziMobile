//
//  NCBPaymentAccountHistoryDetailPopupView.swift
//  NCBApp
//
//  Created by Thuan on 7/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBPaymentAccountHistoryDetailPopupView: UIView {
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var statusLine: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    fileprivate var dataModels = [TransactionModel]()
    fileprivate var detail: NCBDetailHistoryDealItemModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTime.font = regularFont(size: 12)
        lbTime.textColor = ColorName.blackText.color
        
        lbStatus.font = semiboldFont(size: 12)
    
        tblView.register(UINib(nibName: R.nib.ncbPaymentAccountHistoryDetailTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbPaymentAccountHistoryDetailTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 40
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    func setData(_ item: NCBDetailHistoryDealItemModel, showStatus: Bool = false) {
        detail = item
        lbTime.text = item.getTime
        
        switch item.transType {
        case TransType.internalTransfer.rawValue, TransType.citad.rawValue, TransType.fast247.rawValue:
            if item.system_id?.uppercased() == "FT" {
                if item.dorc?.uppercased() == "D" {
                    dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: item.actno ?? ""))
                    dataModels.append(TransactionModel(title: "Tài khoản đích", value: item.destAcctNo ?? ""))
                    dataModels.append(TransactionModel(title: "Tên người nhận", value: item.destAcctName ?? ""))
                    dataModels.append(TransactionModel(title: "Tại ngân hàng", value: item.benBankName ?? ""))
                    dataModels.append(TransactionModel(title: "Nội dung", value: item.message ?? ""))
                } else if item.dorc?.uppercased() == "C" {
                    dataModels.append(TransactionModel(title: "Tài khoản nhận", value: item.actno ?? ""))
                    dataModels.append(TransactionModel(title: "Tài khoản chuyển", value: item.destAcctNo ?? ""))
                    dataModels.append(TransactionModel(title: "Từ ngân hàng", value: (item.transType == TransType.internalTransfer.rawValue) ? "Ngân hàng TMCP Quốc Dân" : item.benBankName ?? ""))
                    dataModels.append(TransactionModel(title: "Nội dung", value: item.message ?? ""))
                }
            } else {
                dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: item.actno ?? ""))
                dataModels.append(TransactionModel(title: "Nội dung", value: item.message ?? ""))
            }
        case TransType.saving.rawValue, TransType.addSaving.rawValue:
            if item.dorc?.uppercased() == "D" {
                dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: item.actno ?? ""))
                dataModels.append(TransactionModel(title: "Tài khoản tiết kiệm", value: item.destAcctNo ?? ""))
            }
        case TransType.settlementSaving.rawValue:
            if item.dorc?.uppercased() == "C" {
                dataModels.append(TransactionModel(title: "Tài khoản tiết kiệm", value: item.destAcctNo ?? ""))
                dataModels.append(TransactionModel(title: "Tài khoản nhận gốc lãi", value: item.actno ?? ""))
            }
        case TransType.payBill.rawValue:
            if item.dorc?.uppercased() == "D" {
                dataModels.append(TransactionModel(title: "Nhà cung cấp", value: item.merchant_name ?? ""))
                dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: item.actno ?? ""))
                dataModels.append(TransactionModel(title: "Mã hóa đơn", value: item.bill_no ?? ""))
            }
        case TransType.rechargePhone.rawValue, TransType.rechargeAirpay.rawValue:
            if item.dorc?.uppercased() == "D" {
                dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: item.actno ?? ""))
                dataModels.append(TransactionModel(title: "Số điện thoại/Số ví", value: item.bill_no ?? ""))
            }
        case TransType.crdCardPayment.rawValue:
            if item.dorc?.uppercased() == "D" {
                dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: item.actno ?? ""))
                dataModels.append(TransactionModel(title: "Số thẻ tín dụng", value: item.destAcctNo ?? ""))
                dataModels.append(TransactionModel(title: "Nội dung", value: item.message ?? ""))
            }
        default:
            if item.dorc?.uppercased() == "D" {
                dataModels.append(TransactionModel(title: "Tài khoản nguồn", value: item.actno ?? ""))
                dataModels.append(TransactionModel(title: "Nội dung", value: item.message ?? ""))
            } else {
                dataModels.append(TransactionModel(title: "Tài khoản nhận", value: item.actno ?? ""))
                dataModels.append(TransactionModel(title: "Nội dung", value: item.message ?? ""))
            }
        }
        
        if showStatus {
            lbStatus.isHidden = false
            statusLine.isHidden = false
            switch item.status {
            case "S", "R":
                lbStatus.text = "Giao dịch thành công"
                lbStatus.textColor = UIColor(hexString: "006EC8")
            case "W":
                lbStatus.text = "Giao dịch chờ xử lý"
                lbStatus.textColor = UIColor(hexString: "ED8A19")
            case "F":
                lbStatus.text = "Giao dịch thất bại"
                lbStatus.textColor = UIColor(hexString: "D75A4A")
            default:
                break
            }
        }
    }
    
}

extension NCBPaymentAccountHistoryDetailPopupView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbPaymentAccountHistoryDetailTableViewCellID.identifier, for: indexPath) as! NCBPaymentAccountHistoryDetailTableViewCell
        let item = dataModels[indexPath.row]
        cell.lbTitle.text = item.title
        cell.lbValue.text = item.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NCBPaymentAccountHistoryDetailHeaderView()
        header.lbAmountValue.textColor = detail?.getAmountColor
        header.lbAmountValue.text = (detail?.getAmount() ?? 0.0).currencyFormatted
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
    
}
