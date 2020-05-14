//
//  NCBBiometricIDAuth.swift
//  TouchFaceID
//
//  Created by Lê Sơn on 4/2/19.
//  Copyright © 2019 Lê Sơn. All rights reserved.
//

import Foundation
import LocalAuthentication

let biometricSuccessCode = 69

enum BiometricType {
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {
    
    let context = LAContext()
    
    init() {
        context.localizedFallbackTitle = ""
    }
    
    var biometricSuffix: String {
        return (biometricType() == .faceID) ? "FaceID" : "Vân tay"
    }
    
    fileprivate func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
        
    func biometricType() -> BiometricType {
        var error: NSError?
        
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error?.code == LAError.Code.touchIDNotAvailable.rawValue {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
             default:
                return .none
            }
        } else {
            return canEvaluatePolicy() ? .touchID : .none
        }
    }
    
    func evaluate(completion: @escaping (_ code: Int, _ msg: String?) -> Void) {        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,localizedReason: "\(appName) muốn sử dụng \(biometricSuffix)") { [unowned self] (success, evaluateError) in
        DispatchQueue.main.async {
            if (success) {
                completion(biometricSuccessCode, nil)
            } else {
                if let error = evaluateError {
                    switch error._code {
                    case LAError.touchIDNotEnrolled.rawValue:
                        completion(error._code, self.biometricType() == .faceID ? "LOGIN_FACEID-1".getMessage() ?? "" : "LOGIN_TOUCHID-1".getMessage() ?? "")
                    case LAError.userCancel.rawValue:
                        completion(error._code, nil)
                    case LAError.touchIDLockout.rawValue:
                        self.context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication,
                                               localizedReason: "LOGIN_TOUCHID-5".getMessage() ?? "",
                                               reply: { (success, error) in
                        })
                    default:
                        completion(error._code, self.biometricType() == .faceID ? "FaceID không hợp lệ, Quý khách vui lòng kiểm tra lại." : "LOGIN_TOUCHID-4".getMessage() ?? "")
                    }
                }
            }
        }
        }
    }
    
    func checkBioNotEnrolled() -> Bool {
        var error: NSError?
        
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error?.code == LAError.Code.touchIDNotEnrolled.rawValue {
            return true
        }
        
        return false
    }
    
    func checkBioStateChanged() -> Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        if let domainState = context.evaluatedPolicyDomainState {
            let newDomain = domainState.base64EncodedString()
            if let oldDomain = NCBKeychainService.loadDomainState(), newDomain != oldDomain {
                removeTouchIDSession()
                return true
            }
        }
        
        
        return false
    }
    
    func domainState() -> String {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        if let domainState = context.evaluatedPolicyDomainState {
            return domainState.base64EncodedString()
        }
        
        return ""
    }
    
}
