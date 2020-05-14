//
//	Body.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NCBAccountModel : NCBBaseModel {

    var actcur  : String?
    var actno   : String?
    var amount  : String?
    var dorc    : String?
	var message : String?
    var seqno   : String?
	var txndate : String?


    override func mapping(map: Map) {
        super.mapping(map: map)
        
		actcur <- map["actcur"]
		actno <- map["actno"]
		amount <- map["amount"]
		dorc <- map["dorc"]
		message <- map["message"]
		seqno <- map["seqno"]
		txndate <- map["txndate"]
	}
}
