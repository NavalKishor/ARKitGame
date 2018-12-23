//
//  Utilities.swift
//  ARKitGame
//
//  Created by Naval Kishor Jha on 24/12/18.
//  Copyright © 2018 Naval. All rights reserved.
//

import Foundation
import SceneKit

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
