//
//  HomeViewController.swift
//  AR_STAMP7_iOS
//
//  Created by BWS MacMini 1 on 17/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion
import CoreLocation
import Lottie
//import FirebaseCore
//import FirebaseAnalytics

class ARGameEnv {
    static let shared = ARGameEnv()
    //var env:SevenEnvironment = .prod // ptoon: ไม่ได้ใช้แล้วนื
    var url:String = ""
    var urlPHP:String = ""
    var urlReact:String = ""
    func updateEnv(newEnv:SevenEnvironment) {
        if(newEnv == .dev){//dev
            url = "https://argame-api-dev.7eleven-game.com/api/v1/"
            urlReact = "https://argame-dev.7eleven-game.com/"
            urlPHP = "https://argame-2-dev.7eleven-game.com/"
        }else if(newEnv == .prod){//production
            url = "https://argame-api.7eleven-game.com/api/v1/"
            urlReact = "https://argame.7eleven-game.com/"
            urlPHP = "https://argame-2.7eleven-game.com/"
        }else if(newEnv == .staging){//uat
            url = "https://argame-api-staging.7eleven-game.com/api/v1/"
            urlReact = "https://argame-staging.7eleven-game.com/"
            urlPHP = "https://argame-2-staging.7eleven-game.com/"
        }else if(newEnv == .bws){//bws - dev
            url = "https://argame-api-dev.7eleven-game.com/api/v1/"
            urlReact = "https://argame-dev.7eleven-game.com/"
            urlPHP = "https://bluewindsolution.com/project/7eleven2020/sampleweb/"
        }
    }
}

public enum SevenEnvironment {
  case dev
  case staging
  case prod
    case bws
}

// prepare to navigate to main App
public protocol ARGameStampDelegate: class {
  func deeplinkToMainApp(to scheme: String)
}

public class ARGameHomeViewController : UIViewController, CLLocationManagerDelegate{
    public var sevenEnv: SevenEnvironment = .prod
    public var delegate: ARGameStampDelegate? // Link Main app
    public var fid:String? // Link firebase_ID from Main app
    
    @IBOutlet weak var vLoading: UIView!
    @IBOutlet weak var lottieLoading: AnimationView!
    
    @IBOutlet weak var CoreFooter: UIView!
    @IBOutlet weak var coreFooterMargin: NSLayoutConstraint!
    var coreTokenResultObject:responseCoreTokenObject?
    var firebase_id:String? = ""
    var gameDetailResultObject:responseGameDetailObject?
    var coreResultObject:responseCoreObject?
    var WebRequestCore:WebRequestCore?
    var gameDetail:responseGameDetailObject?
    var specialImgUrl:[String]?
    var resultGameStartDetail:responseGameDetailObject?
    var resultGameUpdateFirstTime : responseGameUpdateFirstTimeObject?
    var gameFinishResultObject:responseGameFinishObject?
    var webType:Int?
    var playgame:Bool = false
    var lat:Double?
    var long:Double?
    var locationManager: CLLocationManager = CLLocationManager()
    var isFirstLoading = true
    static var isShowDonate = false
    
    // MARK: Unwind To Home (Core Function)
    
    @IBAction func unwindToHome( _ seg: UIStoryboardSegue) {
        //dotAnimate.reloadImages()
        /*if(seg.identifier == "summary_exit_to_home"){
         // Stamp Summary
         // MARK: Wait for Stamp Summary WebView
         webType = 1
         DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
         self.performSegue(withIdentifier: "home_to_webview_segue", sender: nil)
         })
         }else*/
        self.vLoading.isHidden = false
        if(seg.identifier == "timeup_to_home_segue"){
            requestCore()
            // if user can't catch special stamp go to summary
            if let finishObject = gameFinishResultObject?.data?.coupons {
                if(finishObject.count > 0){
                    // Reward
                    webType = 8
                } else {
                    // Go To Summary
                    webType = 9
                }
            } else if let finishObject = gameFinishResultObject?.data?.ar_game {
                // Go To Summary
                webType = 9
            }else{
                // Go To Summary
                webType = 9
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.performSegue(withIdentifier: "home_to_webview_segue", sender: nil)
                self.lottieLoading.stop()
            })
        } else if(seg.identifier == "continue_to_play_segue"){
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.performSegue(withIdentifier: "useStamp", sender: nil)
            })
        }else if(seg.identifier == "useStampToHomeSegue"){
            self.lottieLoading.stop()
            self.vLoading.isHidden = true
        }else if(seg.identifier == "webViewToHome_segue"){
            self.lottieLoading.stop()
            self.vLoading.isHidden = true
        }
        // 20200722
        // terminate app, because reject agreement
        else if (seg.identifier == "webViewToExit_segue") {
            self.headerController.backToMain_btn.sendActions(for: .touchUpInside)
        }
    }
    private var lowerController: LowerVIewController!
    private var headerController: HeaderVIewController!
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LowerVIewController,
            segue.identifier == "home_lower" {
            vc.delegate = self.delegate
            self.lowerController = vc
        }
        //preaw declare uppercontroller to use
        if let upper = segue.destination as? HeaderVIewController,
            segue.identifier == "home_upper" {
            upper.delegate = self.delegate
            self.headerController = upper
        }
    }
    public override func viewDidAppear(_ animated: Bool) {
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  AVAuthorizationStatus.authorized
        {
           // Already Authorized
        }
        else
        {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted :Bool) -> Void in
           });
        }
        
        setupLocationManager()
        //locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways)
        {
            if(locationManager.location?.coordinate.latitude != nil && locationManager.location?.coordinate.longitude != nil){
                self.lat = locationManager.location?.coordinate.latitude
                self.long = locationManager.location?.coordinate.longitude
            } else {
                print("ไม่พบตำแหน่งของคุณ กรุณาตรวจสอบสิทธิ์การเข้าถึงหรือสัญญาณ GPS อีกครั้ง")
            }
        } else {
            print("ไม่พบตำแหน่งของคุณ กรุณาตรวจสอบสิทธิ์การเข้าถึงหรือสัญญาณ GPS อีกครั้ง")
        }
        
        // Check request Data
        if(self.coreTokenResultObject?.msg != nil){
            //self.present(systemAlertMessage(title: "Request Error", message: (self.coreTokenResultObject?.msg)!), animated: true, completion: nil)
        } else if(self.coreTokenResultObject?.code == 0){
            requestCore()
        }
        
        if((self.fid) != nil){
            // use FID from main app
            self.firebase_id = self.fid
        } else {
            // use default FID from JNZ UAT
            // self.firebase_id = "V98MW1GtsMPjMiZjoICCTOPnDXu2"
            self.vLoading.isHidden = true
            self.present(self.systemAlertMessage(title: "Alert", message: "ไม่พบข้อมูล กรุณาลองใหม่ภายหลัง"), animated: true, completion: nil)
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //dismiss(animated: false, completion: nil)
    }
    
    deinit {
        lottieLoading.removeFromSuperview()
        lottieLoading = nil
    }
    
    // กรณียังโหลด request Core, Game Detail ไม่สำเร็จ ให้ปิดแอพไปเลย
    func systemAlertMessageAndTerminate(title:String?, message: String?) -> UIAlertController {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        
        // show the alert
        return alert
    }
    
    // deprecate
    /*
    func requestCoreToken() {
        if !isConnectedToNetwork() {
            self.present(self.systemAlertMessage(title: "Internet not connect", message: "Please check internet connection"), animated: true, completion: nil)
            return
        }
        
        // Request API Core User Detail
        let firebaseString = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjdkNTU0ZjBjMTJjNjQ3MGZiMTg1MmY3OWRiZjY0ZjhjODQzYmIxZDciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2V2ZW4tZWxldmVuLXN0YWdpbmciLCJhdWQiOiJzZXZlbi1lbGV2ZW4tc3RhZ2luZyIsImF1dGhfdGltZSI6MTU5MzY3NjQ3NSwidXNlcl9pZCI6IlM0Zm93VFFCaUNURURteXlBWDNCZ1VVNU9pZzEiLCJzdWIiOiJTNGZvd1RRQmlDVEVEbXl5QVgzQmdVVTVPaWcxIiwiaWF0IjoxNTkzNjc2NDc1LCJleHAiOjE1OTM2ODAwNzUsImVtYWlsIjoicHJlYXdfYWxvaGFoQGhvdG1haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsicHJlYXdfYWxvaGFoQGhvdG1haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.lNp8iYu4QxBcaX5VmZNXxo51oM5xmps4kdO2xaX4zXCNs6TqAengVYKMY5x9nNHkw-5dMhxFRG0sb4jmq9XRJBXluHIJiied0Bovt1lsn6nefVOtjSbeXJJsQmop1UIpaB8L7Roq9bmQC2LAIigF5d4tBZoeJxhpS45uLoWoId_BZt3gn12sW8ouoDox_aaKPopwHbDKXEvaZnO26bIenULipuJLye9X7Z01zSDzaGDyUi3yiNSwERO1Ab7a2vnfzYK4pLMvUKIkPivDjli4kzgwCOYgyU7HO3uGpaBjkRgU7MDv-ZUfRmDEDM651aqdmVHAElZUlAMzE9pk71A7ng"
        // -----------------
        //MARK: Core Token
        let strUrl = "core/token?version=2"
        let requestType = "POST"
        let json: [String:Any] = ["token": "\(firebaseString)"]
        //var firebase_id = ""
        let requestData = (try? JSONSerialization.data(withJSONObject: json))!
        
        var url:URL? = URL(string: "")
        //var responseData:Data?
        //var responseStatus:Int? = nil
        let apiOriginal = "\(ARGameEnv.shared.url)\(strUrl)"
        if let encoded = apiOriginal.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let myURL = URL(string: encoded) {
            url = myURL
        }
        //url = URL(string: "\(url)")
        guard let requestUrl = url else { fatalError() }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // insert json data to the request
        if(requestData != nil && requestType == "POST"){
            request.httpBody = requestData
        }
        
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
        
        // Set HTTP Request Header
        //application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("7ar-game", forHTTPHeaderField: "x-api-key")
        request.setValue(self.firebase_id, forHTTPHeaderField:"x-ar-signature" )
        
        //let semaphore = DispatchSemaphore(value: 0)
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("Response data string:\n \(dataString)")
            // --------
            // data ready, call next method here
            do{
                self.coreTokenResultObject = try JSONDecoder().decode(responseCoreTokenObject.self, from: data!)
            }catch{
                self.present(self.systemAlertMessage(title: "Data Error", message: "Request data not Success"), animated: true, completion: nil)
            }
            
            self.firebase_id = self.coreTokenResultObject?.data?.firebase_id
            
            DispatchQueue.main.async(execute: { () -> Void in
                if((self.coreTokenResultObject?.code)! == 0){
                    self.requestCore()
                }else{
                    self.vLoading.isHidden = true
                    self.present(self.systemAlertMessage(title: "Request Error", message: (self.coreTokenResultObject?.msg)!), animated: true, completion: nil)
                }
            })
        }
        task.resume()
        //semaphore.wait()
        //return (responseData,responseStatus)
    }
    */
    
    //==========================
    // *** Core get game_uuid ***
    //==========================
    func requestCore() {
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessageAndTerminate(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
                self.vLoading.isHidden = true
            })
            return
        }
        
        // -----------------
        //MARK: Core
        let strUrl = "core?check_accept=1&version=2"
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
        
        //var json: [String: Any] = ["is_accept": false,"mstamp": ""]
        // insert json data to the request
        //let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
        //request.httpBody = jsonData
        // insert json data to the request
        /*
         if(requestData != nil && requestType == "POST"){
         request.httpBody = requestData
         }
         */
        
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
                
            }
            catch {
                DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code convertData, on requestCore)"), animated: true, completion: nil)
                    self.vLoading.isHidden = true
                })
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if((self.coreResultObject?.code)! == 0){
                    self.lowerController.coreResultObject = self.coreResultObject
                    self.headerController.coreResultObject = self.coreResultObject
                    
                    let currencyFormatter = NumberFormatter()
                    currencyFormatter.usesGroupingSeparator = true
                    currencyFormatter.numberStyle = .decimal
                    currencyFormatter.locale = Locale.current
                    
                    let priceString = currencyFormatter.string(from: NSNumber(value: (self.coreResultObject?.data?.mstamp ?? 0)!))!
                    self.headerController.your_stamp.text = "\(priceString)"
                    
                    // new button donate
                    ARGameHomeViewController.isShowDonate = self.coreResultObject?.data?.is_show_btn_donate ?? false
                    if ARGameHomeViewController.isShowDonate == true {
                        self.lowerController.btnDonate.setImage(UIImage(named: "btn_donate_1", in: Bundle(identifier: "org.cocoapods.ARGameStamp7-11"), compatibleWith: nil), for: UIControl.State.normal)
                    }
                    else {
                        self.lowerController.btnDonate.setImage(UIImage(named: "btn_donate", in: Bundle(identifier: "org.cocoapods.ARGameStamp7-11"), compatibleWith: nil), for: UIControl.State.normal)
                    }
                    
                    if(self.playgame){
                        self.requestGameDetail()
                        self.playgame = false
                    }
                    else if(self.coreResultObject?.data?.is_accept == false){
                        self.webType = 11
                        self.performSegue(withIdentifier: "home_to_webview_segue", sender: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.vLoading.isHidden = true
                        })
                    }
                    else {
                        self.vLoading.isHidden = true
                    }
                    // test accept term
                    /*
                     self.coreResultObject?.data?.is_accept = false
                     */
                }
                else{
                    // hide stich here
                    self.vLoading.isHidden = true
                    self.present(self.systemAlertMessage(title: "Request Error", message: (self.coreResultObject?.msg)!), animated: true, completion: nil)
                    self.headerController.your_stamp.text = "\(0)"
                }
            })
        }
        task.resume()
        //semaphore.wait()
        //return (responseData,responseStatus)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIREBASE WILL DO IT LATER
        /*
        if isFirstLoading {
            
            let secondaryOptions = FirebaseOptions(googleAppID: "1:834824914099:ios:6edfd11c60efa0b4ba5cc6",
                                                   gcmSenderID: "834824914099") //
            secondaryOptions.apiKey = "AIzaSyB9Z0eZ1Xj3-7ycRTtY-9yzBXyTQPjE9Gg" //
            secondaryOptions.projectID = "elevenstampartest" //
            secondaryOptions.bundleID = "org.cocoapods.ARGameStamp7-11" //
                   /*
                   let secondaryOptions = FirebaseOptions(googleAppID: "1:834824914099:ios:6edfd11c60efa0b4ba5cc6",
                                                          gcmSenderID: "834824914099") //
                   secondaryOptions.apiKey = "AIzaSyB9Z0eZ1Xj3-7ycRTtY-9yzBXyTQPjE9Gg" //
                   secondaryOptions.projectID = "elevenstampartest" //
                   secondaryOptions.bundleID = "org.cocoapods.ARGameStamp7-11" //
            */
                   /*
                   //secondaryOptions.trackingID = "UA-12345678-1"
                   secondaryOptions.clientID = "834824914099-u76sqrc0e4950656tv643nkrrh67mpq9.apps.googleusercontent.com" //
                   //secondaryOptions.databaseURL = "https://elevenstampartest.firebaseio.com" //
                   //secondaryOptions.storageBucket = "myproject.appspot.com"
                   //secondaryOptions.androidClientID = "12345.apps.googleusercontent.com"
                   //secondaryOptions.deepLinkURLScheme = "myapp://"
                   secondaryOptions.storageBucket = "elevenstampartest.appspot.com" //
                   */
                   
                   // Use Firebase library to configure APIs
                   //FirebaseApp.configure(name: "secondary", options: )
                   FirebaseApp.configure(options: secondaryOptions)
                   print("generate FirebaseApp2")
            
            isFirstLoading = false
        }
 */
        
        print("Start AR-Stamp Game")
        
        // Register Font To Framework
        do {
            try UIFont.register(path: "Asset/AR STAMP ASSET/font/", fileNameString: "DB HelvethaicaMon X Bd v3.2 4", type: ".ttf")
        } catch  {
            print("Fail to register font")
        }
        /*UIFont.familyNames.forEach { (font) in
            print("Family Name: \(font)")
            UIFont.fontNames(forFamilyName: font).forEach({name in
                print("--Font Name: \(name)")
            })
        }*/
        
        // ----------------------------
        // FIREBASE GOOGLE ANALYTICS
        //Analytics.logEvent("M18_Page", parameters: nil)
        
        ARGameEnv.shared.updateEnv(newEnv: sevenEnv)
        
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

            case 1334:
                print("iPhone 6/6S/7/8")

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")

            case 2436:
                print("iPhone X/XS/11 Pro")

            case 2688:
                print("iPhone XS Max/11 Pro Max")
                self.headerController.widthIMainStamp.constant = 195
                self.coreFooterMargin.constant = -10

            case 1792:
                print("iPhone XR/ 11 ")

            default:
                print("Unknown")
            }
        }

        //ptoon: set asset
        let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Loading Page  Animation/data", ofType: "json")
        let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Loading Page  Animation/images")
        //loadingAnimated.contentMode = UIView.ContentMode.scaleToFill
        lottieLoading.imageProvider = imageProvider
        lottieLoading.animation = Animation.filepath(str!)
        lottieLoading.play()
        
        // Request Lat, Long from Device
        //=========================
        //*** Core Token ***
        //=========================
        //self.fid = "V98MW1GtsMPjMiZjoICCTOPnDXu2" // use in case DEVELOPMENT
        if((self.fid) != nil){
            // use FID from main app
            self.firebase_id = self.fid
        } else {
            // use default FID from JNZ UAT
            // .dev
            //self.firebase_id = "V98MW1GtsMPjMiZjoICCTOPnDXu2"
            // .staging
            //self.firebase_id = "aDu815ZRaRZR9aHjJaavKBAbsP72"
            self.vLoading.isHidden = true
        }
        
        self.lowerController.firebase_id = self.firebase_id
        self.headerController.firebase_id = self.firebase_id
        if(self.firebase_id == ""){
            //requestCoreToken()
        } else {
            requestCore()
        }
        // ------------------
        /*
         //MARK: Core Token
         var requestUrl = "core/token"
         let json: [String:Any] = ["token": "\(firebaseString)"]
         let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
         if let (data,statusCode) = sendHttpRequest(requestType:"POST", strUrl: requestUrl, requestData: jsonData, firebase_id: ""){
         self.coreTokenResultObject = try! JSONDecoder().decode(responseCoreTokenObject.self, from: data!)
         if(statusCode! == 200 ){ // success
         firsbase_id = self.coreTokenResultObject?.data?.firebase_id
         lowerController.coreTokenResultObject = self.coreTokenResultObject
         //==========================
         // *** Core get game_uuid ***
         //==========================
         // MARK: Core Game
         requestUrl = "core"
         if let (data,statusCode) = sendHttpRequest(requestType:"POST", strUrl: requestUrl, requestData: nil, firebase_id: firsbase_id!) {
         self.coreResultObject = try! JSONDecoder().decode(responseCoreObject.self, from: data!)
         if(statusCode! == 200){
         // success
         if((self.coreResultObject?.code)! == 0){
         lowerController.coreResultObject = self.coreResultObject
         headerController.your_stamp.text = "\((self.coreResultObject?.data?.mstamp)!)"
         }else{
         self.headerController.your_stamp.text = "\(0)"
         }
         }else{
         self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success: " + (self.coreResultObject?.msg)!), animated: true, completion: nil)
         }
         } else {
         self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success"), animated: true, completion: nil)
         }
         }else{
         self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success: " + (self.coreTokenResultObject?.msg)!), animated: true, completion: nil)
         }
         }else{
         self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success"), animated: true, completion: nil)
         }
         */
        //preaw get total stamp from api show in core menu
        
        self.headerController.backToMain_btn.addTarget(self, action: #selector(coreBackToMain), for: .touchUpInside)
        self.lowerController.btn_play.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        self.headerController.checkin_btn.addTarget(self, action: #selector(checkInButtonAction), for: .touchUpInside)
        

    }
    
    @objc
       func coreBackToMain(sender:UIButton){
        ARGameSoundController.shared.playClickButton()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func playButtonAction(sender:UIButton){
        ARGameSoundController.shared.playClickButton()
        
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
                self.vLoading.isHidden = true
            })
            return
        }
        
        self.playgame = true
        self.vLoading.isHidden = false
        self.lottieLoading.stop()
        
        if((self.coreResultObject?.code) == 0){
            // 20200724
            //self.requestCore()
            self.requestGameDetail()
            
            // deprecate
            // 20200717
            /*
            if(self.coreResultObject?.data?.is_accept == false){ // not Accept T&C
                self.webType = 11
                self.performSegue(withIdentifier: "home_to_webview_segue", sender: nil)
                self.vLoading.isHidden = true
            }
            else if((self.coreResultObject?.data?.mstamp) == 0){ // no mstamp
                // requestCore to refresh mstamp
                self.requestCore()
            } else {
                // MARK: Game Detail
                //==========================
                // *** Game Detail ***
                //==========================
                self.requestGameDetail()
            }
            */
 
        } /*else{
            // Request Game Detail
             if let game_uuid = self.coreResultObject?.data?.game.game_uuid{
             let requestUrl = "game/" + game_uuid
             if let (data,statusCode) = sendHttpRequest(requestType:"GET", strUrl: requestUrl, requestData: nil, firebase_id: firebase_id!) {
             self.gameDetailResultObject = try! JSONDecoder().decode(responseGameDetailObject.self, from: data!)
             if(statusCode! == 200){
             // success
             // Use Stamp !!
             if((self.gameDetailResultObject?.code) == 0){
             // first time
             if((self.gameDetailResultObject?.data?.game?.is_firsttime)!){
             // go to how to play
             //
             }else{
             self.performSegue(withIdentifier: "useStamp", sender: nil)
             }
             }else{
             self.present(systemAlertMessage(title: "Request Error", message: (self.gameDetailResultObject?.msg)!), animated: true, completion: nil)
             }
             }else{
             //print("Request data not Success: " + (self.resultObject?.msg)!)
             self.present(systemAlertMessage(title: "Request Error", message: (self.gameDetailResultObject?.msg)!), animated: true, completion: nil)
             return
             }
             } else {
             self.gameDetailResultObject = nil
             self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success"), animated: true, completion: nil)
             }
             } else {
             self.present(systemAlertMessage(title: "Request Error", message: (self.gameDetailResultObject?.msg)!), animated: true, completion: nil)
             }
        }*/
    }
    // MARK: CheckIn Button
    @objc func checkInButtonAction(sender: UIButton){
        ARGameSoundController.shared.playClickButton()
        self.webType = 3
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessage(title: "No Internet Connection", message: "ไม่ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
            })
            return
        }
        
        // ----------------------------
        // FIREBASE GOOGLE ANALYTICS
        //Analytics.logEvent("m19_theme_selected", parameters: nil)
        
        self.performSegue(withIdentifier: "home_to_webview_segue", sender: nil)
    }
    
    
    @objc(GameViewForTestSegue) class GameViewForTestSegue: UIStoryboardSegue {
        override func perform() {
            let sourceViewController = self.source as! ARGameHomeViewController
            let destinationViewController = self.destination as! GameViewController
            
            // Send parameter To GamePlay
            //print(sourceViewController.gameDetailResultObject)
            destinationViewController.firebase_id = sourceViewController.firebase_id
            destinationViewController.gameDetail = sourceViewController.gameDetailResultObject
            sourceViewController.present(destinationViewController, animated: true, completion: nil)
        }
    }
    // MARK: Core Function To WebView
    @objc(CoreGotoWebViewSegue) class CoreGotoWebViewSegue: UIStoryboardSegue {
        override func perform() {
            ARGameSoundController.shared.playClickButton()
            if !self.source.isConnectedToNetwork() {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.source.present(self.source.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
                })
                return
            }
            let sourceViewController = self.source as! ARGameHomeViewController
            let destinationViewController = self.destination as! GameWebViewController
            
            destinationViewController.webType = sourceViewController.webType
            destinationViewController.coreResultObject = sourceViewController.coreResultObject
            destinationViewController.firebase_id = sourceViewController.firebase_id!
            destinationViewController.gameFinishObject = sourceViewController.gameFinishResultObject
            destinationViewController.specialImgUrl = sourceViewController.specialImgUrl
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
    
    @objc(StampNoAnimationSegue) class StampNoAnimationSegue: UIStoryboardSegue {
        override func perform() {
            let sourceViewController = self.source as! ARGameHomeViewController
            let destinationViewController = self.destination as! GameUseStampViewController
            
            // Send parameter To UseStampViewController
            // print(sourceViewController.resultGameDetailObject)
            destinationViewController.firebase_id = sourceViewController.firebase_id
            destinationViewController.coreResultObject = sourceViewController.coreResultObject
            destinationViewController.gameDetailResultObject = sourceViewController.gameDetailResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestGameDetail(){
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessageAndTerminate(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
                self.vLoading.isHidden = true
            })
            return
        }
        
        // MARK: Game Detail
        //==========================
        // *** Game Detail ***
        //==========================
        // Request Game Detail
        if let game_uuid = self.coreResultObject?.data?.game?.game_uuid{
            //let requestUrl = "game/" + game_uuid
            let strUrl = "game/\(game_uuid)?version=2"
            let requestType = "GET"
            var url = URL(string:"")
            let apiOriginal = "\(ARGameEnv.shared.url)\(strUrl)"
            if let encoded = apiOriginal.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let myURL = URL(string: encoded) {
                url = myURL
            }
            //url = URL(string: "\(url)")
            guard let requestUrl = url else { fatalError() }
            
            // Create URL Request
            var request = URLRequest(url: requestUrl)
            
            // insert json data to the request
            /*
             if(requestData != nil && requestType == "POST"){
             request.httpBody = requestData
             }
             */
            
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
            
            //firebase_id = self.coreTokenResultObject?.data?.firebase_id!
            
            // Set HTTP Request Header
            //application/json
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("7ar-game", forHTTPHeaderField: "x-api-key")
            request.setValue(firebase_id, forHTTPHeaderField:"x-ar-signature" )
            
            //let semaphore = DispatchSemaphore(value: 0)
            // Send HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // --------
                // data ready, call next method here
                do {
                    // Check if Error took place
                    if error != nil, let response = response as? HTTPURLResponse {
                        //print("Error took place \(error)")
                        // move all statusCode != 200 to here
                        print("Response HTTP Status code: \(response.statusCode)")
                        self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code \(response.statusCode), on requestGameDetail)"), animated: true, completion: nil)
                        return
                    }
                    
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                    print("Response data string:\n \(dataString)")
                    self.gameDetailResultObject = try JSONDecoder().decode(responseGameDetailObject.self, from: data!)
                    
                } catch {
                    self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code convertData, on requestGameDetail)"), animated: true, completion: nil)
                    self.vLoading.isHidden = true
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if((self.gameDetailResultObject?.code)! == 0){
                        self.vLoading.isHidden = false
                        self.performSegue(withIdentifier: "useStamp", sender: nil)
                    }
                    else if((self.gameDetailResultObject?.code)! == 3){ // Mstamp not enough
                        self.vLoading.isHidden = false
                        self.performSegue(withIdentifier: "useStamp", sender: nil)
                    } else {
                        self.present(self.systemAlertMessage(title: "Request Error", message: "Request data not Success: " + (self.gameDetailResultObject?.msg)!), animated: true, completion: nil)
                        self.vLoading.isHidden = true
                    }
                })
            }
            task.resume()
            
        } else {
            requestCore()
        }
    }
}

class HomeBgController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
class HeaderVIewController: UIViewController {
    @IBOutlet weak var widthIMainStamp: NSLayoutConstraint!
    var webType:Int?
    var delegate: ARGameStampDelegate?
    @IBOutlet weak var backToMain_btn: UIButton!
    var firebase_id:String?
    //var coreTokenResultObject:responseCoreTokenObject?
    var coreResultObject:responseCoreObject?
    @IBOutlet weak var useStamp_btn: UIButton!
    @IBOutlet weak var your_stamp: UILabel!
    @IBOutlet weak var checkin_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        useStamp_btn.addTarget(self, action: #selector(toMainAppUseStamp), for: .touchUpInside)
    }
    
    @objc func toMainAppUseStamp(sender: UIButton){
        
        // ----------------------------
        // FIREBASE GOOGLE ANALYTICS
        //Analytics.logEvent("m18_ir_open_content", parameters: nil)
        
        delegate?.deeplinkToMainApp(to: "/internal/navPage/SE034")
        //self.present(systemAlertMessage(title: "Link Main App", message: "SE034 Use Stamp all member here"), animated: true, completion: nil)
    }
    
    @objc(HeaderGotoWebViewSegue) class HeaderGotoWebViewSegue: UIStoryboardSegue {
        override func perform() {
            if !self.source.parent!.isConnectedToNetwork() {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.source.parent!.present(self.source.parent!.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
                })
                return
            }
            ARGameSoundController.shared.playClickButton()
            let sourceViewController = self.source as! HeaderVIewController
            let destinationViewController = self.destination as! GameWebViewController
            
            // 10 GlobalMaps
           if(self.identifier == "webview_info_segue"){
               sourceViewController.webType = 10
           }
            // Checkin
           else if(self.identifier == "webview_checkin_segue"){
            let homeview = self.source.parent! as! ARGameHomeViewController
                if(homeview.lat != nil && homeview.long != nil){
                    destinationViewController.lat = homeview.lat!
                    destinationViewController.long = homeview.long!
                    sourceViewController.webType = 3
                } else {
                    sourceViewController.present(sourceViewController.systemAlertMessage(title: "Location Not Found", message: "ไม่พบตำแหน่งของคุณ กรุณาตรวจสอบสิทธิ์การเข้าถึงหรือสัญญาณ GPS อีกครั้ง"), animated: true, completion: nil)
                    return
                }
            }
            // Send parameter To UseStampViewController
            
            destinationViewController.webType = sourceViewController.webType
            destinationViewController.firebase_id = sourceViewController.firebase_id ?? ""
            destinationViewController.coreResultObject = sourceViewController.coreResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
}

class LowerVIewController: UIViewController {
    @IBOutlet weak var btn_play: UIButton!
    var webType:Int?
    var firebase_id:String?
    var delegate: ARGameStampDelegate?
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var btnCoupon: UIButton!
    var coreResultObject:responseCoreObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCoupon.addTarget(self, action: #selector(toMainAppCoupon), for: .touchUpInside)
    }
    
    @objc func toMainAppCoupon(sender: UIButton){
        //self.present(systemAlertMessage(title: "Link Main App", message: "SE081 Coupon here"), animated: true, completion: nil)
        delegate?.deeplinkToMainApp(to: "/internal/navPage/SE081")
    }
    
    @objc(GotoWebViewSegue) class GotoWebViewSegue: UIStoryboardSegue {
        override func perform() {
            ARGameSoundController.shared.playClickButton()
            if !self.source.parent!.isConnectedToNetwork() {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.source.parent!.present(self.source.parent!.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
                })
                return
            }
            let sourceViewController = self.source as! LowerVIewController
            let destinationViewController = self.destination as! GameWebViewController
            
            // 7 back to core function
            // 1 stmapbook
            if(self.identifier == "webview_stampbook_segue"){

                // ----------------------------
                // FIREBASE GOOGLE ANALYTICS
                //Analytics.logEvent("M18_StampBookPage", parameters: nil)
                
                sourceViewController.webType = 1
            }
                // 2 Mission
            else if(self.identifier == "webview_mission_segue"){

                // ----------------------------
                // FIREBASE GOOGLE ANALYTICS
                //Analytics.logEvent("M18_TransferMStampPage", parameters: nil)
                
                sourceViewController.webType = 2
            }
                // 4 Promotion
            else if(self.identifier == "webview_stamp_Heavily_segue"){
                
                // ----------------------------
                // FIREBASE GOOGLE ANALYTICS
                //Analytics.logEvent("m18_ir_match", parameters: nil)
                
                sourceViewController.webType = 4
            }
            /*    // 4 Promotion
            else if(self.identifier == "webview_coupon_exchange_segue"){
                sourceViewController.webType = 4
            }*/
            // 5 Donate
            else if(self.identifier == "webview_donate_segue"){
                
                // ----------------------------
                // FIREBASE GOOGLE ANALYTICS
                //Analytics.logEvent("M18_DonatePage", parameters: nil)
                if ARGameHomeViewController.isShowDonate {
                    sourceViewController.webType = 51
                }
                else {
                    sourceViewController.webType = 5
                }
            }
                // 6 GlobalMaps
            else if(self.identifier == "webview_premiem_products_segue"){
                
                // ----------------------------
                // FIREBASE GOOGLE ANALYTICS
                //Analytics.logEvent("M18_PremiumPage", parameters: nil)
                
                sourceViewController.webType = 6
            }
                // 10 info
           else if(self.identifier == "webview_info_segue"){
               sourceViewController.webType = 10
           }
            
            
            // Send parameter To UseStampViewController
            destinationViewController.webType = sourceViewController.webType
            destinationViewController.firebase_id = sourceViewController.firebase_id!
            destinationViewController.coreResultObject = sourceViewController.coreResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
}

class BGViewController: UIViewController {
    @IBOutlet weak var bgMainVIew: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bgMainVIew.contentMode = UIView.ContentMode.scaleAspectFill
    }
}
class BGMickyController: UIViewController {
    @IBOutlet weak var bgMicky: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()

        bgMicky.contentMode = UIView.ContentMode.scaleAspectFill
        if UIDevice.modelName == "NEWVERSION" {
            bgMicky.image = UIImage(named: "BG core function");

            bgMicky.image = UIImage(named: "BG core function", in: Bundle(identifier: "org.cocoapods.ARGameStamp7-11"), compatibleWith: nil)
            //bgMicky.contentMode = UIView.ContentMode.scaleAspectFill
        }
        else {
            let randomInt = Int.random(in: 0..<3)
            
            bgMicky.image = UIImage(named: "bg_home_default_\(randomInt + 1)", in: Bundle(identifier: "org.cocoapods.ARGameStamp7-11"), compatibleWith: nil)
            //bgMicky.contentMode = UIView.ContentMode.scaleAspectFit
        }
    }
}

class  HeaderEffectController: UIViewController{
    //@IBOutlet weak var dotEffect: UIImageView!
    @IBOutlet weak var dotAnimate: AnimationView!
    var imageloaded:Bool = false
    var imgListArray : [UIImage]!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UIDevice.modelName == "NEWVERSION" {
            if let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Dot Promax/data", ofType: "json"){
                 //dotAnimate.contentMode = UIView.ContentMode.scaleAspectFill
                if(!imageloaded){
                    let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Dot Promax/images")
                    dotAnimate.imageProvider = imageProvider
                    dotAnimate.animation = Animation.filepath(str)
                    dotAnimate.backgroundBehavior = .pauseAndRestore
                    imageloaded = true
                }
            }
            dotAnimate.loopMode = .loop
            dotAnimate.play()
        }
        else {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //dismiss(animated: false, completion: nil)
    }
    
    deinit {
        dotAnimate.removeFromSuperview()
        dotAnimate = nil
    }
}


class MickyController: UIViewController {
    @IBOutlet weak var mickyAnimate: AnimationView!
    var imageProviderLoaded:Bool = false
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UIDevice.modelName == "NEWVERSION" {

            if let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Corefunction Pro Max Full/data", ofType: "json"){
                let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Corefunction Pro Max Full/images")
                if(!imageProviderLoaded){
                    mickyAnimate.imageProvider = imageProvider
                    mickyAnimate.animation = Animation.filepath(str)
                    imageProviderLoaded = true
                    mickyAnimate.backgroundBehavior = .pauseAndRestore
                    mickyAnimate.contentMode = UIView.ContentMode.scaleAspectFill
                    mickyAnimate.loopMode = .loop
                    mickyAnimate.play()
                }
            }
            
        }
        // old version
        else {
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //dismiss(animated: false, completion: nil)
    }
    
    deinit {
        mickyAnimate.removeFromSuperview()
        mickyAnimate = nil
    }
    
}

