//
//  NCBSplashPresenter.swift
//  NCBApp
//
//  Created by Thuan on 9/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBSplashPresenterDelegate {
    @objc optional func getHotline(services: [String]?, error: String?)
    @objc optional func getBanner(services: [NCBBannerModel]?, error: String?)
    @objc optional func getVersion(services: NCBCheckVersionUpdateModel?, error: String?)
    @objc optional func getAllMessageCompleted(messages: [NCBMessageModel]?, error: String?)
}

class NCBSplashPresenter: NSObject {
    var delegate: NCBSplashPresenterDelegate?
    
    func getHotline(params: [String: Any]) {
        let apiService = NCBMenuService()
        apiService.getHotline(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = resObj.body.components(separatedBy: "-")
                self?.delegate?.getHotline?(services: services, error: nil)
            } else {
                self?.delegate?.getHotline?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getHotline?(services: nil, error: error)
        }
    }
    
    func getBanner(params: [String : Any]) {
        let apiUserService = NCBAppConfigService()
        apiUserService.getBanner(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBBannerModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getBanner?(services: services, error: nil)
            } else {
                self?.delegate?.getBanner?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBanner?(services: nil, error: error)
        }
    }
    
    func getVersion(params: [String : Any]) {
        let apiUserService = NCBAppConfigService()
        apiUserService.getVersion(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBCheckVersionUpdateModel>().map(JSONString: resObj.body)
                self?.delegate?.getVersion?(services: services, error: nil)
            } else {
                self?.delegate?.getVersion?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getVersion?(services: nil, error: error)
        }
    }
    
    func getAllMessage() {
        let apiUserService = NCBAppConfigService()
        apiUserService.getAllMessage(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
               let messages = Mapper<NCBMessageModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getAllMessageCompleted?(messages: messages, error: nil)
            } else {
                self?.delegate?.getAllMessageCompleted?(messages: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getAllMessageCompleted?(messages: nil, error: error)
        }
    }
    
}
