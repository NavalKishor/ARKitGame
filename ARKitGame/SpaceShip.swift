//
//  SpaceShip.swift
//  ARKitGame
//
//  Created by Naval Kishor Jha on 01/07/18.
//  Copyright © 2018 Naval. All rights reserved.
//

//import UIKit
//step 8 import for the scnnode
import ARKit

class SpaceShip: SCNNode {

    //step 8.1 create func to load the model which mean ship.scn file
    func loadModel()
    {
        // loading the ship model and cross check with guard incase not working simplelly return
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/ship.scn") else {return}
        // wrraper node for the scene
        let wrapperNode = SCNNode()
        // add all the child node from the virtualObjectScene to you SCN node
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        // with this we can load the ship and use that as scnnode in our app
        self.addChildNode(wrapperNode)
        // got to view controller to use it add the func there addObject()
    }
}
