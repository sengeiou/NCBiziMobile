//
//  NCBKeychainService.swift
//  NCBApp
//
//  Created by Thuan on 6/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import KeychainAccess

// MARK: - Constant Identifiers
fileprivate let service = bundleIdentifier
fileprivate let accessLogKeyTouchIDAvai = "access.login.key.touchid"
fileprivate let accessTransactionKeyTouchIDAvai = "access.transaction.key.touchid"
fileprivate let accessDomainState = "access.domain.state"

public class NCBKeychainService: NSObject {
    
    // MARK: - Login ID Avai
    
    class func saveLoginTouchID(data: String) {
        let keychain = Keychain(service: service)
        do {
            try keychain.set(data, key: accessLogKeyTouchIDAvai+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
    }
    
    class func loadLoginTouchID() -> String? {
        let keychain = Keychain(service: service)
        do {
            return try keychain.get(accessLogKeyTouchIDAvai+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    class func removeLoginTouchID() {
        let keychain = Keychain(service: service)
        do {
            return try keychain.remove(accessLogKeyTouchIDAvai+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Transaction ID Avai
    
    class func saveTransactionTouchID(data: String) {
        let keychain = Keychain(service: service)
        do {
            try keychain.set(data, key: accessTransactionKeyTouchIDAvai+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
    }
    
    class func loadTransactionTouchID() -> String? {
        let keychain = Keychain(service: service)
        do {
            return try keychain.get(accessTransactionKeyTouchIDAvai+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    class func removeTransactionTouchID() {
        let keychain = Keychain(service: service)
        do {
            return try keychain.remove(accessTransactionKeyTouchIDAvai+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Bio Domain State
    
    class func saveDomainState(data: String) {
        let keychain = Keychain(service: service)
        do {
            try keychain.set(data, key: accessDomainState+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
    }
    
    class func loadDomainState() -> String? {
        let keychain = Keychain(service: service)
        do {
            return try keychain.get(accessDomainState+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    class func removeDomainState() {
        let keychain = Keychain(service: service)
        do {
            return try keychain.remove(accessDomainState+NCBShareManager.shared.getUserID())
        } catch let error {
            print(error)
        }
    }
}
