//
//  NCBMailboxPresenter.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import Foundation
import ObjectMapper

@objc protocol NCBMailboxPresenterDelegate {
    @objc optional func getEmailInfo(services: [NCBMailboxModel]?, error: String?)
     @objc optional func updateStatusEmail(services: String?, error: String?)
     @objc optional func deleteEmail(services: String?, error: String?)
}

class NCBMailboxPresenter {
    var delegate: NCBMailboxPresenterDelegate?
    func getEmailInfo(params: [String: Any]) {
        let apiService = NCBMailboxService()
        apiService.getEmailInfo(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBMailboxModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getEmailInfo?(services: services, error: nil)
            } else {
                self?.delegate?.getEmailInfo?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getEmailInfo?(services: nil, error: error)
        }
    }
    
    func updateStatusEmail(params: [String: Any]) {
        let apiService = NCBMailboxService()
        apiService.updateStatusEmail(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                 print(resObj.body)
                let services = resObj.description
                self?.delegate?.updateStatusEmail?(services: services, error: nil)
            } else {
                self?.delegate?.updateStatusEmail?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updateStatusEmail?(services: nil, error: error)
        }
    }
    func deleteEmail(params: [String: Any]) {
        let apiService = NCBMailboxService()
        apiService.deleteEmail(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = resObj.description
                self?.delegate?.deleteEmail?(services: services, error: nil)
            } else {
                self?.delegate?.deleteEmail?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.deleteEmail?(services: nil, error: error)
        }
    }
    
}
