//
//  GameScene.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 1/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import MetalKit
import simd
import SpriteKit

class GameScene: Scene {
    var stampArray :[Stamp7] = []
    //var testModel : Model
    //var stamp: Stamp7
    /*var stamp1: Stamp7
     var stamp2: Stamp7
     var stamp3: Stamp7
     var stamp4: Stamp7
     var stamp5: Stamp7*/
    let MTKView = MetalViewController()
    var velocityX = Int.random(in: 50..<200)
    var velocityY = Int.random(in: 50..<200)
    var gameBorder = SIMD3<Float>(5,5,5)
    var touchPoint = CGRect()
    var isTouch = false
    var a = 0
    var time = Float(0)
    
    override init(device: MTLDevice, size: CGSize , label1: UILabel,label2: UILabel,hitCountLabel: UILabel, HPBar: UIImageView,hpProgressBar: UIProgressView) {
        //testModel = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size , label1: label1,label2: label2,hitCountLabel: hitCountLabel, HPBar: HPBar,hpProgressBar: hpProgressBar)
        
        // Create Stamp and special Stamp
        for n in 1...10{
            //if(n <= 5){
            // Normal Stamp
            let number = Int.random(in: 1 ..< 4)
            let stamp = Stamp7(device: device,imageName: "Test Stamp 2D-\(number).png")
            stamp.stampType = 0
            stampArray.append(stamp)
            /*} else {
             // Special Stamp
             let stamp = Stamp7(device: device,imageName: "bombStamp.jpg")
             stamp.stampType = 1
             stampArray.append(stamp)
             }*/
        }
        
        for (index,stamp) in stampArray.enumerated(){
            stamp.scale = SIMD3<Float>(repeating:Float(0.3))
            stamp.moveType = 1
            stamp.position.x = 0
            stamp.position.y = 0
            stamp.position.z = -3
            //stamp.position.x = Float(Int.random(in: Int(-gameBorder.x) ..< Int(gameBorder.x)))
            //stamp.position.y = Float(Int.random(in: Int(-gameBorder.x) ..< Int(gameBorder.x)))
            //stamp.position.z = Float(Int.random(in: Int(-gameBorder.y) ..< Int(gameBorder.y)))
            add(childNode: stamp)
        }
    }
    
    override func update(deltaTime: Float)-> () {
        touchPoint.isEmpty ? (isTouch = false) : (isTouch = true)
        time = deltaTime*2
        // Moving Stamp
        let is_move = true
        if(is_move == true){
            for stamp in stampArray{
                moveAlgorithm(stamp: stamp)
            }
        }
        
        if(isTouch) {
            // check hit
            var intersectResult: [Int] = []
            for (index,stamp) in stampArray.enumerated() {
                //stamp.stampHitBox = stamp.boundingBox()
                if(stamp.boundingBox().intersects(touchPoint))
                {
                    intersectResult.append(index)
                }
            }
            for n in intersectResult{
                //stampArray[n].hitCount += 1
                if(stampArray[n].stampType == 1){
                    stampArray[n].hitCount = 6
                    //SoundController.shared.playBombEffect()
                } else if(stampArray[n].stampType == 0){
                    SoundController.shared.playPopEffect()
                }
                print("=======HIT! stamp \(intersectResult) =======")
                label1.text = "===HIT COUNT \(stampArray[n].hitCount) ! ==="
                label2.text = "===Stamp = \(n) ==="
                hitCountLabel.text = "\(stampArray[n].hitCount)" + "/6"
                hpProgressBar.progress += Float(stampArray[n].hitCount / 10)
                UIupdateHPBar(hp: 10, hitCount: stampArray[n].hitCount)
                if(stampArray[n].hitCount == 6){
                    stampArray.remove(at: n)
                    remove(at: n)
                    print(intersectResult)
                    touchPoint = CGRect()
                    isTouch = false
                    break
                }
            }
            print(intersectResult)
            touchPoint = CGRect()
            isTouch = false
        }
    }
    
    func changeHp(_ imageview: UIImageView) {
        imageview.image  = UIImage(named: "hp3.jpeg")
    }
    
    func UIupdateHPBar(hp:Float, hitCount:Int){
        if(hitCount == 1){
            self.HPBar.image = UIImage(named:"hp5.jpeg")
        } else if(hitCount == 2) {
            self.HPBar.image = UIImage(named:"hp4.jpeg")
        } else if(hitCount == 3) {
            self.HPBar.image = UIImage(named:"hp3.jpeg")
        } else if(hitCount == 4) {
            self.HPBar.image = UIImage(named:"hp2.jpeg")
        } else if(hitCount == 5) {
            self.HPBar.image = UIImage(named:"hp1.jpeg")
        } else if(hitCount == 6) {
            self.HPBar.image = UIImage(named:"hp0.jpeg")
        }
    }
    
    
    
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>,
                               with event: UIEvent?) {
        if let location = touches.first?.location(in: view) {
            //handleInteraction(at: location)
            var screenX = (location.x - view.frame.maxX/2) * 1
            var screenY = (location.y - view.frame.maxY/2) * -1
            
            screenX = screenX/(view.frame.maxX/2)
            screenY = screenY/(view.frame.maxY/2)
            
            let gamePosX = 5 * screenX
            let gamePosY = 5 * screenY
            
            let hitbox = 1.5
            //var hitboxDivide = hitbox/2.0
            touchPoint =  CGRect(x: CGFloat(gamePosX - CGFloat(hitbox/2.0)),
                                 y: CGFloat(gamePosY - CGFloat(hitbox/2.0)),
                                 width: CGFloat(hitbox),
                                 height: CGFloat(hitbox))
        }
    }
    
    func moveAlgorithm(stamp: Stamp7){
        // bounce back if too close to Camera in Random Direction
        if((abs(stamp.current_pos.x) + abs(stamp.current_pos.y) + abs(stamp.current_pos.z)) < 4.0){
            if(abs(stamp.current_pos.x) < abs(stamp.current_pos.y) && abs(stamp.current_pos.x) < abs(stamp.current_pos.z)){
                stamp.move_direction = SIMD3<Float>( 1.0, 0.0, 0.0)
            } else if(abs(stamp.current_pos.y) < abs(stamp.current_pos.x) && abs(stamp.current_pos.y) < abs(stamp.current_pos.z)){
                stamp.move_direction = SIMD3<Float>( 0.0, 1.0, 0.0)
            } else if(abs(stamp.current_pos.z) < abs(stamp.current_pos.x) && abs(stamp.current_pos.z) < abs(stamp.current_pos.y)){
                stamp.move_direction = SIMD3<Float>( 0.0, 0.0, 1.0)
            }
        }
        // bounce back from X Border in Random Direction
        else if(gameBorder.x <= (stamp.current_pos.x) ||
            -gameBorder.x >= (stamp.current_pos.x)){
            let rand_direction = Float.random(in: 0.0 ..< 1.0)
            stamp.reverse = stamp.current_pos.x < 0 ? 1 : -1
            let rand = Int.random(in: 0...1)
            stamp.move_direction = SIMD3<Float>( rand_direction, rand == 1 ? 0.0 : (1.0 - rand_direction), rand == 0 ? 0.0 : (1.0 - rand_direction))
        }
        // bounce back from Y Border in Random Direction
        else if(gameBorder.y <= (stamp.current_pos.y) ||
            -gameBorder.y >= (stamp.current_pos.y)){
            let rand_direction = Float.random(in: 0.0 ..< 1.0)
            stamp.reverse = stamp.current_pos.y < 0 ? 1 : -1
            let rand = Int.random(in: 0...1)
            stamp.move_direction = SIMD3<Float>( rand == 1 ? 0.0 : (1.0 - rand_direction), rand_direction, rand == 0 ? 0.0 : (1.0 - rand_direction))
        }
        // bounce back from Z Border in Random Direction
        else if(gameBorder.z <= (stamp.current_pos.z * stamp.init_section.z) ||
            -gameBorder.z >= (stamp.current_pos.z * stamp.init_section.z)){
            let rand_direction = Float.random(in: 0.0 ..< 1.0)
            stamp.reverse = stamp.current_pos.z < 0 ? 1 : -1
            let rand = Int.random(in: 0...1)
            stamp.move_direction = SIMD3<Float>(rand == 1 ? 0.0 : (1.0 - rand_direction), rand == 0 ? 0.0 : (1.0 - rand_direction), rand_direction)
        }
        /*else if(gameBorder.x <= (stamp.current_pos.x * stamp.init_section.x) ||
         gameBorder.y <= (stamp.current_pos.y * stamp.init_section.y) ||
         gameBorder.z <= (stamp.current_pos.z * stamp.init_section.z))
         {
         stamp.reverse = -1
         // random Diraction of stamp
         let rand_direction = Float.random(in: 0.0 ..< 1.0)
         if(stamp.move_direction.x < stamp.move_direction.y && stamp.move_direction.x < stamp.move_direction.z){
         stamp.move_direction = SIMD3<Float>( rand_direction,  (1.0 - rand_direction)/2,  (1.0 - rand_direction)/2)
         } else if(stamp.move_direction.y < stamp.move_direction.y && stamp.move_direction.x < stamp.move_direction.z){
         stamp.move_direction = SIMD3<Float>( (1.0 - rand_direction)/2,  rand_direction,  (1.0 - rand_direction)/2)
         } else {
         stamp.move_direction = SIMD3<Float>( (1.0 - rand_direction)/2,  (1.0 - rand_direction)/2,  rand_direction)
         }
         stamp.move_direction = SIMD3<Float>( rand_direction,  (1.0 - rand_direction)/2,  (1.0 - rand_direction)/2)
         } else if(-gameBorder.x >= (stamp.current_pos.x * stamp.init_section.x) ||
         -gameBorder.y >= (stamp.current_pos.y * stamp.init_section.y) ||
         -gameBorder.z >= (stamp.current_pos.z * stamp.init_section.z))
         {
         stamp.reverse = 1
         // random Diraction of stamp
         let rand_direction = Float.random(in: 0.0 ..< 1.0)
         if(stamp.move_direction.x < stamp.move_direction.y && stamp.move_direction.x < stamp.move_direction.z){
         stamp.move_direction = SIMD3<Float>( rand_direction,  (1.0 - rand_direction)/2,  (1.0 - rand_direction)/2)
         } else if(stamp.move_direction.y < stamp.move_direction.y && stamp.move_direction.x < stamp.move_direction.z){
         stamp.move_direction = SIMD3<Float>( (1.0 - rand_direction)/2,  rand_direction,  (1.0 - rand_direction)/2)
         } else {
         stamp.move_direction = SIMD3<Float>( (1.0 - rand_direction)/2,  (1.0 - rand_direction)/2,  rand_direction)
         }
         }*/
        
        // Normal move with random direction
        if(stamp.moveType == 1){
            stamp.translation.x += (time * stamp.move_direction.x) * stamp.reverse
            stamp.translation.y += (time * stamp.move_direction.y) * stamp.reverse
            stamp.translation.z += (time * stamp.move_direction.z) * stamp.reverse
            //print("x : \(stamp.current_pos.x)")
            //print("y : \(stamp.current_pos.y)")
            //print("z : \(stamp.current_pos.z)")
        }
        // Move backward in middle of move
        else if(stamp.moveType == 2)
        {
            /*if(stamp.current_pos.x >= -0.1 && stamp.current_pos.x <= 0.1 ){
                stamp.reverse = stamp.reverse * -1
                let rand_direction = Float.random(in: 0.0 ..< 1.0)
                stamp.move_direction = SIMD3<Float>( rand_direction,  (1.0 - rand_direction)/2,  (1.0 - rand_direction)/2)
            }
            stamp.translation.x += (time * stamp.move_direction.x) * stamp.reverse * stamp.init_section.x
            stamp.translation.y += (time * stamp.move_direction.y) * stamp.reverse * stamp.init_section.y
            stamp.translation.z += (time * stamp.move_direction.z) * stamp.reverse * stamp.init_section.z*/
        }
        // Move slowly time to time
        else if(stamp.moveType == 3)
        {
            if(!stamp.is_slow){
                stamp.countTime += 1
                if(stamp.countTime == 90){
                    stamp.is_slow = true
                    stamp.countTime = 0
                }
            } else if(stamp.countTime < 30){
                stamp.countTime += 1
            } else if(stamp.countTime >= 30){
                stamp.is_slow = false
                stamp.countTime = 0
            }
            
            stamp.translation.x += ((time*2/(stamp.is_slow ? 5 : 1)) * stamp.move_direction.x) * stamp.reverse
            stamp.translation.y += ((time*2/(stamp.is_slow ? 5 : 1)) * stamp.move_direction.y) * stamp.reverse
            stamp.translation.z += ((time*2/(stamp.is_slow ? 5 : 1)) * stamp.move_direction.z) * stamp.reverse
        }
        else if(stamp.moveType == 4){
            stamp.rotation.x += time
        }
    }
}
