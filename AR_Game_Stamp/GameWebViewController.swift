//
//  GameWebViewController.swift
//  AR_Game_Stamp
//
//  Created by BWS MacMini 1 on 21/6/2563 BE.
//  Copyright © 2563 com.ARgameStamp.framework. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SwiftyJSON
import CoreLocation

class GameWebViewController: UIViewController, WKUIDelegate {
    //var coreTokenResultObject: responseCoreTokenObject?
    var coreResultObject: responseCoreObject?
    var gameFinishObject: responseGameFinishObject?
    var catchStamp:[String: Any]?
    var wkWebView_display: WKWebView!
    var urlObservation: NSKeyValueObservation?
    var webType: Int?
    var firebase_id:String = ""
    var mstamp: Int = 0
    var game_uuid:String = ""
    let mainUrl:String = "https://argame-dev.7eleven-game.com"
    let mainUrlBws = "https://www.bluewindsolution.com/project/7eleven2020/sampleweb/Views/"
    var jsonData:Data?
    var urlFull = ""
    var urlTemp = ""
    let isUseUrlTemp:Bool = false
    var lat:Double = 0.0
    var long:Double = 0.0
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        let source: String = "var meta = document.createElement('meta');" +
        "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" +
        "head.appendChild(meta);"
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        wkWebView_display = WKWebView(frame: .zero, configuration: conf)
        wkWebView_display.uiDelegate = self
        wkWebView_display.backgroundColor = UIColor.black
        view = wkWebView_display
        if #available(iOS 11.0, *) {
            wkWebView_display.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        wkWebView_display.scrollView.contentInset = .zero
        wkWebView_display.scrollView.alwaysBounceVertical = false
        wkWebView_display.scrollView.bounces = false
        wkWebView_display.scrollView.pinchGestureRecognizer?.isEnabled = false
        wkWebView_display.allowsLinkPreview = false
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    // Disable zooming in webView
    func viewForZooming(in: UIScrollView) -> UIView? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url:URL? = nil
        
        if let dataCore = coreResultObject?.data{
            mstamp = dataCore.mstamp
            game_uuid = dataCore.game.game_uuid
        }
        // 1 stmapbook
        // 2 mission
        // 3 checkin
        // 4 Promotion
        // 5 Donate
        // 6 GlobalMaps
        // 7 back to core function
        // 8 reward BWS
        
        if(webType == 3){
            // Request Lat, Long from Device
            let locManager = CLLocationManager()
            locManager.requestWhenInUseAuthorization()
            if(locManager.location?.coordinate.latitude != nil && locManager.location?.coordinate.longitude != nil){
                lat = (locManager.location?.coordinate.latitude)!
                long = (locManager.location?.coordinate.longitude)!
            } else {
                lat = 13.756331
                long = 100.501762
            }
        }
        
        switch webType {
        // Stamp book
        case 1:
            urlTemp = "\(mainUrlBws)StampBook/Stamp_Book.php?firebase_id=111&game_uuid=111"
            urlFull = "\(mainUrlBws)StampBook/Stamp_Book.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid)"
            //url = URL(string:urlFull)!
            url = URL(string: (isUseUrlTemp ? urlTemp : urlFull))
            break
        // Mission Gallery
        case 2:
            urlTemp = "\(mainUrlBws)Mission/Game_Mission.php?firebase_id=1234&game_uuid=1234"
            urlFull = "\(mainUrlBws)Mission/Game_Mission.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        // checkin
        case 3:
            urlTemp = "\(mainUrl)/checkin"
            urlFull = "\(mainUrl)/checkin?firebase_id=\(firebase_id)&mstamp=\(mstamp)&lat=\(lat)&long=\(long)&game_uuid=\(game_uuid)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        // Promotion
        case 4:
            urlTemp = "\(mainUrl)/promotion"
            urlFull = "\(mainUrl)/promotion?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        // Donate
        case 5:
            urlTemp = "\(mainUrl)/donate"
            urlFull = "\(mainUrl)/donate?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        // Global-maps
        case 6	:
            urlTemp = "\(mainUrl)/global-maps"
            urlFull = "\(mainUrl)/global-maps?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        case 8:
            //urlTemp = "\(mainUrlBws)/postTest.php"
            urlTemp =  "\(mainUrlBws)StampBook/AnimationRandomStamp.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid)&finish_mode=1"
            urlFull = "\(mainUrlBws)StampBook/AnimationRandomStamp.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid)&finish_mode=1"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
        case 9:
            urlTemp =  "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid)"
            urlFull = "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid)"
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
        case 10:
            urlTemp =  "\(self.mainUrlBws)Info/index.php"
            urlFull = "\(self.mainUrlBws)Info/index.php"
                       //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
        // go to core function
        default:
            urlTemp = "\(mainUrlBws)/postTest.php"
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        }
        
        if let url = URL(string:(isUseUrlTemp ? urlTemp : urlFull)){
            var request = URLRequest(url: url)
            if(webType == 8){
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                
                if (firebase_id == ""){
                    urlTemp = "\(mainUrlBws)StampBook/AnimationRandomStamp.php?firebase_id=111&game_uuid=111&finish_mode=1"
                    request = URLRequest(url: url)
                }
                // Encode
               var encodeData:SendDataToRewardWebView = SendDataToRewardWebView(data: SendDataToOpenReward(mstamps_open: [], mstamps: []))
               var json:String?
                if (gameFinishObject?.data) != nil {
                    //MARK: หน้ายินดีด้วย
                    if !((gameFinishObject?.data?.coupons.isEmpty)!) {
                        let couponObj = gameFinishObject?.data?.coupons
                        // coupon to object
                        
                        var m_stampArrayRewardData:[couponRewardData] = []
                        var m_stampOpenOpenOneData:[couponRewardData] = []
                        //let couponRewardDataArray: [couponRewardData] = [couponRewardData]
                        // create array for SendDataToOpenReward
                        
                        for coupon in couponObj! {
                            let couponData: couponRewardData = couponRewardData(name: (coupon?.name)!,description: (coupon?.description)!, image_url: (coupon?.thumbnail_img)!)
                            
                            m_stampArrayRewardData.append(couponData)
                        }
                        encodeData.data.mstamps = []
                        encodeData.data.mstamps_open = m_stampArrayRewardData
                    }else{
                        let emptyArGameDataArray: [couponRewardData?] = []
                        encodeData.data.mstamps = []
                        encodeData.data.mstamps_open = []
                    }
                   
                    let jsonEncoder = JSONEncoder()
                    let jsonData = try! jsonEncoder.encode(encodeData)
                    json = String(data: jsonData, encoding: String.Encoding.utf8)
                    print((json!))
                    let postData = "data=\(json!)"
                    request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)
                    wkWebView_display.load(request)
                }else{
                    /*let json: [String: Any] = ["mstamps_open":"noData",
                     "mstamps":"noData"]
                     jsonData = (try? JSONSerialization.data(withJSONObject: json))!
                     
                     let postData = "data=\(String(data: jsonData!, encoding: String.Encoding.utf8)!)"
                     request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)*/
                    wkWebView_display.load(request)
                }
            }else if(webType == 9){
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                // Encode
                //let catchStampData = (try? JSONSerialization.data(withJSONObject: self.catchStamp))!
                //let jsonCatchStamp = try! JSON(data: catchStampData)
                var encodeData:SendDataToOpenReward?
                var json:String?
                var jsonToSend:Data?
                if(self.gameFinishObject?.data?.ar_game != nil){
                    
                    var encodeData:SendDataToSummary = SendDataToSummary(data: [])
                    var summaryArray:[summaryWebViewData] = []
                    
                    if let dataLoop = self.gameFinishObject?.data?.ar_game{
                        for items in dataLoop{
                            var summaryData:summaryWebViewData = summaryWebViewData(uuid: (items?.item_uuid!)!, image_url: (items?.image_url!)!, quality: (items?.receive!)!)
                            summaryArray.append(summaryData)
                        }
                        encodeData.data.append(contentsOf: summaryArray)
                         //var jsonFromloop:[String:Any] = ["data":"\(dataArray)"]
                        //jsonToSend = (try? JSONSerialization.data(withJSONObject: jsonFromloop))!
                        //encodeData = encodeData
                    }
                    let jsonEncoder = JSONEncoder()
                    let jsonData = try! jsonEncoder.encode(encodeData)
                    json = String(data: jsonData, encoding: String.Encoding.utf8)
                    let postData = "data=\(json!)"
                    request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)
                }
                //request.httpBody = "data=\(postData)"
                self.wkWebView_display.load(request)
            }else{
                wkWebView_display.load(request)
            }
        }
        // Add observation.
        urlObservation = wkWebView_display.observe(\.url, changeHandler: { (webView, change) in
            print(webView.url?.absoluteString)
            if(webView.url?.absoluteString == "https://argame-dev.7eleven-game.com/"){
                SoundController.shared.playClickButton()
                self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
            }
                // back from WebView
            else if (webView.url?.absoluteString.contains("back"))! {
                SoundController.shared.playClickButton()
                self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
            }
                // Close from WebView
            else if (webView.url?.absoluteString.contains("close"))! {
                SoundController.shared.playClickButton()
                self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
            }else if (webView.url?.absoluteString.contains("nextpage"))! {
                SoundController.shared.playClickButton()
                // MARK:Stamp Summary
                //self.urlTemp = "\(self.mainUrlBws)/postTest.php"
                self.urlTemp = "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(self.firebase_id)&game_uuid=\(self.game_uuid)"
                self.urlFull = "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(self.firebase_id)&game_uuid=\(self.game_uuid)"
                if let url = URL(string:(self.isUseUrlTemp ? self.urlTemp : self.urlFull)){
                    var request = URLRequest(url: url)
                    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "POST"
                    // Encode
                    //let catchStampData = (try? JSONSerialization.data(withJSONObject: self.catchStamp))!
                    //let jsonCatchStamp = try! JSON(data: catchStampData)
                    var encodeData:SendDataToOpenReward?
                    var json:String?
                    if(self.gameFinishObject?.data?.ar_game != nil){
                        
                        var encodeData:SendDataToSummary = SendDataToSummary(data: [])
                        var summaryArray:[summaryWebViewData] = []
                        
                        if let dataLoop = self.gameFinishObject?.data?.ar_game{
                            for items in dataLoop{
                                var summaryData:summaryWebViewData = summaryWebViewData(uuid: (items?.item_uuid!)!, image_url: (items?.image_url!)!, quality: (items?.receive!)!)
                                summaryArray.append(summaryData)
                            }
                            encodeData.data.append(contentsOf: summaryArray)
                             //var jsonFromloop:[String:Any] = ["data":"\(dataArray)"]
                            //jsonToSend = (try? JSONSerialization.data(withJSONObject: jsonFromloop))!
                            //encodeData = encodeData
                        }
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try! jsonEncoder.encode(encodeData)
                        json = String(data: jsonData, encoding: String.Encoding.utf8)
                        let postData = "data=\(json!)"
                        request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)
                    }
                    //request.httpBody = "data=\(postData)"
                    self.wkWebView_display.load(request)
                }
            }else if(webView.url?.absoluteString.contains("play"))! {
                self.performSegue(withIdentifier: "continue_to_play_segue", sender: nil)
            }else if (webView.url?.absoluteString.contains("share"))! {
                print(webView.url?.query)
                let urlString = webView.url?.query?.split(separator: "=")
                let resultString = (urlString![1])
                
                let objectsToShare:URL = URL(string: "\(resultString)")!
                // Implement code wherein you take snapshot of the screen if needed. For illustration purposes, assumed an image stored as asset.
                //let image: UIImage = UIImage(named: "", in: ARGameBundle(), with: nil)
                // Button Action. Create a button in your application for "Share" action. Link it to your Controller and add these 3 lines.
                let activityVC = UIActivityViewController(activityItems: [objectsToShare], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    if !completed {
                        activityVC.dismiss(animated: true, completion: nil)
                        //return
                    }
                    // User completed activity
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        })
        
    }
    
}
