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
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfile()
        line1.isHidden = false
        line2.isHidden = true
        
        view1.isHidden = false
        view2.isHidden = true
        
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
        let userID = MySql().LoginUserID()
        userIdLabel.text = "Dreamer ID: \(userID)"
        let userLevel = MySql().getAllDreamFavorSum()/200 + 1
        levelLabel.text = "Level \(userLevel)"
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
        result = Test.userD.getUserPublicDream(user: MySql().LoginUserName())
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pdreamCell", for: indexPath) as! PublicDreamCollectionViewCell
        cell.dreamName.text = String(data: result![indexPath.row]["ghostName"] as! Data, encoding: String.Encoding.utf8)
        cell.ghostImageView.image = UIImage(named: String(data: result![indexPath.row]["ghostStyle"] as! Data, encoding: String.Encoding.utf8)!)
        cell.dreamFavorability.text = "\(result![indexPath.row]["favorability"] as! Int)"
        let generateDate = result![indexPath.row]["createDate"] as! String
        cell.generatedDateLabel.text = convertDateString(string: generateDate)
        let likePerson=result![indexPath.row]["likeCount"] as! Int
        cell.likedPersonCount.text = "\(likePerson)"
        return cell
    }
    // 转化成格式化后的日期字符串
    private func convertDateString(string: String) -> String{
        let date = Util.stringConvertDate(string: string)
        let tempString = Util.dateConvertString(date: date)
        return tempString
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.5 - 5, height: (collectionView.frame.width*0.5 - 5)*3/5)
    }
    
    var connectDreamName = ""
    var connectDreamFavor = 0
    var connectDreamLike = 0
    var connectDreamProfile = ""
    var connectDreamStyle = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        connectDreamName = String(data: result![indexPath.row]["ghostName"] as! Data, encoding: String.Encoding.utf8)!
        connectDreamFavor = result![indexPath.row]["favorability"] as! Int
        connectDreamLike = result![indexPath.row]["likeCount"] as! Int
        connectDreamProfile=String(data: result![indexPath.row]["tag"] as! Data, encoding: String.Encoding.utf8)!
        connectDreamStyle = String(data: result![indexPath.row]["ghostStyle"] as! Data, encoding: String.Encoding.utf8)!
        performSegue(withIdentifier: "toMyPublicDream", sender: self)
    }
    
    
    // MARK: -init view2
    
    var queryresult:[[String: Any]]?
    @IBOutlet weak var suggestionTableView: UITableView!
    func initView2(){
        suggestionTableView.register(UINib(nibName: "SuggestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "suggestion")
        suggestionTableView.delegate = self
        suggestionTableView.rowHeight = 80
        queryresult = MySql().getAllMyPosts()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queryresult!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "suggestion", for: indexPath) as! SuggestionsTableViewCell
        cell.suggestTitle.text = String(data: queryresult![indexPath.row]["title"] as! Data, encoding: String.Encoding.utf8)!
        cell.suggestContent.text = String(data: queryresult![indexPath.row]["context"] as! Data, encoding: String.Encoding.utf8)!
        return cell
    }
    
    var connectDriftID:Int?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connectDriftID = (queryresult![indexPath.row]["id"] as! Int)
        performSegue(withIdentifier: "toMyBottle", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMyBottle") {
            if let destination = segue.destination as? MyBottleViewController {
                destination.driftID = connectDriftID
            }
        }
        if(segue.identifier == "toMyPublicDream") {
            if let destination = segue.destination as? MyPublicDreamViewController {
                destination.favor = connectDreamFavor
                destination.dreamName = connectDreamName
                destination.likeCount = connectDreamLike
                destination.tag = connectDreamProfile
                destination.dreamStyle = connectDreamStyle
            }
        }
    }
    // MARK: -inter views
    func changeView(change:Int){
        if change == 1{
            line1.isHidden = false
            line2.isHidden = true
            view1.isHidden = false
            view2.isHidden = true
        }else if change == 2{
            line1.isHidden = true
            line2.isHidden = false
            view1.isHidden = true
            view2.isHidden = false
        }
    }

    @IBAction func publicDreamsPressed(_ sender: UIButton) {
        changeView(change: 1)
    }
    
    @IBAction func suggestionPressed(_ sender: UIButton) {
        changeView(change: 2)
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
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: self)
        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil,      kCFStringTransformToLatin, false)
        //去掉声调
        var transformContents = mutableString.folding(options:          String.CompareOptions.diacriticInsensitive, locale:NSLocale.current)
        transformContents = CFStringCreateMutableCopy(nil, 0, transformContents as CFString)! as String
        CFStringTransform((transformContents as! CFMutableString), nil, kCFStringTransformStripDiacritics, false)
        let traStr:String = transformContents as String
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
