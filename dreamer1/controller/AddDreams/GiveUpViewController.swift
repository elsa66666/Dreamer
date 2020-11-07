//
//  GiveUpViewController.swift
//  dreamer1
//
//  Created by 陈宥伊 on 2020/5/30.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class GiveUpViewController: UIViewController {

    var timer = Timer()
    @IBOutlet weak var favorNumber: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet var backColoe: UIView!
    var internalTime = 0.1
    override func viewDidLoad() {
        super.viewDidLoad()
        favorNumber.text! = "\(Diary.favor)"
        timer = Timer.scheduledTimer(timeInterval: internalTime, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTimer() {
        if favorNumber.text! != "0" {
            favorNumber.text! = "\(Int(favorNumber.text!)! - 1)"
        }
        else{
            timer.invalidate()
            Test.deleteDB(name: Diary.DghostName)
            Diary.deleteDB(name: Diary.DghostName)
            Test.Rearrangement()
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
            UIApplication.shared.windows[0].rootViewController = VCMain
        }
    }
    
    @IBAction func giveUpDelete(_ sender: Any) {
        timer.invalidate()
        Test.GiveUpDelete(favor: Int(favorNumber.text!)!, name: Diary.DghostName)
        let alert = UIAlertController(title: "\(Diary.DghostName)", message: "万幸，差点就失去你了", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
            UIApplication.shared.windows[0].rootViewController = VCMain
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
