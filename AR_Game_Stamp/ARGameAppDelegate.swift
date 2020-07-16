//
//  AppDelegate.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 21/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import UIKit
import SystemConfiguration

//@UIApplicationMain
// THIS DELEGATE WILL NOT LOAD< NO MATTER WHAT
class ARGameAppDelegate: UIResponder, UIApplicationDelegate  {
    var window: UIWindow?
    let session = URLSession.shared
    
    //let firebase_token = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImMzZjI3NjU0MmJmZmU0NWU5OGMyMGQ2MDNlYmUyYmExMTc2ZWRhMzMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2V2ZW4tZWxldmVuLXN0YWdpbmciLCJhdWQiOiJzZXZlbi1lbGV2ZW4tc3RhZ2luZyIsImF1dGhfdGltZSI6MTU5MTc4NjgzMCwidXNlcl9pZCI6ImFEdTgxNVpSYVJaUjlhSGpKYWF2S0JBYnNQNzIiLCJzdWIiOiJhRHU4MTVaUmFSWlI5YUhqSmFhdktCQWJzUDcyIiwiaWF0IjoxNTkyNTQzMDU5LCJleHAiOjE1OTI1NDY2NTksImVtYWlsIjoiYmlyZF9zdXJpbjU1NUBob3RtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImJpcmRfc3VyaW41NTVAaG90bWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.LWULkOtZxjih65ZO6bFX9A0ZkNKc2jgVKP1PA0j7kMxdtdYlmUsFVCpasWHkqf2E_kpKL24b3vrfNR2hoNj0hxj9MBTCznOinCgpBz3CCuHwYsGjaKwnAvYgPMxKlvffdzFpA9R6lhO4DqbxqeuK9rATX8F3DqGbm7zJ9d1X5vf9anlVD_CbY98UyD-2xy6nreUrxUWrowmx7EZrNvJkUVGsji6WbHN8d-hMaDMma5QQ2HjCYFO77ryCQO8SdNb6zdtcPrTihMx5ExcTZEK-TwMzNs-hXWCB_v5F4gThWVbOsxKMPSh-V4jGGagecZ30ghRl2DkD_iCape9ukSyBEA"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        //FirebaseApp.configure()
        
        /*
        print("generate FirebaseApp1")
        // Configure with manual options. Note that projectID and apiKey, though not
        // required by the initializer, are mandatory.
        let secondaryOptions = FirebaseOptions(googleAppID: "1:834824914099:ios:db36f0f9f10e6943ba5cc6",
                                               gcmSenderID: "834824914099") //
        secondaryOptions.apiKey = "AIzaSyB9Z0eZ1Xj3-7ycRTtY-9yzBXyTQPjE9Gg" //
        secondaryOptions.projectID = "elevenstampartest" //
        secondaryOptions.bundleID = "com.jenosize.iPhoneTestDev" //
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
        */
        
        return true
    }

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
        return Bundle(identifier: "org.cocoapods.ARGameStamp7-11")
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
        let BASE_URL = ARGameEnv.shared.url
        let apiUrl = api.contains("http") ? api : BASE_URL + api
        return URL(string: apiUrl)
    }
    
    func sendHttpRequest(requestType:String,  strUrl: String, requestData: Data?,firebase_id: String) -> (Data?,Int?)?{
        /*let firebase_token = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImMzZjI3NjU0MmJmZmU0NWU5OGMyMGQ2MDNlYmUyYmExMTc2ZWRhMzMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2V2ZW4tZWxldmVuLXN0YWdpbmciLCJhdWQiOiJzZXZlbi1lbGV2ZW4tc3RhZ2luZyIsImF1dGhfdGltZSI6MTU5MTc4NjgzMCwidXNlcl9pZCI6ImFEdTgxNVpSYVJaUjlhSGpKYWF2S0JBYnNQNzIiLCJzdWIiOiJhRHU4MTVaUmFSWlI5YUhqSmFhdktCQWJzUDcyIiwiaWF0IjoxNTkyNjI5ODAwLCJleHAiOjE1OTI2MzM0MDAsImVtYWlsIjoiYmlyZF9zdXJpbjU1NUBob3RtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImJpcmRfc3VyaW41NTVAaG90bWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.qeZe9J45aqDGaISud0daVvx1dMtXe9vKfRnrokwMZcTc24v9XtxB1C6HPIkdxMvs6xXEsmvTQULv0yV4PCD3xDJ0spNzqvXFx9J-wHzOIyOu9TlEBcbg70E6PdONLgwOsTKaQ5R5mn0zmmZKtrMtdCIK5lrU0m4tsqRd7dq0Cdd0PsICe_9hCMTxZ82U9k40_UQJDNxAJ2Vgdg00LJ1zodohCpKhu9jgs_cUod9WVDOtmkYzSIMpt7K6OOd0BddBXqpYDLed1LEpEKbKHKqq8MXcTGXjoldS07TmO3IIIO-cfYSf_WUcVBv6quQLjZ2CL_sgXBTs9pWADuf9mxDKiQ"*/
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
    
    func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

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
    let frameworkBundle = Bundle(identifier: "org.cocoapods.ARGameStamp7-11")
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

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
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

