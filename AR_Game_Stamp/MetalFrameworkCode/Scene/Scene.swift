//
//  Scene.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 1/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import MetalKit
import CoreMotion
import AVFoundation
import UIKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    var label1 : UILabel
    var label2 : UILabel
    var hitCountLabel : UILabel
    var hpProgressBar: UIProgressView
    var HPBar : UIImageView
    var player: AVAudioPlayer?
    var sceneConstants = SceneConstants()
    
    let motionManager = CMMotionManager()
    var referenceAttitude = CMAttitude()
    var projectionMatrix = matrix_float4x4()
    
    var rotX: Float = 0
    var rotY: Float = 0
    var rotZ: Float = 0
    // use to check sensor change
    var lastRotX: Float = 0, lastRotY: Float = 0, lastRotZ: Float = 0
    
    init(device: MTLDevice, size: CGSize,label1: UILabel,label2: UILabel,hitCountLabel: UILabel, HPBar: UIImageView,hpProgressBar: UIProgressView) {
        self.device = device
        self.size = size
        self.label1 = label1
        self.label2 = label2
        self.hitCountLabel = hitCountLabel
        self.HPBar = HPBar
        self.hpProgressBar = hpProgressBar
        super.init()
    }
    
    func update(deltaTime: Float) {}
    
    func render(commandEncoder: MTLRenderCommandEncoder,
                deltaTime: Float, frameTime: Float) {
        update(deltaTime: deltaTime)
        //var viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -5)
        
        // Device screen
        // ipad 2388 × 1668
        // iphone 11 || 750.0 / 1334	.0
        //let aspect = Float(windowWidth()/windowHeight())
        
        // Create world space
        //var projectionMatrix = matrix_float4x4(projectionFov: radians(fromDegrees: 60),aspect: aspect,nearZ:0.1, farZ:100)
        
        // Rotate camera by angle value from gyroscope sensor
        myGyroscope()
        projectionMatrix = projectionMatrix.rotatedBy(rotationAngle: self.rotX, x: 0, y: 1, z: 0)
        projectionMatrix = projectionMatrix.rotatedBy(rotationAngle: self.rotY, x: 1, y: 0, z: 0)
        projectionMatrix = projectionMatrix.rotatedBy(rotationAngle: self.rotZ, x: 0, y: 0, z: 1)
        
        //projectionMatrix = projectionMatrix.rotatedBy(rotationAngle: Float(Double.pi/12), x: -1, y: 0, z: 0)
        
        sceneConstants.projectionMatrix = projectionMatrix
        self._projectionMatrix = projectionMatrix
        commandEncoder.setVertexBytes(&sceneConstants,
                                      length: MemoryLayout<ModelConstants>.stride,
                                      index: 2)
        for child in children {
            child.render(commandEncoder: commandEncoder,parentModelViewMatrix: projectionMatrix, frameTime: frameTime)
        }
    }
    
    func touchesBegan(_ view: UIView, touches: Set<UITouch>,
                      with event: UIEvent?) {}
    
    func touchesMoved(_ view: UIView, touches: Set<UITouch>,
                      with event: UIEvent?) {}
    
    func touchesEnded(_ view: UIView, touches: Set<UITouch>,
                      with event: UIEvent?) {}
    
    func touchesCancelled(_ view: UIView, touches: Set<UITouch>,
                          with event: UIEvent?) {}
    
    func myGyroscope() {
        // GET VALUE FROM GYRO SCOPE SENSOR
        self.motionManager.deviceMotionUpdateInterval = 0.01
        self.motionManager.startDeviceMotionUpdates()
        //print(self.motionManager.deviceMotion?.attitude)
        var attitude = self.motionManager.deviceMotion?.attitude;
        
        if ( referenceAttitude == nil )
        {
            let dm = self.motionManager.deviceMotion
            attitude = dm?.attitude
            referenceAttitude = attitude!
            attitude?.multiply(byInverseOf: referenceAttitude)
        }
        
        self.rotX = Float(attitude?.roll ?? 0) // horizontal rotate
        self.rotY = Float(attitude?.pitch ?? 0) // vertical rotate
        self.rotZ = Float(attitude?.yaw ?? 0)

        // use to check sensor change
        /*if !(lastRotX < rotX + 0.1 && lastRotX > rotX - 0.1) ||
            !(lastRotY < rotY + 0.1 && lastRotY > rotY - 0.1) ||
            !(lastRotZ < rotZ + 0.1 && lastRotZ > rotZ - 0.1) {
            
            print("roll : \(self.rotX) \(self.rotY) \(self.rotZ)")
            lastRotX = rotX
            lastRotY = rotY
            lastRotZ = rotZ
        }*/
        /*print("roll : \(self.rotX)")
        print("pitch : \(self.rotY)")
        print("yaw : \(self.rotZ)")*/
        return
    }
    
    func handleInteraction(at point: CGPoint) {
        guard let transfromProjectMatrix = self._projectionMatrix else { return }
        
        //let viewport = mtkView.bounds // Assume viewport matches window; if not, apply additional inverse viewport xform
        //let aspect = Float(appDelegate.windowWidth()/appDelegate.windowHeight())
        // Create world space
        //let width = Float(appDelegate.windowWidth())
        //let height = Float(appDelegate.windowHeight())
        
        //let projectionMatrix = matrix_float4x4(projectionFov: radians(fromDegrees: 60),aspect: aspect,nearZ:0.1, farZ:100)
        let inverseProjectionMatrix = projectionMatrix.inverse

        let viewMatrix = transfromProjectMatrix.inverse
        let inverseViewMatrix = viewMatrix.inverse

        let clipX = (2 * Float(point.x)) / width - 1
        let clipY = 1 - (2 * Float(point.y)) / height
        let clipCoords = SIMD4<Float>(clipX, clipY, 0, 1) // Assume clip space is hemicube, -Z is into the screen

        var eyeRayDir = inverseProjectionMatrix * clipCoords
        eyeRayDir.z = -1
        eyeRayDir.w = 0
        
        let resultRayDir = (inverseViewMatrix * eyeRayDir)
        var worldRayDir = SIMD3<Float>(resultRayDir.x, resultRayDir.y, resultRayDir.z)
        worldRayDir = normalize(worldRayDir)

        let eyeRayOrigin = SIMD4<Float>(x: 0, y: 0, z: 0, w: 1)
        let worldRayOrigin = SIMD3<Float>((inverseViewMatrix * eyeRayOrigin).x, (inverseViewMatrix * eyeRayOrigin).y, (inverseViewMatrix * eyeRayOrigin).z)

        let ray = Ray(origin: worldRayOrigin, direction: worldRayDir)
        if let hit = hitTest(ray) {
            //hit.node.material.highlighted = !hit.node.material.highlighted // In Swift 4.2, this could be written with toggle()
            print("Hit \(hit.node) at \(hit.intersectionPoint)")
        }
    }
}
