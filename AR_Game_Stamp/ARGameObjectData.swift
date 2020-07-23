//
//  UserInfoStorage.swift
//  AR_STAMP7_iOS
//
//  Created by BWS MacMini 2 on 13/6/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import Foundation
//--------------------------------------//
//       Core Object Response Data      //
//--------------------------------------//
// POST //
struct responseCoreTokenObject : Codable {
    var code:Int
    var msg:String?
    var data:coreTokenData?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}

struct coreTokenData : Codable {
    var firebase_id:String?
}

struct responseCoreObject : Codable {
    var code:Int
    var msg:String?
    var data:coreData?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}

struct coreData : Codable {
    //var uuid: String
    var firebase_id:String?
    var email:String?
    var username:String?
    var allmember:String?
    var firstname:String?
    var lastname:String?
    var mobile_no:String?
    var mstamp:Int?
    var is_accept:Bool?
    var game:gameInfo?
    var is_show_btn_donate: Bool?
}
struct gameInfo : Codable {
    var game_uuid:String
    var title:String?
    var detail:String?
    var description:String?
    var is_firsttime:Bool?
    var start_date:String?
    var end_date:String?
    var schedule:scheduleObject?
    var firebase_id:String?
}

//--------------------------------------//
//   GameDetail Object Response Data    //
//--------------------------------------//
// GET //
struct responseGameDetailObject : Codable {
    var code:Int
    var msg:String?
    var data:gameDetail?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}
struct gameDetail : Codable {
    var game:gameInfo?
}

//--------------------------------------//
//   GameUpdateFirstTime Object Response Data    //
//--------------------------------------//
// PUT //
struct responseGameUpdateFirstTimeObject : Codable {
    var code:Int
    var msg:String?
    var data:gameUpdateData?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}
struct gameUpdateData : Codable {
    var is_firsttime:Bool
}

//--------------------------------------//
//   GameStart Object Response Data    //
//--------------------------------------//
// POST //
struct responseGameStartObject : Codable {
    var code:Int
    var msg:String?
    var data:gameStart?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}

struct gameStart : Codable {
    var game_uuid:String?
    var round_uuid:String?
    var title:String?
    var detail:String?
    var description:String?
    var start_date:String?
    var end_date:String?
    var schedule:scheduleObject?
}

struct scheduleObject : Codable {
    var mstamp_use:Int?
    var is_store:Bool?
    var items: [itemsArray?]
}

struct itemsArray : Codable{
    var item_play_uuid:String?
    var name: String?
    var type:Int?
    var description:String?
    var level:Int?
    var hp:Int?
    var image_url:String?
    var time:Int?
    var quantity:Int?
}

//--------------------------------------//
//   GameUseStamp Object Response Data    //
//--------------------------------------//
// POST //
struct responseGameUseStampObject : Codable {
    var code:Int
    var msg:String?
    var data:useStampData
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}

struct useStampData : Codable {
}

//--------------------------------------//
//   GameUseFinish Object Response Data    //
//--------------------------------------//
// POST //
struct responseGameFinishObject : Codable {
    var code:Int
    var msg:String?
    var data:gameFinishData?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}
// old
/*struct gameFinishData : Codable{
    var item_uuid:String?
    var name:String?
    var description: String?
    var stamp_id:Int?
    var type:Int?
    var hp:Int?
    var level:Int?
    var time:Int?
    var image_url:String?
    var receive:Int?
}*/

struct gameFinishData : Codable {
    var ar_game: [arGamedata?]
    var coupons: [couponFinishData?]
}

struct arGamedata : Codable{
    var item_uuid:String?
   var name:String?
   var description: String?
    var type:Int?
   var stamp_id:Int?
   var hp:Int?
   var level:Int?
   var time:Int?
   var image_url:String?
   var receive:Int?
    init() {
    }
}

struct couponFinishData: Codable {
    var id: String?
    var name:String?
    var description:String?
    var promotion_code:String?
    var condition_url:String?
    var thumbnail_img:String?
    var stamp_url:String?
}

struct requestGameFinishData:Codable {
    var round_uuid:String
    var items: [requestItemsGameFinishData]
}

struct requestItemsGameFinishData:Codable{
    var item_play_uuid:String
    var time_received:String
}
//--------------------------------------//
//   GameArStampBook Object Response Data    //
//--------------------------------------//
// GET //
struct responseArStampBookObject : Codable {
    var code:Int
    var msg:String?
    var data:[arStampBookData?]
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}

struct arStampBookData : Codable{
    var uuid:String
    var name:String
    var description:String
    var type:Int
    var stamp_id:String
    var hp:Int
    var level:Int
    var time:Int
    var image_url:String
    var quality:Int
}

//--------------------------------------//
//   GameMissionArStamp Object Response Data    //
//--------------------------------------//
// GET //
struct responseMissionArStampObject : Codable {
    var code:Int
    var msg:String?
    var data: missionArStampData
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}

struct missionArStampData:Codable {
    var today:[todayArray?]
    var week:[todayArray?]
    var month:[todayArray?]
}

struct todayArray : Codable{
    var mission_uuid:String
    var coupon:couponData
    var items: [missionitemsData?]
}

struct couponData:Codable {
    var id:String
    var name:String
    var detail:String
    var description:String
    var image_url:String
}

struct missionitemsData:Codable {
    var uuid:String
    var quantity:Int
    var type:Int
    var reward_id:String
    var name:String
    var detail:String
    var description:String
    var image_url:String
    var sequence:Int
    var received:Int
    var is_redeem:Bool
}

//--------------------------------------//
//   GameMissionArStamp Object Response Data    //
//--------------------------------------//
// POST //
struct responseMissionArStampRedeemObject : Codable {
    var code:Int
    var msg:String?
    var data: useStampData
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
        case data = "data"
    }
}

//--------------------------------------//
//    Summary Object Response Data      //
//--------------------------------------//
// POST //
class summaryData : Codable {
    var round_uuid:String
    var items:[sumItems]?
}
class sumItems : Codable {
    var item_play_uuid:String
    var item_is_special:Bool
    var time_received:String
}

struct SendDataToOpenReward: Codable {
   //var mstamps_open: couponFinishData
    var mstamps_open: [couponRewardData?]
   var mstamps: [couponRewardData?]
}

struct couponRewardData:Codable{
    var name:String
    var description:String
    var image_url:String
    var stamp_url:String?
    init(name:String,description:String,image_url:String,stamp_url:String?){
        self.name = name
        self.description = description
        self.image_url = image_url
        self.stamp_url = stamp_url
    }
}

struct SendDataToRewardWebView:Codable{
    var data: SendDataToOpenReward
    init(data:SendDataToOpenReward){
        self.data = data
    }
}

struct  SendDataToSummary :Codable{
    var data:[summaryWebViewData]
    init(data:[summaryWebViewData]) {
        self.data = data
    }
}

struct  SendDataToGameDetail :Codable{
    var data:responseGameDetailObject
    init(data:responseGameDetailObject) {
        self.data = data
    }
}

struct summaryWebViewData:Codable {
    var uuid:String
    var image_url:String
    var quality:Int
    init(uuid:String,image_url:String,quality:Int) {
        self.uuid = uuid
        self.image_url = image_url
        self.quality = quality
    }
}
