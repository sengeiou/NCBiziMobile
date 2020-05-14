//
//  NCBResupplyPINViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation


class NCBResupplyPINViewController: NCBCardListViewController {
    
    override var cardTypeParams: [String] {
        return [CreditCardType.VD.rawValue, CreditCardType.DB.rawValue]
    }
     var presenter: NCBCardServicePresenter?
    var cardData:NCBCardModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NCBResupplyPINViewController {
    
    override func setupView() {
        super.setupView()
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Cấp lại PIN thẻ")
        
    }
    
    override func applyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.applyCell(tableView, cellForRowAt: indexPath) as! NCBCardListTableViewCell
        //let item = cardList[indexPath.row]
        cell.mainBtn.setTitle("Cấp lại mã PIN", for: .normal)
        cell.mainBtn.normalType()
        cell.mainBtn.addTarget(self, action: #selector(registerAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func registerAction(_ sender: UIButton) {
         cardData = cardList[sender.tag]
        var params: [String: Any] = [:]
        params["cifNo"] = NCBShareManager.shared.getUser()!.cif
        params["username"] = NCBShareManager.shared.getUser()!.username
        params["cardNo"] = cardData.cardno
        print(params)
        SVProgressHUD.show()
        presenter?.checkReissuePin(params: params)
        
       
    }
    
}

extension NCBResupplyPINViewController: NCBCardServicePresenterDelegate {
    func checkReissuePin(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if let _vc =  R.storyboard.cardService.ncbRegistrationResupplyPINViewController() {
                _vc.setupData(data: cardData)
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        }
    }
    
}
