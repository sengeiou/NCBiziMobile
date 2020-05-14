//
//  NCBShareManager.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBShareManager {
    
    static let shared = NCBShareManager()
    
    private init(){}
    
    var sheets = [SheetViewController]()
    fileprivate var user: NCBUserModel?
    fileprivate var access_token: String?
    fileprivate var refresh_token: String?
    
    var areTrading = false
    var openURL: String?
    var messages: [NCBMessageModel]?
    
    func setUser(_ user: NCBUserModel?) {
        self.user = user
        
//        if let user = user {
//            let json = Mapper().toJSONString(user)
//            UserDefaults.standard.set(json, forKey: keyUserSaved)
//            UserDefaults.standard.synchronize()
//        }
    }
    
    func getUser() -> NCBUserModel? {
        return user
    }
        
    func setAccessToken(_ token: String?) {
        self.access_token = token

    }
    
    func getAccessToken() -> String? {
        return access_token
    }
    
    func setRefreshToken(_ token: String?) {
        self.refresh_token = token

    }
    
    func getRefreshToken() -> String? {
        return refresh_token
    }
    
    func setUserID(_ id: String) {
        UserDefaults.standard.setValue(id, forKey: keyUserIDSaved)
    }
    
    func getUserID() -> String {
        if UserDefaults.standard.object(forKey: keyUserIDSaved) != nil {
            return UserDefaults.standard.object(forKey: keyUserIDSaved) as! String
        }
        return ""
    }
    
}
