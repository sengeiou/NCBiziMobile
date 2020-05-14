//
//  NCBChargeMoneyPhoneNumberPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/19/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBChargeMoneyPhoneNumberPresenterDelegate {
    @objc optional func chargePhoneNumbCompleted(success: String?, error: String?)
    @objc optional func getListCardValueCompleted(cardValues: [NCBSendSavingItemModel]?, error: String?)
    @objc optional func saveServiceCompleted(error: String?)
}

class NCBChargeMoneyPhoneNumberPresenter {
    
    var delegate: NCBChargeMoneyPhoneNumberPresenterDelegate?
    
    func chargePhoneNumb(params: [String : Any]) {
        let apiService = NCBChargeMoneyService()
        apiService.chargePhoneNumber(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.chargePhoneNumbCompleted?(success: resObj.body, error: nil)
            } else {
                self?.delegate?.chargePhoneNumbCompleted?(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.chargePhoneNumbCompleted?(success: nil, error: error)
        }
    }
    
    func getListCardValue(params: [String : Any]) {
        let apiService = NCBChargeMoneyService()
        apiService.getTopupCardValues(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let items = Mapper<NCBSendSavingItemModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListCardValueCompleted?(cardValues: items, error: nil)
            } else {
                self?.delegate?.getListCardValueCompleted?(cardValues: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCardValueCompleted?(cardValues: nil, error: error)
        }
    }
    
    func saveService(memName: String, providerCode: String, serviceCode: String, billNo: String, type: String, isActive: Bool) {
        var params: [String: Any] = [:]
        if providerCode != "" {
            params["providerCode"] = providerCode
        }
        params["serviceCode"] = serviceCode
        if isActive {
            params["status"] = PayBillingStatus.ACTIVE.rawValue
        } else {
            params["status"] = PayBillingStatus.CLOSE.rawValue
        }
        params["type"] = type.removeDashSymbol
        params["memName"] = memName
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["billNo"] = billNo
        
        let apiService = NCBApiServicePaymentService()
        apiService.saveService(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.saveServiceCompleted?(error: nil)
            } else {
                self?.delegate?.saveServiceCompleted?(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.saveServiceCompleted?(error: error)
        }
    }
}
