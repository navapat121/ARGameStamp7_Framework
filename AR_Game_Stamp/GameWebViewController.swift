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
import CoreLocation
import Lottie

class GameWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var mainUrlReact = ARGameEnv.shared.urlReact
    var mainUrlPHP = ARGameEnv.shared.urlPHP
    
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
    var previousUrl = ""
    var lat:Double?
    var long:Double?
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var gameWebView: WKWebView!
    @IBOutlet weak var vLoading: UIView!
    @IBOutlet weak var animationLoading: AnimationView!
    override func loadView() {
        super.loadView()
        //let webConfiguration = WKWebViewConfiguration()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.vLoading.isHidden = true
        })
        /*
        if(self.webType == 11){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.vLoading.isHidden = true
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.vLoading.isHidden = true
            })
        }
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainUrlReact = ARGameEnv.shared.urlReact
        self.mainUrlPHP = ARGameEnv.shared.urlPHP+"Views/"
        
        let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Loading Page Animation/data", ofType: "json")
        let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Loading Page Animation/images")
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
        blockView.backgroundColor = UIColor(rgb: 0x9ECBEC)
        switch webType {
        // Stamp book
        case 1:
            urlFull = "\(mainUrlPHP)StampBook/Stamp_Book.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x7baace) // pass
            break
        // Mission Gallery
        case 2:
            urlFull = "\(mainUrlPHP)Mission/Select_Mission.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)&mstamp=\(mstamp)&timetrick=\(timetick)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x1e3e4c) // pass
            break
        // checkin
        case 3:
            urlFull = "\(mainUrlReact)checkin?firebase_id=\(firebase_id)&mstamp=\(mstamp)&lat=\(self.lat!)&long=\(self.long!)&game_uuid=\(game_uuid!)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x7baace)
            break
        // Promotion
        case 4:
            urlFull = "\(mainUrlReact)promotion?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid!)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0xd31e23) // pass red
            blockView.backgroundColor = UIColor(rgb: 0x000000) // pass k'max request
            break
        // Premium
        case 5:
            urlFull = "\(mainUrlReact)global-maps/all-premium?game_uuid=\(game_uuid!)&firebase_id=\(firebase_id)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x7baace)
            break
        // Donate
        case 51:
            urlFull = "\(mainUrlReact)donate?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid!)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x00c6c1)
            break
        // Global-maps
        case 6	:
            urlFull = "\(mainUrlReact)global-maps?firebase_id=\(firebase_id)&mstamp=\(mstamp)&game_uuid=\(game_uuid!)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x000000)
            break
        case 8: //random stamp
            urlFull = "\(mainUrlPHP)StampBook/Gotgift.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)&version=2"
            url = URL(string:urlFull)
        case 9:
            urlFull = "\(self.mainUrlPHP)StampSummary/Stamp_Summary.php?firebase_id=\(firebase_id)&game_uuid=\(game_uuid!)&version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x204651)  // pass
            break
        case 10:
            urlFull = "\(self.mainUrlPHP)Info/index.php?version=2"
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x204651)
            break
        // Term and Condition
        case 11:
            // 20200724 use in v2
            urlFull = "\(self.mainUrlPHP)agreement/index_v2.php?firebase_id=\(firebase_id)&mstamp=\(mstamp)&version=2"
            // 20200717 use in v1
            /*
            urlFull = "\(self.mainUrlPHP)agreement/?firebase_id=\(firebase_id)&mstamp=\(mstamp)"
            */
            url = URL(string:urlFull)
            //blockView.backgroundColor = UIColor(rgb: 0x204651)  // pass
            break
        // Preview Stamp in round
        case 12:
            urlFull = "\(self.mainUrlPHP)stampReview/index.php?firebase_id=\(firebase_id)&version=2"
                       
            // case code == 3, no mstamp
            if self.gameDetailObject?.code == 3 {
                urlFull = "\(mainUrlPHP)stampReview/nomstamp.php?firebase_id=\(firebase_id)&version=2"
            }
            url = URL(string:urlFull)
            blockView.backgroundColor = UIColor(rgb: 0x000000)  // pass black
            break
            
        case 13:
            urlFull = "\(self.mainUrlPHP)stampReview/nomstamp.php?firebase_id=\(firebase_id)&version=2"
            url = URL(string:(urlFull))
            blockView.backgroundColor = UIColor(rgb: 0x000000)  // pass
            break
        // go to core function
        default:
            self.dismiss(animated: false, completion: nil)
            self.destroyWebview()
            break
        }
        
        if let url = URL(string:(urlFull)){
            print("url=\(url)")
            var request = URLRequest(url: url)
            if(webType == 8){
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                
                if (firebase_id == ""){
                    self.dismiss(animated: false, completion: nil)
                    self.destroyWebview()
                    /*
                    urlTemp = "\(mainUrlPHP)StampBook/AnimationRandomStamp.php?firebase_id=111&game_uuid=111&finish_mode=1"
                    request = URLRequest(url: url)
                    */
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
                        var _:[couponRewardData] = []
                        //let couponRewardDataArray: [couponRewardData] = [couponRewardData]
                        // create array for SendDataToOpenReward
                        
                        for (i,coupon) in couponObj!.enumerated() {
                            let couponData: couponRewardData = couponRewardData(name: (coupon?.name)!,description: (coupon?.description)!, image_url: (coupon?.thumbnail_img)!, stamp_url: (specialImgUrl?[i]))
                            m_stampArrayRewardData.append(couponData)
                        }
                        encodeData.data.mstamps = []
                        encodeData.data.mstamps_open = m_stampArrayRewardData
                    }else{
                        //let emptyArGameDataArray: [couponRewardData?] = []
                        encodeData.data.mstamps = []
                        encodeData.data.mstamps_open = []
                    }
                   
                    let jsonEncoder = JSONEncoder()
                    let jsonData = try! jsonEncoder.encode(encodeData)
                    json = String(data: jsonData, encoding: String.Encoding.utf8)
                    json = recheckData(json!)
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
                //var encodeData:SendDataToOpenReward?
                var json:String?
                //var jsonToSend:Data?
                if(self.gameFinishObject?.data?.ar_game != nil){
                    
                    var encodeData:SendDataToSummary = SendDataToSummary(data: [])
                    var summaryArray:[summaryWebViewData] = []
                    
                    if let dataLoop = self.gameFinishObject?.data?.ar_game{
                        for items in dataLoop{
                            let summaryData:summaryWebViewData = summaryWebViewData(uuid: (items?.item_uuid!)!, image_url: (items?.image_url!)!, quality: (items?.receive!)!)
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
                    json = recheckData(json!)
                    let postData = "data=\(json!)"
                    request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)
                }
                //request.httpBody = "data=\(postData)"
                self.gameWebView.load(request)
            }else if(webType == 12){
                
                var request = URLRequest(url: url)
                //var request = URLRequest(url: URL(string:("\(self.mainUrlPHP)postTest.php"))!)
                //var request = URLRequest(url: URL(string:("https://postman-echo.com/post"))!)
                
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                //let encodeData:SendDataToGameDetail = SendDataToGameDetail(data:self.gameDetailObject!)
                let jsonEncoder = JSONEncoder()
                let jsonData = try! jsonEncoder.encode(self.gameDetailObject!)
                var json = String(data: jsonData, encoding: String.Encoding.utf8)
                json = recheckData(json!)
                // TEST
                //json = "{\"data\":{\"firebase_id\":\"dlesVvxbzPM1WUU53eW4e9XQ6dm2\",\"game\":{\"detail\":\"test\",\"game_uuid\":\"c97dd402-b900-11ea-bf1c-24359e7a8738\",\"start_date\":\"1593322320\",\"title\":\"game-1\",\"is_firsttime\":false,\"description\":\"test\",\"end_date\":\"1596214500\",\"schedule\":{\"items\":[{\"hp\":7,\"quantity\":5,\"image_url\":\"https:\\/\\/cpgamear.s3.ap-southeast-1.amazonaws.com\\/game\\/2020\\/07\\/04\\/3d362f2b2acddb44320d9b2968179e55.png\",\"level\":1,\"type\":1,\"description\":\"\\u0e01\\u0e35\\u0e27\\u0e35\\u0e48\",\"name\":\"A1\"}],\"is_store\":false,\"mstamp_use\":2}}},\"code\":0}"
                let postData = "data=\(json!)"
                print("postData=")
                print(postData)
                request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)
                gameWebView.load(request)
            }
            else{
                gameWebView.load(request)
            }
        }
        // Add observation.
        urlObservation = gameWebView.observe(\.url, changeHandler: { (webView, change) in
            //self.vLoading.isHidden = false
            if let checkUrlString = webView.url?.absoluteString {
                print("checkUrlString=\(checkUrlString)")
                if(checkUrlString == self.mainUrlReact){
                    //SoundController.shared.playClickButton()
                    self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
                    self.dismiss(animated: false, completion: nil)
                    self.destroyWebview()
                }
                // 20200724 use in v2
                else if ((checkUrlString.contains("exittomainapp"))) {
                    self.performSegue(withIdentifier: "webViewToExit_segue", sender: nil)
                    self.dismiss(animated: false, completion: nil)
                    self.destroyWebview()
                }
                // 20200724 use in v2
                else if ((webView.url?.fragment == ("sharescreen"))) {
                    let image = self.takeScreenshot(false)

                    // set up activity view controller
                    let imageToShare = [ image! ]
                    let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

                    // exclude some activity types from the list (optional)
                    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

                    // present the view controller
                    self.present(activityViewController, animated: true, completion: nil)
                    
                    self.gameWebView.load(URLRequest(url: URL(string: "\(checkUrlString)complete")!));
                    return
                }
                // Close from WebView
                else if ((checkUrlString.contains("close")) || (checkUrlString.contains("back"))) {
                    // webView now use "closeWebView" as signal
                    //SoundController.shared.playClickButton()

                    self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
                    /*
                    // deprecate
                    // 20200717 use in v1
                    if(self.webType == 11){
                        self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
                    }
                    else {
                        self.performSegue(withIdentifier: "webViewToHome_segue", sender: nil)
                    }
                    */
                    self.dismiss(animated: false, completion: nil)
                    self.destroyWebview()
                }
                else if (checkUrlString.contains("nextpage")) {
                    ARGameSoundController.shared.playClickButton()
                    // MARK:Stamp Summary
                    self.urlFull = "\(self.mainUrlPHP)StampSummary/Stamp_Summary.php?firebase_id=\(self.firebase_id)&game_uuid=\(self.game_uuid!)&version=2"
                    if let url = URL(string: self.urlFull){
                        var request = URLRequest(url: url)
                        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.httpMethod = "POST"
                        // Encode
                        //let catchStampData = (try? JSONSerialization.data(withJSONObject: self.catchStamp))!
                        //let jsonCatchStamp = try! JSON(data: catchStampData)
                        //var encodeData:SendDataToOpenReward?
                        var json:String?
                        if(self.gameFinishObject?.data?.ar_game != nil){
                            
                            var encodeData:SendDataToSummary = SendDataToSummary(data: [])
                            var summaryArray:[summaryWebViewData] = []
                            
                            if let dataLoop = self.gameFinishObject?.data?.ar_game{
                                for items in dataLoop{
                                    let summaryData:summaryWebViewData = summaryWebViewData(uuid: (items?.item_uuid!)!, image_url: (items?.image_url!)!, quality: (items?.receive!)!)
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
                            json = self.recheckData(json!)
                            let postData = "data=\(json!)"
                            request.httpBody = postData.data(using: .utf8, allowLossyConversion: false)
                        }
                        //request.httpBody = "data=\(postData)"
                        self.gameWebView.load(request)
                    }
                }else if(checkUrlString.contains("play")) {
                    if(self.webType == 12){
                        self.dismiss(animated: false, completion: nil)
                        self.destroyWebview()
                    }
                    else {
                        self.performSegue(withIdentifier: "continue_to_play_segue", sender: nil)
                        self.dismiss(animated: false, completion: nil)
                        self.destroyWebview()
                    }
                }
                else if (checkUrlString.contains("sharecomplete")) {
                    self.gameWebView.goBack()
                }
                /*
                else if (checkUrlString.contains("share")) {
                    //print(webView.url?.query)
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
                        } else {
                            self.gameWebView.goBack()
                        }
                        // User completed activity
                    }
                    self.present(activityVC, animated: false, completion: nil)
                }
                */
                else if (checkUrlString.contains("agreement_success")) {
                    self.requestCore()
                }
            }
        })
    }
    
    func requestCore() {
        self.vLoading.isHidden = false
        self.animationLoading.play()
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
                self.vLoading.isHidden = true
            })
            return
        }
        
        // -----------------
        //MARK: Core
        let strUrl = "core?version=2"
        let requestType = "POST"
        
        var url:URL? = URL(string: "")
        //var responseData:Data?
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
        let json: [String: Any] = ["is_accept": true,
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
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // --------
            // data ready, call next method here
            do{
                // Check if Error took place
                if error != nil, let response = response as? HTTPURLResponse {
                    //print("Error took place \(error)")
                    // move all statusCode != 200 to here
                    // Read HTTP Response Status code
                    print("Response HTTP Status code: \(response.statusCode)")
                    responseStatus = response.statusCode
                    self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code \(response.statusCode), on requestCore)"), animated: true, completion: nil)
                    return
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                print("Response data string:\n \(dataString)")
                self.coreResultObject = try JSONDecoder().decode(responseCoreObject.self, from: data!)
            } catch {
                self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code convertData, on requestCore)"), animated: true, completion: nil)
                self.vLoading.isHidden = true
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if((self.coreResultObject?.code)! == 0){
                    // Success
                    self.dismiss(animated: false, completion: nil)
                    self.destroyWebview()
                }else{
                    self.present(self.systemAlertMessage(title: "Request Error", message: (self.coreResultObject?.msg)!), animated: true, completion: nil)
                }
            })
        }
        task.resume()
        //semaphore.wait()
        //return (responseData,responseStatus)
    }
    
    func recheckData(_ _data: String) -> String {
        
        return _data
        .replacingOccurrences(of: "%", with: "%25")
        .replacingOccurrences(of: "&", with: "%26")
        .replacingOccurrences(of: "+", with: "%2B")
    }
    
    // share screen
    /// Takes the screenshot of the screen and returns the corresponding image
    ///
    /// - Parameter shouldSave: Boolean flag asking if the image needs to be saved to user's photo library. Default set to 'true'
    /// - Returns: (Optional)image captured as a screenshot
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        setNeedsStatusBarAppearanceUpdate()

        if #available(iOS 13.0, *) {
            let tag = 3848245
            let keyWindow = UIApplication.shared.connectedScenes
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                statusBar.backgroundColor = hexStringToUIColor(hex: "#7baace")
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999

                keyWindow?.addSubview(statusBarView)
                statusBarView.backgroundColor = hexStringToUIColor(hex: "#7baace")
            }

        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = hexStringToUIColor(hex: "#7baace")
            }
        }
         */
    }

    /*
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
        
    func destroyWebview() {
        animationLoading.removeFromSuperview()
        animationLoading = nil
        
        gameWebView.uiDelegate = nil
        gameWebView.navigationDelegate = nil
        gameWebView.loadHTMLString("", baseURL: nil)
        gameWebView.removeFromSuperview()
        gameWebView = nil
    }
}
