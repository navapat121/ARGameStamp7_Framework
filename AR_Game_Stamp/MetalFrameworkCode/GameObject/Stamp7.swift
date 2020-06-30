//
//  Stamp7.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 1/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import MetalKit
import CoreMotion

class Stamp7: Node {
    //let device: MTLDevice
    //let commandQueue: MTLCommandQueue!

    // main vertex to create Box
    /*var verticles: [Vertex] = [
        Vertex(position: SIMD3<Float>(-1,1,0), // V0 Corner
               color: SIMD4<Float>(1,0,0,1),
               texture: SIMD2<Float>(0,1)),
        Vertex(position: SIMD3<Float>(-1,-1,0), // V1 Corner
               color: SIMD4<Float>(0,1,0,1),
                texture: SIMD2<Float>(0,0)),
        Vertex(position: SIMD3<Float>(-0.75,1,0), // V2
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.125,1)),
        Vertex(position: SIMD3<Float>(-0.75,-1,0), // V3
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.125,0)),
        Vertex(position: SIMD3<Float>(-0.5,1,0), // V4
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.25,1)),
        Vertex(position: SIMD3<Float>(-0.5,-1,0), // V5
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.25,0)),
        Vertex(position: SIMD3<Float>(-0.25,1,0), // V6
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.375,1)),
        Vertex(position: SIMD3<Float>(-0.25,-1,0), // V7
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.375,0)),
        Vertex(position: SIMD3<Float>(0,1,0), // V8
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.5,1)),
        Vertex(position: SIMD3<Float>(0,-1,0), // V9
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.5,0)),
        Vertex(position: SIMD3<Float>(0.25,1,0), // V10
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.625,1)),
        Vertex(position: SIMD3<Float>(0.25,-1,0), // V11
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.625,0)),
        Vertex(position: SIMD3<Float>(0.5,1,0), // V12
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.75,1)),
        Vertex(position: SIMD3<Float>(0.5,-1,0), // V13
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.75,0)),
        Vertex(position: SIMD3<Float>(0.75,1,0), // V14
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.875,1)),
        Vertex(position: SIMD3<Float>(0.75,-1,0), // V15
                color: SIMD4<Float>(1,0,0,1),
                texture: SIMD2<Float>(0.875,0)),
        Vertex(position: SIMD3<Float>(1,1,0), // V16 Corner
               color: SIMD4<Float>(0,0,1,1),
                texture: SIMD2<Float>(1,1)),
        Vertex(position: SIMD3<Float>(1,-1,0), //  V17 Corner
               color: SIMD4<Float>(1,0,1,1),
                texture: SIMD2<Float>(1,0)),
    ]*/
    //var stampHitBox: CGRect = CGRect()
    var vertexList: [Vertex] = []
    
    var indices: [UInt16] = []

    var storeDevice: MTLDevice?
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    // Get Gyroscope Data From CoreMotion
    let motionManager = CMMotionManager()
    var referenceAttitude = CMAttitude()
    
    var rotX: Float = 0
    var rotY: Float = 0
    var rotZ: Float = 0
    
    // Texturable
    var texture: MTLTexture?
    
    // Sampler State
    var samplerState: MTLSamplerState?
    
    struct Constants {
        var animateBy: Float = 0.0
    }
    
    //var constants = Constants()
    var time: Float = 0
    var modelConstants = ModelConstants()
    
    // Renderable
    var pipelineState: MTLRenderPipelineState!
    var fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    
    var vertexDescriptor: MTLVertexDescriptor{
        let vertexDiscriptor = MTLVertexDescriptor()
        vertexDiscriptor.attributes[0].format = .float3
        vertexDiscriptor.attributes[0].offset = 0
        vertexDiscriptor.attributes[0].bufferIndex = 0
        
        vertexDiscriptor.attributes[1].format = .float4
        vertexDiscriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDiscriptor.attributes[1].bufferIndex = 0
        
        vertexDiscriptor.attributes[2].format = .float2
        vertexDiscriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride
        vertexDiscriptor.attributes[2].bufferIndex = 0
        
        vertexDiscriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDiscriptor
    }
    
    var startWave = 0
    
    init(device: MTLDevice){
        super.init()
        self.storeDevice = device
        buildModel(device: device, frameTime:0)
        pipelineState = buildPipelineState(device: device)
    }
    
    init(device: MTLDevice, imageName: String){
        super.init()
        if let texture = setTexture(device: device, imageName: imageName){
            self.texture = texture
            fragmentFunctionName = "texture_fragment"
        }
        self.storeDevice = device
        buildModel(device: device, frameTime:0)
        pipelineState = buildPipelineState(device: device)
    }
    
    private func buildModel(device: MTLDevice, frameTime: Float){
        let numberOfSquare = 16 //** (MUST BE EVEN NUMBER) number of square inside of stamp
        var posX = Float(-1.0)
        var texturePosX = Float(0)
        var j = startWave
        let wavePower = Float(0.5)
        let wave = [
            wavePower/5,
            wavePower/4,
            wavePower/3.5,
            wavePower/3,
            wavePower/2.5,
            wavePower/2,
            wavePower/1.5,
            wavePower/1.4,
            wavePower/1.5,
            wavePower/2,
            wavePower/2.5,
            wavePower/3,
            wavePower/3.5,
            wavePower/4
        ]
        startWave += 1
        if(startWave == wave.count - 1){
            startWave = 0
        }
        // Set Vertex
        vertexList = []
        for i in 0..<(numberOfSquare + 2){
            posX = posX + (i == 0 ? Float(0) : (Float(1)/Float(numberOfSquare/2))) // Calculate position X up to number of square
            texturePosX = texturePosX + (i == 0 ? Float(0) : (Float(1)/Float(numberOfSquare))) // Calculate Texture position X up to number of square

            let z = Float(wave[j])
            vertexList.append(
                Vertex(position: SIMD3<Float>(Float(posX),1,z), // Y
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(Float(texturePosX),1))
            )
            vertexList.append(
                Vertex(position: SIMD3<Float>(Float(posX),-1,z), // -Y
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(Float(texturePosX),0))
            )
            //rint(vertexList)
            if(j == wave.count - 1){
                j = 0
            } else
            {
                j += 1;
            }
        }
        indices = []
        // Set indices
        for i in 0..<(numberOfSquare*2){
            indices.append(UInt16(i+1))
            indices.append(UInt16(i))
            indices.append(UInt16(i+2))
        }
        
        vertexBuffer = device.makeBuffer(bytes: vertexList,
                                 length: vertexList.count * MemoryLayout<Vertex>.stride,
                                 options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                        length: indices.count * MemoryLayout<UInt16>.size,
                        options: [])
    }
}

extension Stamp7: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4, frameTime: Float) {
        guard let indexBuffer = indexBuffer else { return }
        
        /*let updateVerticles = [
            Vertex(position: SIMD3<Float>(-1,1,0 - sin(frameTime*10)/5), // V0 Corner
                   color: SIMD4<Float>(1,0,0,1),
                   texture: SIMD2<Float>(0,1)),
            Vertex(position: SIMD3<Float>(-1,-1,0 - sin(frameTime*10)/5), // V1 Corner
                   color: SIMD4<Float>(0,1,0,1),
                    texture: SIMD2<Float>(0,0)),
            Vertex(position: SIMD3<Float>(-0.75,1,0 + sin(frameTime*10)/5), // V2
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.125,1)),
            Vertex(position: SIMD3<Float>(-0.75,-1,0 + sin(frameTime*10)/5), // V3
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.125,0)),
            Vertex(position: SIMD3<Float>(-0.5,1,0 - sin(frameTime*10)/5), // V4
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.25,1)),
            Vertex(position: SIMD3<Float>(-0.5,-1,0 - sin(frameTime*10)/5), // V5
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.25,0)),
            Vertex(position: SIMD3<Float>(-0.25,1,0 + sin(frameTime*10)/5), // V6
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.375,1)),
            Vertex(position: SIMD3<Float>(-0.25,-1,0 + sin(frameTime*10)/5), // V7
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.375,0)),
            Vertex(position: SIMD3<Float>(0,1,0 - sin(frameTime*10)/5), // V8
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.5,1)),
            Vertex(position: SIMD3<Float>(0,-1,0 - sin(frameTime*10)/5), // V9
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.5,0)),
            Vertex(position: SIMD3<Float>(0.25,1,0 + sin(frameTime*10)/5), // V10
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.625,1)),
            Vertex(position: SIMD3<Float>(0.25,-1,0 + sin(frameTime*10)/5), // V11
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.625,0)),
            Vertex(position: SIMD3<Float>(0.5,1,0 - sin(frameTime*10)/5), // V12
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.75,1)),
            Vertex(position: SIMD3<Float>(0.5,-1,0 - sin(frameTime*10)/5), // V13
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.75,0)),
            Vertex(position: SIMD3<Float>(0.75,1,0 + sin(frameTime*10)/5), // V14
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.875,1)),
            Vertex(position: SIMD3<Float>(0.75,-1,0 + sin(frameTime*10)/5), // V15
                    color: SIMD4<Float>(1,0,0,1),
                    texture: SIMD2<Float>(0.875,0)),
            Vertex(position: SIMD3<Float>(1,1,0 - sin(frameTime*10)/5), // V16 Corner
                   color: SIMD4<Float>(0,0,1,1),
                    texture: SIMD2<Float>(1,1)),
            Vertex(position: SIMD3<Float>(1,-1,0 - sin(frameTime*10)/5), //  V17 Corner
                   color: SIMD4<Float>(1,0,1,1),
                    texture: SIMD2<Float>(1,0)),
        ]*/
        buildModel(device: storeDevice!,frameTime:frameTime)
        
        modelConstants.modelViewMatrix = modelViewMatrix
        commandEncoder.setRenderPipelineState(pipelineState)
        
        commandEncoder.setVertexBytes(&modelConstants,
                                      length: MemoryLayout<ModelConstants>.stride,
                                      index: 1)
        commandEncoder.setVertexBuffer(vertexBuffer,offset: 0, index: 0)
        commandEncoder.setFragmentTexture(texture, index: 0)
        //commandEncoder.setFragmentTexture(maskTexture, at: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}

extension Stamp7: Texturable {}

