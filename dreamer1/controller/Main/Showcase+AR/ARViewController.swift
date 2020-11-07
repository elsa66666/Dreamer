//
//  ARViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/7/10.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import ARKit
class ARViewController: UIViewController, ARSCNViewDelegate{

    //MARK: -outlets
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    //MARK: -properties
    var focusSquare: FocusSquare?
    var screenCenter: CGPoint!
    var modelsInTheScene: Array<SCNNode> = []
    var trackingStatus: String = "" //提示信息
    var whichGhost: Int?
    
    override func viewDidLoad() {
        sceneView.delegate = self
        statusLabel.text = "Greetings! :]"
        initSceneView()
        initScene()
        initARSession()
        }

 // MARK: - Initialization
      func initSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        screenCenter = view.center
      }

      func initScene() {
        let scene = SCNScene()
        scene.isPaused = false
        sceneView.scene = scene
      }

      func initARSession() { //ARSession: an instance to track motion, run the session to start tracking

        let config = ARImageTrackingConfiguration()
        switch whichGhost {
        case 1:
            if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR1", bundle: Bundle.main){
                config.trackingImages = trackedImages
                config.maximumNumberOfTrackedImages = 1//同时只追踪一张图
            }
        case 2:
            if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR2", bundle: Bundle.main){
                config.trackingImages = trackedImages
                config.maximumNumberOfTrackedImages = 1//同时只追踪一张图
            }
        case 3:
            if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR3", bundle: Bundle.main){
                config.trackingImages = trackedImages
                config.maximumNumberOfTrackedImages = 1//同时只追踪一张图
            }
        case 4:
            if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR4", bundle: Bundle.main){
                config.trackingImages = trackedImages
                config.maximumNumberOfTrackedImages = 1//同时只追踪一张图
            }
        case 5:
            if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR5", bundle: Bundle.main){
                config.trackingImages = trackedImages
                config.maximumNumberOfTrackedImages = 1//同时只追踪一张图
            }
        default:
            if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR6", bundle: Bundle.main){
                config.trackingImages = trackedImages
                config.maximumNumberOfTrackedImages = 1//同时只追踪一张图
            }
        }
        config.providesAudioData = false
        sceneView.session.run(config)
      }
    
// MARK: -control
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        DispatchQueue.main.async {
            self.statusLabel.text = "Image found!"
        }
        if let imageAnchor = anchor as? ARImageAnchor {

            var videoNode:SKVideoNode = SKVideoNode(fileNamed: "幽灵1.mp4")
            switch whichGhost {
            case 1:
                videoNode = SKVideoNode(fileNamed: "幽灵1.mp4")
            case 2:
                videoNode = SKVideoNode(fileNamed: "幽灵2.mp4")
            case 3:
                videoNode = SKVideoNode(fileNamed: "幽灵3.mp4")
            case 4:
                videoNode = SKVideoNode(fileNamed: "幽灵4.mp4")
            case 5:
                videoNode = SKVideoNode(fileNamed: "幽灵5.mp4")
            default:
                videoNode = SKVideoNode(fileNamed: "幽灵6.mp4")
            }
            videoNode.play()
            print("video playing...")
            //注意，视频修改后要随之修改参数
            let videoScene = SKScene(size: CGSize(width: 545, height: 567))
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            videoNode.yScale = -1.0
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
        }
        return node
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let viewCenter = CGPoint(x: size.width / 2, y: size.height / 2)
        screenCenter = viewCenter
    }

}

