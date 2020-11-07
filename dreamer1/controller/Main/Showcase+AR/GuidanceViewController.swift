//
//  GuidanceViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/8/7.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class GuidanceViewController: UIViewController {
    var img:UIImage = UIImage(named: toARGuidance.ARGuidanceName) ?? UIImage(named: "幽灵不屑")!
    var whichG:Int = toARGuidance.ARGuidanceNo
    @IBOutlet weak var guidanceImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guidanceImage.image = img
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ARViewController
        if segue.identifier == "toAR" {
            destination.whichGhost = whichG
        }
    }
    
    @IBAction func toHome(_ sender: UIBarButtonItem) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
}
