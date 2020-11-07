//
//  MeViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/9.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class MeViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfile()
        line1.isHidden = false
        line2.isHidden = true
        line3.isHidden = true
        
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
        
        initView1()
        initView2()
        
    }
    func initProfile(){
        let name:String = Test.userD.LoginUserName()
        nameLabel.text = name
        let imageName = name.getFirstAlphabet() + ".circle.fill"
        profileImageView.image = UIImage(systemName: imageName)
        levelLabel.layer.cornerRadius = 5
        let motto = Test.userD.getUserIntro()
        profileLabel.text = motto
    }
    
    @IBAction func changeName(_ sender: Any) {

        var textField = UITextField()
        let alert = UIAlertController(title: "修改用户昵称", message: "", preferredStyle: .alert)
        let alertAction2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        let action = UIAlertAction(title: "确定", style: .default){(action) in
            self.nameLabel.text = textField.text
            let imageName = textField.text!.getFirstAlphabet() + ".circle.fill"
            self.profileImageView.image = UIImage(systemName: imageName)
            //更新用户名到数据库
            if self.nameLabel.text != ""
            {
                Test.userD.alterUserName(newName: self.nameLabel.text!)
            }
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeMotto(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "修改用户简介", message: "", preferredStyle: .alert)
        let alertAction2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        let action = UIAlertAction(title: "确定", style: .default){(action) in
            self.profileLabel.text = textField.text
            //更新用户简介到数据库
            if self.profileLabel.text != ""
            {
                Test.userD.alterUserIntro(intro: self.profileLabel.text!)
            }
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion: nil)
    }
    var result: [[String:Any]]?
    // MARK: -init view1
    @IBOutlet weak var publicDreamsCollectionView: UICollectionView!
    func initView1(){
        publicDreamsCollectionView.register(UINib(nibName: "PublicDreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "pdreamCell")
        publicDreamsCollectionView.delegate = self
        result = Test.userD.getUserPublicDream()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pdreamCell", for: indexPath) as! PublicDreamCollectionViewCell
        cell.dreamName.text = String(data: result![indexPath.row]["ghostName"] as! Data, encoding: String.Encoding.utf8)
        cell.ghostImageView.image = UIImage(named: String(data: result![indexPath.row]["ghostStyle"] as! Data, encoding: String.Encoding.utf8)!)
        cell.dreamFavorability.text = "\(result![indexPath.row]["favorability"] as! Int)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.75, height: collectionView.frame.width*0.5)
    }
    
    
    
    // MARK: -init view2
    @IBOutlet weak var suggestionTableView: UITableView!
    func initView2(){
        suggestionTableView.register(UINib(nibName: "SuggestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "suggestion")
        suggestionTableView.delegate = self
        suggestionTableView.rowHeight = 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "suggestion", for: indexPath) as! SuggestionsTableViewCell
        return cell
    }
    
    
    // MARK: -inter views
    func changeView(change:Int){
        if change == 1{
            line1.isHidden = false
            line2.isHidden = true
            line3.isHidden = true
            
            view1.isHidden = false
            view2.isHidden = true
            view3.isHidden = true
        }else if change == 2{
            line1.isHidden = true
            line2.isHidden = false
            line3.isHidden = true
            
            view1.isHidden = true
            view2.isHidden = false
            view3.isHidden = true
        }else{
            line1.isHidden = true
            line2.isHidden = true
            line3.isHidden = false
            
            view1.isHidden = true
            view2.isHidden = true
            view3.isHidden = false
        }
    }
    
    
    @IBAction func publicDreamsPressed(_ sender: UIButton) {
        changeView(change: 1)
    }
    
    @IBAction func suggestionPressed(_ sender: UIButton) {
        changeView(change: 2)
    }
    
    @IBAction func collectionPressed(_ sender: UIButton) {
        changeView(change: 3)
    }
    
    @IBAction func toMagicTest(_ sender: UIButton) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "toMagicTest")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    @IBAction func toQuit(_ sender: UIButton) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "User", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcLaunch")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
}
extension String{
    func getFirstAlphabet() -> String{
        let transformContents = CFStringCreateMutableCopy(nil, 0, self as CFString)
        CFStringTransform(transformContents, nil, kCFStringTransformStripDiacritics, false)
        let traStr:String = transformContents! as String
        let firstCharStr = String(traStr.prefix(1))
        var num:UInt32 = 0  //用于接受字符整数值的变量
        for item in firstCharStr.unicodeScalars {
            num = item.value    //循环只执行一次,获取字符的整数的值

        }
        if num >= 65 && num <= 90 {  //大写转小写
            num += 32
        }
        let newChNum = Character(UnicodeScalar(num)!)
        return String(newChNum)
    }
}
