//
//  StampNode.swift
//  AR_STAMP7_iOS
//
//  Created by BWS MacMini 1 on 31/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import SceneKit

class Stamp : SCNNode {
    let frameworkBundle = Bundle(identifier: "com.AR-Game-Stamp.framwork")
    var id: String!
    var stampName: String!
    var hitCount: Int!
    var hp: Int!
    var stampChildNode: SCNNode!
    var is_catch: Bool!
    var active: Bool!
    var matName: String!
    var stamp_type: Int!
    var stampImg: UIImage!
    var imgUrl: String!
    var level: Int!
    // stamp_type Description
    // 1 = Bomb stamp reduce timer
    // 2 = Hourglass stamp up time
    // 3 = Net stamp power up hit count
    
    var moveType: Int!
    var special_stamp: Int!
    init(scene: SCNScene,position: SCNVector3, stampName: String, stamp_type:Int,hp:Int,level:Int, id: String, index: Int,stampImage:UIImage?, special_stamp: Int, imgUrl:String?) {
        super.init()
        let stamp = nodeFromResource(assetName: "Stamp/Stamp_Only", extensionName: "dae")
        var matName = ""
        let randStamp = Int.random(in: 1 ... 4)
        switch stamp_type {
            case 0: matName = "A\(randStamp)"
            case 1: matName = "Item1"
            case 2: matName = "Item2"
            case 3: matName = "Item3"
            default: matName = "A1"
        }
        if(special_stamp != 0){
            matName = "R\(randStamp)"
        }
        self.id = id
        self.stampName = stampName
        self.hitCount = 0
        //self.hp = 10
        self.hp =  hp
        self.position = position
        self.is_catch = false
        self.active = true
        self.stampChildNode = stamp
        self.stamp_type = stamp_type
        self.moveType = 1
        self.matName = matName
        self.stampImg = stampImage
        self.imgUrl = imgUrl
        self.special_stamp = special_stamp
        self.level = level
        stamp.name = stampName
        stamp.scale = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
        stamp.value(forKey: "index")
        stamp.setValue(index, forKey: "index")
        stamp.value(forKey: "id")
        stamp.setValue(id, forKey: "id")
        /*stamp.value(forKey: "Hp")
        stamp.setValue(10, forKey: "Hp")
        stamp.value(forKey: "hitCount")
        stamp.setValue(0, forKey: "hitCount")
        stamp.value(forKey: "stamp_type")
        stamp.setValue(0, forKey: "stamp_type")
        stamp.value(forKey: "moveType")
        stamp.setValue(2, forKey: "moveType")*/
        
        var action: SCNAction!
        var actions = [SCNAction] ()
        let nums = [1,-1]
        let rand_x = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
        let rand_y = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
        let rand_z = Int.random(in: 50 ..< 70) * nums[Int.random(in: 0 ... 1)]
        let ramdPos = SCNVector3(x: Float(rand_x), y: Float(rand_y), z: Float(rand_z))
        let action1 = SCNAction.move(to: ramdPos, duration: 8)
        actions.append(action1)
        action = SCNAction.sequence(actions)
        //stamp.runAction(action)
        
        let spin = CABasicAnimation(keyPath: "rotation")
        // Use from-to to explicitly make a full rotation around z
         spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
         spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(CGFloat(2 * M_PI))))
         spin.duration = CFTimeInterval(abs(14 - self.level)) // default is 6
         spin.repeatCount = .infinity
         stamp.addAnimation(spin, forKey: "spin around")
        
        let matIndex = stamp.buildMaterialIndex()
        
        // use meterial name to call SCNMeterial
        //let getMeterial = matIndex["material_1"]
        let getMeterial = matIndex["material"]
        
        // change Texture in diffuse content
        if(self.stampImg != nil){
            getMeterial?.diffuse.contents = self.stampImg
        } else {
            // Default Image
            self.stampImg = UIImage(named: matName, in: frameworkBundle, compatibleWith: nil)
            getMeterial?.diffuse.contents = self.stampImg
        }
        getMeterial?.isDoubleSided = true
        //stamp.geometry?.firstMaterial?.diffuse.contents = imageMaterial
        stamp.position = position
        scene.rootNode.addChildNode(stamp)
        if(special_stamp == 1){
            stamp.isHidden = true
        }
        
        
        //stamp.rotation = SCNVector4Make(0, 1, 0, Float(45 * M_PI / 180.0))
        //cloneStamp(scene: scene, parentNode: stamp)
        //let stamp = nodeFromResource(assetName: "Stamp/Stamp_Only", extensionName: "dae")
        //stamp.position = position
    }
    
    func nodeFromResource(assetName: String, extensionName: String) -> SCNNode {
        let frameworkBundle = Bundle(identifier: "com.AR-Game-Stamp.framwork")
        let url = (frameworkBundle?.url(forResource: "art.scnassets/\(assetName)", withExtension: extensionName)!)!
        let node = SCNReferenceNode(url: url)!
        //print(node.boundingBox)
        node.load()
        return node
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func CreateObject3D(){
    // 1. get obj (scn)
    /*let ship1 = nodeFromResource(assetName: "shipFolder/ship", extensionName: "scn")
     ship1.position = SCNVector3Make(0, 0, -50)
     scene.rootNode.addChildNode(ship1)
     
     let ship2 = nodeFromResource(assetName: "shipFolder/ship", extensionName: "scn")
     ship2.position = SCNVector3Make(5, 30, 0)
     scene.rootNode.addChildNode(ship2)
     
     let ship3 = nodeFromResource(assetName: "shipFolder/ship", extensionName: "scn")
     ship3.position = SCNVector3Make(0, 50, 0)
     scene.rootNode.addChildNode(ship3)*/
    /*
     
     // 2. get obj (dae)
     let stonesTreasureRoot = nodeFromResource(assetName: "stones_and_treasure", extensionName: "dae")
     
     // 2.1. get obj in obj (dae)
     let treeNode = stonesTreasureRoot.childNode(withName: "Tree_Fir", recursively: true)!
     treeNode.position = SCNVector3Make(1, 1, 1)
     scene.rootNode.addChildNode(treeNode)
     
     // 3. get obj (dae)
     let potionsRoot = nodeFromResource(assetName: "potions/vzor", extensionName: "dae")
     
     // 3.1. get obj in obj (dae)
     let potion = potionsRoot.childNode(withName: "small_health_poti_purple", recursively: true)!
     potion.position = SCNVector3Make(1, 1, 1)
     scene.rootNode.addChildNode(potion)
     
     // 3.2. get obj in obj (dae)
     let bluePotion = potionsRoot.childNode(withName: "small_health_poti_blue", recursively: true)!
     bluePotion.position = SCNVector3Make(2, 1, 1)
     scene.rootNode.addChildNode(bluePotion)
     
     // 4. get obj (animate dae)
     let cowboyObj = nodeFromResource(assetName: "cowboy/cowboy", extensionName: "dae")
     cowboyObj.position = SCNVector3Make(0, 0, -10)
     scene.rootNode.addChildNode(cowboyObj)
     */
}

extension SCNNode {
    
    convenience init(named name: String) {
        self.init()
        
        guard let scene = SCNScene(named: name) else {
            return
        }
        
        for childNode in scene.rootNode.childNodes {
            addChildNode(childNode)
        }
    }
}
