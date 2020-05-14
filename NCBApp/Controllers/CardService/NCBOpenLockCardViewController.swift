//
//  NCBCardServiceOpenLockActivateViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBOpenLockCardViewController: NCBCardListViewController {
    
    override var cardTypeParams: [String] {
        return [CreditCardType.VS.rawValue, CreditCardType.DB.rawValue]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NCBOpenLockCardViewController {
    
    override func setupView() {
        super.setupView()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
          setHeaderTitle("Mở khoá/kích hoạt thẻ")
    }
    
    override func applyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.applyCell(tableView, cellForRowAt: indexPath) as! NCBCardListTableViewCell
        let item = cardList[indexPath.row]
        let type = item.getActiveType()
        cell.mainBtn.isHidden = false
        switch type {
        case .lock:
            cell.mainBtn.setTitle("Khoá thẻ", for: .normal)
            cell.mainBtn.normalType()
            break
        case .open:
            cell.mainBtn.setTitle("Mở khoá thẻ", for: .normal)
            cell.mainBtn.normalType()
            break
        case .activate:
            cell.mainBtn.setTitle("Kích hoạt thẻ", for: .normal)
            cell.mainBtn.normalType()
            break
        default:
            cell.mainBtn.isHidden = true
            break
        }
        
        cell.mainBtn.addTarget(self, action: #selector(registerAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func registerAction(_ sender: UIButton) {
        let item = cardList[sender.tag]
        
        if item.isExpired {
            showAlert(msg: ErrorConstant.crdCardExpired.getMessage() ?? "Thẻ của Quý khách đã hết hạn. Quý khách vui lòng liên hệ tổng đài 18006061 để được hỗ trợ.")
            return
        }
        
        if !item.allowOpen {
            showAlert(msg: ErrorConstant.crdCardNotAllowOpen.getMessage() ?? "Thẻ không được phép mở khóa. Quý khách vui lòng liên hệ tổng đài 18006061 để được hỗ trợ.")
            return
        }
        
        if let _vc = R.storyboard.cardService.ncbOpenLockCardDetailViewController() {
            let data = item
            _vc.setupData(data: data)
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
}

