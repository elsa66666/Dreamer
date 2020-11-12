//
//  BubbleViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/8/2.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class BubbleViewController: UIViewController {

    @IBOutlet weak var bubbleLabel1: UILabel!
    @IBOutlet weak var bubbleLabel2: UILabel!
    @IBOutlet weak var bubbleLabel3: UILabel!
    @IBOutlet weak var bubbleLabel4: UILabel!
    
    var bubbleLabelText1 = "在Notes(梦想草稿本)中输入灵感"
    var bubbleLabelText2 = "Notes"
    var bubbleLabelText3 = "草稿本中灵感将在此呈现"
    var bubbleLabelText4 = "梦想草稿本"
    var contentArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleLabel1.isHidden = true
        bubbleLabel2.isHidden = true
        bubbleLabel3.isHidden = true
        bubbleLabel4.isHidden = true
        
        bubbleLabel1.text = bubbleLabelText1
        bubbleLabel2.text = bubbleLabelText2
        bubbleLabel3.text = bubbleLabelText3
        bubbleLabel4.text = bubbleLabelText4
        contentArray = MySql().getAllNoteContentForBubble()
        bubbleShow()
    }
    
    @IBAction func onBubbleMachinePressed(_ sender: UIButton) {
        if contentArray.count == 1{
            bubbleLabel1.text = contentArray[0]
            bubbleLabel2.text = ""
            bubbleLabel3.text = ""
            bubbleLabel4.text = ""
        }else if contentArray.count == 2{
            bubbleLabel1.text = contentArray[0]
            bubbleLabel3.text = contentArray[1]
            bubbleLabel2.text = ""
            bubbleLabel4.text = ""
        }else if contentArray.count == 3{
            bubbleLabel1.text = contentArray[0]
            bubbleLabel3.text = contentArray[1]
            bubbleLabel2.text = contentArray[2]
            bubbleLabel4.text = ""
        }else if contentArray.count >= 4{
            var tempArray:[Int] = []
            while tempArray.count < 4{
                let randomIndex = Int(arc4random_uniform(UInt32(contentArray.count)))
                if !tempArray.contains(randomIndex){
                    tempArray.append(randomIndex)
                }
            }
            inputContent(array: tempArray)
        }
        bubbleShow()
    }

    
    func inputContent(array: [Int]){
            bubbleLabel1.text = contentArray[array[0]]
            bubbleLabel2.text = contentArray[array[1]]
            bubbleLabel3.text = contentArray[array[2]]
            bubbleLabel4.text = contentArray[array[3]]
    }
    func bubbleShow(){
        if bubbleLabel1.text != ""{
            bubbleLabel1.isHidden = false
            bubbleLabel1.layer.animation(forKey: bubbleLabelText1)
        }
        if bubbleLabel2.text != ""{
            bubbleLabel2.isHidden = false
            bubbleLabel2.layer.animation(forKey: bubbleLabelText2)
        }
        if bubbleLabel3.text != ""{
            bubbleLabel3.isHidden = false
            bubbleLabel3.layer.animation(forKey: bubbleLabelText3)
        }
        if bubbleLabel4.text != ""{
            bubbleLabel4.isHidden = false
            bubbleLabel4.layer.animation(forKey: bubbleLabelText4)
        }
    }    
}









