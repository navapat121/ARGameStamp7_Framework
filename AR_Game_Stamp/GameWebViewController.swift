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
import Lottie

class GameWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    // Appsync DEV
    var mainUrl:String = "https://argame-dev.7eleven-game.com/"
    var mainUrlBws = "https://argame-2-dev.7eleven-game.com/Views/"
    // DEV
    //let mainUrl:String = "https://argame-dev.7eleven-game.com"
    //let mainUrlBws = "https://www.bluewindsolution.com/project/7eleven2020/sampleweb/Views/"
    
    
    //var coreTokenResultObject: responseCoreTokenObject?
    var coreResultObject: responseCoreObject?
    var gameFinishObject: responseGameFinishObject?
    var gameDetailObject: responseGameDetailObject?
    var specialImgUrl:[String]?
    //var wkWebView_display: WKWebView!
    var urlObservation: NSKeyValueObservation?
    var webType: Int?
    var firebase_id:String = ""
    var mstamp: Int = 0
    var game_uuid:String? = ""
    
    var jsonData:Data?
    var urlFull = ""
    var urlTemp = ""
    let isUseUrlTemp:Bool = false
    var lat:Double?
    var long:Double?
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var gameWebView: WKWebView!
    @IBOutlet weak var vLoading: UIView!
    @IBOutlet weak var animationLoading: AnimationView!
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
        //gameWebView = WKWebView(frame: .zero, configuration: conf)
        userContentController.addUserScript(script)
        gameWebView.configuration.userContentController.addUserScript(self.getZoomDisableScript())
        gameWebView.uiDelegate = self
        gameWebView.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {
            //wkWebView_display.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
            gameWebView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        gameWebView.scrollView.contentInset = .zero
        gameWebView.scrollView.alwaysBounceVertical = false
        gameWebView.scrollView.bounces = false
        gameWebView.scrollView.pinchGestureRecognizer?.isEnabled = false
        gameWebView.allowsLinkPreview = false
        gameWebView.navigationDelegate = self
        
        // Disabled Cache
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
        //gameWebView = wkWebView_display
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // Disable zooming in webView
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    func viewForZooming(in: UIScrollView) -> UIView? {
        return nil
    }
    
    // On finish loading page
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("loaded")
        if(self.webType == 11){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.vLoading.isHidden = true
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.vLoading.isHidden = true
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainUrl = ARGameEnv.shared.urlReact
        self.mainUrlBws = ARGameEnv.shared.urlPHP+"Views/"
        
        let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Loading Page  Animation/data", ofType: "json")
        let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Loading Page  Animation/images")
        //loadingAnimated.contentMode = UIView.ContentMode.scaleToFill
        animationLoading.imageProvider = imageProvider
        animationLoading.animation = Animation.filepath(str!)
        animationLoading.loopMode = .loop
        animationLoading.play()
        var url:URL? = nil
        
        if let dataCore = coreResultObject?.data{
            mstamp = dataCore.mstamp!
            game_uuid = dataCore.game?.game_uuid
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
            if(self.lat == nil && self.long == nil){
                lat = 13.756331
                long = 100.501762
            }
        }
        
        let timetick = NSDate().timeIntervalSince1970
        switch webType {
        // Stamp book
        case 1:
            urlTemp = "\(mainUrlBws)StampBook/Stamp_Book.php?firebase_id=111&game_uuid=111"
            urlFull = "\(mainUrlBws)StampBook/Stamp_Book.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)"
            //url = URL(string:urlFull)!
            url = URL(string: (isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x204651)
            break
        // Mission Gallery
        case 2:
            urlTemp = "\(mainUrlBws)Mission/Select_Mission.php?firebase_id=1234&game_uuid=1234"
            urlFull = "\(mainUrlBws)Mission/Select_Mission.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)&mstamp=\(mstamp)&timetrick=\(timetick)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x204651)

            break
        // checkin
        case 3:
            urlTemp = "\(mainUrl)checkin"
            urlFull = "\(mainUrl)checkin?firebase_id=\(firebase_id)&mstamp=\(mstamp)&lat=\(self.lat!)&long=\(self.long!)&game_uuid=\(game_uuid!)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x1b754a)
            break
        // Promotion
        case 4:
            urlTemp = "\(mainUrl)promotion"
            urlFull = "\(mainUrl)promotion?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid!)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x1d70a4)
            break
        // Donate
        case 5:
            // Donate stil not use
            //urlTemp = "\(mainUrl)donate"
            //urlFull = "\(mainUrl)donate?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid!)"
            //global-maps/all-premium?mstamp=20000&game_uuid=c97dd402-b900-11ea-bf1c-24359e7a8738&firebase_id=V98MW1GtsMPjMiZjoICCTOPnDXu2"
            urlTemp = "\(mainUrl)global-maps/all-premium"
            urlFull = "\(mainUrl)global-maps/all-premium?game_uuid=\(game_uuid!)&firebase_id=\(firebase_id)"
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x00c6c1)
            break
        // Global-maps
        case 6	:
            urlTemp = "\(mainUrl)global-maps"
            urlFull = "\(mainUrl)global-maps?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid!)"
            //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x000000)
            break
        case 8: //random stamp
            urlTemp = "\(mainUrlBws)StampBook/Gotgift.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)"
            urlFull = "\(mainUrlBws)StampBook/Gotgift.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)"
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
        case 9:
            urlTemp =  "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)"
            urlFull = "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)"
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x204651)
            break
        case 10:
            urlTemp =  "\(self.mainUrlBws)Info/index.php"
            urlFull = "\(self.mainUrlBws)Info/index.php"
                       //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x204651)
            break
        // Term and Condition
        case 11:
            urlTemp =  "\(self.mainUrlBws)agreement/?firebase_id=1&mstamp=1"
            urlFull = "\(self.mainUrlBws)agreement/?firebase_id=\(firebase_id)&mstamp=\(mstamp)"
                       //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        // Preview Stamp in round
        case 12:
            urlTemp =  "\(self.mainUrlBws)stampReview/index.php"
            urlFull = "\(self.mainUrlBws)stampReview/index.php"
                       //url = URL(string:urlFull)!
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        // go to core function
        default:
            urlTemp = "\(mainUrlBws)/postTest.php"
            url = URL(string:(isUseUrlTemp ? urlTemp : urlFull))
            break
        }
        
        if let url = URL(string:(urlFull)){
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
                        
                        for (i,coupon) in couponObj!.enumerated() {
                            let couponData: couponRewardData = couponRewardData(name: (coupon?.name)!,description: (coupon?.description)!, image_url: (coupon?.thumbnail_img)!, stamp_url: (specialImgUrl?[i]))
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
                    gameWebView.load(request)
                }else{
                    /*let json: [String: Any] = ["mstamps_open":"noData",
                     "mstamps":"noData"]
                     jsonData = (try? JSONSerialization.data(withJSONObject: json))!
                     
                     let postData = "data=\(String(data: jsonData!, encoding: String.Encoding.utf8)!)"
                     request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)*/
                    gameWebView.load(request)
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
                self.gameWebView.load(request)
            }else if(webType == 12){
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let encodeData:SendDataToGameDetail = SendDataToGameDetail(data:self.gameDetailObject!)
                let jsonEncoder = JSONEncoder()
                let jsonData = try! jsonEncoder.encode(self.gameDetailObject!)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)
                
                let postData = "data=\(json!)"
                request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)
                gameWebView.load(request)
            }else{
                gameWebView.load(request)
            }
        }
        // Add observation.
        urlObservation = gameWebView.observe(\.url, changeHandler: { (webView, change) in
            //self.vLoading.isHidden = false
            print(webView.url?.absoluteString)
            if(webView.url?.absoluteString == "https://argame-dev.7eleven-game.com/"){
                //SoundController.shared.playClickButton()
                self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
            }
                // back from WebView
            /*else if (webView.url?.absoluteString.contains("back"))! {
                SoundController.shared.playClickButton()
                self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
            }*/
                // Close from WebView
            else if (webView.url?.absoluteString.contains("close"))! {
                // webView now use "closeWebView" as signal
                //SoundController.shared.playClickButton()
                self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
            }else if (webView.url?.absoluteString.contains("nextpage"))! {
                SoundController.shared.playClickButton()
                // MARK:Stamp Summary
                //self.urlTemp = "\(self.mainUrlBws)/postTest.php"
                self.urlTemp = "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(self.firebase_id)&game_uuid=\(self.game_uuid!)"
                self.urlFull = "\(self.mainUrlBws)StampSummary/Stamp_Summary.php?firebase_id=\(self.firebase_id)&game_uuid=\(self.game_uuid!)"
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
                    self.gameWebView.load(request)
                }
            }else if(webView.url?.absoluteString.contains("play"))! {
                if(self.webType == 12){
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "continue_to_play_segue", sender: nil)
                }
                
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
                        activityVC.dismiss(animated: false, completion: nil)
                        //return
                    }
                    // User completed activity
                }
                self.present(activityVC, animated: false, completion: nil)
            }else if (webView.url?.absoluteString.contains("agreement_success"))! {
                self.requestCore()
            }
        })
    }
    
    func requestCore() {
        self.vLoading.isHidden = false
        self.animationLoading.play()
        if !isConnectedToNetwork() {
            self.present(self.systemAlertMessage(title: "Internet not connect", message: "Please check internet connection"), animated: true, completion: nil)
            self.vLoading.isHidden = true
            return
        }
        
        // -----------------
        //MARK: Core
        var strUrl = "core"
        var requestType = "POST"
        
        var url:URL? = URL(string: "")
        var responseData:Data?
        var responseStatus:Int? = nil
        let apiOriginal = "\(ARGameEnv.shared.url)\(strUrl)"
        if let encoded = apiOriginal.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let myURL = URL(string: encoded) {
            url = myURL
        }
        //url = URL(string: "\(url)")
        guard let requestUrl = url else { fatalError() }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        var json: [String: Any] = ["is_accept": true,
                                   "mstamp": self.mstamp]
        // insert json data to the request
        let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
        request.httpBody = jsonData
        
        // Specify HTTP Method to use
        switch requestType {
        case "POST":
            request.httpMethod = "POST"
        case "PUT":
            request.httpMethod = "PUT"
        case "GET":
            request.httpMethod = "GET"
        default:
            request.httpMethod = "POST"
        }
        // firebase_id = coreTokenResultObject?.data?.firebase_id!
        // Set HTTP Request Header
        // application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("7ar-game", forHTTPHeaderField: "x-api-key")
        request.setValue(firebase_id, forHTTPHeaderField:"x-ar-signature" )
        
        //let semaphore = DispatchSemaphore(value: 0)
        // Send HTTP Request
        var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                //print("Error took place \(error)")
                // move all statusCode != 200 to here
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    responseStatus = response.statusCode
                    self.present(self.systemAlertMessage(title: "Request Error", message: "Request data not Success: Status code \(responseStatus!)"), animated: true, completion: nil)
                    return
                }
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("Response data string:\n \(dataString)")
            // --------
            // data ready, call next method here
            do{
                self.coreResultObject = try JSONDecoder().decode(responseCoreObject.self, from: data!)
            } catch {
                self.present(self.systemAlertMessage(title: "Request Error", message: dataString), animated: true, completion: nil)
                self.vLoading.isHidden = true
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if((self.coreResultObject?.code)! == 0){
                    // Success
                    self.dismiss(animated: false, completion: nil)
                }else{
                    self.present(self.systemAlertMessage(title: "Request Error", message: (self.coreResultObject?.msg)!), animated: true, completion: nil)
                }
            })
        }
        task.resume()
        //semaphore.wait()
        //return (responseData,responseStatus)
    }
}
