//
//  inviteCodeViewController.swift
//  dreamer1
//
//  Created by 陈宥伊 on 2020/5/27.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class inviteCodeViewController: UIViewController {

    var btnLogin:UIButton!
    var txtUser:UITextField!
    var User: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        //print(mainSize)
        
        //登录框背景
        let vLogin = UIView(frame:CGRect(x: 15, y: 305, width: mainSize.width - 30, height: 250))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        
        
        self.view.addSubview(vLogin)
        
        txtUser = UITextField(frame: CGRect(x: mainSize.width/2-100, y: 70, width: 225, height: 60))
        txtUser.layer.cornerRadius = 5
        //txtUser.layer.borderColor = UIColor.lightGray.cgColor
        //txtUser.layer.borderWidth = 0.5
        txtUser.autocapitalizationType = .none
        txtUser.textAlignment = .left
        //txtUser.placeholder = "invitation code"
        txtUser.background = UIImage(named: "ck1")
        txtUser.textColor = #colorLiteral(red: 0.3293838501, green: 0.3294274211, blue: 0.3293690681, alpha: 1)
        txtUser.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        txtUser.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 44))
        txtUser.leftViewMode = UITextField.ViewMode.always
        
        User = UILabel(frame: CGRect(x: 60, y: 25, width: vLogin.frame.size.width - 100, height: 50))
        User.text = "Please enter the invitation code："
        User.font = UIFont(name: "Futura-Bold", size: 15)
        vLogin.addSubview(User)
        
        //用户名输入框左侧图标
        let imgUser = UIImageView(frame: CGRect(x: 21, y: 11, width: 22, height: 22))
        //imgUser.image = UIImage(named: "心右")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        let img1 = UIImageView(frame: CGRect(x: mainSize.width/2-155, y: 90, width: 55, height: 60))
        img1.image = UIImage(named: "幽灵")
        vLogin.addSubview(img1)
        
        let img = UIImageView(frame: CGRect(x: mainSize.width/2-155, y: 190, width: 55, height: 60))
        img.image = UIImage(named: "幽灵")
        vLogin.addSubview(img)
        
        //添加登陆按钮
        btnLogin = UIButton(frame: CGRect(x: mainSize.width/2-100, y: 170, width: 225, height: 60))
        btnLogin.layer.cornerRadius = 15
        btnLogin.setTitleColor(#colorLiteral(red: 0.3293838501, green: 0.3294274211, blue: 0.3293690681, alpha: 1), for: .normal)
        btnLogin.contentHorizontalAlignment = .leading

        btnLogin.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        btnLogin.setTitle("      Login", for: .normal)
        btnLogin.setBackgroundImage(UIImage(named: "ck1"), for: .normal)
        //btnLogin.backgroundColor = #colorLiteral(red: 1, green: 0.9185910821, blue: 0, alpha: 1)
        vLogin.addSubview(btnLogin)
        
        //添加action
        btnLogin.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        let style = Test.getUserStyle()
        if style == "pink" {
            vLogin.backgroundColor = UIColor.white
        
         }else{
            vLogin.backgroundColor = UIColor.black
            User.textColor = UIColor.white
         }
    }
    @objc func loginEvent(){
        let userCode = txtUser.text!
        var userName = ""
        var uid = 0
        var style = ""
        var judge = false
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let queryResult1 = sqlite.executeQuerySQL(sql: "SELECT * FROM invite")
        let queryResult2 = sqlite.executeQuerySQL(sql: "SELECT * FROM user")
    
        for row in queryResult1!
        {
            if row["code"] as! String == userCode
            {
                judge = true
                userName = row["user"] as! String
            }
        }
        for row in queryResult2!
        {
            if row["name"] as! String == userName
            {
                uid = row["id"] as! Int
                style = row["style"] as! String
            }
        }
        if judge == true
        {
            let user = Test.LoginUserName()
            Test.LoginSuccess(id: uid, name: userName, style: style, user: user)
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            let p = UIAlertController(title: "共享失败", message: "邀请码输入错误", preferredStyle: .alert)
            p.addAction(UIAlertAction(title: "确定", style: .default, handler: {(act:UIAlertAction) in self.txtUser.text = ""}))
            present(p, animated: false, completion: nil)
    }
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
