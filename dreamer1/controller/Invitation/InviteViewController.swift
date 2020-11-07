//
//  InviteViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/5/14.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    @IBOutlet weak var inviteCodeLabel: UILabel!
    
    @IBOutlet var fullBackground: UIView!
    
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var inviteBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteCodeLabel.text = String.arbitrary()
        let p = UIAlertController(title: "邀请码说明", message: "对方输入邀请码后，可以看到你的幽灵和日记。(点击即可复制)", preferredStyle: .alert)
        p.addAction(UIAlertAction(title: "确定", style: .default, handler: {(act: UIAlertAction) in inviteCode.insertDB(code: self.inviteCodeLabel.text!)
            inviteCode.getDB()
        }))
        present (p,animated: false,completion: nil)
        let style = Test.getUserStyle()
        if style == "pink" {
             fullBackground.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             inviteBack.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         }else{
             fullBackground.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            inviteBack.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
         }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onCopyButtonPressed(_ sender: UIButton) {
        let pastboard = UIPasteboard.general
        pastboard.string = inviteCodeLabel.text
    }
}
