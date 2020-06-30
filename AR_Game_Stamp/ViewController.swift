//
//  ViewController.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 21/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion // gyro
import AVKit

enum Colors{
    static let wenderlichGreen = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha:0.0)
    static let tranparent = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
}

class ViewController: UIViewController   {
    
    
    
    @IBAction func unwindSegueToGame(segue: UIStoryboardSegue) {
    }
    let captureSession = AVCaptureSession()
    var captureInput: AVCaptureDeviceInput!
    let outputData = AVCaptureVideoDataOutput()
    var cameraVC: UIImagePickerController!
    var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    //var mtkVC: TestViewController!
    //var metalView: MTKView!
    //var device: MTLDevice!
    //var commandQueue: MTLCommandQueue!
    var renderer: Renderer?
    
    let imgPicker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.cameraVC = imgPicker
        
        self.cameraVC.view.frame = CGRectMake(x: 0,y: 0,width: self.view.frame.width, height: self.view.frame.height);
        //imagePickerController.delegate = self;
        self.cameraVC.sourceType = UIImagePickerController.SourceType.camera;
        self.cameraVC.isNavigationBarHidden = true;
        self.cameraVC.isToolbarHidden = true;
        self.cameraVC.videoQuality = UIImagePickerController.QualityType.typeLow;
        self.cameraVC.showsCameraControls = false;
        self.cameraVC.view.isUserInteractionEnabled = false;
        self.view.insertSubview(self.cameraVC.view, belowSubview: self.view)
        self.view.sendSubviewToBack(self.cameraVC.view)*/
        
        let captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}

        captureSession.addInput(input)
        captureSession.startRunning()

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.layer.insertSublayer(previewLayer, at: 0)
        /*self.mtkVC = TestViewController()
        self.view.addSubview(self.mtkVC.view)*/
        
        // Metal View
        /*metalView = self.view as! MTKView
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
          fatalError("Device not created. Run on a physical device")
        }*/

        /*metalView.clearColor = Colors.wenderlichGreen
        renderer = Renderer(device: device)
        renderer?.scene = GameScene(device: device, size: view.bounds.size)
        metalView.delegate = renderer*/
        //self.view.addSubview(sel)
        //commandQueue = device.makeCommandQueue()
        /*if let theurl = URL(string: "https://www.bluewindsolution.com/en/404.php"){
            let theURLRequest = URLRequest(url: theurl)
            webView?.loadRequest(theURLRequest)

        }*/
        
    }
    func CGRectMake(x :CGFloat,y:CGFloat, width:CGFloat , height:CGFloat ) -> CoreGraphics.CGRect{
        var rect: CGRect = CGRect()
        rect.origin.x = x; rect.origin.y = y;
        rect.size.width = width; rect.size.height = height;
        return rect;
    }
}

