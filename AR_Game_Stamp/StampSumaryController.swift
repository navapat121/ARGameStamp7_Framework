//
//  EndGameViewController.swift
//  AR_STAMP7_iOS
//
//  Created by BWS MacMini 1 on 7/6/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation
import CoreMotion
import Lottie

class StampSumaryController: UIViewController {
    //private var stampbook: StampBookController!
    var firebase_id:String?
    var gameDetail:responseGameDetailObject?
    var catchStampList: [String: Any]?
    var resultFinishGame: responseGameFinishObject?
    // @IBOutlet weak var summaryAmimate: AnimationView!
    var page_num:Int = 1
    
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var light_animate: AnimationView!
    @IBOutlet weak var congrat_animate: AnimationView!
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let vc = segue.destination as? StampBookController,
     segue.identifier == "stampbook" {
     self.stampbook = vc
     }
     }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Effect Light/data", ofType: "json")
        let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Effect Light/images")
        light_animate.contentMode = UIView.ContentMode.scaleToFill
        light_animate.imageProvider = imageProvider
        light_animate.animation = Animation.filepath(str!)
        light_animate.loopMode = .loop
        
        
        let str_congrat = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Text Congrat/data", ofType: "json")
        let imageProvider_congrat = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Text Congrat/images")
        congrat_animate.contentMode = UIView.ContentMode.scaleAspectFill
        congrat_animate.imageProvider = imageProvider_congrat
        congrat_animate.animation = Animation.filepath(str_congrat!)
        congrat_animate.loopMode = .playOnce
        /* let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Summary Page Aniamtion/data", ofType: "json")
         let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Summary Page Aniamtion/images")
         summaryAnimate.contentMode = UIView.ContentMode.scaleToFill
         summaryAnimate.imageProvider = imageProvider
         summaryAnimate.animation = Animation.filepath(str!)
         summaryAnimate.loopMode = .loop
         summaryAnimate.play()
         
         
         self.rewardController.btn_confirm.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
         
         self.stampbook.btn_previous.addTarget(self, action: #selector(selectPreviousPage), for: .touchUpInside)
         
         self.stampbook.btn_next.addTarget(self, action: #selector(selectNextPage), for: .touchUpInside)*/
        
        btn_confirm.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool){
       
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            SoundController.shared.playRewardPopUpSFX()
            self.congrat_animate.play()
            self.light_animate.play()
            SoundController.shared.playSpecialStampPopup()
            SoundController.shared.playReceivePopUpSFX()
        })
        // use this sound when get special stamp
        // SoundController.shared.playLightSpecialStampToCoupon()
        
    }
    
    
    
    /*@objc
     func buttonAction(sender:UIButton){
     self.rewardview.isHidden = true
     }
     @objc
     
     func selectPreviousPage(sender:UIButton){
     self.page_num -= 1
     if(self.page_num <= 1){
     self.page_num = 1
     }
     self.stampbook.page_number.text = "\(self.page_num)"
     }
     @objc
     func selectNextPage(sender:UIButton){
     self.page_num += 1
     self.stampbook.page_number.text = "\(self.page_num)"
     }*/
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.gameDetail != nil){
            let requestUrl = "game/" + (self.gameDetail?.data?.game?.game_uuid)! + "/finish"
            let jsonData = (try? JSONSerialization.data(withJSONObject: self.catchStampList))!
            if let (data,statusCode) = sendHttpRequest(requestType:"POST", strUrl: requestUrl, requestData: jsonData, firebase_id: self.firebase_id!) {
                self.resultFinishGame = try! JSONDecoder().decode(responseGameFinishObject.self, from: data!)
                if(statusCode! == 200){
                    if((self.resultFinishGame?.code)! == 0){
                        // success
                    } else {
                        self.present(systemAlertMessage(title: "Request Error", message: self.resultFinishGame?.msg), animated: true, completion: nil)
                    }
                }
            } else {
                self.present(systemAlertMessage(title: "Request Error", message: "Request data not Success"), animated: true, completion: nil)
            }
        }
        /* self.stampbook.btn_play_continue.addTarget(self, action: #selector(goToHome), for: .touchUpInside)*/
    }
    
    @objc func goToHome(sender:UIButton){
        SoundController.shared.playClickButton()
        performSegue(withIdentifier: "summary_exit_to_home", sender: nil)
    }
    
    /*@objc(BackToHomeController) class BackToHomeController: UIStoryboardSegue {
     override func perform() {
     let sourceViewController = self.source as! StampSumaryController
     let destinationViewController = self.destination as! HomeViewController
     
     destinationViewController.firsbase_id = sourceViewController.firebase_id
     sourceViewController.present(destinationViewController, animated: true, completion: nil)
     }
     }*/
}

/*class StampBookController: UIViewController{
 
 @IBOutlet weak var btn_previous: UIButton!
 @IBOutlet weak var btn_next: UIButton!
 @IBOutlet weak var page_number: UILabel!
 @IBOutlet weak var btn_play_continue: UIButton!
 override func viewDidLoad() {
 super.viewDidLoad()
 }
 }*/


