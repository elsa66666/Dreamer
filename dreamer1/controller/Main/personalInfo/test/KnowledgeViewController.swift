//
//  KnowledgeViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/8/12.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class KnowledgeViewController: UIViewController {
    
    var marks = [0.0,0.0,0.0,0.0,0.0,0.0]
    var whichKnowledge:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        testResult.layer.cornerRadius = 3
        introLabel.layer.cornerRadius = 5
        showText()
        showResult()
    }
    
    @IBOutlet weak var testResult: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    func showResult()
    {
        switch whichKnowledge {
        case 0, 1, 2: //力量
            if marks[whichKnowledge!] < 0.5
            {
                testResult.text = "从测评结果上看，你的心理韧性很差，可能在成长过程中存在防御方面的不足，导致某些情绪体验上防御功能的失效。你大多时候受制于过去经验的影响，僵化地使用某些早年的防御机制、失去了现实检验和联结。"
            }
            else if marks[whichKnowledge!] >= 0.5 && marks[whichKnowledge!] < 0.8
            {
                testResult.text = "从测评结果上看，你的心理韧性差了一点。你喜欢处于心理舒适区来生活。其实，这样也许没有什么不好，但是当问题来临的时候，你会措手不及。勇敢去尝试改变，失败或挫折不是一个结局 ，它一个暂时的状态，克服了我们就可以走的更远。"
            }
            else
            {
                testResult.text = "从测评结果上看，你的心理韧性很棒。如果你对这个世界保持着一种乐观积极的态度，那么即使面对再多的困难和挫折，你都可以坚持前行，直到解决问题。也许你就是传说中的打不死小强，有着顽强的生命力。继续保持一种幽默、乐观的心态，让你的生活更加精彩。"
            }
        case 3:
            if marks[3] < 0.5
            {
                testResult.text = "你的自信心很低，甚至有点自卑，建议经常鼓励自己，相信自己是行的，正确地对待自己的优点和缺点，学会欣赏自己。"
            }
            else if marks[3] >= 0.5 && marks[3] < 0.8  {
                testResult.text = "你的自信心较高。"
            }else{
                testResult.text = "你的自信心非常高，但要注意正确看待自己的缺点。"
            }
        default:
            if marks[4] < 0.5
            {
                testResult.text = "你一般是看起来比较冷漠的，自卫性较强的，就像是把自己包裹在一套很厚实的铠甲里。在你眼中，别人和自己中间有条不可逾越的河流，你需要的是自己的空间。对你来说是很难保持与人持久的亲密无间的关系的。"
            
            
            }else{
                testResult.text = "你的心里边界感弱。你一般是开放的、轻信的、容易与人变得很亲密的。你很容易把别人当成自己看待，把自己渗透别人生活的方方面面。你比较随性，喜欢无组织组安排的散漫生活，而且往往能很好的应对突发事件。有时你还甚至会出现比较呆萌的状态，即不知道一件事情是在梦里发生还是以前的真实经历。而且更容易出现白日梦，或者做恶梦。"
            }
        }
    }
    
    func showText(){
        switch whichKnowledge {
        case 0: //力量
            introLabel.text = "  力量感不仅局限于外表，内心的力量感更为重要。力量感对于我来说意味着强大的内心，能够承受住压力。敢于表达自己是力量感的表现，不扭捏不压抑，清楚自己的想法和欲望，个人充满活力，阳光勇敢。有自己的目标和方向，不轻易被人改动，不轻易迷茫，不容易颓丧。早早就知道自己想要什么，有计划按部就班完成目标。心中有热爱，眼里有目标，生活有惊喜，有承受能力，能够承担责任，敢于表达自己。"
        case 1: //乐观
            introLabel.text = "  乐观心态是指对待事物的变化所具有的积极向上的人生态度。人生会遇到许多难以预料的事，在这些事物面前，我们应当正面对待，多往好的一面想并为此而努力。人有悲欢离合，月有阴晴圆缺，此事古难全。单独一人的力量很渺小，不能左右事物的发生发展，但我们可以用积极的心态和乐观主义精神去面对它。"
        case 2: //坚韧
            introLabel.text = "  韧性用在心理学上，是一种压力下复原和成长的心理机制，指面对丧失、困难或者逆境时的有效应对和适应。不仅意味着个体能在重大创伤或应激之后恢复最初状态，在压力的威胁下能够顽强持久、坚韧不拔，更强调个体在挫折后的成长和新生。"
        case 3: //自信
            introLabel.text = "  自我效能感是Bandura社会认知理论中的核心概念 。自我效能感与结果期望不同， 后者是指个体对自己行动后果的知觉，而自我效能感指的是人们对自己行动的控制或主导。一个相信自己能处理好各种事情的人，在生活中会更积极、更主动。这种“能做”的认知反映了一种对环境的控制感，因此自我效能感反映了一种个体能采取适当的行动面对环境挑战的信念。自我效能感以自信的观点看待个体处理生活中各种压力的能力。"
        case 4: //边界感
            introLabel.text = "  心理边界这个词最早由心理学家埃内斯特·哈曼特提出。他认为，心理边界是个体与外界连接方式的重要指标。心理边界，好象一个人的心灵家园。太小了可能没有自我，弱小，不够独立，没有安全感，不清楚自己的需要；太大了可能过于个性，强悍，影响人际关系。你的心理边界是强是弱，快来测一下吧！"

        default: // 。。。
            
            introLabel.text = ""
        }
        
        
        
        
    }
    
}
