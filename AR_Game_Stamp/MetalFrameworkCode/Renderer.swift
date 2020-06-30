//
//  Renderer.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 21/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import MetalKit
import simd

/*struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}*/

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue!
    
    var scene: Scene?
    var time: Float = 0
    // Sampler State
    var samplerState: MTLSamplerState?
    var depthStencilState: MTLDepthStencilState?
    
    init(device: MTLDevice){
       self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
        buildSamplarState()
        buildDepthStencilState()
    }
    
    // Make Texture Look smooth and not Look like Pixel
    private func buildSamplarState(){
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
    
    private func buildDepthStencilState() {
      let depthStencilDescriptor = MTLDepthStencilDescriptor()
      depthStencilDescriptor.depthCompareFunction = .less
      depthStencilDescriptor.isDepthWriteEnabled = true
      depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
}

extension Renderer : MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
        let descriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        commandEncoder?.setFragmentSamplerState(samplerState, index: 0)
        //commandEncoder?.setDepthStencilState(depthStencilState)
        scene?.render(commandEncoder: commandEncoder!, deltaTime: Float(deltaTime), frameTime: Float(deltaTime))
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
