//
//  qiandaoController.swift
//  dreamer1
//
//  Created by 陈宥伊 on 2020/8/27.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import Foundation

class qiandaoController: UIViewController {
    
    var btnLogin:UIButton!
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
        btnLogin.setTitle("      签到", for: .normal)
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
         }
    }
    
    @objc func loginEvent(){
        Test.qianDao()
        let p = UIAlertController(title: "恭喜", message: "签到成功", preferredStyle: .alert)
        p.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(p, animated: false, completion: nil)
    }
}
