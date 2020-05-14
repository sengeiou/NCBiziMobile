//
//  NCBCustomerSupportPresenter.swift
//  NCBApp
//
//  Created by Van Dong on 08/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBCustomerSupportPresenterDelegate {
    @objc optional func getQuestionAnswer(services: [NCBQuestionAnswerModel]?, error: String?)
    @objc optional func getUserGuide(services: [NCBUserGuideModel]?, error: String?)
    @objc optional func getCustomerInfomation(services: NCBCustomerInfomationModel?, error: String?)
    @objc optional func getDataOptionFeedbackCompleted(options: NCBFeedbackModel?, error: String?)
    @objc optional func sendFeedbackCompleted(error: String?)
}

class NCBCustomerSupportPresenter {
    var delegate: NCBCustomerSupportPresenterDelegate?
    //Câu hỏi thường gặp
    func getQuestionAnswer(params: [String: Any]) {
        let apiService = NCBCustomerSupportService()
        apiService.getQuestionAnswer(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBQuestionAnswerModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getQuestionAnswer?(services: services, error: nil)
            } else {
                self?.delegate?.getQuestionAnswer?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getQuestionAnswer?(services: nil, error: error)
        }
    }
    //hướng dẫn sử dụng
    func getUserGuide(params: [String: Any]) {
        let apiService = NCBCustomerSupportService()
        apiService.getUserGuide(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBUserGuideModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getUserGuide?(services: services, error: nil)
            } else {
                self?.delegate?.getUserGuide?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getUserGuide?(services: nil, error: error)
        }
    }
    //thông tin khách hàng 
    func getCustomerInfomation(params: [String: Any]) {
        let apiService = NCBCustomerSupportService()
        apiService.getCustomerInfomation(params: params, success: { [weak self] (response) in
            let services = Mapper<NCBCustomerInfomationModel>().map(JSONString: response.description)
            self?.delegate?.getCustomerInfomation?(services: services, error: nil)
        }) { [weak self] (error) in
            self?.delegate?.getCustomerInfomation?(services: nil, error: error)
        }
    }
    
    func getDataOptionFeedback() {
        let apiService = NCBCustomerSupportService()
        apiService.getDataOptionFeedback(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let options = Mapper<NCBFeedbackModel>().map(JSONString: resObj.body)
                self?.delegate?.getDataOptionFeedbackCompleted?(options: options, error: nil)
            } else {
                self?.delegate?.getDataOptionFeedbackCompleted?(options: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDataOptionFeedbackCompleted?(options: nil, error: error)
        }
    }
    
    func sendFeedback(params: [String: Any]) {
        let apiService = NCBCustomerSupportService()
        apiService.sendFeedback(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.sendFeedbackCompleted?(error: nil)
            } else {
                self?.delegate?.sendFeedbackCompleted?(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.sendFeedbackCompleted?(error: error)
        }
    }
}
