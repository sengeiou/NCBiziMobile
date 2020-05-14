//
//  NCBCardListPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBCardListPresenterDelegate {
    func getCardListCompleted(cardList: [NCBCardModel]?, error: String?)
}

class NCBCardListPresenter {
    
    var delegate: NCBCardListPresenterDelegate?
    
    func getCardList(params: [String: Any]) {
        let apiService = NCBCreditCardService()
        apiService.getListCreditCard(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let services = Mapper<NCBCardModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getCardListCompleted(cardList: services, error: nil)
            } else {
                self?.delegate?.getCardListCompleted(cardList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getCardListCompleted(cardList: nil, error: error)
        }
    }
    
}
