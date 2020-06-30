//
//  Texturable.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 22/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import MetalKit
protocol Texturable {
    var texture: MTLTexture? {get set}
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture? = nil
        
        let textureLoaderOption: [String: NSObject]
        if #available(iOS 10.0, *){
            let origin = MTKTextureLoader.Origin.bottomLeft
            //textureLoaderOption = [MTKTextureLoader.Option : origin]
            //textureLoaderOption = [:]
        } else {
            textureLoaderOption = [:]
        }
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil){
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: [MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.bottomLeft as NSObject])
                
            } catch {
                print("texture not created")
            }
        }
        return texture
    }
}
