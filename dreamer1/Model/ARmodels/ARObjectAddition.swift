//
//  ARObjectAddition.swift
//  dreamer1
//
//  Created by Elsa on 2020/7/12.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ARViewController {
    fileprivate func getModel(named name: String) -> SCNNode?{
        let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")
        guard let model = scene?.rootNode.childNode(withName: "SketchUp", recursively: false) else {return nil}
        model.name = name
        return model
    }
    
    @IBAction func addObjectButtonTapped(_ sender: UIButton) {
        print("add button pressed")
        
        guard focusSquare != nil else {return}
        let modelName = "iPhone"
        guard let model = getModel(named: modelName) else{
            print("unable to load \(modelName)")
            return
        }
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        let hitTestResult = hitTest.first
        guard let worldTransform = hitTestResult?.worldTransform else {return}
        let worldTransformColumn3 = worldTransform.columns.3
        model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        sceneView.scene.rootNode.addChildNode(model)
        print("\(modelName) added.")
        
        modelsInTheScene.append(model)
        print(modelsInTheScene.count)
    }
    
}
