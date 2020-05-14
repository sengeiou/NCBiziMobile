//
//  NCBLocalization.swift
//  NCBApp
//
//  Created by Tuan Pham Hai  on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

//  Convenience function
func localized(_ key: String) -> String {
    return NCBLocalization.shared().localized(key)
}

class NCBLocalization {
    
    // MARK: - Properties
    private static var sharedLocalization: NCBLocalization = {
        let localization = NCBLocalization()
        return localization
    }()
    
    var bundle: Bundle!
    
    // Initialization
    
    private init() {
        bundle = Bundle.main
    }
    // MARK: - Accessors
    
    class func shared() -> NCBLocalization {
        return sharedLocalization
    }
    
    
    func localized(_ key:String, comment:String = "") -> String {
        return bundle.localizedString(forKey: key, value: comment, table: nil)
    }
    
    //MARK:- setLanguage
    // Sets the desired language of the ones you have.
    // If this function is not called it will use the default OS language.
    // If the language does not exists y returns the default OS language.
    func setLanguage(_ langCode:String) {
        var appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        appleLanguages.remove(at: 0)
        appleLanguages.insert(langCode, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        if let languageDirectoryPath = Bundle.main.path(forResource: langCode, ofType: "lproj")  {
            bundle = Bundle.init(path: languageDirectoryPath)
        } else {
            resetLocalization()
        }
    }
    
    //MARK:- Reset Localization
    func resetLocalization() {
        bundle = Bundle.main
    }
    
    //MARK:- Get Language Code
    func getLangCode() -> String {
        let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        let prefferedLanguage = appleLanguages[0]
        if prefferedLanguage.contains("-") {
            let array = prefferedLanguage.components(separatedBy: "-")
            return array[0]
        }
        return prefferedLanguage
    }
}
