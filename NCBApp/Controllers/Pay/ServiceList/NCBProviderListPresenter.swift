//
//  NCBProviderListPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

protocol NCBProviderListPresenterDelegate {
    func getListProviderCompleted(providerList: [NCBServiceProviderModel]?, error: String?)
}

class  NCBProviderListPresenter {
    
    var delegate: NCBProviderListPresenterDelegate?
    
    func getListProvider(code: String) {
        let apiService = NCBApiServicePaymentService()
        apiService.getServiceListProvider(params: ["serviceCode": code], success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let providers = Mapper<NCBServiceProviderModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListProviderCompleted(providerList: providers, error: nil)
            } else {
                self?.delegate?.getListProviderCompleted(providerList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListProviderCompleted(providerList: nil, error: error)
        }
    }
    
}
