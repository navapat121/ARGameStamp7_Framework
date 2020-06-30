//
//  Node.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 1/5/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import MetalKit
import simd
import SceneKit

class Node {
    var name = "Untitled"
    var children: [Node] = []
    
    var position = SIMD3<Float>(repeating: 0) // init position of Object
    
    // Moving Algorithm variable
    var moveType = Int(0)
    var current_pos = SIMD3<Float>(repeating: 0) // current position of Object
    var reverse = Float(1) // moving forward or backward
    var move_direction = SIMD3<Float>(Float.random(in: 0.0 ..< 1.0), Float.random(in: 0.0 ..< 1.0), Float.random(in: 0.0 ..< 1.0))
    var init_section = SIMD3<Float>(repeating: 0)
    var is_slow = false
    var countTime = Int()
    
    var rotation = SIMD3<Float>(repeating: 0) // use to rotation objact
    var translation = SIMD3<Float>(repeating: 0) // use to translate objact
    var scale = SIMD3<Float>(repeating: 1) // use to change scale objact
    
    var hp = 10
    var hitCount : Int = 0
    var width: Float = 1.0
    var height: Float = 1.0
    var stampType: Int = 0 // Normal Stamp or Spacial Stamp
    
    var _modelMatrix: matrix_float4x4?
    var _projectionMatrix: matrix_float4x4?
    var boundingSphere = BoundingSphere(center: SIMD3<Float>(x: 0, y: 0, z: 0), radius: 0)
    
    var modelMatrix: matrix_float4x4{
        var matrix = matrix_float4x4(translationX: position.x, y: position.y, z: position.z)
        current_pos = position
        init_section.x = position.x < 0 ? -1 : 1
        init_section.y = position.y < 0 ? -1 : 1
        init_section.z = position.z < 0 ? -1 : 1
        matrix = matrix.rotatedBy(rotationAngle: rotation.x,x: 1, y: 0, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.y,x: 0, y: 1, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.z,x: 0, y: 0, z: 1)
        matrix = matrix.translatedBy(x: translation.x, y: translation.y, z: translation.z)
        current_pos.x += translation.x
        current_pos.y += translation.y
        current_pos.z += translation.z
        matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
        return matrix
    }
    
    func add(childNode: Node){
        children.append(childNode)
    }
    
    func  remove(at: Int){
        children.remove(at: at)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4, frameTime: Float){
        //let modelViewMatrix = matrix_multiply(parentModelViewMatrix,modelMatrix)
        self._modelMatrix = modelMatrix
        self._projectionMatrix = parentModelViewMatrix
        
        for child in children {
          child.render(commandEncoder: commandEncoder,
                       parentModelViewMatrix: modelMatrix, frameTime:frameTime)
        }
        
        if let renderable = self as? Renderable {
          commandEncoder.pushDebugGroup(name)
          renderable.doRender(commandEncoder: commandEncoder,
                              modelViewMatrix: modelMatrix, frameTime:frameTime)
          commandEncoder.popDebugGroup()
        }
    }
    
    func boundingBox() -> CGRect{
        if(self._modelMatrix == nil){
            return CGRect(x: CGFloat(0),
                y: CGFloat(0),
                width: CGFloat(0),
                height: CGFloat(0))
        }
        let modelViewMatrix = matrix_multiply(self._projectionMatrix!, self._modelMatrix!)
        var lowerLeft = SIMD4<Float>(-1/2,-1/2,0,1)
        lowerLeft = matrix_multiply(modelViewMatrix,lowerLeft)
        var upperRight = SIMD4<Float>(1/2,1/2,0,1)
        upperRight = matrix_multiply(modelViewMatrix,upperRight)
        
        let boundingBox = CGRect(x: CGFloat(lowerLeft.x),
                                y: CGFloat(lowerLeft.y),
                                width: CGFloat(upperRight.x - lowerLeft.x),
                                height: CGFloat(upperRight.y - lowerLeft.y))
        return boundingBox
    }
    
    
    
    func hitTest(_ ray: Ray) -> HitResult? {
        guard let transfromProjectMatrix = self._projectionMatrix else { return nil }
        let modelToWorld = transfromProjectMatrix
        let localRay = modelToWorld.inverse * ray
        
        var nearest: HitResult?
        /*if let modelPoint = boundingSphere.intersect(localRay) {
            let worldPoint = modelToWorld * modelPoint
            let worldParameter = ray.interpolate(worldPoint)
            nearest = HitResult(node: self, ray: ray, parameter: worldParameter)
        }
        
        var nearestChildHit: HitResult?
        for child in children {
            if let childHit = child.hitTest(ray) {
                if let nearestActualChildHit = nearestChildHit {
                    if childHit < nearestActualChildHit {
                        nearestChildHit = childHit
                    }
                } else {
                    nearestChildHit = childHit
                }
            }
        }
        
        if let nearestActualChildHit = nearestChildHit {
            if let nearestActual = nearest {
                if nearestActualChildHit < nearestActual {
                    return nearestActualChildHit
                }
            } else {
                return nearestActualChildHit
            }
        }*/
        
        return nearest
    }
}
