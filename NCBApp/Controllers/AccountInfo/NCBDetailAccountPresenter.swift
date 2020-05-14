//
//  NCBDetailAccountPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBDetailAccountPresenterDelegate {
    func getDetailTransactionHistoryCompleted(model: NCBDetailTransactionHistoryModel? ,error: String?)
    func getAccountDetailCompleted(error: String?)
}

class NCBDetailAccountPresenter: NSObject {
    
    var delegate: NCBDetailAccountPresenterDelegate?
    
    func getDetailTransactionHistory(params: [String : Any]) {
        let apiUserService = NCBDealService()
        apiUserService.getDealDetail(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
                if resObj.code == ResponseCodeConstant.success {
                    
                    let model = Mapper<NCBDetailTransactionHistoryModel>().map(JSONString: resObj.body)
                    self?.delegate?.getDetailTransactionHistoryCompleted(model: model, error: nil)
                } else {
                    self?.delegate?.getDetailTransactionHistoryCompleted(model: nil, error: resObj.description)
                }
        }) { [weak self] (error) in
            self?.delegate?.getDetailTransactionHistoryCompleted(model: nil, error: error)
        }
    }
    
    func getAccountDetail(params: [String : Any]) {
        let apiUserService = NCBAccountService()
        apiUserService.getAccountDetail(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
                if resObj.code == ResponseCodeConstant.success {
                    self?.delegate?.getAccountDetailCompleted(error: nil)
                } else {
                    self?.delegate?.getAccountDetailCompleted(error: resObj.description)
                }
        }) { [weak self] (error) in
            self?.delegate?.getAccountDetailCompleted(error: error)
        }
    }
}
