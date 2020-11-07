//
//  LetterSendViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/10.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class LetterSendViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var contentText: UITextView!
    
    @IBAction func sendMessage(_ sender: UIBarButtonItem) {
        //存漂流瓶至数据库
        Test.userD.sendDriftMessage(title: titleText.text!, cont: contentText.text)
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
