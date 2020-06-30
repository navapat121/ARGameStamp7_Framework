//
//  DataFactory.swift
//  AR_STAMP7_iOS
//
//  Created by BWS MacMini 2 on 12/6/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import Foundation

struct DataFactory {
    static var apiUrlMain = "https://argame-api-dev.7eleven-game.com/api/v1/"
    static var urlMain = ""
    static var firebase_id = ""
    static var is_production = false
}

struct WebRequestCore: Codable {
    var code: Int
    var msg: String
    var Data: WebRequestCoreArray
}

struct WebRequestCoreArray : Codable{
    var uuid: String
    var firebase_id: String
    var allmember:String
    var firstname: String
    var lastname: String
    var mobile_no: String
    var mstamp:Int?
    var game : gameDetail
}
