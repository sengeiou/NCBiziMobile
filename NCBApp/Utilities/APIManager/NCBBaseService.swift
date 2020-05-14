//
//  NCBBaseService.swift
//  NCBApp
//
//  Created by Thuan on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Moya
import SwiftyJSON
import Alamofire

class NCBBaseService {
    
}

let unknowErrorMsg = "Lỗi kết nối. Quý khách vui lòng thử lại sau."

public struct ResponseModel {
    var code = ""
    var body = ""
    var description = ""
}

public typealias RequestSuccessWithDataClosure = ((JSON) -> Void)
public typealias RequestFailureClosure = ((String?) -> Void)

public struct SuccessResponseKey {
    static let code             = "code"
    static let body             = "body"
    static let description      = "description"
}

public struct ErrorResponseKey {
    static let message              = "message"
    static let error              = "error"
    static let error_description  = "error_description"
}

public func DefaultRequestFailureHandler(_ errorResponse: Response?) -> String {
    // Check statusCode and handle desired errors
    do {
        guard let errorJson = try errorResponse?.mapJSON() as? Dictionary<String, Any> else {
            return unknowErrorMsg
        }
        
        print(errorJson.description)
        switch errorResponse?.statusCode {
        case 401:
            return StringConstant.invalidToken
        case -1009:
            return "SYSTEM-2".getMessage() ?? "Lỗi kết nối Internet yếu, vui lòng kiểm tra kết nối \"Wifi/3G/GPRS\""
        case -1001:
            return "SYSTEM-1".getMessage() ?? "Yêu cầu tạm thời bị gián đoạn. Quý khách vui lòng thử lại sau."
        default:
            let message = errorJson[ErrorResponseKey.error_description] as? String
            return message ?? unknowErrorMsg
        }
    } catch {
        return unknowErrorMsg
    }
}

public func DefaultRequestSuccessHandler(_ response: JSON) -> ResponseModel {
    let code = response[SuccessResponseKey.code].rawString() ?? ""
    let body = response[SuccessResponseKey.body].rawString() ?? ""
    var description = response[SuccessResponseKey.description].rawString() ?? ""
    
    if code != ResponseCodeConstant.success {
        if let mes = code.getMessage() {
            description = mes
        }
    }
    
    return ResponseModel(code: code, body: body, description: description)
}

//public func DefaultRequestLoginFailureHandler(_ errorResponse: Response?) -> String {
//    // Check statusCode and handle desired errors
//    do {
//        guard let errorJson = try errorResponse?.mapJSON() as? Dictionary<String, Any> else {
//            return unknowErrorMsg
//        }
//
//        let message = errorJson[ErrorResponseKey.error_description] as? String
//        return message ?? unknowErrorMsg
//    } catch {
//        return unknowErrorMsg
//    }
//}
