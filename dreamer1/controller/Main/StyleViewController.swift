//
//  StyleViewController.swift
//  dreamer1
//
//  Created by 陈宥伊 on 2020/5/30.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
protocol Style {
    func changeStyle()
}
class StyleViewController: UINavigationController,Style {
    func changeStyle() {
        let style = Test.getUserStyle()
        if style == "pink" {
            bartitle.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             bartitle.tintColor = #colorLiteral(red: 0.4941176471, green: 0.3607843137, blue: 0.6156862745, alpha: 1)
         }else{
            bartitle.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            bartitle.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
         }
        print("change")
    }
    

    @IBOutlet weak var bartitle: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let nav = presentedViewController as? UINavigationController
        Test.jumpD = viewControllers.first as? MainViewController
        changeStyle()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
