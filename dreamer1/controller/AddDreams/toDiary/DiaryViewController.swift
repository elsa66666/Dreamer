//
//  DiaryViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/5/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//


import UIKit

class DiaryViewController: UIViewController, TokenDelegate, EmotionDelegate {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var drawTextView: UIImageView!
    @IBOutlet weak var toolStack: UIStackView!

    @IBOutlet weak var photoButtonShow: UIButton!
    @IBOutlet weak var saveButtonShow: UIButton!
    @IBOutlet weak var ghostAddFavorabilityImage: UIImageView!
    @IBOutlet weak var ghostAddFavorabilityPoint: UILabel!
    @IBOutlet weak var changeStyleShow: UIButton!
    private let textView = YYTextView.init()
    
    let userName = Test.LoginUserName()
    var ghostName = Diary.ghostName
    var textNew = ""
    var textNew1 = ""
    var styleG = ""
    var ghostFavorability = 0
    var type = 0
    var judge = false  //判断好感度是否增加过，避免重复增加
    var ifPointUpdated = false //判断好感度算法是否已经回传值
    var enter = false //判断是否是等待修改的日记
    var pic = true //判断日记是否含图片
    
    var tokenManager = TokenManager()
    var emotionManager = EmotionManager()
    var diary = "你个憨批"  //日记中的文本
    var diaryG: [String.SubSequence]?
    var image: YYImage?
    var image1: [Data] = []
    var image2: [Int] = []
    
    var positivePoint: Float = 0.0
    var negativePoint: Float = 0.0
    var favorabilityPoint: Float = 0.0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ghostAddFavorabilityImage.isHidden = true
        ghostAddFavorabilityPoint.isHidden = true
        toolStack.isHidden = false

        photoButtonShow.isEnabled = true
        saveButtonShow.isEnabled = true

        drawTextView.isUserInteractionEnabled = true
        textView.textParser = TextParser.init()
        drawTextView.addSubview(textView)
        saveButtonShow.isEnabled = true
        judge = false
        
        tokenManager.delegate = self
        emotionManager.delegate = self
        level = getLevel(ghostFavorability: ghostFavorability)
        
        
        if Diary.new == false
        {
            let sqlite = SQliteManager.sharedInstance
            if !sqlite.openDB(){return}
            let id = Diary.getpicID(name: ghostName)
            // 用index数值带入id[?]获取真正的id
            let query = Diary.getDB1(id: id[1])
            for row in query!
            {
                diary = row["words"] as! String
                if row["picture"] as? NSData == nil
                {pic = false}
                styleG = row["style"] as! String
            }
            var i = 0
            var m = 0
            diaryG = diary.split(separator: "「")
            var num = 0
            for j in 0...diaryG!.count - 1
            {
                if diaryG![j].hasSuffix("%") && diaryG![j] != "%"
                {
                    num += diaryG![j].count
                    textView.text += diaryG![j].prefix(diaryG![j].count - 1)
                    image2.append(num - 1)
                    m += 1
                    print("光标位置：" + "\(num)")
                }
                else if diaryG![j] != "%"
                {
                    num += diaryG![j].count + 1
                    textView.text += diaryG![j]
                }
            }
            
            for row in Diary.query
            {
                let ima_ = YYImage.init(data: Diary.LoadImage1(id: row["id"] as! Int)!,scale: 2)
                addImage1(image: ima_, point: image2[i])
                i += 1
            }
            
            getStylePicture(style: Int(styleG)!)
            Diary.new = true
            enter = true
        }
        else 
        {
            enter = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.frame = CGRect.init(x: 40, y: 120, width: drawTextView.bounds.size.width -  40 * 2, height: drawTextView.bounds.size.height - 120 * 2)
    }
    
    var style = 0
    func getStylePicture(style: Int) {
        switch style {
            case 0:
                bgImage.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            case 1:
                bgImage.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.9568627451, blue: 0.9607843137, alpha: 1)
            case 2:
                bgImage.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.8666666667, blue: 0.8549019608, alpha: 0.9317831889)
            case 3:
                bgImage.backgroundColor = #colorLiteral(red: 1, green: 0.9803921569, blue: 0.8039215686, alpha: 1)
            case 4:
                bgImage.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9803921569, alpha: 1)
            case 5 :
                bgImage.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9725490196, blue: 1, alpha: 1)
            default:
                bgImage.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
         
    }
    @IBAction func changeStylePressed(_ sender: UIButton) {
        style = (style + 1) % 6
        getStylePicture(style: style)
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        selectPic()
    }
    
    
    //判断现有等级
    func getLevel(ghostFavorability: Int) -> Int{
        switch ghostFavorability {
        case 0...100:
            return 1
        case 101...200:
            return 2
        case 201...300:
            return 3
        default:
            return 4
        }
    }
    
    var level = 1
    
    //通过现有等级增加好感度
    func addFavorability(level: Int) -> Int{
        print("未加权好感度增加:\(Int(favorabilityPoint))")

        switch level {
        case 1:
            ghostFavorability += Int(favorabilityPoint * 2)
            return Int(favorabilityPoint * 2)
        case 2:
            ghostFavorability += Int(favorabilityPoint * 1.5)
            return Int(favorabilityPoint * 1.5)
        case 3:
            ghostFavorability += Int(favorabilityPoint * 1.2)
            return Int(favorabilityPoint * 1.2)
        default:
            ghostFavorability += Int(favorabilityPoint)
            return Int(favorabilityPoint)
        }
    }
    
    var token: String = ""
    func didGetToken(token: String) {
        //print(token)
        emotionManager.performRequest1(token: token, diary: diary + ".")
    }
    func didGetEmotionPoint(emotion: Emotion) {
        positivePoint = emotion.positive
        negativePoint = emotion.negative
        favorabilityPoint = emotion.point

        ifPointUpdated = true
        
    }
    
    var timer = Timer()
    @IBAction func save(_ sender: UIButton) {
        if textView.text == ""{
            let p = UIAlertController(title: "保存失败", message: "你输入了一个寂寞", preferredStyle: .alert)
            p.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(p, animated: false, completion: nil)
            }
        else{
            if judge == false{
                diary = textView.text
                tokenManager.performRequest()
                while (ifPointUpdated == false){};
                if ifPointUpdated == true{
                    //将好感度增加的信息呈现在屏幕上
                    let addFavor = addFavorability(level: level)
                    ghostAddFavorabilityPoint.text = "好感度+\(addFavor)"
                    ghostAddFavorabilityPoint.isHidden = false
                    ghostAddFavorabilityImage.isHidden = false
                    //更新数据库
                    Test.userD.AddFavor(ghostName: ghostName, add: addFavor)
                    var image = UIApplication.shared.windows[0].asImage()
                    if Test.userD.getId(name: ghostName) == 0{
                        image = image.crop(ratio: 1.9/3.3)
                    }else{
                        image = image.crop(ratio: 1.9/3.3)
                    }
                    
                    let fileManager = FileManager.default
                    let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                    .userDomainMask, true)[0] as String
                    let date = NSDate(),
                    timeInterval = date.timeIntervalSince1970 * 1000
                    let filePath = "\(rootPath)/" + String(timeInterval) + ".png"
                    let imageData = image.jpegData(compressionQuality: 1.0)
                    fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
                    //OssClient.getToken()
                    //OssClient.uploadPic(url: URL.init(fileURLWithPath: filePath))
                    
                    let words = textNew + (textView.text! as NSString).substring(from: textNew1.count)
                    if enter == false
                    {
                        if image1.count - 1 < 0
                        {
                            Test.userD.insertDB(name: ghostName, back: image, type: 0, words: words + "%「", voice: "\(style)", positive: "\(positivePoint)", negative: "\(negativePoint)")
                            Diary.insertDB(name: ghostName, back: image, type: 0, words: words + "%「", voice: "\(style)", media: "", positive: "\(positivePoint)", negative: "\(negativePoint)")
                            let allId = Diary.getpicID(name: ghostName)
                            Test.amount = allId[allId.endIndex - 1]
                            //Test.amount = Test.userD.getId(name: ghostName)
                            Diary.SaveImage(img: image, id: Test.amount)
                            Diary.SaveImage1(img: UIImage(named: "transparent")?.pngData(), id: Test.amount)
                        }
                        else
                        {
                            for i in 0...image1.count - 1
                            {
                                Test.userD.insertDB(name: ghostName, back: image, type: i, words: words, voice: "\(style)", positive: "\(positivePoint)", negative: "\(negativePoint)")
                                Diary.insertDB(name: ghostName, back: image, type: i, words: words, voice: "\(style)", media: "", positive: "\(positivePoint)", negative: "\(negativePoint)")
                                let allId = Diary.getpicID(name: ghostName)
                                Test.amount = allId[allId.endIndex - 1]
                                //Test.amount = Test.userD.getId(name: ghostName)
                                Diary.SaveImage(img: image, id: Test.amount)
                                Diary.SaveImage1(img: image1[i], id: Test.amount)
                            }
                        }
                    }
                    /*
                    else
                    {
                        Diary.updateDB()
                        for i in 0...image1.count - 1
                        {
                            Diary.insertDB(name: ghostName, back: image, type: i, words: words, voice: "\(style)", media: "", positive: "\(positivePoint)", negative: "\(negativePoint)")
                            Diary.getDB()
                            Test.amount = Diary.getId(name: ghostName)
                            Diary.SaveImage(img: image, id: Test.amount)
                            Diary.SaveImage1(img: image1[i], id: Test.amount)
                            Diary.getDB()
                        }
                    }*/
                    //返回主界面
                    let time: TimeInterval = 1.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                        let mainboard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
                        let Vcmain = mainboard!.instantiateViewController(identifier: "vcMain")
                        UIApplication.shared.windows[0].rootViewController = Vcmain
                    }
                    judge = true
                }
            }
        }
    }
    
    @IBAction func onToolButtonPressed(_ sender: UIBarButtonItem) {
        
        if toolStack.isHidden == false {
            toolStack.isHidden = true
            photoButtonShow.isEnabled = false
            saveButtonShow.isEnabled = false
            
        }else{
            toolStack.isHidden = false
            photoButtonShow.isEnabled = true
            saveButtonShow.isEnabled = true
        }
    }
}

extension DiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
//    选择图片
    private func selectPic() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("")
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        do {
            let data = try Data.init(contentsOf: info[.imageURL] as! URL)
            image = YYImage.init(data: data, scale: 2)
            image1.append(data)
            addImage(image: image)
            print(image1 as Any)
            
            
        } catch  {
            
        }
        
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }
    
//    插入图片到编辑框
    private func addImage(image: YYImage?) {
        if let attri = textView.attributedText {

            image?.preloadAllAnimatedImageFrames = true
            let imageTemp = YYAnimatedImageView.init(image: image)
            
            let text = NSMutableAttributedString.init(attributedString: attri)
            let imageAtt = NSMutableAttributedString.yy_attachmentString(withContent: imageTemp, contentMode: .scaleAspectFit, attachmentSize: CGSize.init(width: 40 * 1.4, height: 50 * 1.4), alignTo: .systemFont(ofSize: 18), alignment: .center)
            
            let currentPoint = textView.selectedRange.location
            text.insert(imageAtt, at: currentPoint)
            textView.attributedText = text
            textView.selectedRange = NSRange.init(location: currentPoint + 1, length: 0)
            
            textNew = textNew + (textView.text! as NSString).substring(from: textNew1.count) + "%「"
            textNew1 = textView.text
        }
    }
   
    //在光标处加图片
    private func addImage1(image: YYImage?, point: Int) {
        let attri = textView.attributedText
        image?.preloadAllAnimatedImageFrames = true
        let imageTemp = YYAnimatedImageView.init(image: image)
               
        let text = NSMutableAttributedString.init(attributedString: attri!)
        let imageAtt = NSMutableAttributedString.yy_attachmentString(withContent: imageTemp, contentMode: .scaleAspectFit, attachmentSize: CGSize.init(width: 40 * 1.4, height: 50 * 1.4), alignTo: .systemFont(ofSize: 18), alignment: .center)
        //let currentPoint = textView.selectedRange.location
        text.insert(imageAtt, at: point)
        textView.attributedText = text
        textView.selectedRange = NSRange.init(location: point + 1, length: 0)
           
       }
}


