//
//  GameViewController.swift
//  SimpleScene
//
//  Created by TSD040 on 2018-03-31.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import CoreMotion
import QuartzCore
import SceneKit
import AVKit
import Darwin
import CoreLocation
import Lottie
//import FirebaseAnalytics

class GameViewHeaderController: UIViewController {
    
    @IBOutlet weak var timer_label: UILabel!
    @IBOutlet weak var hpbar_to_fill: UIImageView!
    @IBOutlet weak var hpbar_full: UIImageView!
    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var hp_fill_const: NSLayoutConstraint!
    @IBOutlet weak var hp_label: UILabel!
    @IBOutlet weak var preview_small_stamp: UIImageView!
    @IBOutlet weak var timer_animate: AnimationView!
    @IBOutlet weak var timereffect_animate: AnimationView!
    @IBOutlet weak var netHeaderFlashAnimated: AnimationView!
    @IBOutlet weak var netHeaderFlashAnimated2: AnimationView!
    var origin_conts_fillHp: CGFloat?
    var origin_width_fillHp: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.origin_conts_fillHp = hp_fill_const.constant
        self.origin_width_fillHp = hpbar_to_fill.frame.width
        
        //self.bgUpperSafearea.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async {
            self.timer_animate.removeFromSuperview()
            self.timereffect_animate.removeFromSuperview()
            self.netHeaderFlashAnimated.removeFromSuperview()
            self.netHeaderFlashAnimated2.removeFromSuperview()
            
            self.timer_animate = nil
            self.timereffect_animate = nil
            self.netHeaderFlashAnimated = nil
            self.netHeaderFlashAnimated2 = nil
        }
        
        dismiss(animated: false, completion: nil)
    }
}

class GameViewSpecialController: UIViewController{
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var loadingBG: UIImageView!
    //@IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var specialAlertAnimate: AnimationView!
    @IBOutlet weak var timeup_animate: AnimationView!
    @IBOutlet weak var loadingAnimated: AnimationView!
    @IBOutlet weak var light_timeupAnimate: AnimationView!
    @IBOutlet weak var bgAlpha: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Loading Page Game Animation/data", ofType: "json")
        let imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Loading Page Game Animation/images")
        //loadingAnimated.contentMode = UIView.ContentMode.scaleToFill
        loadingAnimated.imageProvider = imageProvider
        loadingAnimated.animation = Animation.filepath(str!)
        loadingAnimated.loopMode = .loop
        loadingAnimated.play()
        
        /* let str_spc = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Redline Alert Special Stamp/data", ofType: "json")
         let imageProvider_spc = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Alert Special Stamp Full/images")
         specialAlertAnimate.contentMode = UIView.ContentMode.scaleToFill
         specialAlertAnimate.imageProvider = imageProvider_spc
         specialAlertAnimate.animation = Animation.filepath(str_spc!)
         specialAlertAnimate.loopMode = .loop
         specialAlertAnimate.play()*/
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async {
            self.specialAlertAnimate.removeFromSuperview()
            self.timeup_animate.removeFromSuperview()
            self.loadingAnimated.removeFromSuperview()
            self.light_timeupAnimate.removeFromSuperview()
            
            self.specialAlertAnimate = nil
            self.timeup_animate = nil
            self.loadingAnimated = nil
            self.light_timeupAnimate = nil
        }
        
        dismiss(animated: false, completion: nil)
    }
}

class GameViewLowerController:UIViewController{
    @IBOutlet weak var left_btn: UIButton!
    @IBOutlet weak var img_1: UIImageView!
    @IBOutlet weak var img_2: UIImageView!
    @IBOutlet weak var img_3: UIImageView!
    @IBOutlet weak var img_4: UIImageView!
    @IBOutlet weak var img_5: UIImageView!
    @IBOutlet weak var right_btn: UIButton!
    @IBOutlet weak var glasses: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.glasses.contentMode = UIView.ContentMode.scaleToFill
        self.img_1.isHidden = true
        self.img_2.isHidden = true
        self.img_3.isHidden = true
        self.img_4.isHidden = true
        self.img_5.isHidden = true
        
        // left_btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
}

class GameViewController: UIViewController {
    // ###### Request Object #####
    var firebase_id:String?
    var coreResultObject:responseCoreObject?
    var gameDetail:responseGameDetailObject?
    var resultGameStartDetail:responseGameStartObject?
    var gameFinishResultObject:responseGameFinishObject?
    var specialImgUrl:[String]?
    // #####################
    // MUST SEE: 1
    var cameraNode: SCNNode!
    var cameraRollNode: SCNNode!
    var cameraPitchNode: SCNNode!
    var cameraYawNode: SCNNode!
    
    var camera: SCNCamera!
    var scene: SCNScene!
    var scnView: SCNView!
    let motionManager = CMMotionManager()
    var frameworkBundle:Bundle?
    // #####################
    
    var stampList :[ARStampObject] = []
    // On game running
    var gameRunning:Bool = true
    var target_stamp_index = 0
    var start_index_preview = 0
    var state_power_up: Bool = false
    var power_up_endtime: Int = 0
    var alertTime:Int = 0
    var is_alert:Bool = false
    var is_timeup:Bool = false
    var normal_stamp_amount = 0
    var game_is_start = false
    var timer_realtime:Int = 0
    var captureDevice:AVCaptureDevice?
    // Animation File
    
    var motionTimer: Timer?
    let speed = 0.017
    var rotPitch: Float = 0, rotRoll: Float = 0, rotYaw: Float = 0
    // use to check sensor change
    var lastRotPitch: Float = 0, lastRotRoll: Float = 0, lastRotYaw: Float = 0
    
    var seconds : Int =  60
    var counterProgess:Int = 0
    var timer = Timer()
    var time_is_on = false
    var collectedStampArray = [Int](repeating: 0, count: 5)
    
    // Reference from story board
    @IBOutlet weak var GameHeaderView: UIView!
    @IBOutlet weak var start_button: UIButton!
    @IBOutlet weak var label_countdown: UILabel!
    @IBOutlet weak var stampPreview: UIImageView!
    // Animation from storyboard
    @IBOutlet weak var startAnimation: AnimationView!
    @IBOutlet weak var basketAnimate: AnimationView!
    @IBOutlet weak var NetAnimated: AnimationView!
    @IBOutlet weak var hourGlassAnimated: AnimationView!
    @IBOutlet weak var increaseTimeAnimated: AnimationView!
    @IBOutlet weak var decreaseTimeAnimated: AnimationView!
    @IBOutlet weak var bombAnimated: AnimationView!
    @IBOutlet weak var bombBGAnimated: AnimationView!
    @IBOutlet weak var hourGlassBGAnimated: AnimationView!
    @IBOutlet weak var netBGAnimated: AnimationView!
    // animation touch screen
    @IBOutlet weak var touchAnimate: AnimationView!
    // animation timer circle
    let keypath = AnimationKeypath(keys: ["**", "Ellipse 1", "**", "Color"])
    let redColorProvider = ColorValueProvider(UIColor.red.lottieColorValue)
    let greenColorProvider = ColorValueProvider(UIColor.blue.lottieColorValue)
    var changeColor:Bool = true
    let notificationCenter = NotificationCenter.default
    private var headerViewController: GameViewHeaderController!
    private var alertViewController : GameViewSpecialController!
    private var lowerViewController: GameViewLowerController!
    
    //Container
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var lowerContainer: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Game View Header
        if let vc = segue.destination as? GameViewHeaderController,
            segue.identifier == "EmbedSegue" {
            self.headerViewController = vc
        }
        // Game View Alert Special Time
        if let vc = segue.destination as? GameViewSpecialController,
            segue.identifier == "SpecialTimeSegue" {
            self.alertViewController = vc
        }
        // Game View Lower
        if let vc = segue.destination as? GameViewLowerController,
            segue.identifier == "lower_seuge" {
            self.lowerViewController = vc
        }
        
        if (segue.identifier == "timeup_to_home_segue") {
            // pass data to next view
            weak var viewController = segue.destination as? ARGameHomeViewController
            viewController!.coreResultObject = self.coreResultObject
            viewController!.gameFinishResultObject = self.gameFinishResultObject
            viewController!.specialImgUrl = self.specialImgUrl
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Check request Data
        if(self.resultGameStartDetail?.msg != nil){
            self.present(systemAlertMessage(title: "Request Error", message: (self.resultGameStartDetail?.msg)!), animated: true, completion: nil)
        }
        
        // Dismiss Wiat For Loading screen
        if(!game_is_start){
            // Loading Progess
            self.alertViewController.loadingText.font = UIFont(name: "DB HelvethaicaMon X", size: 43)
            let steps: Int = 1
            let duration = 0.01
            let rate = duration / Double(steps)
            let rand = Int.random(in: 10 ..< 40)
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.counterProgess = 0
                DispatchQueue.global().async {
                    for i in 0...rand {
                        DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(i)) {
                            self.alertViewController.loadingText.text = "\(i)%"
                            self.counterProgess = i
                        }
                    }
                }
            })
            
            let rand2 = Int.random(in: 50 ..< 80)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                DispatchQueue.global().async {
                    for i in self.counterProgess...rand2 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(i)) {
                            self.alertViewController.loadingText.text = "\(i)%"
                            self.counterProgess = i
                        }
                    }
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                DispatchQueue.global().async {
                    for i in self.counterProgess...100 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(i)) {
                            self.alertViewController.loadingText.text = "\(i)%"
                            self.counterProgess = i
                        }
                    }
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
                self.alertViewController.loadingBG.isHidden = true
                //self.alertViewController.loadingImage.isHidden = true
                self.alertViewController.loadingAnimated.isHidden = true
                self.alertViewController.view.isHidden = true
                self.alertViewController.loadingAnimated.stop()
                self.alertViewController.loadingText.isHidden = true
                
                let str = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Countdown/data", ofType: "json")
                let imageProvider = BundleImageProvider(bundle: (self.ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Countdown/images")
                ARGameSoundController.shared.playCountDownSFX()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    ARGameSoundController.shared.playCountDownSFX()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    ARGameSoundController.shared.playCountDownSFX()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    ARGameSoundController.shared.playStartSFX()
                })
                //self.startAnimation.contentMode = UIView.ContentMode.scaleToFill
                self.startAnimation.imageProvider = imageProvider
                self.startAnimation.animation = Animation.filepath(str!)
                self.startAnimation.play{(finished) in
                    ARGameSoundController.shared.playBGMGameplay()
                    self.headerViewController.timer_animate.play()
                    for stamp in self.stampList {
                        if(stamp.special_stamp == 0){
                            stamp.stampChildNode.isHidden = false
                        }
                    }
                    self.game_is_start = true
                    //MARK: Time on Game
                    self.seconds = 60
                    self.timeOn(on: true)
                }
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async {
            self.startAnimation.removeFromSuperview()
            self.basketAnimate.removeFromSuperview()
            self.NetAnimated.removeFromSuperview()
            self.hourGlassAnimated.removeFromSuperview()
            self.increaseTimeAnimated.removeFromSuperview()
            self.decreaseTimeAnimated.removeFromSuperview()
            self.bombAnimated.removeFromSuperview()
            self.bombBGAnimated.removeFromSuperview()
            self.hourGlassBGAnimated.removeFromSuperview()
            self.netBGAnimated.removeFromSuperview()
            self.touchAnimate.removeFromSuperview()
            
            self.startAnimation = nil
            self.basketAnimate = nil
            self.NetAnimated = nil
            self.hourGlassAnimated = nil
            self.increaseTimeAnimated = nil
            self.decreaseTimeAnimated = nil
            self.bombAnimated = nil
            self.bombBGAnimated = nil
            self.hourGlassBGAnimated = nil
            self.netBGAnimated = nil
            self.touchAnimate = nil
            self.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            
            for stamp in self.stampList{
                stamp.stampChildNode.removeFromParentNode()
                stamp.cleanup()
            }
            self.scnView.delegate = nil
            self.scnView.removeFromSuperview()
            
            self.scene.rootNode.cleanup()
            self.scene = nil
            let cache = LRUAnimationCache()
            cache.clearCache()
            
            self.view.removeFromSuperview()
        }
        
        self.motionManager.stopDeviceMotionUpdates()
        
        self.notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        self.notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        if self.motionTimer != nil {
        self.motionTimer?.invalidate()
        self.motionTimer = nil
        }
        
        //self.scene.rootNode.cleanup()
        dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frameworkBundle = ARGameBundle()
        //self.requestGameItem()

        // ----------------------------
        // FIREBASE GOOGLE ANALYTICS
        //Analytics.logEvent("M18_GamePage", parameters: nil)
        
        DispatchQueue.main.async {
            let str = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Loading Page Game Animation/data", ofType: "json")
            let imageProvider = BundleImageProvider(bundle: (self.ARGameBundle())!, searchPath: "Asset/AnimationLottie/Loading Page Game Animation/images")
            //self.alertViewController.loadingAnimated.contentMode = UIView.ContentMode.scaleToFill
            self.alertViewController.loadingAnimated.imageProvider = imageProvider
            self.alertViewController.loadingAnimated.animation = Animation.filepath(str!)
            self.alertViewController.loadingAnimated.loopMode = .loop
            self.alertViewController.loadingAnimated.play()
        }
        // Loading Screen Animation
        self.alertViewController.view.isHidden = false
        self.alertViewController.loadingBG.isHidden = false
        //self.alertViewController.loadingImage.isHidden = false
        
        //let phoneModel = UIDevice.modelName
        
        // MARK: Prepare Animation
        // Touch Screen
        
        if UIDevice.modelName == "NEWVERSION" {
            let str_touch =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Touch_Effect/data", ofType: "json")
            self.touchAnimate.animation = Animation.filepath(str_touch!)
        }
        /*
        if(!phoneModel.contains("iPhone 5") && !phoneModel.contains("iPhone 6")){
            let str_touch =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Touch_Effect/data", ofType: "json")
            self.touchAnimate.animation = Animation.filepath(str_touch!)
        }
        */

        // Time Up
        let str_timeup =  self.alertViewController.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Time up/data", ofType: "json")
        let imageProvider_timeup = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Time up/images")
        self.alertViewController.timeup_animate.imageProvider = imageProvider_timeup
        self.alertViewController.timeup_animate.animation = Animation.filepath(str_timeup!)
        // light time up
        if UIDevice.modelName == "NEWVERSION" {
            let str_lighttimeup =  self.alertViewController.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Effect Light/data", ofType: "json")
            let imageProvider_lighttimeup = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Effect Light/images")
            self.alertViewController.light_timeupAnimate.imageProvider = imageProvider_lighttimeup
            self.alertViewController.light_timeupAnimate.animation = Animation.filepath(str_lighttimeup!)
        }
        /*
        if(!phoneModel.contains("iPhone 5") && !phoneModel.contains("iPhone 6")){
            let str_lighttimeup =  self.alertViewController.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Effect Light/data", ofType: "json")
            let imageProvider_lighttimeup = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Effect Light/images")
            self.alertViewController.light_timeupAnimate.imageProvider = imageProvider_lighttimeup
            self.alertViewController.light_timeupAnimate.animation = Animation.filepath(str_lighttimeup!)
        }
        */
        
        
        // MARK: Bomb Animation
        if UIDevice.modelName == "NEWVERSION" {
            let bombpath = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/bomb effect/data", ofType: "json")
             let imageProvider_bomb  = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Bomb/bomb effect/images")
            self.bombAnimated.imageProvider = imageProvider_bomb
            self.bombAnimated.animation = Animation.filepath(bombpath!)
        }
        /*
        if(!phoneModel.contains("iPhone 5") && !phoneModel.contains("iPhone 6")){
            let bombpath = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/bomb effect/data", ofType: "json")
             let imageProvider_bomb  = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Bomb/bomb effect/images")
            self.bombAnimated.imageProvider = imageProvider_bomb
            self.bombAnimated.animation = Animation.filepath(bombpath!)
        }
        */
        
        if UIDevice.modelName == "NEWVERSION" {
            // BG Bomb
            let bgBombPath = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/BG Light/data", ofType: "json")
            self.bombBGAnimated.contentMode = UIView.ContentMode.scaleToFill
            self.bombBGAnimated.animation = Animation.filepath(bgBombPath!)
            // Decease Time
            let str_minus_five =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/data", ofType: "json")
            let imageProvider_minus_five = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/images")
            self.decreaseTimeAnimated.imageProvider = imageProvider_minus_five
            self.decreaseTimeAnimated.animation = Animation.filepath(str_minus_five!)
            // Decrease Time Effect
            let str_timer_minus =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/data", ofType: "json")
            //let imageProvider_timer_minus = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/images")
            self.headerViewController.timereffect_animate.imageProvider = imageProvider_minus_five
            self.headerViewController.timereffect_animate.animation = Animation.filepath(str_timer_minus!)
            // MARK: Net
            self.NetAnimated.imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Net/Net Image/images")
            self.NetAnimated.animation = Animation.filepath((ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Net/Net Image/data", ofType: "json"))!)
            
            // NET BG
            let bgNetPath = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Net/BG Light/data", ofType: "json")
            self.netBGAnimated.contentMode = UIView.ContentMode.scaleToFill
            self.netBGAnimated.animation = Animation.filepath(bgNetPath!)
            
            // Header Flash
            let str_header_flash =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Net/Header Flash/data", ofType: "json")
            let imageProvider_header_flash  = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Net/Header Flash/images")
            self.headerViewController.netHeaderFlashAnimated.imageProvider = imageProvider_header_flash
            self.headerViewController.netHeaderFlashAnimated.animation = Animation.filepath(str_header_flash!)
            self.headerViewController.netHeaderFlashAnimated.loopMode = .loop
            self.headerViewController.netHeaderFlashAnimated2.imageProvider = imageProvider_header_flash
            self.headerViewController.netHeaderFlashAnimated2.animation = Animation.filepath(str_header_flash!)
            self.headerViewController.netHeaderFlashAnimated2.loopMode = .loop
            
            // MARK: HourGlass
            // HourGlass
            var pathFile = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/HourGlass/hourGlass image/data", ofType: "json")
            var pathImage = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/HourGlass/hourGlass image/images")
            self.hourGlassAnimated.imageProvider = pathImage
            self.hourGlassAnimated.animation = Animation.filepath(pathFile!)
            // Incease Time
            pathFile =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/HourGlass/plus five second/data", ofType: "json")
            pathImage = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/HourGlass/plus five second/images")
            self.increaseTimeAnimated.imageProvider = pathImage
            self.increaseTimeAnimated.animation = Animation.filepath(pathFile!)
            
            pathFile = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/HourGlass/BG Light/data", ofType: "json")
            self.hourGlassBGAnimated.animation = Animation.filepath(pathFile!)
        }
        /*
        if(!phoneModel.contains("iPhone 5") && !phoneModel.contains("iPhone 6")){
            let bgBombPath = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/BG Light/data", ofType: "json")
            self.bombBGAnimated.contentMode = UIView.ContentMode.scaleToFill
            self.bombBGAnimated.animation = Animation.filepath(bgBombPath!)
            // Decease Time
            let str_minus_five =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/data", ofType: "json")
            let imageProvider_minus_five = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/images")
            self.decreaseTimeAnimated.imageProvider = imageProvider_minus_five
            self.decreaseTimeAnimated.animation = Animation.filepath(str_minus_five!)
            // Decrease Time Effect
            let str_timer_minus =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/data", ofType: "json")
            //let imageProvider_timer_minus = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Bomb/minus five second/images")
            self.headerViewController.timereffect_animate.imageProvider = imageProvider_minus_five
            self.headerViewController.timereffect_animate.animation = Animation.filepath(str_timer_minus!)
            // MARK: Net
            self.NetAnimated.imageProvider = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Net/Net Image/images")
            self.NetAnimated.animation = Animation.filepath((ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Net/Net Image/data", ofType: "json"))!)
            
            // NET BG
            let bgNetPath = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Net/BG Light/data", ofType: "json")
            self.netBGAnimated.contentMode = UIView.ContentMode.scaleToFill
            self.netBGAnimated.animation = Animation.filepath(bgNetPath!)
            
            // Header Flash
            let str_header_flash =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Net/Header Flash/data", ofType: "json")
            let imageProvider_header_flash  = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Net/Header Flash/images")
            self.headerViewController.netHeaderFlashAnimated.imageProvider = imageProvider_header_flash
            self.headerViewController.netHeaderFlashAnimated.animation = Animation.filepath(str_header_flash!)
            self.headerViewController.netHeaderFlashAnimated.loopMode = .loop
            self.headerViewController.netHeaderFlashAnimated2.imageProvider = imageProvider_header_flash
            self.headerViewController.netHeaderFlashAnimated2.animation = Animation.filepath(str_header_flash!)
            self.headerViewController.netHeaderFlashAnimated2.loopMode = .loop
            
            // MARK: HourGlass
            // HourGlass
            var pathFile = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/HourGlass/hourGlass image/data", ofType: "json")
            var pathImage = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/HourGlass/hourGlass image/images")
            self.hourGlassAnimated.imageProvider = pathImage
            self.hourGlassAnimated.animation = Animation.filepath(pathFile!)
            // Incease Time
            pathFile =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/HourGlass/plus five second/data", ofType: "json")
            pathImage = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/HourGlass/plus five second/images")
            self.increaseTimeAnimated.imageProvider = pathImage
            self.increaseTimeAnimated.animation = Animation.filepath(pathFile!)
            
            pathFile = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/HourGlass/BG Light/data", ofType: "json")
            self.hourGlassBGAnimated.animation = Animation.filepath(pathFile!)
        }
        */
        // MARK: Basket
        let str_basket = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/basket_receive/data", ofType: "json")
        let imageProvider_basket = BundleImageProvider(bundle: (ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/basket_receive/images")
        basketAnimate.imageProvider = imageProvider_basket
        basketAnimate.animation = Animation.filepath(str_basket!)
        basketAnimate.currentFrame = 1
        
        // Timer_circle
        let str_timer = ARGameBundle()?.path(forResource: "Asset/AnimationLottie/timer_circle_v3", ofType: "json")
        self.headerViewController.timer_animate.animation = Animation.filepath(str_timer!)
        self.headerViewController.timer_animate.flipX()
        
        let str_spc =  self.alertViewController.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Alert Special Stamp Full/data", ofType: "json")
        let imageProvider_spc = BundleImageProvider(bundle: ( self.alertViewController.ARGameBundle())!, searchPath: "Asset/AnimationLottie/Alert Special Stamp Full/images")
        self.alertViewController.specialAlertAnimate.contentMode = UIView.ContentMode.scaleToFill
        self.alertViewController.specialAlertAnimate.imageProvider = imageProvider_spc
        self.alertViewController.specialAlertAnimate.animation = Animation.filepath(str_spc!)
        
        self.lowerViewController.left_btn.addTarget(self, action: #selector(previousAction), for: .touchUpInside)
        self.lowerViewController.right_btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        
        self.headerViewController.muteBtn.addTarget(self, action: #selector(muteAction), for: .touchUpInside)
        
        // -------
        // Rotate camera by angle value from gyroscope sensor
        
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = speed
            self.motionManager.startDeviceMotionUpdates()
        }
        motionTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.updateSensor), userInfo: nil, repeats: true)
        // -------
        // MARK: Create new Scene
        // create a new scene
        scene = SCNScene()
        self.stampPreview.isHidden = true
        setUpSceneScene(scene: self.scene)
        // ******************************************************
        
        CreateStampInList()
        
        //let stamp = Stamp()
        //stamp.position = SCNVector3(0,0,0)
        //scene.rootNode.addChildNode(stamp)
        //let nodeStamp = Stamp(scene: scene, position: SCNVector3(60,-15,-60))
        //CreateStamp(scene: scene, x: 30, y: -30, z:-70, matName: "Test Stamp 2D-2")
        
        // TODO figure out how to import obj
        //        let url = Bundle.main.url(forResource: "art.scnassets/Sting-Sword", withExtension: "obj")!
        //       let path = bundle.pathForResource("Sting-Sword", ofType: "obj")
        //        let url = NSURL(fileURLWithPath: path!)
        //        let asset: MDLObject = MDLAsset(url: url).object(at: 0)
        //        print(asset)
        //        scene.rootNode.addChildNode(swordNode)
        // ******************************************************
        
        notificationCenter.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appBecomesActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    @objc func muteAction(sender:UIButton){
        ARGameSoundController.shared.sound_on = !ARGameSoundController.shared.sound_on
        if(ARGameSoundController.shared.sound_on){
            self.headerViewController.muteBtn.setImage(UIImage(named: "sound on", in: ARGameBundle(), compatibleWith: nil), for: UIControl.State.normal)
            if(self.seconds > 10){
                ARGameSoundController.shared.playBGMGameplay()
            } else {
                ARGameSoundController.shared.playBGMSpeicalGameplay()
            }
        } else {
            self.headerViewController.muteBtn.setImage(UIImage(named: "sound off", in: ARGameBundle(), compatibleWith: nil), for: UIControl.State.normal)
            ARGameSoundController.shared.stopBackgroundSound()
        }
    }
    @objc func previousAction(sender: UIButton!) {
        self.start_index_preview -= self.start_index_preview == 0 ? 0 : 1
        self.UpdateDisplayCollectedStamp()
    }
    @objc func nextAction(sender: UIButton!) {
        self.start_index_preview += self.start_index_preview == self.normal_stamp_amount-5 ? 0 : 1
        self.UpdateDisplayCollectedStamp()
    }
    
    
    @objc(SummarySegue) class SummarySegue: UIStoryboardSegue {
        override func perform() {

            let sourceViewController = self.source as! GameViewController
            let destinationViewController = self.destination as! ARGameHomeViewController
            
            /*var stampSumList:[stampSummary] = []
             for stamp in sourceViewController.stampList{
             if(stamp.is_catch && stamp.stamp_type == 0){
             if let thisStamp = stampSumList.first(where: {$0.item_uuid == stamp.id}) {
             thisStamp.quantity! += 1
             } else {
             stampSumList.append(stampSummary(item_uuid: stamp.id, imageUrl: stamp.imgUrl, quantity: 1))
             }
             }
             }*/
            
            //destinationViewController.firebase_id = sourceViewController.coreTokenObject?.data?.firebase_id
            destinationViewController.gameFinishResultObject = sourceViewController.gameFinishResultObject
            //destinationViewController.catchStampList = sourceViewController.catchStamp
            //sourceViewController.present(destinationViewController, animated: true, completion: nil)
            //sourceViewController.unwind(for: UIStoryboardSegue?, towards: destinationViewController)
            //sourceViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func finishGame(){
        var itemArray = [[String: Any]]()
        var special_url:[String]
        special_url = []
        for stamp in self.stampList{
            if(stamp.is_catch){
                let stampItem: [String: Any] = [
                    "item_play_uuid": stamp.id as Any,
                    "item_is_special":stamp.special_stamp == 1 ? true : false,
                    "time_received":NSDate().timeIntervalSince1970
                ]
                itemArray.append(stampItem)
                if(stamp.special_stamp == 1){
                    special_url.append(stamp.imgUrl)
                }
            }
        }
        
        let jsonObject: [String: Any] = [
            "round_uuid": self.resultGameStartDetail?.data?.round_uuid as Any,
            "items":itemArray
        ]
        self.specialImgUrl = special_url
        ARGameSoundController.shared.stopBGMSpeicalGameplay()
        if(self.gameDetail != nil){
            let requestData = (try? JSONSerialization.data(withJSONObject: jsonObject))!
            
            let strUrl = "game/" + (self.gameDetail?.data?.game?.game_uuid)! + "/finish?version=2"
            let requestType = "POST"
            
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
            request.httpMethod = "POST"
            
            // Set HTTP Request Header
            //application/json
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("7ar-game", forHTTPHeaderField: "x-api-key")
            request.setValue((self.firebase_id)!, forHTTPHeaderField:"x-ar-signature" )
            
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
                    self.present(self.systemAlertMessage(title: "Request Error", message: "พบปัญหาระหว่างการเชื่อมต่อ กรุณาลองใหม่อีกครั้งค่ะ (error code \(response.statusCode), on finishGame)"), animated: true, completion: nil)
                        return
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                print("Response data string:\n \(dataString)")
                    self.gameFinishResultObject = try JSONDecoder().decode(responseGameFinishObject.self, from: data!)
                } catch {
                    self.alertViewController.loadingAnimated.isHidden = true
                    self.alertViewController.loadingBG.isHidden = true
                    //self.alertViewController.loadingImage.isHidden = true
                    self.alertViewController.loadingAnimated.stop()
                    self.performSegue(withIdentifier: "timeup_to_home_segue", sender: nil)
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.scene = SCNScene()
                    if((self.gameFinishResultObject?.code)! == 0 ){
                        self.alertViewController.loadingAnimated.isHidden = true
                        self.alertViewController.loadingBG.isHidden = true
                        //self.alertViewController.loadingImage.isHidden = true
                        self.alertViewController.loadingAnimated.stop()
                        self.performSegue(withIdentifier: "timeup_to_home_segue", sender: nil)
                    }else{
                        self.alertViewController.loadingAnimated.isHidden = true
                        self.alertViewController.loadingBG.isHidden = true
                        //self.alertViewController.loadingImage.isHidden = true
                        self.alertViewController.loadingAnimated.stop()
                        self.performSegue(withIdentifier: "timeup_to_home_segue", sender: nil)
                    }
                })
            }
            task.resume()
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                self.performSegue(withIdentifier: "timeup_to_home_segue", sender: nil)
            })
        }
    }
    
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if(!game_is_start) {
            return
        }
        // retrieve the SCNView
        //let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: self.scnView)
        //let hitResults = self.scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        /*if hitResults.count > 0 {
         // retrieved the first clicked object
         let result = hitResults[0]
         
         /*if let node = result.node.childNode(withName: "stamp2", recursively: true){
         print("hit !!! ")
         let hpOld = node.value(forKey: "Hp") as! Int
         let hpNew = hpOld + 1
         node.setValue(hpNew, forKey: "Hp")
         }*/
         // get its material
         let material = result.node.geometry!.firstMaterial!
         
         // highlight it
         SCNTransaction.begin()
         SCNTransaction.animationDuration = 0.5
         
         // on completion - unhighlight
         SCNTransaction.completionBlock = {
         SCNTransaction.begin()
         SCNTransaction.animationDuration = 0.5
         
         material.emission.contents = UIColor.black
         
         SCNTransaction.commit()
         }
         
         material.emission.contents = UIColor.blue
         
         SCNTransaction.commit()
         }*/
        // find hit node
        // MARK:  Touch Stamp Handle
        if gestureRecognize.state == .ended {
            let location: CGPoint = gestureRecognize.location(in: self.scnView)
            self.touchAnimate.center = CGPoint(x: location.x, y: location.y);
            let hits = self.scnView.hitTest(location, options: nil)
            
            //effect click
            self.touchAnimate.stop()
            self.touchAnimate.play()
            if let tappednode = hits.first?.node {
                let hit_stamp = tappednode.parent?.parent
                
                var index = hit_stamp?.value(forKey: "index") as? Int
                if index == nil {
                    index = tappednode.parent?.value(forKey: "index") as? Int
                }
                
                let tapedStamp = stampList[index!]
                #if targetEnvironment(simulator)
                    tapedStamp.hitCount += self.state_power_up ? 2 : 10
                #else
                    tapedStamp.hitCount += self.state_power_up ? 2 : 1
                #endif
                if(tapedStamp.stamp_type == 0){
                    ARGameSoundController.shared.playPopEffect()
                    
                    // Update HP bar
                    var hit_percent = Float(tapedStamp.hitCount)/Float(tapedStamp.hp)
                    hit_percent = hit_percent < Float(0.1) ? 0.1 : hit_percent
                    let ori_width = self.headerViewController.origin_width_fillHp!
                    let hp_fill_const = self.headerViewController.hp_fill_const
                    let hp_fill_bar = self.headerViewController.hpbar_to_fill
                    let ori_const = self.headerViewController.origin_conts_fillHp!
                    let width = (ori_width) * CGFloat(Float(1) - hit_percent)
                    //print(CGFloat(Float(1) - hit_percent))
                    let full_hp_const = -(width + abs(tapedStamp.hitCount == 1 ? 0 : ori_const))
                    hp_fill_const?.constant = full_hp_const
                    hp_fill_bar!.transform = CGAffineTransform(translationX: -((ori_width/2) * CGFloat(Float(1) - hit_percent)), y: 0)
                    
                    // Update preview small
                    self.headerViewController.preview_small_stamp.image = tapedStamp.stampImg
                    if tapedStamp.hitCount > tapedStamp.hp! {
                        self.headerViewController.hp_label.text = "\(tapedStamp.hp!)/\(tapedStamp.hp!)"
                    }
                    else {
                        self.headerViewController.hp_label.text = "\(tapedStamp.hitCount!)/\(tapedStamp.hp!)"
                    }
                } else if(tapedStamp.stamp_type == 1){
                    ARGameSoundController.shared.playTapBombStamp()
                    self.bombAnimated.play()
                    self.timer_realtime =  Int(self.headerViewController.timer_animate.realtimeAnimationFrame)
                    print(timer_realtime)
                    self.headerViewController.timer_animate.currentFrame = AnimationFrameTime(timer_realtime+5)
                    self.headerViewController.timer_animate.play()
                    self.bombBGAnimated.play{(finished) in
                        let str_timer_minus =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Reduce Time/data", ofType: "json")
                        let imageProvider_timer_minus = BundleImageProvider(bundle: (self.ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Reduce Time/images")
                        self.headerViewController.timereffect_animate.imageProvider = imageProvider_timer_minus
                        self.headerViewController.timereffect_animate.animation = Animation.filepath(str_timer_minus!)
                        ARGameSoundController.shared.playTimeTick()
                        self.headerViewController.timereffect_animate.play()
                        self.decreaseTimeAnimated.play()
                        //self.bombAnimated.play()
                    }
                } else if(tapedStamp.stamp_type == 2){
                    ARGameSoundController.shared.playTapHourGlassStamp()
                    self.hourGlassAnimated.play()
                    self.timer_realtime =  Int(self.headerViewController.timer_animate.realtimeAnimationFrame)
                     print(timer_realtime)
                    self.headerViewController.timer_animate.currentFrame = AnimationFrameTime(timer_realtime-5)
                    self.headerViewController.timer_animate.play()
                    self.hourGlassBGAnimated.play{(finished) in
                        let str_timer_plus =  self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/Increase Time/data", ofType: "json")
                        let imageProvider_timer_plus = BundleImageProvider(bundle: (self.ARGameBundle())!, searchPath: "Asset/AnimationLottie/Gameplay Animation/Increase Time/images")
                        self.headerViewController.timereffect_animate.imageProvider = imageProvider_timer_plus
                        self.headerViewController.timereffect_animate.animation = Animation.filepath(str_timer_plus!)
                        
                        
                        ARGameSoundController.shared.playIncreaseTime()
                        ARGameSoundController.shared.playTimeTick()
                        self.headerViewController.timereffect_animate.play()
                        self.increaseTimeAnimated.play()
                    }
                } else if(tapedStamp.stamp_type == 3){
                    ARGameSoundController.shared.playTapNetStamp()
                    ARGameSoundController.shared.playPowerUp()
                    self.NetAnimated.play()
                    //self.netBGAnimated.loopMode = .loop
                    self.netBGAnimated.play()
                    //self.headerViewController.netHeaderFlashAnimated.loopMode = .loop
                    self.headerViewController.netHeaderFlashAnimated.play()
                    self.headerViewController.netHeaderFlashAnimated2.play()
                }
                
                /*print(hit_stamp?.name)
                 print(hit_stamp?.value(forKey: "id") as? Int)
                 print(tapedStamp.hitCount)*/
                
                // Reset hit count of previous tapedStamp to 0
                if(self.target_stamp_index != index){
                    stampList[self.target_stamp_index].hitCount = 0
                    self.target_stamp_index = index!
                }
                
                // Check Hit Count
                if(tapedStamp.stamp_type == 0 && tapedStamp.hitCount >= tapedStamp.hp){
                    tapedStamp.is_catch = true
                    //print("======= Catch stamp \(tapedStamp.stampName) =======")
                } else if(tapedStamp.stamp_type != 0){
                    tapedStamp.is_catch = true
                    //print("======= Catch special stamp \(tapedStamp.stampName) =======")
                }
                
                //do something with tapped object
                //print(tappednode)
                //let stampParent = tappednode.parent
                /*let parent = NodeGetParent(node: tappednode)
                 let stampNOde = parent.childNode(withName: "Stamp", recursively: true)
                 if let hpOld = stampNOde?.value(forKey: "hitCount") as? Int {
                 //print(hpOld)
                 let hpNew = hpOld + 1
                 //print(hpNew)
                 stampNOde?.setValue(hpNew, forKey: "hitCount")
                 print(stampNOde?.value(forKey: "hitCount")! as Any)
                 }*/
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @objc func appWillResignActive() {
        //to background
        if (motionManager.deviceMotion != nil) {
            motionManager.stopDeviceMotionUpdates()
        }
    }

    @objc func appBecomesActive() {
        //to front
        if (motionManager.deviceMotion != nil) {
            self.motionManager.deviceMotionUpdateInterval = speed
            self.motionManager.startDeviceMotionUpdates()
        }
    }
    
    @objc func updateSensor() {
        // MARK: Camera Sensor
        if (motionManager.deviceMotion != nil) {
            
            let attitude = motionManager.deviceMotion!.attitude
            
            // #####################
            // MUST SEE: 3
            self.rotPitch = Float(attitude.pitch) // horizontal rotate
            self.rotRoll = Float(attitude.roll) // vertical rotate
            self.rotYaw = Float(attitude.yaw)
            // use to check sensor change
            // สำหรับเอาไว้ตรวจสอบข้อมูล, สามารถ comment ทิ้งได้
            /*
             if !(lastRotPitch < rotPitch + 0.1 && lastRotPitch > rotPitch - 0.1) ||
             !(lastRotRoll < rotRoll + 0.1 && lastRotRoll > rotRoll - 0.1) ||
             !(lastRotYaw < rotYaw + 0.1 && lastRotYaw > rotYaw - 0.1) {
             
             print("\((Double(rotPitch) * 180.0 / Double.pi).format(f: ".3")) \t\((Double(rotRoll) * 180.0 / Double.pi).format(f: ".3")) \t\((Double(rotYaw) * 180.0 / Double.pi).format(f: ".3"))")
             
             lastRotPitch = rotPitch
             lastRotRoll = rotRoll
             lastRotYaw = rotYaw
             }
             */
            // #####################
            
            // #####################
            // MUST SEE: 4
            // portrait
            // portrait แนวตั้ง
            self.cameraRollNode.eulerAngles.z = -Float(attitude.roll)
            self.cameraPitchNode.eulerAngles.x = Float(attitude.pitch)
            self.cameraYawNode.eulerAngles.y = Float(attitude.yaw)
            // #####################
            
            // perfect landscape left
            // ptoon: must set device orient to landscape left + change cameraNode eulerAngle to 0,0,0
            /*
             self.cameraNode.eulerAngles = SCNVector3Make(
             Float(attitude.roll - Double.pi/2.0),
             Float(attitude.yaw),
             Float(attitude.pitch)
             )
             */
        }
    }
    
    @IBAction func tab_start(_ sender: Any) {
        self.start_button.isHidden = true;
        time_is_on = true
        timeOn(on: true)
    }
    
    // MARK: Time Function
    func timeOn(on: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in guard let strongSelf = self else{ return}
            strongSelf.seconds -= 1
            self!.alertTime += self!.is_alert ? 1 : 0
            if(strongSelf.seconds >= 0){
                self!.headerViewController.timer_label.text = "\(strongSelf.seconds)"
            }else if(strongSelf.seconds < 0){
                 self!.headerViewController.timer_label.text = "0"
            }
            if(strongSelf.seconds <= 0){
                self?.timer.invalidate()
                
                /*let alertController = UIAlertController(title: "Time Over", message: "", preferredStyle: .alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: .default){
                 alertController in
                 self?.performSegue(withIdentifier: "segue_to_home", sender: nil)
                 })*/
                //alertController.addAction(backToHome)
                //self!.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func CreateWorldSphere(scene:SCNScene){
        // create world sphere
        guard let imagePath = Bundle.main.path(forResource: "Hellbrunn25", ofType: "jpg") else {
            fatalError("Failed to find path for panaromic file.")
        }
        guard let image = UIImage(contentsOfFile:imagePath) else {
            fatalError("Failed to load panoramic image")
        }
        //Create node, containing a sphere, using the panoramic image as a texture
        let sphere = SCNSphere(radius: 80.0)
        sphere.firstMaterial!.isDoubleSided = true
        sphere.firstMaterial!.diffuse.contents = image
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(0,0,0)
        scene.rootNode.addChildNode(sphereNode)
    }
    
    func setUpSceneScene(scene:SCNScene){
        //CreateWorldSphere(scene: scene)
        setUpCamera(scene: scene)
        setUpAmbientLight(scene: scene)
        setUpLight(scene: scene)
        setUpSceneView()
    }
    
    func setUpSceneView(){
        // retrieve the SCNView
        //let scnView = self.view as! SCNView
        self.scnView = SCNView()
        // set the scene to the view
        self.scnView.scene = self.scene
        self.scnView.frame = self.view.bounds
        self.view.insertSubview(self.scnView, at: 1)
        // allows the user to manipulate the camera
        // ptoon: DONT ALLOW THIS
        //scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //scnView.showsStatistics = true
        //scnView.debugOptions = [.showWireframe, .showBoundingBoxes]
        
        // configure the view
        self.scnView.backgroundColor = UIColor.clear
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // MARK: Turn On/Off Camera in game
        #if targetEnvironment(simulator)
            
        #else
        let captureSession = AVCaptureSession()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        var err: NSError? = nil
        var videoIn : AVCaptureDeviceInput?
        do {
            videoIn = try AVCaptureDeviceInput.init(device: videoDevice!)
            if(err == nil){
                if(captureSession.canAddInput(videoIn! as AVCaptureInput)){
                    captureSession.addInput(videoIn! as AVCaptureDeviceInput)
                }
            }
            captureSession.startRunning()
            previewLayer.frame = self.view.bounds
            //self.scene.background.contents = previewLayer
            self.view.layer.insertSublayer(previewLayer, at: 0)
            
        } catch {
            
        }
        /*DispatchQueue.main.async {
            self.scene.background.contents = self.captureDevice
        }*/
        #endif
        scnView.delegate = self
    }
    
    func stopSceneView(){
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        scnView.stop(nil)
        scnView.pause(nil)
        scnView.delegate = nil
        self.finishGame()
    }
    
    func setUpCamera(scene:SCNScene){
        //#####################
        // MUST SEE: 2
        camera = SCNCamera()
        camera.zNear = 0
        camera.zFar = 100
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.eulerAngles = SCNVector3Make(-Float(Double.pi / 2.0), 0, 0)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        // NOTE: MUST USE Roll,Pitch,Yaw in Portrait Mode
        // for Landscape Mode, it just a decoration
        cameraRollNode = SCNNode()
        cameraRollNode.eulerAngles = SCNVector3Make(0, 0, 0)
        cameraRollNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraRollNode.addChildNode(cameraNode)
        
        cameraPitchNode = SCNNode()
        cameraPitchNode.eulerAngles = SCNVector3Make(0, 0, 0)
        cameraPitchNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraPitchNode.addChildNode(cameraRollNode)
        
        cameraYawNode = SCNNode()
        cameraYawNode.eulerAngles = SCNVector3Make(0, 0, 0)
        cameraYawNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraYawNode.addChildNode(cameraPitchNode)
        
        scene.rootNode.addChildNode(cameraYawNode)
        // #####################
    }
    
    func changeTimerColor(change:Bool,time:Int){
        //change &&
        if((time % 2 == 0)){
            self.headerViewController.timer_animate.setValueProvider(self.redColorProvider, keypath: self.keypath)
            //self.changeColor = false
        }else{
            self.headerViewController.timer_animate.setValueProvider(self.greenColorProvider, keypath: self.keypath)
            //self.changeColor = true
        }
    }
    
    func setUpLight(scene: SCNScene){
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.light?.spotOuterAngle = 300
        lightNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(lightNode)
    }
    
    func setUpAmbientLight(scene: SCNScene){
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        //ambientLightNode.light!.color = UIColor(red: 0.54, green: 0.43, blue: 0.22, alpha: 0.5)
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    // MARK: CreateStampInList Function
    func CreateStampInList(){
        // Check Request Stamp Data Success
        if(resultGameStartDetail == nil){ // MOCKUP STAMP IF NO DATA
            for i in 0...16{
                let nums = [1,-1]
                let rand_x = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
                let rand_y = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
                let rand_z = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
                let ramdPos = SCNVector3(x: Float(rand_x), y: Float(rand_y), z: Float(rand_z))
                //normal
                if(i < 9){
                    normal_stamp_amount += 1
                    stampList.append(ARStampObject(scene: scene, position: ramdPos, stampName: "stamp_\(i)", stamp_type: 0,hp: 10,level:5, id: String(i+1), index:i, stampImage: nil, special_stamp: 0, imgUrl: nil))
                }
                    //special stamp
                else {
                    stampList.append(ARStampObject(scene: scene, position: ramdPos, stampName: "stamp_\(i)", stamp_type: 0,hp: 10,level: 10, id: String(i+1), index:i, stampImage: nil, special_stamp: 1, imgUrl: nil))
                }
            }
        } else { // CREATE STAMP FROM REQUEST
            if let stampData = resultGameStartDetail?.data?.schedule?.items {
                var sIndex = 0
                for (stamp) in stampData{
                    var url_image:String = ""
                    let nums = [1,-1]
                    let rand_x = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
                    let rand_y = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
                    let rand_z = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
                    let ramdPos = SCNVector3(x: Float(rand_x), y: Float(rand_y), z: Float(rand_z))
                    
                    url_image  = stamp?.image_url ?? ""
                    let url:NSURL = NSURL(string: url_image)!
                    guard let data:NSData = NSData(contentsOf: url as URL) else {
                        continue
                    }
                    //let stampImage = UIImage(data: data as Data)
                    let stampImage = resizeImage(image: UIImage(data: data as Data)!, targetSize: CGSize(width: 300,height: 300))
                    
                    for i in 0 ..< (stamp?.quantity)!{
                        normal_stamp_amount += 1
                        var stamp_type:Int = 0
                        // convert Stamp Type in to in Game Type
                        switch(stamp?.type){
                        //1 = ar game
                        case 1:
                            stamp_type = 0
                            break
                        //2 = ar_special
                        case 2:
                            stamp_type = 0
                            break
                        //3 = ar_item (ระเบิด,เพิ่มเวลา,ลดเวลา)
                        case 3:
                            (stamp?.name == "ระเบิดลดเวลา" ? (stamp_type = 1) :
                                (stamp?.name == "นาฬิกาเพิ่มเวลา" ? (stamp_type = 2) :
                                    (stamp?.name == "ตาข่ายช่วยจับ" ? (stamp_type = 3) :
                                        (stamp_type = 0))))
                            break
                        case 6:
                            stamp_type = 0
                            break
                        default:
                            stamp_type = 0
                            break
                        }
                        
                        stampList.append(ARStampObject(scene: scene, position: ramdPos,
                                               stampName: "\(stamp?.name!)",
                            stamp_type: stamp_type,
                            hp:(stamp?.hp)!,
                            level:(stamp?.level)!,
                            id: (stamp?.item_play_uuid!)!,
                            index:sIndex,
                            stampImage:stampImage,
                            special_stamp: (stamp?.type == 6 ? 1 : 0), imgUrl: stamp?.image_url))
                        sIndex += 1
                    }
                }
            }
        }
        
        // MockUp Item
        // Normal Stamp
        /*stampList.append(Stamp(scene: scene, position: SCNVector3(x: 0, y: -10, z: -20), stampName: "stampNormal", stamp_type: 0, hp: 20, level: 5, id: String(stampList.count), index:stampList.count, stampImage: nil, special_stamp: 0, imgUrl: nil))
        stampList.append(Stamp(scene: scene, position: SCNVector3(x: 5, y: -10, z: -10), stampName: "stampNormal", stamp_type: 0, hp: 30, level: 5, id: String(stampList.count), index:stampList.count, stampImage: nil, special_stamp: 0, imgUrl: nil))
        stampList.append(Stamp(scene: scene, position: SCNVector3(x: 10, y: -10, z: -30), stampName: "stampNormal", stamp_type: 0, hp: 40, level: 5, id: String(stampList.count), index:stampList.count,stampImage: nil, special_stamp: 0, imgUrl: nil))*/
         // Special Stamp
        /*stampList.append(Stamp(scene: scene, position: SCNVector3(x: 0, y: -5, z: -30), stampName: "Special", stamp_type: 0, hp: 1,level: 10, id: String(stampList.count), index:stampList.count,stampImage: nil, special_stamp: 1, imgUrl: nil))
        stampList.append(Stamp(scene: scene, position: SCNVector3(x: 5, y: -5, z: -30), stampName: "Special", stamp_type: 0, hp: 1,level: 10, id: String(stampList.count), index:stampList.count,stampImage: nil, special_stamp: 1, imgUrl: nil))
        stampList.append(Stamp(scene: scene, position: SCNVector3(x: 10, y: -5, z: -30), stampName: "Special", stamp_type: 0, hp: 1,level: 10, id: String(stampList.count), index:stampList.count, stampImage: nil, special_stamp: 1, imgUrl: nil))*/
         // Item
        /*stampList.append(Stamp(scene: scene, position: SCNVector3(x:0 ,y:-15 ,z:-30), stampName: "Bomb", stamp_type: 1, hp: 1,level: 10, id: String(stampList.count), index:stampList.count, stampImage: nil, special_stamp: 0, imgUrl: nil))
        stampList.append(Stamp(scene: scene, position: SCNVector3(x:10 ,y:-15 ,z:-30), stampName: "HourGlass", stamp_type: 2, hp: 1,level: 10, id: String(stampList.count), index:stampList.count, stampImage: nil, special_stamp: 0, imgUrl: nil))
        stampList.append(Stamp(scene: scene, position: SCNVector3(x:5 ,y:-15 ,z:-30), stampName: "Net", stamp_type: 3, hp: 1,level: 10, id: String(stampList.count), index:stampList.count, stampImage: nil, special_stamp: 0, imgUrl: nil))*/
    }
    
    func clearNormalStamp(){
        for stamp in stampList{
            if(stamp.active && stamp.special_stamp == 0){
                stamp.stampChildNode.isHidden = true
            }
            if(stamp.active && stamp.special_stamp == 1){
                self.normal_stamp_amount += 1
                stamp.stampChildNode.isHidden = false
            }
        }
    }
    
    func UpdateDisplayCollectedStamp(){
        let lowerView = self.lowerViewController!
        let imageList:[UIImageView] = [lowerView.img_1, lowerView.img_2, lowerView.img_3,lowerView.img_4,lowerView.img_5]
        var stampCatchList: [UIImage] = []
        var j = 0
        for (stamp) in stampList{
            if(stamp.is_catch && stamp.stamp_type == 0){
                j += 1
                if(j > self.start_index_preview){
                    stampCatchList.append(stamp.stampImg)
                    if(stampCatchList.count == 5){
                        break
                    }
                }
            }
        }
        //print(self.start_index_preview)
        for i in 0...5{
            if(i > stampCatchList.count-1){
                break
            }
            imageList[i].isHidden = false
            imageList[i].image = stampCatchList[i]
        }
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

func cloneStamp(scene: SCNScene,parentNode: SCNNode){
    let newNode = parentNode.clone()
    newNode.position = SCNVector3Make(30, -30, -70)
    scene.rootNode.addChildNode(newNode)
}

fileprivate func deepCopyNode(node: SCNNode) -> SCNNode {
    let clone = node.clone()
    clone.geometry = node.geometry?.copy() as? SCNGeometry
    if let g = node.geometry {
        clone.geometry?.materials = g.materials.map{ $0.copy() as! SCNMaterial }
    }
    return clone
}

extension SCNScene {
    func buildMaterialIndex() -> Dictionary<String, SCNMaterial> {
        return self.rootNode.buildMaterialIndex()
    }
}

extension SCNNode {
    func isPartOf(node: SCNNode) -> Bool {
        return (node === self) || (parent?.isPartOf(node: node) ?? false)
    }
    
    private class _DictBox {
        var dict = Dictionary<String, SCNMaterial>()
    }
    private func _populateMaterialIndex(dictbox: _DictBox, node: SCNNode) {
        if let g = node.geometry {
            for m in g.materials {
                if let n = m.name {
                    dictbox.dict[n] = m
                }
            }
        }
        for n in node.childNodes {
            _populateMaterialIndex(dictbox: dictbox, node: n)
        }
    }
    func buildMaterialIndex() -> Dictionary<String, SCNMaterial> {
        let dictbox = _DictBox()
        _populateMaterialIndex(dictbox: dictbox, node: self)
        return dictbox.dict
    }
}

// MARK: Renderer
extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if(gameRunning){
            DispatchQueue.main.async {
                // MARK: Special TIME
                if(!self.is_alert && self.seconds <= 20){
                    
                    ARGameSoundController.shared.stopBGMGameplay()
                    ARGameSoundController.shared.playAlertSpecialStamp()
                    let str_basket = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/basket_special/data", ofType: "json")
                    self.basketAnimate.animation = Animation.filepath(str_basket!)
                    self.basketAnimate.loopMode = .loop
                    self.basketAnimate.play()
                    self.is_alert = true
                    self.alertViewController.light_timeupAnimate.stop()
                    self.alertViewController.timeup_animate.stop()
                    self.alertViewController.loadingAnimated.stop()
                    self.alertViewController.view.isHidden = false
                    //self.alertViewController.bgAlpha.isHidden = true
                    self.alertViewController.specialAlertAnimate.isHidden = false
                    self.headerViewController.timer_animate.currentFrame = 40
                    self.headerViewController.timer_animate.pause()
                    self.clearNormalStamp()
                    self.alertViewController.specialAlertAnimate.play{(finished) in
                        self.seconds = 20
                    }
                    //red
                    //self.changeTimerColor(change: self.changeColor)
                    // Change StampList to Special (Disney)
                }
                if(self.alertTime == 4){
                    //self.is_alert = false
                    //self.alertTime = 0
                    self.alertViewController.view.isHidden = true
                    self.alertViewController.specialAlertAnimate.isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.headerViewController.timer_animate.play()
                        ARGameSoundController.shared.playBGMSpeicalGameplay()
                    })
                }
                if(self.seconds <= 0 && !self.is_timeup){
                    // MARK: TIME UP
                    // Stop All Animation
                    self.headerViewController.netHeaderFlashAnimated.stop()
                    self.headerViewController.netHeaderFlashAnimated2.stop()
                    ARGameSoundController.shared.stopPowerUp()
                    self.state_power_up = false
                    self.netBGAnimated.stop()
                    ARGameSoundController.shared.stopBackgroundSound()
                    self.is_timeup = true
                    DispatchQueue.main.async {
                        self.alertViewController.view.isHidden = false
                        self.alertViewController.loadingAnimated.isHidden = true
                        self.alertViewController.loadingBG.isHidden = true
                        //self.alertViewController.loadingImage.isHidden = true
                        self.alertViewController.light_timeupAnimate.isHidden = false
                        self.alertViewController.specialAlertAnimate.isHidden = true
                         self.alertViewController.bgAlpha.isHidden = false
                        ARGameSoundController.shared.playTimeUpSFX()
                        self.alertViewController.light_timeupAnimate.play()
                        self.alertViewController.timeup_animate.play{(finished) in
                            //self.alertViewController.light_timeupAnimate.stop()
                            self.alertViewController.loadingAnimated.play()
                            self.alertViewController.light_timeupAnimate.isHidden = true
                            self.alertViewController.loadingAnimated.isHidden = false
                            self.alertViewController.loadingBG.isHidden = false
                            //self.alertViewController.loadingImage.isHidden = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self.gameRunning = false
                                self.stopSceneView()
                            })
                        }
                        /*self.alertViewController.light_timeupAnimate.play{(finished) in
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                         self.gameRunning = false
                         self.stopSceneView()
                         })
                         }*/
                    }
                    
                    //self.scene = SCNScene()
                }
            }
            /*if(self.seconds <= 10 && self.seconds >= 1){
             self.changeTimerColor(change: self.changeColor,time: self.seconds)
             }*/
            // update something when game running
            // print(seconds)
            for stamp in stampList{
                let node = stamp.stampChildNode
                StampAction(node: node!,level: stamp.level)
                
                if(stamp.is_catch && stamp.active){
                    node?.removeFromParentNode()
                    // prevent background thread
                    if(stamp.stamp_type == 0){
                        DispatchQueue.main.async {
                            self.UpdateDisplayCollectedStamp()
                            self.stampPreview.isHidden = false
                            self.stampPreview.image = stamp.stampImg
                            let origin = self.stampPreview.center.y
                            let toPos = self.view.bounds.height / 2
                            //self.stampPreview.center.y = moveDistance
                            self.stampPreview.center.y = toPos
                            //print(self.stampPreview.center)
                            //print(toPos)
                            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
                                //let float:CGFloat
                                ARGameSoundController.shared.playStampMoveToBasket()
                                self.stampPreview.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                                self.stampPreview.center.y = origin
                                if(self.seconds > 10){
                                    let str_basket = self.ARGameBundle()?.path(forResource: "Asset/AnimationLottie/Gameplay Animation/basket_receive/data", ofType: "json")
                                    self.basketAnimate.animation = Animation.filepath(str_basket!)
                                    self.basketAnimate.play()
                                }
                            }, completion: {(_ finished: Bool) -> Void in
                                self.stampPreview?.transform = CGAffineTransform(scaleX: 1, y: 1)
                                self.stampPreview.isHidden = true
                                ARGameSoundController.shared.playRecieveStampToBasket()
                            })
                        }
                    }
                    
                    if(stamp.stamp_type == 1){
                        self.seconds -= 5
                    } else if(stamp.stamp_type == 2){
                        self.seconds += 5
                    } else if(stamp.stamp_type == 3 && self.seconds > 0){
                        // MARK:Power Up
                        self.state_power_up = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                            self.headerViewController.netHeaderFlashAnimated.stop()
                            self.headerViewController.netHeaderFlashAnimated2.stop()
                            ARGameSoundController.shared.stopPowerUp()
                            self.state_power_up = false
                            self.netBGAnimated.stop()
                        })
                        self.power_up_endtime = self.seconds - 4
                    }
                    stamp.active = false
                }
            }
            // End Power up time
            // 1 click = 2 click
            /*if(self.power_up_endtime >= self.seconds){
                self.headerViewController.netHeaderFlashAnimated.stop()
                self.headerViewController.netHeaderFlashAnimated2.stop()
                SoundController.shared.stopPowerUp()
                
            }*/
            //node?.position.x += 0.05
            //StampAction(node: node!)
            //print("x = \(node?.position.x)!")
            //print("y = \(node?.position.y)!")
            //print("z = \(node?.position.z)!")
        }
    }
}

// MARK: Stamp Action Function
func StampAction(node: SCNNode,level:Int){
    // ========= Game Rule ===========
    let maxGameBorder = 50
    let minGameBorder = 5
    
    var action: SCNAction!
    var actions = [SCNAction] ()
    
    let moveType = node.value(forKey: "moveType") as? Int
    let current_position = node.position
    let distance = Float(powf(current_position.x, 2) + powf(current_position.y, 2) + powf(current_position.z, 2)).squareRoot()
    
    // Reach Game border then change animation sequence
    if(/*Int(distance) <= minGameBorder || */Int(distance) >= maxGameBorder){
        let nums = [1,-1]
        let rand_x = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
        let rand_y = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
        let rand_z = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
        let ramdPos = SCNVector3(x: Float(rand_x), y: Float(rand_y), z: Float(rand_z))
        //let speedPercent = Float(abs(10 - level)) / Float(100) * 10
        let speedPercent = Float(abs(10 - level)) / 10.0
        let duration = Double(10 * speedPercent) + 4
        let action1 = SCNAction.move(to: ramdPos, duration: duration)
        actions.append(action1)
        action = SCNAction.sequence(actions)
        node.runAction(action)
    }
    /*switch moveType {
     case 1:
     action = SCNAction.rotate(by: 1.0, around: node.position, duration: 8)
     case 2:
     let action1 = SCNAction.move(to: ramdPos, duration: 10)
     actions.append(action1)
     action = SCNAction.sequence(actions)
     }
     node.runAction(action)*/
}
