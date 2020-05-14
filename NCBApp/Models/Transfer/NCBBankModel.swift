//
//  NCBBankModel.swift
//  NCBApp
//
//  Created by Thuan on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBBankModel : NCBBaseModel {
    
    var citad_tt  : String?
    var bnk_code  : String?
    var status  : String?
    var bin  : String?
    var bnkname  : String?
    var shtname  : String?
    var citad_gt  : String?
    var name_en: String?
    
    //MARK: Province
    
    var pro_id  : String?
    var shrtname  : String?
    
    //MARK: Branch
    
    var tinh_tp  : String?
    var short_bank  : String?
    var bank  : String?
    var chi_nhanh  : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        citad_tt <- map["citad_tt"]
        bnk_code <- map["bnk_code"]
        status <- map["status"]
        bin <- map["bin"]
        bnkname <- map["bnkname"]
        shtname <- map["shtname"]
        citad_gt <- map["citad_gt"]
        name_en <- map["name_en"]
        
        //MARK: Province
        
        pro_id <- map["pro_id"]
        shrtname <- map["shrtname"]
        
        //MARK: Branch
        
        tinh_tp <- map["tinh_tp"]
        short_bank <- map["short_bank"]
        bank <- map["bank"]
        chi_nhanh <- map["chi_nhanh"]
    }
    
    func getBankFullName() -> String {
        return (shtname?.count ?? 0 > 0) ? "\(shtname?.firstUppercasedOnly ?? "") - \(bnkname ?? "")" : bnkname?.firstUppercasedOnly ?? ""
    }
    
}
