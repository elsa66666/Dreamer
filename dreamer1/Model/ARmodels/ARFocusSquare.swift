//
//  ARFocusSquare.swift
//  dreamer1
//
//  Created by Elsa on 2020/7/12.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import SceneKit

class FocusSquare: SCNNode {
    
    var isClosed: Bool = true{
        didSet{
            geometry?.firstMaterial?.diffuse.contents = self.isClosed ? UIImage(named: "focus") : UIImage(named: "denied")
        }
    }
    
    override init() {
        super.init()
        
        let plane = SCNPlane(width: 0.4, height: 0.4)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "add")
        plane.firstMaterial?.isDoubleSided = true
        
        geometry = plane
        eulerAngles.x = GLKMathDegreesToRadians(-90)
    }
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    func setHidden(to hidden: Bool) {
        var fadeTo: SCNAction
        if hidden {
            fadeTo = .fadeOut(duration: 0.5)
        }else{
            fadeTo = .fadeIn(duration: 0.5)
        }
        
        let actions = [fadeTo, .run({ (focusSquare: SCNNode) in
            focusSquare.isHidden = hidden
        })]
        runAction(.sequence(actions))
    }
}
