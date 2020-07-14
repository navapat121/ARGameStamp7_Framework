//
//  CMDeviceMotionExt.swift
//  SimpleScene
//
//  Created by Sruit Angkavanitsuk on 24/5/20.
//  Copyright © 2020 Paige Sun. All rights reserved.
//

import CoreMotion
import SceneKit

extension CMDeviceMotion {

    /*
    func gaze(atOrientation orientation: UIInterfaceOrientation?) -> SCNVector4 {

        let attitude = self.attitude.quaternion
        let aq = GLKQuaternionMake(Float(attitude.x), Float(attitude.y), Float(attitude.z), Float(attitude.w))

        let scnVect4: SCNVector4!

        switch orientation {

        case .landscapeRight:

            let cq = GLKQuaternionMakeWithAngleAndAxis(Float(Float.pi/2), 0, 1, 0)
            let q = GLKQuaternionMultiply(cq, aq)

            scnVect4 = SCNVector4(x: -q.y, y: q.x, z: q.z, w: q.w)

        case .landscapeLeft:

            let cq = GLKQuaternionMakeWithAngleAndAxis(Float(-Float.pi), 0, 1, 0)
            let q = GLKQuaternionMultiply(cq, aq)

            scnVect4 = SCNVector4(x: q.y, y: -q.x, z: q.z, w: q.w)

        case .portraitUpsideDown:

            let cq = GLKQuaternionMakeWithAngleAndAxis(Float(Float.pi), 1, 0, 0)
            let q = GLKQuaternionMultiply(cq, aq)

            scnVect4 = SCNVector4(x: -q.x, y: -q.y, z: q.z, w: q.w)

        case .unknown:

            fallthrough

        case .portrait:

            let cq = GLKQuaternionMakeWithAngleAndAxis(Float(-Float.pi), 1, 0, 0)
            let q = GLKQuaternionMultiply(cq, aq)

            scnVect4 = SCNVector4(x: q.x, y: q.y, z: q.z, w: q.w)

        default:
            print("Default")
            scnVect4 = SCNVector4(x: 0, y: 0, z: 0, w: 0)
        }

        return scnVect4
    }
 */
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}



extension SCNNode {
    func cleanup() {
        for child in childNodes {
            child.cleanup()
        }
        geometry = nil
    }
}
