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
    var is_tutorial:Int? = 0
    var lat:Double?
    var long:Double?
    

    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var loading_ani: AnimationView!
    @IBOutlet weak var confirm_btn: UIButton!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var loadingBG: UIImageView!
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var loadinfText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Loading Page  Animation/data", ofType: "json")
        let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Loading Page  Animation/images")
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
                //self.present(systemAlertMessage(title: "Unsupport Location", message: "Cannot recieve Lat,Long from device. Using Default location"), animated: true, completion: nil)
                print("Unsupport Location: Cannot recieve Lat,Long from device. Using Default location")
            }
        } else {
            //self.present(systemAlertMessage(title: "Unauthorize Location", message: "Cannot recieve Lat,Long from device. Using Default location"), animated: true, completion: nil)
            print("Unauthorize Location: Cannot recieve Lat,Long from device. Using Default location")
        }
        
        loading_ani.imageProvider = imageProvider
        loading_ani.animation = Animation.filepath(str!)
        loading_ani.play()
        loading_ani.loopMode = .loop
        counterLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if(self.lat == nil || self.long == nil){
                self.lat = 13.756331
                self.long = 100.501762
                self.requestGameDetail()
            } else {
                self.requestGameDetail()
            }
        })
        tutorialBtn.addTarget(self, action: #selector(goToTutorialAction), for: .touchUpInside)
        confirm_btn.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        cancel_btn.addTarget(self, action: #selector(buttonBack), for: .touchUpInside)
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
        SoundController.shared.playClickButton()
        self.performSegue(withIdentifier: "tutorialFirstTime", sender: nil)
    }
    @objc func buttonBack(sender:UIButton) {
        SoundController.shared.playClickButton()
        self.loadingBG.isHidden = false
        self.loadingImage.isHidden = false
        self.loading_ani.isHidden = false
        self.loading_ani.play()
        performSegue(withIdentifier: "useStampToHomeSegue", sender: self)
    }
    @objc func confirmButtonAction(sender:UIButton){
        SoundController.shared.playClickButton()
        self.loadingBG.isHidden = false
        self.loadingImage.isHidden = false
        self.loading_ani.isHidden = false
        self.loading_ani.play()
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
            destinationViewController.is_tutorial = sourceViewController.is_tutorial
            destinationViewController.firebase_id = sourceViewController.firebase_id
            destinationViewController.gameDetail = sourceViewController.gameDetailResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
    
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
    }
    
    func requestGameUseStamp(){
        if !isConnectedToNetwork() {
            self.present(self.systemAlertMessage(title: "Internet not connect", message: "Please check internet connection"), animated: true, completion: nil)
            return
        }
        
        //==========================
        // *** Use Stamp ***
        //==========================
        // request Use Stamp
        if let game_uuid = self.coreResultObject?.data?.game?.game_uuid {
            strUrl = "game/" + game_uuid + "/use-mstamp"
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
                
                // Check if Error took place
                if let error = error {
                    //print("Error took place \(error)")
                    // move all statusCode != 200 to here
                   if let response = response as? HTTPURLResponse {
                        print("Response HTTP Status code: \(response.statusCode)")
                        self.present(self.systemAlertMessage(title: "Request Error", message: "Request data not Success: Status code \(response.statusCode)"), animated: true, completion: nil)
                        return
                    }
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                print("Response data string:\n \(dataString)")
                // --------
                // data ready, call next method here
                do{
                    self.gameUseStampResultObject = try! JSONDecoder().decode(responseGameUseStampObject.self, from: data!)
                } catch {
                    self.present(self.systemAlertMessage(title: "Request Error", message: "Response data. Game useStamp. Data Wrong"), animated: true, completion: nil)
                    self.loadingBG.isHidden = true
                    self.loadingImage.isHidden = true
                    self.loading_ani.isHidden = true
                    self.loading_ani.stop()
                }
                
                
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if ((self.gameUseStampResultObject?.code)! == 0){
                        self.performSegue(withIdentifier: "playGame", sender: nil)
                    } else {
                        //self.present(self.systemAlertMessage(title: "Request Error", message: (self.gameUseStampResultObject?.msg)!), animated: true, completion: nil)
                        self.popUpImage.image = UIImage(named: "m-stamp_notError", in: self.ARGameBundle(), compatibleWith: nil)
                        self.confirm_btn.addTarget(self, action: #selector(self.buttonBack), for: .touchUpInside)
                        self.loadingBG.isHidden = true
                        self.loadingImage.isHidden = true
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
    
    func requestGameStart(){
        if !isConnectedToNetwork() {
            self.present(self.systemAlertMessage(title: "Internet not connect", message: "Please check internet connection"), animated: true, completion: nil)
            return
        }
        //==========================
        // *** Game Start ***
        //==========================
        // request Game detail
        //print(self.gameDetailResultObject!)
        //
        let json: [String: Any] = ["lat": self.lat as Any,
                                   "long": self.long as Any]
        
        strUrl = "game/" + (self.gameDetailResultObject?.data?.game?.game_uuid)! + "/start"
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
            
            // Check if Error took place
            if let error = error {
                //print("Error took place \(error)")
                // move all statusCode != 200 to here
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    self.present(self.systemAlertMessage(title: "Request Error", message: "Request data not Success: Status code \(response.statusCode)"), animated: true, completion: nil)
                    return
                }
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("Response data string:\n \(dataString)")
            // --------
            // data ready, call next method here
            do{
                self.gameStartResultObject = try JSONDecoder().decode(responseGameStartObject.self, from: data!)
            }catch{
                self.present(self.systemAlertMessage(title: "Request Error", message: "Response data Game Start. Data Wrong"), animated: true, completion: nil)
                self.loadingBG.isHidden = true
                self.loadingImage.isHidden = true
                self.loading_ani.isHidden = true
                self.loading_ani.stop()
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if((self.gameStartResultObject?.code)! == 0){
                    // request game start
                    self.requestGameUseStamp()
                } else {
                    self.present(self.systemAlertMessage(title: "Request Error", message: (self.gameStartResultObject?.msg)!), animated: true, completion: nil)
                    self.loadingBG.isHidden = true
                    self.loadingImage.isHidden = true
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
    
    func requestGameDetail(){
        if !isConnectedToNetwork() {
            self.present(self.systemAlertMessage(title: "Internet not connect", message: "Please check internet connection"), animated: true, completion: nil)
            return
        }
        // MARK: Game Detail
        //==========================
        // *** Game Detail ***
        //==========================
        // Request Game Detail
        if let game_uuid = self.coreResultObject?.data?.game?.game_uuid{
            //let requestUrl = "game/" + game_uuid
            
            strUrl = "game/" + game_uuid + "?lat=\(self.lat!)&long=\(self.long!)"
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
                
                // Check if Error took place
                if let error = error {
                    //print("Error took place \(error)")
                    // move all statusCode != 200 to here
                    if let response = response as? HTTPURLResponse {
                        print("Response HTTP Status code: \(response.statusCode)")
                        self.present(self.systemAlertMessage(title: "Request Error", message: "Request data not Success: Status code \(response.statusCode)"), animated: true, completion: nil)
                        return
                    }
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                self.gameDetailResultString = dataString
                print("Response data string:\n \(dataString)")
                // --------
                // data ready, call next method here
                do {
                    self.gameDetailResultObject = try! JSONDecoder().decode(responseGameDetailObject.self, from: data!)
                } catch {
                    self.present(self.systemAlertMessage(title: "Request Error", message: "Response data Game Detail. Data Wrong"), animated: true, completion: nil)
                    self.loading_ani.isHidden = true
                    self.loadingImage.isHidden = true
                    self.loadingBG.isHidden = true
                    self.loading_ani.stop()
                    return
                }
                
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if((self.gameDetailResultObject?.code)! == 0){
                        if((self.gameDetailResultObject?.data?.game?.is_firsttime)!){
                            self.loadingBG.isHidden = true
                            self.loadingImage.isHidden = true
                            self.loading_ani.isHidden = true
                            self.loading_ani.stop()
                            self.is_tutorial = 1
                            self.performSegue(withIdentifier: "tutorialFirstTime", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "useStamp_to_webView", sender: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                self.loading_ani.isHidden = true
                                self.loadingImage.isHidden = true
                                self.loadingBG.isHidden = true
                                self.loading_ani.stop()
                            })
                        }
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
                SoundController.shared.playClickButton()
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
            destinationViewController.coreResultObject = sourceViewController.coreResultObject
            destinationViewController.gameDetailObject = sourceViewController.gameDetailResultObject
            sourceViewController.present(destinationViewController, animated: false, completion: nil)
        }
    }
}
