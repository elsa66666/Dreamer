//
//  WelcomeViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/8/3.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //OssClient.initClient()
        //let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
       // .userDomainMask, true)[0] as String
        //let filePath = "/Users/chenyouyi/Desktop/zhenjing.jpg"
        
        //client.putObject(image: UIImage(named: "dreamerIcon")!)
        //OssClient.uploadPic(url: URL.init(fileURLWithPath: filePath))
        
        welcomeLabel.text = "DREAMER"
        // Do any additional setup after loading the view.
        //let client = OssClient()
        
    }
    
}
