//
//  DriftBottleEntranceViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/10.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class DriftBottleEntranceViewController: UIViewController {
    
    @IBAction func receiveLetter(_ sender: UIButton) {
       performSegue(withIdentifier: "toReceiveLetter", sender: self)
    }
    
    @IBAction func sendLetter(_ sender: UIButton) {
        //toSendLetter
        performSegue(withIdentifier: "toSendLetter", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
