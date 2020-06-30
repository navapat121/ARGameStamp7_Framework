//
//  Type.swift
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 21/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

import simd

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
    var texture: SIMD2<Float>
}

struct ModelConstants {
  var modelViewMatrix = matrix_identity_float4x4
}

struct SceneConstants {
  var projectionMatrix = matrix_identity_float4x4
}

struct Ray {
    var origin: SIMD3<Float>
    var direction: SIMD3<Float>
    
    static func *(transform: float4x4, ray: Ray) -> Ray {
        let resultOri = (transform * SIMD4<Float>(ray.origin, 1))
        let originT = SIMD3<Float>(resultOri.x, resultOri.y, resultOri.z)
        let resultDir = (transform * SIMD4<Float>(ray.direction, 0))
        let directionT = SIMD3<Float>(resultDir.x, resultDir.y,resultDir.x)
        return Ray(origin: originT, direction: directionT)
    }
    
    /// Determine the point along this ray at the given parameter
    func extrapolate(_ parameter: Float) -> SIMD4<Float> {
        return SIMD4<Float>(origin + parameter * direction, 1)
    }
    
    /// Determine the parameter corresponding to the point,
    /// assuming it lies on this ray
    func interpolate(_ point: SIMD4<Float>) -> Float {
        return length(SIMD3<Float>(point.x , point.y, point.z) - origin) / length(direction)
    }
}

struct HitResult {
    var node: Node
    var ray: Ray
    var parameter: Float
    
    var intersectionPoint: float4 {
        return float4(ray.origin + parameter * ray.direction, 1)
    }
    
    static func < (_ lhs: HitResult, _ rhs: HitResult) -> Bool {
        return lhs.parameter < rhs.parameter
    }
}

struct BoundingSphere {
    var center: SIMD3<Float>
    var radius: Float
    
    // https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-sphere-intersection
    func intersect(_ ray: Ray) -> SIMD4<Float>? {
        var t0, t1: Float
        let radius2 = radius * radius
        if (radius2 == 0) { return nil }
        let L = center - ray.origin
        let tca = simd_dot(L, ray.direction)
        
        let d2 = simd_dot(L, L) - tca * tca
        if (d2 > radius2) { return nil }
        let thc = sqrt(radius2 - d2)
        t0 = tca - thc
        t1 = tca + thc
        
        if (t0 > t1) { swap(&t0, &t1) }
        
        if t0 < 0 {
            t0 = t1
            if t0 < 0 { return nil }
        }
        
        return SIMD4<Float>(ray.origin + ray.direction * t0, 1)
    }
}

/*struct CGPoint {
    var x: Float
    var y: Float
}

struct CGSize {
    var width: Float
    var height: Float
}

struct CGRect {
    var origin: CGPoint
    var size: CGSize
}*/

struct ApiResponseCore: Codable {
    let code: Int
    let msg: String
    let data: String
}

