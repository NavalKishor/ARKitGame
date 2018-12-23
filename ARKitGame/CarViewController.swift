//
//  CarViewController.swift
//  ARKitGame
//
//  Created by Naval Kishor Jha on 23/12/18.
//  Copyright © 2018 Naval. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreMotion

class CarViewController: UIViewController , ARSCNViewDelegate{

    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var addCarButton: UIButton!
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var carNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupAddButton()
        setupControlButton(frontButton)
        setupControlButton(backButton)
        // Do any additional setup after loading the view.
        frontButton.isHidden = true
        backButton.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runWorldTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goFront(_ sender: UIButton) {
        runActionForCarNode(withDistance: 1)
    }
    
    @IBAction func addCar(_ sender: UIButton) {
        addCarButton.isHidden = true
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32, -transform.m33)
        let location = SCNVector3( transform.m41,transform.m42,transform.m43-5)
//        let currentPositionOfCamera = SCNVector3Make(orientation.x+location.x, orientation.y+location.y, orientation.z+location.z) //we have used extension
        let currentPositionOfCamera=orientation + location
        
        let scene = SCNScene(named: "art.scnassets/audi.scn")
        carNode = (scene?.rootNode.childNode(withName: "audi",recursively:false))!
        carNode.position = currentPositionOfCamera
        self.sceneView.scene.rootNode.addChildNode(carNode)
        backButton.isHidden = false
        frontButton.isHidden = false
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        runActionForCarNode(withDistance: -1)
    }
    
    func createFloor(for planeAnchor: ARPlaneAnchor) -> SCNNode {
    let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.init(white: 0, alpha: 0.1)
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        floorNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        //floorNode.eulerAngles = SCNVector3(90,0,0) here we have used extension
        floorNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        let staticBody = SCNPhysicsBody.static()
        floorNode.physicsBody = staticBody
        return floorNode
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return }
        let floorNode = createFloor(for: planeAnchor)
        node.addChildNode(floorNode)
    }
    func renderer(_ renderer: SCNSceneRenderer,didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        node.enumerateChildNodes{
            (childNode, _) in childNode.removeFromParentNode()
        }
        let floorNode = createFloor(for: planeAnchor)
        node.addChildNode(floorNode)
    }
    
    private func runWorldTracking(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    private func setupScene() {
        sceneView.delegate = self
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        sceneView.scene = scene
    }
    private func setupAddButton() {
        addCarButton.layer.cornerRadius = 5.0
        addCarButton.clipsToBounds = true
    }
    private func setupControlButton(_ button: UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    private func runActionForCarNode(withDistance distance: Float) {
        let action = SCNAction.move(by: SCNVector3Make(0, 0, distance), duration: 1)
        carNode.runAction(action)
    }

    @IBAction func closeToBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
