import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var ghostImageView: UIImageView!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        name.endEditing(true)
            password.endEditing(true)
            var flag = 0 // check if the password is correct
            let message2 = "密码错误，登录失败！"
            let message3 = "未注册！"
            var id = 0
            var style = ""
            let sqlite = SQliteManager.sharedInstance
            if !sqlite.openDB() { return }
            let queryresult = Test.userD.getUserInfo()
            //print("用户信息： \(queryresult)")
            var name0 = ""
            var password0 = ""
            if queryresult.count != 0{
                for row in queryresult {
                    name0 = String(data: row["name"] as! Data, encoding: String.Encoding.utf8)!
                    password0 = String(data: row["password"] as! Data, encoding: String.Encoding.utf8)!
                    
                     //用户名和密码均匹配
                    if name.text!.trimmingCharacters(in: .whitespaces) == name0 && password.text! == password0{
                        //读取user中的d,name,style
                        flag = 2
                        id = row["id"]! as! Int 
                        style = String(data: row["style"] as! Data, encoding: String.Encoding.utf8)!
                        
                    //用户名匹配但密码错误
                    }else if name.text!.trimmingCharacters(in: .whitespaces) == name0 && password.text! != password0{
                        flag = 1
                    }
                }
                
                //print(flag)
            }

            if flag == 2{  //登录成功
                Test.userD.LoginSuccess(id:id, name:name.text!.trimmingCharacters(in: .whitespaces),style: style, user: name.text!.trimmingCharacters(in: .whitespaces))
                Test.name = name.text!.trimmingCharacters(in: .whitespaces)
                //Diary.Drop()
                Diary.initDB()
                let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
                let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
                UIApplication.shared.windows[0].rootViewController = VCMain
                
                
            }else if flag == 1{
                let alertController = UIAlertController(title: "提示", message: message2, preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "提示", message: message3, preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
        name.delegate = self
        Test.initUserDB()
        Test.initUserLoginDB()
        //Test.drop()
        Test.initAllDreamDB()
        Test.initTimelineDB()
        Diary.initDB()
        //Diary.Drop()
        //Diary.getDB()
        //Test.getDB1()
        //Test.DeleteDB()
        inviteCode.initDB()
        inviteCode.getDB()
        testData.initDB()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))//数据库位置
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name.endEditing(true)
        password.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "您的输入为空!"
            ghostImageView.image = UIImage(named: "幽灵密码")
            return false
        }
    }
}


