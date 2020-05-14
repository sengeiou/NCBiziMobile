//
//  NCBAutoDebtDeductionViewController.swift
//  NCBApp
//
//  Created by Van Dong on 30/07/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

enum AutoDebtActionType: String {
    case CREATE
    case UPDATE
    case CANCEL
}

class NCBAutoDebtDeductionViewController: NCBCardListViewController {
    
    //AMRK: Properties
    
    fileprivate var p: NCBAutoDebtDeductionPresenter?
    fileprivate var actionType: String?
    fileprivate var cardSelected: NCBCardModel?
    
    override var cardTypeParams: [String] {
        return [CreditCardType.VD.rawValue]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
        p = NCBAutoDebtDeductionPresenter()
        p?.delegate = self
    }
        
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Đăng ký trích nợ tự động")
    }
    
    override func applyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.applyCell(tableView, cellForRowAt: indexPath) as! NCBCardListTableViewCell
        let item = cardList[indexPath.row]
        
        switch item.getAutoDebtCardServiceType() {
        case .registered:
            cell.mainBtn.setTitle("Thay đổi thông tin trích nợ", for: .normal)
            cell.otherBtnView.isHidden = false
            cell.otherBtn.setTitle("Huỷ dịch vụ", for: .normal)
            cell.mainBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell.mainBtn.addTarget(self, action: #selector(updateAction(_:)), for: .touchUpInside)
            cell.otherBtn.addTarget(self, action: #selector(unregisterAction(_:)), for: .touchUpInside)
        case .unregistered:
            cell.mainBtn.setTitle("Đăng ký", for: .normal)
            cell.mainBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell.mainBtn.addTarget(self, action: #selector(registerAction(_:)), for: .touchUpInside)
            cell.otherBtnView.isHidden = true
        default:
            break
        }
        
        return cell
    }
    
    @objc func registerAction(_ sender: UIButton) {
        actionType = AutoDebtActionType.CREATE.rawValue
        cardSelected = cardList[sender.tag]
        checkAutoDebit()
    }
    
    @objc func unregisterAction(_ sender: UIButton) {
        actionType = AutoDebtActionType.CANCEL.rawValue
        cardSelected = cardList[sender.tag]
        checkAutoDebit()
    }
    
    @objc func updateAction(_ sender: UIButton) {
        actionType = AutoDebtActionType.UPDATE.rawValue
        cardSelected = cardList[sender.tag]
        checkAutoDebit()
    }
    
    fileprivate func checkAutoDebit() {
        guard let card = cardSelected else {
            return
        }
        
        let params: [String: Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifNo": NCBShareManager.shared.getUser()?.cif ?? "",
            "cardNo": card.cardno ?? "",
            "action": actionType ?? ""
        ]
        
        SVProgressHUD.show()
        p?.checkAutoDebit(params: params)
    }
    
}

extension NCBAutoDebtDeductionViewController: NCBAutoDebtDeductionPresenterDelegate {
    
    func checkAutoDebitCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        switch actionType {
        case AutoDebtActionType.CREATE.rawValue:
            if let vc = R.storyboard.autoDebtDeduction.ncbRegisterAutoDebtDeductionViewController() {
                vc.card = cardSelected
                vc.type = .register
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case AutoDebtActionType.CANCEL.rawValue:
            if let vc = R.storyboard.autoDebtDeduction.ncbUnregisterAutoDebtDeductionViewController() {
                vc.card = cardSelected
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case AutoDebtActionType.UPDATE.rawValue:
            if let vc = R.storyboard.autoDebtDeduction.ncbRegisterAutoDebtDeductionViewController() {
                vc.card = cardSelected
                vc.type = .update
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
}

