//
//  NCBRechargeSavedListPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBRechargeSavedListPresenterDelegate {
    func getBenitTopup(benitTopup: NCBBenitTopupModel?, error: String?)
}

class NCBRechargeSavedListPresenter {
    
    var delegate: NCBRechargeSavedListPresenterDelegate?
    
    func getBenitTopup(params: [String : Any]) {
        let apiService = NCBChargeMoneyService()
        apiService.getBenitTopup(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBBenitTopupModel>().mapArray(JSONString: resObj.body)
                var dataModel: NCBBenitTopupModel?
                if dataModels?.count ?? 0 > 0 {
                    dataModel = dataModels?[0]
                }
                self?.delegate?.getBenitTopup(benitTopup: dataModel, error: nil)
            } else {
                self?.delegate?.getBenitTopup(benitTopup: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBenitTopup(benitTopup: nil, error: error)
        }
    }
    
}
