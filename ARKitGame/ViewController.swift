//
//  ViewController.swift
//  ARKitGame
//
//  Created by Naval Kishor Jha on 01/07/18.
//  Copyright © 2018 Naval. All rights reserved.
//

import UIKit
// step2 import arkit
import ARKit

class ViewController: UIViewController {

    // Step 1 create Ui and drag drop from ui
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var counterLabel: UILabel!
    var counter = 0 {
        didSet{
            counterLabel.text = "\(counter)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // step 3 create object of SCNScence and set a refernce to our view
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
       // counterLabel.isUserInteractionEnabled = true
        counterLabel.addGestureRecognizer(tap)
        
        let scene = SCNScene()
        sceneView.scene = scene
    }
    //step 4 override the viewWillapper func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //step 5 create or handle the device configuration after this take permission in info.plist for the Privacy -Camera and reason as AR in string
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        //Step 6 copy the art.scnassets with the ship.scn and texture.png file into your project also you have learn how create
        //step 7 create a spaceship cocoatouch class which extend scnnode go theres
        
        //step 10 call the addObject() here so in our camera ship will appear
        addObject()
        
        
    }
    // step 11 give motion to the ship so implement the touch func
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the touch object to get the position of it
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            // generate the hit list  by sceneviw to  perform a hit test  with specific point
            let hitList = sceneView.hitTest(location, options: nil)
            // now to check wheather we hit out object or not
            if let hitObject = hitList.first{
                let node = hitObject.node
                if node.name == "ARShip" {
                    // on hit of our ship object just remove it so it will disapper
                    counter += 1
                    node.removeFromParentNode()
                    // add it again to it will appear at different place
                    addObject()
                }
            }
        }
    }
    // step 9 to call the load of model and use it to postion the ship randomly
    func addObject()
    {
        let ship = SpaceShip()
        ship.loadModel()
        // file two position of real world x and y
        let xPos = randomPostion(lowerBound: -1.5, upperBound: 1.5)
        let yPos = randomPostion(lowerBound: -1.5, upperBound: 1.5)
        //-1 mean as z cord and its 1 miter away from camera
        ship.position = SCNVector3(xPos,yPos,-1)
        sceneView.scene.rootNode.addChildNode(ship)

    }
    
    // this func will return number which will also place our ship in real world
    func randomPostion(lowerBound lower:Float,upperBound upper:Float) ->Float
    {
        // no b/w 1 and 2 to the power of 32
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        performSegue(withIdentifier: "toCarSegue", sender: self)
        print("tap working after segue done")
        
    }


}

