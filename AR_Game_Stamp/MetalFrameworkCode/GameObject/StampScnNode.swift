//
//  StampScnNode.swift
//  AR_STAMP7_iOS
//
//  Created by BWS MacMini 2 on 29/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import SceneKit

class Stamp : SCNNode{
    let assetName: String = "Stamp/Stamp_Only"
    let extensionName: String = "dae"
    override init() {
        super.init()
        let url = Bundle.main.url(forResource: "art.scnassets/\(assetName)", withExtension: extensionName)!
        let referenceNode = SCNReferenceNode(url: url)!
        SCNTransaction.begin()
        referenceNode.load()
        SCNTransaction.commit()
        // Get all material into Dictionary
        //let matIndex = node.buildMaterialIndex()
        
        // use meterial name to call SCNMeterial
        //let getMeterial = matIndex["material"]
        
        // change Texture in diffuse content
        //getMeterial?.diffuse.contents = UIImage(named: "Test Stamp 2D-2")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

