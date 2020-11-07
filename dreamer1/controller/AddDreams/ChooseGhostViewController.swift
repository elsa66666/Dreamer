//
//  ChooseGhostViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/5/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class ChooseGhostViewController: UIViewController {

    @IBOutlet var bgp: UIView!
    @IBOutlet weak var fullStack: UIStackView!
    @IBOutlet weak var pleaseChooseGhostLabel: UILabel!
    @IBOutlet weak var Image11: UIImageView!
    @IBOutlet weak var Image12: UIImageView!
    @IBOutlet weak var Image21: UIImageView!
    @IBOutlet weak var Image22: UIImageView!
    @IBOutlet weak var Image31: UIImageView!
    @IBOutlet weak var Image32: UIImageView!
    var ghostName: String?
    var style: String?
    var ghostStyle: String = ""
    var tagText: String = ""
    var IsPublic: Int = 0
    
    func getLabelColor(){
        if style == "pink"{
            pleaseChooseGhostLabel.textColor = #colorLiteral(red: 0.4941176471, green: 0.3607843137, blue: 0.6156862745, alpha: 1)
            bgp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            pleaseChooseGhostLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            bgp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        if ghostStyle == ""{
            let alertController = UIAlertController(title: "提示", message: "请选择样式", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
        }else{
            let userName = Test.userD.LoginUserName()
            //let userId = Test.LoginUserId()
            
            let alertController = UIAlertController(title: "提示", message: "成功生成dream!", preferredStyle: .actionSheet)
            let alertAction1 = UIAlertAction(title: "确定", style: .default, handler: {(act: UIAlertAction) in
                let mainboard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
                let Vcmain = mainboard!.instantiateViewController(identifier: "vcMain")
                
                UIApplication.shared.windows[0].rootViewController = Vcmain
                //let ranTest = Int(arc4random_uniform(100))
                    
                Test.userD.AddNewDream(name: userName, ghostName: self.ghostName!, favorablity: 0, ghostStyle: self.ghostStyle, tag: self.tagText, ispublic: self.IsPublic)
            })
            let alertAction2 = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            alertController.addAction(alertAction1)
            alertController.addAction(alertAction2)
            present(alertController, animated: true, completion: nil)
            
            //Test.getDB()
            
            
        }
        
        
    }
    
    @IBAction func Clicked(_ sender: UIButton) {
        if style == "pink"{
            switch(sender.tag){
            case 11:
                if Image11.backgroundColor == #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1) {
                    Image11.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1)
                    Image11.layer.cornerRadius = 10
                    Image12.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image21.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image31.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image32.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = "幽灵不屑"
                }
                break
            case 12:
                if Image12.backgroundColor == #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1) {
                    Image12.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1)
                    Image12.layer.cornerRadius = 10
                    Image21.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image31.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image32.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = "幽灵吐舌头"
                }
                break
            case 21:
                if Image21.backgroundColor == #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1) {
                    Image21.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image21.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1)
                    Image21.layer.cornerRadius = 10
                    Image22.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image31.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image32.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = "幽灵高兴"
                }
                break
            case 22:
                if Image22.backgroundColor == #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1) {
                    Image22.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image21.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1)
                    Image22.layer.cornerRadius = 10
                    Image31.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image32.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = "幽灵炫酷左"
                }
                break
            case 31:
                if Image31.backgroundColor == #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1) {
                    Image31.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image21.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image31.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1)
                    Image31.layer.cornerRadius = 10
                    Image32.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = "幽灵期待"
                }
                break
            default:
                if Image32.backgroundColor == #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1) {
                    Image32.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image21.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image31.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image32.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9333333333, blue: 0.9607843137, alpha: 1)
                    Image32.layer.cornerRadius = 10
                    ghostStyle = "幽灵抱歉"
                }
                break
            }
        }else{
            switch(sender.tag){
            case 11:
                if Image11.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
                    Image11.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image11.layer.cornerRadius = 10
                    Image12.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image21.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image31.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image32.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = "幽灵不屑"
                }
                break
            case 12:
                if Image12.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
                    Image12.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image12.layer.cornerRadius = 10
                    Image21.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image31.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image32.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = "幽灵吐舌头"
                }
                break
            case 21:
                if Image21.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
                    Image21.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image21.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image21.layer.cornerRadius = 10
                    Image22.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image31.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image32.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = "幽灵高兴"
                    
                }
                break
            case 22:
                if Image22.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
                    Image22.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image21.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image22.layer.cornerRadius = 10
                    Image31.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image32.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = "幽灵炫酷左"
                }
                break
            case 31:
                if Image31.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
                    Image31.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image21.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image31.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Image31.layer.cornerRadius = 10
                    Image32.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = "幽灵期待"
                }
                break
            default:
                if Image32.backgroundColor == #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
                    Image32.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    ghostStyle = ""
                }else{
                    Image11.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image12.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image21.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image22.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image31.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    Image32.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    Image32.layer.cornerRadius = 10
                    ghostStyle = "幽灵抱歉"
                }
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLabelColor()
    }
}

