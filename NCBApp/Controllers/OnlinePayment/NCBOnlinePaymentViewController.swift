//
//  NCBOnlinePaymentViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBOnlinePaymentViewController: NCBCardListViewController {
    
    override var cardTypeParams: [String] {
        return [CreditCardType.VD.rawValue, CreditCardType.DB.rawValue]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBOnlinePaymentViewController {
    
    override func setupView() {
        super.setupView()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Dịch vụ thanh toán trực tuyến")
    }
    
    override func applyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.applyCell(tableView, cellForRowAt: indexPath) as! NCBCardListTableViewCell
        let item = cardList[indexPath.row]
        
        if item.registeredECOM {
            cell.mainBtn.setTitle("Huỷ đăng ký", for: .normal)
            cell.mainBtn.destructiveType()
        } else {
            cell.mainBtn.setTitle("Đăng ký dịch vụ", for: .normal)
            cell.mainBtn.normalType()
        }
        cell.mainBtn.addTarget(self, action: #selector(registerAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func registerAction(_ sender: UIButton) {
        let item = cardList[sender.tag]
        if item.isExpired {
            showAlert(msg: ErrorConstant.crdCardExpired.getMessage() ?? "Thẻ của Quý khách đã hết hạn")
            return
        }
        
        if item.cardDBIsLocked {
            showAlert(msg: ErrorConstant.crdCardLocked.getMessage() ?? "Thẻ đang tạm khóa. Quý khách vui lòng liên hệ tổng đài 18006061 để được hỗ trợ.")
            return
        }
        
        if let vc = R.storyboard.onlinePayment.ncbOnlinePaymentRegisterViewController() {
            vc.card = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
