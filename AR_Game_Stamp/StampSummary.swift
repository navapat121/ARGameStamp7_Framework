//
//  StampSummary.swift
//  AR_Game_Stamp
//
//  Created by BWS MacMini 2 on 19/6/2563 BE.
//  Copyright © 2563 com.ARgameStamp.framework. All rights reserved.
//

import Foundation

class ARGameStampSummary {
    var item_uuid:String?
    var imageUrl:String?
    var quantity:Int?
    init(item_uuid: String, imageUrl:String, quantity:Int){
        self.item_uuid = item_uuid
        self.imageUrl = imageUrl
        self.quantity = quantity
    }
}
