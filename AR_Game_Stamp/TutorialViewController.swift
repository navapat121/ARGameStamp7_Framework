//
//  TutorialViewController.swift
//  AR_Game_Stamp
//
//  Created by BWS MacMini 2 on 29/6/2563 BE.
//  Copyright © 2563 com.ARgameStamp.framework. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate   {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pageView: UIScrollView!
    @IBOutlet weak var skipBtn: UIButton!
    var gameDetail:responseGameDetailObject?
    var resultUpdateFirstTime:responseGameDetailObject?
    var is_tutorial_from_firsttime:Int? = 0
    var firebase_id:String?
    var strUrl:String = ""
    var requestType:String = ""
    var url:URL?
    var responseData:Data?
    var responseStatus:Int?
    var slides:[GameTutorialSlideView] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.titleLabel?.font = UIFont(name: "DB HelvethaicaMon X", size: 30)
        skipBtn.titleLabel?.font = UIFont(name: "DB HelvethaicaMon X", size: 30)
        pageView.delegate = self
        createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        self.playButton.addTarget(self, action: #selector(playFromTutorialButtonAction), for: .touchUpInside)
        self.skipBtn.addTarget(self, action: #selector(skipTutorial), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //dismiss(animated: false, completion: nil)
    }

    @objc
    func playFromTutorialButtonAction(sender:UIButton){
        ARGameSoundController.shared.playClickButton()
        // 20200724
        // v2. let PHP handler this
        self.performSegue(withIdentifier: "tutorial_to_usestamp_segue", sender: nil)
        self.dismiss(animated: false, completion: nil)
        self.destroyTutorial()
        // 20200717
        // deprecate
        //submitFirstTime()
    }
    
    @objc
    func skipTutorial(sender:UIButton){
        ARGameSoundController.shared.playClickButton()
        self.skipBtn.isHidden = true
        let bottomOffset = CGPoint(x: pageView.contentSize.width - pageView.bounds.size.width, y: 0)
        pageView.setContentOffset(bottomOffset, animated: true)
    }
    
    /*
    func submitFirstTime(){
        if !isConnectedToNetwork() {
            self.present(self.systemAlertMessage(title: "Internet not connect", message: "Please check internet connection"), animated: true, completion: nil)
            return
        }
        
        strUrl = "game/" + (self.gameDetail?.data?.game!.game_uuid)! + "/firsttime"
        requestType = "PUT"
        
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
        var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                self.responseStatus = response.statusCode
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("Response data string:\n \(dataString)")
            // --------
            // data ready, call next method here
            do{
                self.resultUpdateFirstTime = try! JSONDecoder().decode(responseGameDetailObject.self, from: data!)
            } catch{
                self.present(self.systemAlertMessage(title: "Request Error", message: "Response upadate first time. Data wrong. " + dataString), animated: true, completion: nil)
                return
            }
            
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                if ((self.resultUpdateFirstTime?.code)! == 0){
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.present(self.systemAlertMessage(title: "Request Error", message: "Request data not Success: " + (self.resultUpdateFirstTime?.msg)!), animated: true, completion: nil)
                    self.performSegue(withIdentifier: "tutorial_to_home", sender: nil)
                }
            })
        }
        task.resume()
    }
    */
    
    func createSlides(){
        for i in 1...4 {
            let oneSlide:GameTutorialSlideView = ARGameBundle()!.loadNibNamed("GameTutorialSlide", owner: self, options: nil)?.first as! GameTutorialSlideView
            oneSlide.page1.image = UIImage(named: "tutorial_in_game_tutorial_\(i)", in: ARGameBundle(), compatibleWith: nil)
            slides.append(oneSlide)
        }
        // Image not in first time tutorial 2, 3, 6, 7, 8, 9, 10, 11
        /*
        if(self.is_tutorial_from_firsttime == 1){
            let array = [1,4,5,12]
            for i in array{
                let oneSlide:GameTutorialSlideView = ARGameBundle()!.loadNibNamed("GameTutorialSlide", owner: self, options: nil)?.first as! GameTutorialSlideView
                oneSlide.page1.image = UIImage(named: "tutorial_in_game_tutorial_\(i)", in: ARGameBundle(), compatibleWith: nil)
                slides.append(oneSlide)
            }
        } else {
            for i in 1...12 {
                let oneSlide:GameTutorialSlideView = ARGameBundle()!.loadNibNamed("GameTutorialSlide", owner: self, options: nil)?.first as! GameTutorialSlideView
                oneSlide.page1.image = UIImage(named: "tutorial_in_game_tutorial_\(i)", in: ARGameBundle(), compatibleWith: nil)
                slides.append(oneSlide)
            }
        }
         */
    }
    
    func setupSlideScrollView(slides : [GameTutorialSlideView]) {
        pageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        pageView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        pageView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            pageView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if(Int(pageIndex) == (slides.count - 1)){
            playButton.isHidden = false
            self.skipBtn.isHidden = true
        } else {
            self.skipBtn.isHidden = false
            playButton.isHidden = true
        }
    }
    
    func destroyTutorial() {
        pageView.removeFromSuperview()
        pageView = nil
    }
}

