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
    var gameDetail:responseGameDetailObject?
    var resultUpdateFirstTime:responseGameDetailObject?
    var firebase_id:String?
    var strUrl:String = ""
    var requestType:String = ""
    var url:URL?
    var responseData:Data?
    var responseStatus:Int?
    var slides:[SlideView] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.titleLabel?.font = UIFont(name: "DB HelvethaicaMon X", size: 30)
        pageView.delegate = self
        createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        self.playButton.addTarget(self, action: #selector(playFromTutorialButtonAction), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: false, completion: nil)
    }

    @objc
    func playFromTutorialButtonAction(sender:UIButton){
        submitFirstTime()
    }
    
    func submitFirstTime(){
        strUrl = "game/" + (self.gameDetail?.data?.game!.game_uuid)! + "/firsttime"
        requestType = "PUT"
        
        url = URL(string: "")
        let apiOriginal = "\(DataFactory.apiUrlMain)\(strUrl)"
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
                self.present(self.systemAlertMessage(title: "Request Error", message: "Request data not Success: " + (self.resultUpdateFirstTime?.msg)!), animated: true, completion: nil)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                self.responseStatus = response.statusCode
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("Response data string:\n \(dataString)")
            // --------
            // data ready, call next method here
            self.resultUpdateFirstTime = try! JSONDecoder().decode(responseGameDetailObject.self, from: data!)
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                if ((self.resultUpdateFirstTime?.code)! == 0){
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "tutorial_to_home", sender: nil)
                }
            })
        }
        task.resume()
    }
    
    func createSlides(){
        for i in 1...13 {
            let oneSlide:SlideView = ARGameBundle()!.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
            oneSlide.page1.image = UIImage(named: "in game tutorial-\(i)", in: ARGameBundle(), compatibleWith: nil)
            slides.append(oneSlide)
        }
    }
    
    func setupSlideScrollView(slides : [SlideView]) {
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
        
        if(Int(pageIndex) == 12){
            playButton.isHidden = false
        } else {
            playButton.isHidden = true
        }
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        /*if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
         
         slides[0].page1.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
         slides[1].page1.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
         
         } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
         slides[1].page1.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
         slides[2].page1.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
         
         } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
         slides[2].page1.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
         slides[3].page1.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
         
         } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
         slides[3].page1.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
         slides[4].page1.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
         }*/
    }
}

