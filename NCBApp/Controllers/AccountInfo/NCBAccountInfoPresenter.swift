//
//  NCBAccountInfoPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBAccountInfoPresenterDelegate {
    @objc optional func getTopTenDealCompleted(listHistoryItems: [NCBDetailHistoryDealItemModel]?,error: String?)
    @objc optional func searchTransactionCompleted(listHistoryItems: [NCBDetailHistoryDealItemModel]?,error: String?)
    @objc optional func searchTransactionByCifCompleted(listHistoryItems: [NCBDetailHistoryDealItemModel]?,error: String?)
}

class NCBAccountInfoPresenter: NSObject {
    
    var delegate: NCBAccountInfoPresenterDelegate?
    
    func getTopTenDeal(params: [String : Any]) {
        SVProgressHUD.show()
        let apiUserService = NCBDealService()
        apiUserService.getTopTenDealService(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
                if resObj.code == ResponseCodeConstant.success {
                    let models = Mapper<NCBDetailHistoryDealItemModel>().mapArray(JSONString: resObj.body)
                    self?.delegate?.getTopTenDealCompleted?(listHistoryItems: models, error: nil)
                } else {
                    self?.delegate?.getTopTenDealCompleted?(listHistoryItems: nil, error: resObj.description)
                }
        }) { [weak self] (error) in
            self?.delegate?.getTopTenDealCompleted?(listHistoryItems: nil, error: error)
        }
    }
    
    func searchTransaction(params: [String : Any]) {
        let apiUserService = NCBDealService()
        apiUserService.getListDealHistoryOnSearch(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBDetailHistoryDealItemModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.searchTransactionCompleted?(listHistoryItems: dataModels, error: nil)
            } else {
                self?.delegate?.searchTransactionCompleted?(listHistoryItems: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.searchTransactionCompleted?(listHistoryItems: nil, error: error)
        }
    }
    
    func searchTransactionByCif(params: [String : Any]) {
        let apiUserService = NCBDealService()
        apiUserService.searchTransactionByCif(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBDetailHistoryDealItemModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.searchTransactionByCifCompleted?(listHistoryItems: dataModels, error: nil)
            } else {
                self?.delegate?.searchTransactionByCifCompleted?(listHistoryItems: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.searchTransactionByCifCompleted?(listHistoryItems: nil, error: error)
        }
    }
    
}
