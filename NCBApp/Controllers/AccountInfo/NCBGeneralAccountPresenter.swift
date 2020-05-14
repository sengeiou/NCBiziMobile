//
//  NCBGeneralAccountPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBGeneralAccountPresenterDelegate {
    @objc optional func getListPaymentAccountCompleted(listPaymentAccount: [NCBDetailPaymentAccountModel]?, error: String?)
    @objc optional func getListSavingAccountFollowMoneyUnitCompleted(savingAccount: [NCBSavingAccountModel]?, error: String?)
    @objc optional func getListDebtAccountCompleted(listDebtAccount: [NCBDebtAccountModel]?, error: String?)
    @objc optional func getListCreditCardCompleted(listCreditCard: [NCBCreditCardModel]?, error: String?)
    @objc optional func findTransactionTypeCompleted(error: String?)
}

class NCBGeneralAccountPresenter: NSObject {
    
    var delegate: NCBGeneralAccountPresenterDelegate?
    var listTransactionType = [NCBTransactionTypeModel]()
    
    func getListPaymentAccount(_ controlCode: PaymentControlCode) {
        let params: [String: Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "controlCode": controlCode.rawValue
        ]
        let apiUserService = NCBAccountService()
        apiUserService.getListAccountCA(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBDetailPaymentAccountModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListPaymentAccountCompleted?(listPaymentAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getListPaymentAccountCompleted?(listPaymentAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListPaymentAccountCompleted?(listPaymentAccount: nil, error: error)
        }
    }
    
    func getListSavingAccount(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getListSavingAccountFollowMoneyUnit(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBSavingAccountModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListSavingAccountFollowMoneyUnitCompleted?(savingAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getListSavingAccountFollowMoneyUnitCompleted?(savingAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListSavingAccountFollowMoneyUnitCompleted?(savingAccount: nil, error: error)
        }
    }
    
    func getListDebtAccount(params: [String : Any]) {
        let apiAccountService = NCBDebtAccountService()
        apiAccountService.getListDebtAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBDebtAccountModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListDebtAccountCompleted?(listDebtAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getListDebtAccountCompleted?(listDebtAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListDebtAccountCompleted?(listDebtAccount: nil, error: error)
        }
    }
    
    func getListCreditCard(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getListCreditCard(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let dataModels = Mapper<NCBCreditCardModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListCreditCardCompleted?(listCreditCard: dataModels, error: nil)
            } else {
                self?.delegate?.getListCreditCardCompleted?(listCreditCard: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCreditCardCompleted?(listCreditCard: nil, error: error)
        }
    }
    
    func findTransactionType() {
        let apiTransactionService = NCBApiTransactionService()
        apiTransactionService.findTypeTransaction(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.listTransactionType = Mapper<NCBTransactionTypeModel>().mapArray(JSONString: resObj.body) ?? []
                self?.delegate?.findTransactionTypeCompleted?(error: nil)
            } else {
                self?.delegate?.findTransactionTypeCompleted?(error: resObj.description)
            }
        }) { [weak self] error in
            self?.delegate?.findTransactionTypeCompleted?(error: error)
        }
    }
}
