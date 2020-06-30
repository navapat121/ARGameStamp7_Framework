//
//  Renderable.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 1/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import MetalKit

protocol Renderable {
    var pipelineState: MTLRenderPipelineState! { get set }
    var vertexFunctionName: String {get}
    var fragmentFunctionName: String {get}
    var vertexDescriptor: MTLVertexDescriptor {get}
    
    var modelConstants: ModelConstants {get set}
    
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4, frameTime:Float)
}

extension Renderable {
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: fragmentFunctionName)
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        let pipelineState: MTLRenderPipelineState
        do {
          pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
          fatalError("error: \(error.localizedDescription)")
        }
        return pipelineState
    }
}
