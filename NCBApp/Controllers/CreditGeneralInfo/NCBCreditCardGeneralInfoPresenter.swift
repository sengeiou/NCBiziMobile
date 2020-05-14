//
//  NCBCreditCardGeneralInfoPresenter.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBCreditCardGeneralInfoPresenterDelegate {
    func getHistoryCompleted(historyList: [NCBCreditCardDealHistoryModel]?, error: String?)
}

class NCBCreditCardGeneralInfoPresenter {
    
    var delegate: NCBCreditCardGeneralInfoPresenterDelegate?
    
    func getHistory(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getHistoryCreditCardList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let historyList = Mapper<NCBCreditCardDealHistoryModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getHistoryCompleted(historyList: historyList, error: nil)
            } else {
                self?.delegate?.getHistoryCompleted(historyList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getHistoryCompleted(historyList: nil, error: error)
        }
    }
    
}
