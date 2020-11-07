//
//  MainNavigationController.swift
//  dreamer1
//
//  Created by Elsa on 2020/5/15.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    @IBOutlet weak var navBar: UINavigationBar!
    var style = ""
    func getUserStyle() {
        //查询数据库"userLogin"的最后一行，即刚刚登录时存入的数据
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() { return }
        let queryresult = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin")
        if queryresult != nil{
            for row in queryresult! {
                if row["num"]! as! Int == queryresult!.count {
                    style = row["style"]! as! String
                }
            }
        }
        if style == "pink"{
            navBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            navBar.barTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        }else{
            navBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserStyle()
    }
}
