//
//  NCBCardReissueViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCardReissueViewController: NCBCardListViewController {
    
    override var cardTypeParams: [String] {
        return [CreditCardType.VD.rawValue, CreditCardType.DB.rawValue,]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBCardReissueViewController {
    
    override func setupView() {
        super.setupView()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Đăng ký phát hành lại thẻ")
    }
    
    override func applyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.applyCell(tableView, cellForRowAt: indexPath) as! NCBCardListTableViewCell
        //let item = cardList[indexPath.row]
        cell.mainBtn.setTitle("Phát hành lại", for: .normal)
        cell.mainBtn.normalType()
        cell.mainBtn.addTarget(self, action: #selector(registerAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func registerAction(_ sender: UIButton) {
        if let _vc = R.storyboard.cardService.ncbRegistrationCardReissueViewController() {
            let data = cardList[sender.tag]
            _vc.setupData(data: data)
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
}



