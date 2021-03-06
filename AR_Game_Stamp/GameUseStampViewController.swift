//
//  GameUseStampViweController.swift
//  AR_STAMP7_iOS
//
//  Created by BWS MacMini 2 on 14/6/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import CoreLocation

class GameUseStampViewController: UIViewController {
    // ###### Request Object #####
    //var coreTokenObject:responseCoreTokenObject?
    var coreResultObject:responseCoreObject?
    var gameDetailResultObject:responseGameDetailObject?
    var gameDetailResultString:String?
    var firebase_id: String?
    //var resultObject:responseCoreTokenObject?
    //var gameDetailResultObject:responseGameDetailObject?
    var gameStartResultObject:responseGameStartObject?
    var gameUseStampResultObject:responseGameUseStampObject?
    let debug_mode:Bool = true
    var strUrl:String = ""
    var counter:Int?
    var requestType:String = ""
    var url:URL?
    var responseData:Data?
    var responseStatus:Int?
    var is_tutorial_from_firsttime:Int? = 0
    var isPlayClick = false
    var lat:Double?
    var long:Double?
    
    
    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var vPopUpUseMStamp: UIView!
    @IBOutlet weak var ivUseMStamp: UIImageView!
    @IBOutlet weak var ivFreeMStamp: UIImageView!
    @IBOutlet weak var loading_ani: AnimationView!
    @IBOutlet weak var confirm_btn: UIButton!
    //@IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var loadingBG: UIImageView!
    @IBOutlet weak var cancel_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Loading Page Animation/data", ofType: "json")
        let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Loading Page Animation/images")
        //loading_ani.contentMode = UIView.ContentMode.scaleToFill
        
        // Request Lat, Long from Device
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways)
        {
            if(locManager.location?.coordinate.latitude != nil && locManager.location?.coordinate.longitude != nil){
                self.lat = locManager.location?.coordinate.latitude
                self.long = locManager.location?.coordinate.longitude
            } else {
                print("ไม่พบตำแหน่งของคุณ กรุณาตรวจสอบสิทธิ์การเข้าถึงหรือสัญญาณ GPS อีกครั้ง")
            }
        } else {
            print("ไม่พบตำแหน่งของคุณ กรุณาตรวจสอบสิทธิ์การเข้าถึงหรือสัญญาณ GPS อีกครั้ง")
        }
        
        loading_ani.imageProvider = imageProvider
        loading_ani.animation = Animation.filepath(str!)
        loading_ani.play()
        loading_ani.loopMode = .loop
        //counterLabel()
        tutorialBtn.addTarget(self, action: #selector(goToTutorialAction), for: .touchUpInside)
        confirm_btn.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        cancel_btn.addTarget(self, action: #selector(buttonBack), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if(self.lat == nil || self.long == nil){
                self.lat = 13.756331
                self.long = 100.501762
                self.requestGameDetail()
            } else {
                self.requestGameDetail()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Wiat For Loading screen
        /* DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
         self.loading_ani.isHidden = true
         self.loadingImage.isHidden = true
         self.loadingBG.isHidden = true
         self.loading_ani.stop()
         })*/
    }
    @objc func goToTutorialAction(sender:UIButton) {
        ARGameSoundController.shared.playClickButton()
        self.performSegue(withIdentifier: "tutorialFirstTime", sender: nil)
    }
    @objc func buttonBack(sender:UIButton) {
        ARGameSoundController.shared.playClickButton()
        //self.loadingBG.isHidden = false
        //self.loadingImage.isHidden = false
        //self.loading_ani.isHidden = false
        //self.loading_ani.play()
        performSegue(withIdentifier: "useStampToHomeSegue", sender: self)
    }
    @objc func confirmButtonAction(sender:UIButton){
        ARGameSoundController.shared.playClickButton()
        //self.loadingBG.isHidden = false
        //self.loadingImage.isHidden = false
        //self.loading_ani.isHidden = false
        //self.loading_ani.play()
        // request game start
        self.requestGameStart()
        
        
        //self.loadingImage.isHidden = false
        //self.loadingBG.isHidden = false
        //self.performSegue(withIdentifier: "playGame", sender: nil)
        
        //==========================
        // *** Game Start ***
        //==========================
        // request Start Game
        //self.requestGameStart()
        //==========================
        // *** Use Stamp ***
        //==========================
        // request Use Stamp
        // self.requestGameUseStamp()
        
        // ====== START GAME ======
        /*if ((gameUseStampResultObject?.code)! == 0){
         self.performSegue(withIdentifier: "playGame", sender: nil)
         }*/
    }
    
    @objc(SEPushNoAnimationSegue) class SEPushNoAnimationSegue: UIStoryboardSegue {
        override func perform() {
            let sourceViewController = self.source as! GameUseStampViewController
            let destinationViewController = self.destination as! GameViewController
            
            // Send parameter To GamePlay
            destinationViewController.firebase_id = sourceViewController.firebase_id
            destinationViewController.coreResultObject = sourceViewController.coreResultObject
            destinationViewController.gameDetail = sourceViewController.gameDetailResultObject
            destinationViewController.resultGameStartDetail = sourceViewController.gameStartResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
    
    @objc(UseMstampToTutorial) class UseMstampToTutorial: UIStoryboardSegue {
        override func perform() {
            let sourceViewController = self.source as! GameUseStampViewController
            let destinationViewController = self.destination as! TutorialViewController
            
            // Send parameter To GamePlay
            //print(sourceViewController.gameDetailResultObject)
            destinationViewController.is_tutorial_from_firsttime = sourceViewController.is_tutorial_from_firsttime
            destinationViewController.firebase_id = sourceViewController.firebase_id
            destinationViewController.gameDetail = sourceViewController.gameDetailResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
    /*
    func counterLabel(){
        let steps: Int = 1
        let duration = 0.01
        let rate = duration / Double(steps)
        DispatchQueue.global().async {
            for i in 0...100 {
                DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(i)) {
                    self.loadinfText.text = "\(i)%"
                    self.counter = i
                }
            }
        }
    }*/
    
    // step 3:
    func requestGameUseStamp(){
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
            })
            return
        }
        
        //==========================
        // *** Use Stamp ***
        //==========================
        // request Use Stamp
        if let game_uuid = self.coreResultObject?.data?.game?.game_uuid {
            strUrl = "game/" + game_uuid + "/use-mstamp?version=2"
            requestType = "POST"
            url = URL(string: "")
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
            let json: [String: Any] = ["round_uuid": "\((self.gameStartResultObject?.data?.round_uuid)!)"]
            let requestData = (try? JSONSerialization.data(withJSONObject: json))!
            if(requestType == "POST"){
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
                        print("Response HTTP Status code: \(response.statusCode)")
                        self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code \(response.statusCode), on requestGameUseStamp)"), animated: true, completion: nil)
                        return
                    }
                    
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                    print("Response data string:\n \(dataString)")
                    
                    // deprecate in v.2
                    // will never happen anymore
                    if (dataString.contains("\"code\":3")) {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.loadingBG.isHidden = true
                            //self.loadingImage.isHidden = true
                            self.loading_ani.isHidden = true
                            self.loading_ani.stop()
                            
                            self.vPopUpUseMStamp.isHidden = true
                            self.tutorialBtn.isHidden = true
                            
                        })
                        return
                    }
                    self.gameUseStampResultObject = try JSONDecoder().decode(responseGameUseStampObject.self, from: data!)
                }
                catch {
                    self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code convertData, on requestGameUseStamp)"), animated: true, completion: nil)
                    self.loadingBG.isHidden = true
                    //self.loadingImage.isHidden = true
                    self.loading_ani.isHidden = true
                    self.loading_ani.stop()
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if ((self.gameUseStampResultObject?.code)! == 0){
                        self.performSegue(withIdentifier: "playGame", sender: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.loading_ani.isHidden = true
                            self.loading_ani.stop()
                            
                            self.loading_ani.removeFromSuperview()
                            self.loading_ani = nil
                            //self.loadingImage.isHidden = false
                            self.loadingBG.isHidden = false
                            // this page wont show anymore , destroy to clear memory
                        })
                        
                    } else {
                        //self.present(self.systemAlertMessage(title: "Request Error", message: (self.gameUseStampResultObject?.msg)!), animated: true, completion: nil)
                        self.confirm_btn.removeTarget(self, action: #selector(self.confirmButtonAction), for: .touchUpInside)
                        self.confirm_btn.addTarget(self, action: #selector(self.buttonBack), for: .touchUpInside)
                        self.loadingBG.isHidden = true
                        //self.loadingImage.isHidden = true
                        self.loading_ani.isHidden = true
                        self.loading_ani.stop()
                    }
                })
            }
            task.resume()
        }
        /*if let game_uuid = self.coreResultObject?.data?.game.game_uuid {
         let requestUrl = "game/" + game_uuid + "/use-mstamp"
         var json: [String: Any] = ["round_uuid": "\((self.gameStartResultObject?.data?.round_uuid)!)"]
         let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
         if let (data,statusCode) = sendHttpRequest(requestType:"POST", strUrl: requestUrl, requestData: jsonData, firebase_id: firebase_id!) {
         //use round uuid
         if let round_uuid = self.gameStartResultObject?.data?.round_uuid{
         json = ["round_uuid": "\(round_uuid)"]
         }
         self.gameUseStampResultObject = try! JSONDecoder().decode(responseGameUseStampObject.self, from: data!)
         if(statusCode! == 200){
         // success
         // go to play game
         if ((gameUseStampResultObject?.code)! == 0){
         self.loading_ani.isHidden = true
         }else{
         self.present(systemAlertMessage(title: "Request Error", message: (self.gameUseStampResultObject?.msg)!), animated: true, completion: nil)
         }
         }else{
         self.present(systemAlertMessage(title: "Request Error", message: (self.gameUseStampResultObject?.msg)!), animated: true, completion: nil)
         
         }
         } else {
         self.coreTokenObject = nil
         self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success"), animated: true, completion: nil)
         }
         } else {
         self.present(systemAlertMessage(title: "Alert", message:"Request game start unavailible. cannot start game please try again later."), animated: true, completion: nil)
         
         }*/
    }
    
    // step 2: when click confirm
    func requestGameStart(){
        // allow to click play only 1 time
        if isPlayClick {
            return
        }
        
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
            })
            return
        }

        isPlayClick = true
        //==========================
        // *** Game Start ***
        //==========================
        // request Game detail
        //print(self.gameDetailResultObject!)
        //
        let json: [String: Any] = ["lat": self.lat as Any,
                                   "long": self.long as Any]
        
        strUrl = "game/" + (self.gameDetailResultObject?.data?.game?.game_uuid)! + "/start?version=2"
        requestType = "POST"
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
         let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
         let requestData = jsonData
         if(requestType == "POST"){
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
                    print("Response HTTP Status code: \(response.statusCode)")
                    self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code \(response.statusCode), on requestGameStart)"), animated: true, completion: nil)
                    return
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                print("requestGameStart() Response data string:\n \(dataString)")
                self.gameStartResultObject = try JSONDecoder().decode(responseGameStartObject.self, from: data!)
            }catch{
                self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code convertData, on requestGameStart)"), animated: true, completion: nil)
                self.loadingBG.isHidden = true
                //self.loadingImage.isHidden = true
                self.loading_ani.isHidden = true
                self.loading_ani.stop()
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if((self.gameStartResultObject?.code)! == 0){
                    // request game start
                    self.requestGameUseStamp()
                } else {
                    self.present(self.systemAlertMessage(title: "Request Error", message: (self.gameStartResultObject?.msg)!), animated: true, completion: nil)
                    self.loadingBG.isHidden = true
                    //self.loadingImage.isHidden = true
                    self.loading_ani.isHidden = true
                    self.loading_ani.stop()
                }
            })
        }
        task.resume()
        /*if let (data,statusCode) = sendHttpRequest(requestType:"POST", strUrl: requestUrl, requestData: jsonData, firebase_id: firebase_id!) {
         self.gameStartResultObject = try! JSONDecoder().decode(responseGameStartObject.self, from: data!)
         if (statusCode! == 200) {
         //success
         }else{
         self.present(systemAlertMessage(title: "Request Error", message: (self.gameStartResultObject?.msg)!), animated: true, completion: nil)
         }
         } else {
         self.gameStartResultObject = nil
         self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success"), animated: true, completion: nil)
         }*/
    }
    
    // step 1 [view load, before click]
    func requestGameDetail(){
        if !isConnectedToNetwork() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(self.systemAlertMessage(title: "No Internet Connection", message: "ไม่ได้เชื่อมต่อ Internet กรุณาเชื่อมต่อ Internet"), animated: true, completion: nil)
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
            
            strUrl = "game/" + game_uuid + "?lat=\(self.lat!)&long=\(self.long!)&version=2"
            requestType = "GET"
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
            
            //firebase_id = self.coreTokenObject?.data?.firebase_id!
            
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
                    self.gameDetailResultString = dataString
                    print("requestGameDetail() Response data string:\n \(dataString)")
                    self.gameDetailResultObject = try JSONDecoder().decode(responseGameDetailObject.self, from: data!)
                    
                    
                }
                catch {
                    self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code convertData, on requestGameDetail)"), animated: true, completion: nil)
                    self.loading_ani.isHidden = true
                    //self.loadingImage.isHidden = true
                    self.loadingBG.isHidden = true
                    self.loading_ani.stop()
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if((self.gameDetailResultObject?.data?.game?.is_free_day)!){
                        self.ivUseMStamp.isHidden = true
                        self.ivFreeMStamp.isHidden = false
                    }
                    else {
                        self.ivUseMStamp.isHidden = false
                        self.ivFreeMStamp.isHidden = true
                    }
                    
                    if((self.gameDetailResultObject?.code)! == 0){
                        if((self.gameDetailResultObject?.data?.game?.is_firsttime)!){
                            self.gameDetailResultObject?.data?.game?.is_firsttime = false
                            //self.loadingBG.isHidden = true
                            //self.loadingImage.isHidden = true
                            //self.loading_ani.isHidden = true
                            //self.loading_ani.stop()
                            self.is_tutorial_from_firsttime = 1
                            self.performSegue(withIdentifier: "tutorialFirstTime", sender: nil)
                        }
                        else {
                            self.performSegue(withIdentifier: "useStamp_to_webView", sender: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                self.loading_ani.isHidden = true
                                //self.loadingImage.isHidden = true
                                self.loadingBG.isHidden = true
                                self.loading_ani.stop()
                            })
                        }
                    }
                        // ptoon: พี่ว่าไม่ใช่นะ แล้วอีกอย่าง มันไม่มีทางเข้า เพราะ code=3 มันก็เข้าอันบนไปแล้ว
                        // ptoon: สรุป มันต้องเข้า เพราะเอ๊งตั้งลำดับ method สลับกัน...
                        // hotfix v.1 ไม่ต้องเข้าแล้ว จะไม่มีโอกาสเข้าอีกต่อไป
                        /*
                         else if((self.gameDetailResultObject?.code)! == 3){
                         self.loadingBG.isHidden = true
                         self.loadingImage.isHidden = true
                         self.loading_ani.isHidden = true
                         self.loading_ani.stop()
                         self.confirm_btn.removeTarget(self, action: #selector(self.confirmButtonAction), for: .touchUpInside)
                         self.confirm_btn.addTarget(self, action: #selector(self.buttonBack), for: .touchUpInside)
                         }
                         */
                    else {
                        self.performSegue(withIdentifier: "useStamp_to_webView", sender: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.loading_ani.isHidden = true
                            //self.loadingImage.isHidden = true
                            self.loadingBG.isHidden = true
                            self.loading_ani.stop()
                        })
                        /*
                         self.loadingBG.isHidden = true
                         self.loadingImage.isHidden = true
                         self.loading_ani.isHidden = true
                         self.loading_ani.stop()
                         */
                    }
                })
            }
            task.resume()
            /*if let (data,statusCode) = sendHttpRequest(requestType:"GET", strUrl: requestUrl, requestData: nil, firebase_id: (self.coreTokenObject?.data?.firebase_id!)!) {
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
             //self.performSegue(withIdentifier: "useStamp", sender: nil)
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
             }*/
        } else {
            if(!DataFactory.is_production){
                ARGameSoundController.shared.playClickButton()
                self.present(systemAlertMessage(title: "Testing Mode", message: "Will GoToHome in 3 Seconds"), animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.performSegue(withIdentifier: "useStampToHomeSegue", sender: self)
                    })
            }else{
                self.present(systemAlertMessage(title: "Request Error", message: (self.gameDetailResultObject?.msg)!), animated: true, completion: nil)
            }
        }
    }
    
    @objc(UseStampToWebView) class UseStampToWebView: UIStoryboardSegue {
        override func perform() {
            let sourceViewController = self.source as! GameUseStampViewController
            let destinationViewController = self.destination as! GameWebViewController
            
            destinationViewController.webType = 12
            destinationViewController.firebase_id = sourceViewController.firebase_id ?? "0"
            destinationViewController.coreResultObject = sourceViewController.coreResultObject
            destinationViewController.gameDetailObject = sourceViewController.gameDetailResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func unwindToUseStamp( _ seg: UIStoryboardSegue) {
        if(seg.identifier == "tutorial_to_usestamp_segue"){
            if is_tutorial_from_firsttime == 1 {
                is_tutorial_from_firsttime = 0
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.performSegue(withIdentifier: "useStamp_to_webView", sender: self)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.loading_ani.isHidden = true
                    //self.loadingImage.isHidden = true
                    self.loadingBG.isHidden = true
                    self.loading_ani.stop()
                })
            }
        }
    }
}
