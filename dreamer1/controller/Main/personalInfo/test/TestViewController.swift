//
//  TestViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/8/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class TestViewController: UIViewController {
    
    @IBOutlet weak var questionlabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var ans1: UIButton!
    @IBOutlet weak var ans2: UIButton!
    @IBOutlet weak var ans3: UIButton!
    @IBOutlet weak var ans4: UIButton!
    @IBOutlet weak var ans5: UIButton!
    
    var num = 0
    var questionNo:Int = 0
    var questionContent:[[Any]]?
    var marks = [0,0,0,0,0,0]
    @IBOutlet weak var bgImageView: UIImageView!
    var whichGhost: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        showBGImage()
        initQuestion()
    }
    
    func initQuestion() {
        switch whichGhost {
        case 1:
            questionlabel.text = MTest.question1[0][0] as? String
            questionContent = MTest.question1
            num = 0
        case 2:
            questionlabel.text = MTest.question2[0][0] as? String
            questionContent = MTest.question2
            num = 1
        case 3:
            questionlabel.text = MTest.question3[0][0] as? String
            questionContent = MTest.question3
            num = 2
        case 4:
            questionlabel.text = MTest.question4[0][0] as? String
            questionContent = MTest.question4
            num = 3
        case 5:
            questionlabel.text = MTest.question1[0][0] as? String
            questionContent = MTest.question1
            num = 4
        default:
            questionlabel.text = MTest.question1[0][0] as? String
            questionContent = MTest.question1
            num = 5
        }
    }
    
    func showBGImage(){
        switch whichGhost {
        case 1:
            bgImageView.image = UIImage(named: "答题幽灵不屑")
            questionlabel.backgroundColor = #colorLiteral(red: 0.8946837783, green: 0.8212885261, blue: 0.9043553472, alpha: 0.6689293033)
        case 2:
            bgImageView.image = UIImage(named: "答题幽灵吐舌头")
            questionlabel.backgroundColor = #colorLiteral(red: 0.7497889996, green: 0.8678550124, blue: 0.9368970394, alpha: 0.8466103142)
        case 3:
            bgImageView.image = UIImage(named: "答题幽灵高兴")
            questionlabel.backgroundColor = #colorLiteral(red: 0.3946247995, green: 0.5784347653, blue: 0.835801661, alpha: 0.7972378757)
        case 4:
            bgImageView.image = UIImage(named: "答题幽灵炫酷")
            questionlabel.backgroundColor = #colorLiteral(red: 0.7497889996, green: 0.8678550124, blue: 0.9368970394, alpha: 0.8466103142)
        case 5:
            bgImageView.image = UIImage(named: "答题幽灵期待")
            questionlabel.backgroundColor = #colorLiteral(red: 0.2686321437, green: 0.2391856611, blue: 0.3990458548, alpha: 0.6792178962)
        case 6:
            bgImageView.image = UIImage(named: "答题幽灵抱歉")
            questionlabel.backgroundColor = #colorLiteral(red: 0.9714148641, green: 0.9473028779, blue: 1, alpha: 0.5955643784)
        default:
            break
        }
    }
    
    
    @IBAction func onAnswerClicked(_ sender: UIButton) {
        if questionNo < questionContent!.count - 1{
            marks[questionContent![questionNo][1] as! Int] += sender.tag
            progress.progress = Float(questionNo + 1) / Float(questionContent!.count)
            questionNo += 1
            questionlabel.text = questionContent![questionNo][0] as? String
            
            print(marks)
        }else{
            marks[questionContent![questionNo][1] as! Int] += sender.tag
            progress.progress = Float(questionNo + 1) / Float(questionContent!.count)
            testData.updateDB(strength: "\(marks[0])", optimism: "\(marks[1])", toughness: "\(marks[2])", confidence: "\(marks[3])", boundary: "\(marks[4])")
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "testResult")
            UIApplication.shared.windows[0].rootViewController = VCMain
        }
    }
    
}
