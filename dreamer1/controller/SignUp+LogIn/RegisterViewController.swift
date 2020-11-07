import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ghostImageView: UIImageView!    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var maleSelectedLabel: UILabel!
    @IBOutlet weak var femaleSelectedLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    
    var genderSelected = ""
    var style = ""
    
    //选择性别为男，则风格为蓝色，反选则性别和风格清空
    @IBAction func maleButtonPressed(_ sender: UIButton) {
        if maleSelectedLabel.text == ""{
            maleSelectedLabel.text = "✔️"
            femaleSelectedLabel.text = ""
            genderSelected = "male"
            style = "blue"
        }else{
            maleSelectedLabel.text = ""
            genderSelected = ""
            style = ""
        }
    }

    @IBAction func femaleButtonPressed(_ sender: UIButton) {
        if femaleSelectedLabel.text == ""{
            femaleSelectedLabel.text = "✔️"
            maleSelectedLabel.text = ""
            genderSelected = "female"
            style = "pink"
        }else{
            femaleSelectedLabel.text = ""
            genderSelected = ""
            style = ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
        userName.delegate = self
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        userName.endEditing(true)
            password.endEditing(true)
            //如果未选择性别
            if maleSelectedLabel.text == "" && femaleSelectedLabel.text == "" {
                let alertController = UIAlertController(title: "提示", message: "请选择性别", preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
            
        let flag = Test.userD.judgeName(name: (userName.text?.trimmingCharacters(in: .whitespaces))!)

            if flag == true{ // 如果用户名已被使用，注册失败
                let alertController = UIAlertController(title: "提示", message: "该用户名已被使用", preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }else{  // 如果用户名未被注册
                
                if userName.text?.trimmingCharacters(in: .whitespaces) != "" && userName.text != nil && !(maleSelectedLabel.text == "" && femaleSelectedLabel.text == "") {
                    Test.userD.AddUser(name: (userName.text?.trimmingCharacters(in: .whitespaces))!, password: (password.text?.trimmingCharacters(in: .whitespaces))!, gender: genderSelected, style: style)
                    testData.insertDB(user: (userName.text?.trimmingCharacters(in: .whitespaces))!)
                    let alertController = UIAlertController(title: "提示", message: "注册成功", preferredStyle: .actionSheet)
                    let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    present(alertController, animated: true, completion: nil)
                }else{
                    //只输入空格或者不输入，注册失败
                    let alertController = UIAlertController(title: "提示", message: "注册失败，用户名为空", preferredStyle: .actionSheet)
                    let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    present(alertController, animated: true, completion: nil)
                }
            }
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.endEditing(true)
        password.endEditing(true)
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

}

