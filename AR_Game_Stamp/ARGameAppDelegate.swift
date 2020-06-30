//
//  AppDelegate.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 21/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import UIKit

//@UIApplicationMain
class ARGameAppDelegate  {
    var window: UIWindow?
    let session = URLSession.shared
    
    //let firebase_token = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImMzZjI3NjU0MmJmZmU0NWU5OGMyMGQ2MDNlYmUyYmExMTc2ZWRhMzMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2V2ZW4tZWxldmVuLXN0YWdpbmciLCJhdWQiOiJzZXZlbi1lbGV2ZW4tc3RhZ2luZyIsImF1dGhfdGltZSI6MTU5MTc4NjgzMCwidXNlcl9pZCI6ImFEdTgxNVpSYVJaUjlhSGpKYWF2S0JBYnNQNzIiLCJzdWIiOiJhRHU4MTVaUmFSWlI5YUhqSmFhdktCQWJzUDcyIiwiaWF0IjoxNTkyNTQzMDU5LCJleHAiOjE1OTI1NDY2NTksImVtYWlsIjoiYmlyZF9zdXJpbjU1NUBob3RtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImJpcmRfc3VyaW41NTVAaG90bWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.LWULkOtZxjih65ZO6bFX9A0ZkNKc2jgVKP1PA0j7kMxdtdYlmUsFVCpasWHkqf2E_kpKL24b3vrfNR2hoNj0hxj9MBTCznOinCgpBz3CCuHwYsGjaKwnAvYgPMxKlvffdzFpA9R6lhO4DqbxqeuK9rATX8F3DqGbm7zJ9d1X5vf9anlVD_CbY98UyD-2xy6nreUrxUWrowmx7EZrNvJkUVGsji6WbHN8d-hMaDMma5QQ2HjCYFO77ryCQO8SdNb6zdtcPrTihMx5ExcTZEK-TwMzNs-hXWCB_v5F4gThWVbOsxKMPSh-V4jGGagecZ30ghRl2DkD_iCape9ukSyBEA"
}

extension UIViewController {
    
    /*@available(iOS 13.0, *)
    func application(_ application: UIApplicationDelegate, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }*/
    
    // MARK: UISceneSession Lifecycle
    /*@available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }*/
    
    func ARGameBundle() -> Bundle? {
        return Bundle(identifier: "com.AR-Game-Stamp.framwork")
    }
    
    func windowHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    func windowWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func getHeaders() -> [String: String]? {
        return [
            "x-api-key": "application/json",
            "x-ar-signature":  "your access token or api key"
        ]
    }
    
    func getUrl(from api: String) -> URL? {
        let BASE_URL = DataFactory.apiUrlMain
        let apiUrl = api.contains("http") ? api : BASE_URL + api
        return URL(string: apiUrl)
    }
    
    /*func sendGetHttpRequest(url: String, requestData: Data?)-> Data?{
        let url = getUrl(from: url)
        guard let requestUrl = url else { fatalError() }
        var responseData:Data?
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Set HTTP Request Header
        //application/json
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("7ar-game", forHTTPHeaderField: "x-api-key")
        request.setValue(firebase_token, forHTTPHeaderField:"x-ar-signature" )
        
        // insert json data to the request
        if(requestData != nil){
            request.httpBody = requestData
        }
        let semaphore = DispatchSemaphore(value: 0)
        // Send HTTP Request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //self.jsonResult = dataString
                responseData = data
                print("Response data string:\n \(dataString)")
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()
        return responseData
    }*/
    
    func sendHttpRequest(requestType:String,  strUrl: String, requestData: Data?,firebase_id: String) -> (Data?,Int?)?{
        /*let firebase_token = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImMzZjI3NjU0MmJmZmU0NWU5OGMyMGQ2MDNlYmUyYmExMTc2ZWRhMzMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2V2ZW4tZWxldmVuLXN0YWdpbmciLCJhdWQiOiJzZXZlbi1lbGV2ZW4tc3RhZ2luZyIsImF1dGhfdGltZSI6MTU5MTc4NjgzMCwidXNlcl9pZCI6ImFEdTgxNVpSYVJaUjlhSGpKYWF2S0JBYnNQNzIiLCJzdWIiOiJhRHU4MTVaUmFSWlI5YUhqSmFhdktCQWJzUDcyIiwiaWF0IjoxNTkyNjI5ODAwLCJleHAiOjE1OTI2MzM0MDAsImVtYWlsIjoiYmlyZF9zdXJpbjU1NUBob3RtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImJpcmRfc3VyaW41NTVAaG90bWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.qeZe9J45aqDGaISud0daVvx1dMtXe9vKfRnrokwMZcTc24v9XtxB1C6HPIkdxMvs6xXEsmvTQULv0yV4PCD3xDJ0spNzqvXFx9J-wHzOIyOu9TlEBcbg70E6PdONLgwOsTKaQ5R5mn0zmmZKtrMtdCIK5lrU0m4tsqRd7dq0Cdd0PsICe_9hCMTxZ82U9k40_UQJDNxAJ2Vgdg00LJ1zodohCpKhu9jgs_cUod9WVDOtmkYzSIMpt7K6OOd0BddBXqpYDLed1LEpEKbKHKqq8MXcTGXjoldS07TmO3IIIO-cfYSf_WUcVBv6quQLjZ2CL_sgXBTs9pWADuf9mxDKiQ"*/
        var url:URL? = URL(string: "")
        var responseData:Data?
        var responseStatus:Int? = nil
        let apiOriginal = "\(DataFactory.apiUrlMain)\(strUrl)"
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
        request.setValue(firebase_id, forHTTPHeaderField:"x-ar-signature" )
        
        let semaphore = DispatchSemaphore(value: 0)
        // Send HTTP Request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                responseStatus = response.statusCode
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //self.jsonResult = dataString
                print("Response data string:\n \(dataString)")
                // --------
                // data ready, call next method here
                responseData = data
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()
        return (responseData,responseStatus)
    }
    
    func systemAlertMessage(title:String?, message: String?) -> UIAlertController {
         // create the alert
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

         // add an action (button)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

         // show the alert
        return alert
    }
}

/*extension Node {
    var appDelegate: ARGameAppDelegate {
        return UIApplication.shared.delegate as! ARGameAppDelegate
    }
}*/

extension UIView {

   /// Flip view horizontally.
   func flipX() {
       transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
   }

   /// Flip view vertically.
   func flipY() {
       transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
   }
}

extension UIFont {
static func register(path: String, fileNameString: String, type: String) throws {
    let frameworkBundle = Bundle(identifier: "com.AR-Game-Stamp.framwork")
    guard let resourceBundleURL = frameworkBundle!.path(forResource: path + "/" + fileNameString, ofType: type) else {
        return
  }
  guard let fontData = NSData(contentsOfFile: resourceBundleURL),    let dataProvider = CGDataProvider.init(data: fontData) else {
    return
  }
  guard let fontRef = CGFont.init(dataProvider) else {
    return
  }
  var errorRef: Unmanaged<CFError>? = nil
guard CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) else   {
    return
  }
 }
}

public protocol mainAppDelegate: class {
  func deeplink(to scheme: String)
/*
  scheme like >>
  seven-eleven-dev://internal/navPage/SEXXX
  seven-eleven-staging://internal/navPage/SEXXX
  seven-eleven://internal/navPage/SEXXX
 */
}

