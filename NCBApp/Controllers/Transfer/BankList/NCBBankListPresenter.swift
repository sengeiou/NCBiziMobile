//
//  NCBBankListPresenter.swift
//  NCBApp
//
//  Created by Thuan on 5/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBBankListPresenterDelegate {
    func getListCompleted(list: [NCBBankModel]?, error: String?)
}

class NCBBankListPresenter {
    
    var delegate: NCBBankListPresenterDelegate?
    
    func getBanks(params: [String: Any], type: BankServiceType) {
        let apiService = NCBApiBankService()
        apiService.getBankList(params: params, type: type, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let items = Mapper<NCBBankModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListCompleted(list: items, error: nil)
            } else {
                self?.delegate?.getListCompleted(list: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCompleted(list: nil, error: error)
        }
    }
    
    func getBankProvinces(params: [String: Any]) {
        let apiService = NCBApiBankService()
        apiService.getBankProvinceList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let items = Mapper<NCBBankModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListCompleted(list: items, error: nil)
            } else {
                self?.delegate?.getListCompleted(list: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCompleted(list: nil, error: error)
        }
    }
    
    func getBankBranchs(params: [String: Any]) {
        let apiService = NCBApiBankService()
        apiService.getBankBranchList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let items = Mapper<NCBBankModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListCompleted(list: items, error: nil)
            } else {
                self?.delegate?.getListCompleted(list: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCompleted(list: nil, error: error)
        }
    }
    
}
