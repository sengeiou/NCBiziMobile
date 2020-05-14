//
//  NCBSearchDealOnAccountPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBSearchDealOnAccountPresenterDelegate {
    func getDealHistoryCompleted(listAccountCA: [NCBSearchHistoryDealItemModel]?,error: String?)
}

class NCBSearchDealOnAccountPresenter: NSObject {
    
    var delegate: NCBSearchDealOnAccountPresenterDelegate?
    
    func getListDealHistoryOnAccount(params: [String : Any]) {
        let apiUserService = NCBDealService()
        apiUserService.getListDealHistoryOnSearch(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBSearchHistoryDealItemModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getDealHistoryCompleted(listAccountCA: dataModels, error: nil)
            } else {
                self?.delegate?.getDealHistoryCompleted(listAccountCA: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDealHistoryCompleted(listAccountCA: nil, error: error)
        }
    }
}
