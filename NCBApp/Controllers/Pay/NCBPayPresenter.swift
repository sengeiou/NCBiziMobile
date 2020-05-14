//
//  NCBPayPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBPayPresenterDelegate {
    func getServiceListCompleted(services: [NCBServiceModel]?, error: String?)
}

class NCBPayPresenter {
    
    var delegate: NCBPayPresenterDelegate?
    
    func getServiceList(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.getServiceList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let services = Mapper<NCBServiceModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getServiceListCompleted(services: services, error: nil)
            } else {
                self?.delegate?.getServiceListCompleted(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getServiceListCompleted(services: nil, error: error)
        }
    }
    
}
