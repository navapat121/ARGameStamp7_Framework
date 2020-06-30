//
//  ViewController.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 21/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import UIKit
import MetalKit
import CoreMotion
import AVFoundation

class MetalViewController: UIViewController {
    
    var metalView: MTKView {
        return view as! MTKView
    }
    var viewController = ViewController()
    @IBOutlet weak var HPBar: UIImageView!
    @IBOutlet weak var stampName: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var label_countdown: UILabel!
    @IBOutlet weak var start_button: UIButton!
    @IBOutlet weak var img_Header: UIImageView!
    var renderer: Renderer?
    @IBOutlet weak var btn_close: UIButton!
    var touchPoint = CGRect()
    
    @IBOutlet weak var hpProgressBar: UIProgressView!
    @IBOutlet weak var img_Hit: UIImageView!
    @IBOutlet weak var hitCountLabel: UILabel!
    @IBOutlet weak var img_timeFrame: UIImageView!
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hitCountLabel.text = ""
        // Metal View
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }
        //messageLabel.isHighlighted = true
        self.view.isOpaque = false
        //self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        //renderer = Renderer(device: device, imageName: "stamp.jpeg")
        metalView.clearColor = Colors.tranparent
        renderer = Renderer(device: device)
        //SoundController.shared.playIntroGame()
        renderer?.scene = GameScene(
            device: device,
            size: view.bounds.size,
            label1: messageLabel,
            label2 : stampName,
            hitCountLabel: hitCountLabel,
            HPBar: HPBar,
            hpProgressBar: hpProgressBar
        )
        metalView.delegate = renderer
        
        //commandQueue = device.makeCommandQueue()
        
        
        if let theurl = URL(string: "https://www.bluewindsolution.com/en/404.php"){
            let theURLRequest = URLRequest(url: theurl)
            webview?.loadRequest(theURLRequest)
        }
    }
    
    /*@IBAction func close_webview(_ sender: Any) {
     webview.isHidden = true
     btn_close.isHidden = true
     }*/
    
    /* @IBAction func remove_webview(_ sender: Any) {
     webview.isHidden = true
     close_web.isHidden = true
     
     }*/
    
    
    var seconds : Int =  60
    var timer = Timer()
    var time_is_on = false
    @IBAction func tab_start(_ sender: Any) {
        self.start_button.isHidden = true;
        time_is_on = true
        timeOn(on: time_is_on)
    }
    
    func timeOn(on: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in guard let strongSelf = self else{ return}
            strongSelf.seconds -= 1
            strongSelf.label_countdown.text = "\(strongSelf.seconds)"
            if(strongSelf.seconds == 0){
                self?.timer.invalidate()
                
                let alertController = UIAlertController(title: "Time Over", message: "", preferredStyle: .alert)
                
                /* let backToHome = UIAlertAction(title: "OK", style: .cancel, handler: { action in self?.performSegue(withIdentifier: "game_seage", sender: self)})*/
                
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default){
                    alertController in
                    self?.performSegue(withIdentifier: "seuge_to_home", sender: nil)
                })
                //alertController.addAction(backToHome)
                self!.present(alertController, animated: true, completion: nil)
            }
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesBegan(view, touches:touches,
                                      with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesMoved(view, touches: touches,
                                      with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesEnded(view, touches: touches,
                                      with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        renderer?.scene?.touchesCancelled(view, touches: touches,
                                          with: event)
    }
}
