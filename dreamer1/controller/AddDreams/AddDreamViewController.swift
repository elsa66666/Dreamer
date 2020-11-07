//
//  ChooseGhostLookViewController.swift
//  Dreamer
//
//  Created by Elsa on 2020/5/6.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class AddDreamViewController: UIViewController, UITextFieldDelegate {

    var style: String = ""
    var id = 0
    var name = ""

    @IBOutlet weak var isPublic: UISwitch!
    
    @IBOutlet var fullStack: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tagText: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "您的输入为空!"
            return false
        }
    }
    
    
    @IBAction func goToChooseGhostPressed(_ sender: UIButton) {
        if nameTextField.text == ""{
            let alertController = UIAlertController(title: "提示", message: "请输入dream的名字", preferredStyle: .actionSheet)
            let alertAction1 = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(alertAction1)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let userName = Test.userD.LoginUserName()
            var judge = true
            let queryResult = Test.userD.getAllDreamName(user: userName)
            print(nameTextField.text!.trimmingCharacters(in: .whitespaces))
            for row in queryResult
            {
                if row == nameTextField.text!.trimmingCharacters(in: .whitespaces)
                {
                    judge = false
                }
            }
            if judge == true
            {
                performSegue(withIdentifier: "goToChooseGhost", sender: UIButton.self)
            }
            else
            {
                let alertController = UIAlertController(title: "提示", message: "已经有过这个dream了哦", preferredStyle: .actionSheet)
                let alertAction1 = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertController.addAction(alertAction1)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func getUserStyle() {
        //查询数据库"userLogin"的最后一行，即刚刚登录时存入的数据
        style = Test.userD.getUserStyle()[0] as! String
        id = Test.userD.getUserStyle()[1] as! Int
        name = Test.userD.getUserStyle()[2] as! String

        fullStack.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    }
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 5
        getUserStyle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChooseGhost"{
            let destinationVC = segue.destination as! ChooseGhostViewController
                destinationVC.ghostName = nameTextField.text!
                destinationVC.style = style
                destinationVC.tagText = tagText.text!
            if isPublic.isOn == true
            {
                destinationVC.IsPublic = 1
            }
            else
            {
                destinationVC.IsPublic = 0
            }
        }
    }
}
