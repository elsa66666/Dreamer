//
//  AllGhostsCollectionView.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/8/27.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
import Charts
import SwiftDate
class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ChartViewDelegate {
    
    // MARK: -view1: Dreams
    
    func initView1(){
        
        DreamsButton.isSelected = true
        //DreamsButton.backgroundColor  = .white
        DreamsButton.layer.cornerRadius = 5
        dataButton.layer.cornerRadius = 5
        interactButton.layer.cornerRadius = 5
        
        DreamsButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        dataButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        interactButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        
        DreamsButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        dataButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        interactButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        toNotesButton.layer.cornerRadius = 20
        trashButton.layer.cornerRadius = 20
        getUserStyle()
        
        trashButton.setImage(UIImage(named: "垃圾桶")
            , for: .normal)
        trashButton.setImage(UIImage(named: "垃圾桶fill")
            , for: .selected)
        
        detailedCollectionView.backgroundColor = .white
        
        detailedCollectionView.register(UINib(nibName: "DreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dreamCell")
        detailedCollectionView.isHidden = false
        
        userName = Test.userD.LoginUserName()
        queryResult = Test.userD.getAllDreamInfo(user: userName)

        if Test.jumpDia == true
        {
            Test.jumpDia = false
            performSegue(withIdentifier: "toNewDream", sender: nil)
        }
    }
    func getUserStyle(){
        //查询数据库"userLogin"的最后一行，即刚刚登录时存入的数据
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() { return}
        let queryresult = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin")
        if queryresult != nil{
            for row in queryresult! {
                if row["num"]! as! Int == queryresult!.count {
                    style = (row["style"]! as? String)!
                    userName = (row["name"]! as? String)!
                }
            }
        }
    }
    @IBOutlet weak var detailedCollectionView: UICollectionView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var toNotesButton: UIButton!
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var interactButton: UIButton!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var DreamsButton: UIButton!
    
    @IBAction func changeSection(_ sender: UIButton) {
        DreamsButton.isSelected = false
        dataButton.isSelected = false
        interactButton.isSelected = false
        sender.isSelected = true
        
        DreamsButton.backgroundColor = nil
        dataButton.backgroundColor = nil
        interactButton.backgroundColor = nil
        
        if sender.tag != 0{
            view1.isHidden = true
            line1.isHidden = true
        }else{
            view1.isHidden = false
            line1.isHidden = false
        }
        
        if sender.tag != 1{
            view2.isHidden = true
            line2.isHidden = true
        }else{
            view2.isHidden = false
            line2.isHidden = false
        }
        
        if sender.tag != 2{
            view3.isHidden = true
            line3.isHidden = true
        }else{
            view3.isHidden = false
            line3.isHidden = false
        }
    }
    
    
    var queryResult: [[String : Any]] = []
    var userName: String = ""
    var style = ""
    var nameSelected: String = ""
    var favor:Int?
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: -init view1
        initView1()
        initView2()
        initView3()
        
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
        line1.isHidden = false
        line2.isHidden = true
        line3.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        initView1()
        detailedCollectionView.reloadData()
    }
    @IBAction func toNotes(_ sender: UIButton) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "toNotes")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    
    @IBAction func toAudio(_ sender: UIButton) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "toAudio")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: (collectionView.frame.width/3)*4.7/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queryResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as! DreamCollectionViewCell
        
        let favorability1 = (queryResult[indexPath.row]["favorability"] as? Int)!
        let ghostS1 = String(data: queryResult[indexPath.row]["ghostStyle"] as! Data, encoding: String.Encoding.utf8)
        
        cell.ghostImageView.image = UIImage(named: getDreamLevelPicture(ghostStyle: ghostS1!, favorability: favorability1))
        cell.dreamName.text = String(data: queryResult[indexPath.row]["ghostName"] as! Data, encoding: String.Encoding.utf8)
        cell.dreamFavorability.text = "\(favorability1)"
        let isPublic = queryResult[indexPath.row]["ispublic"] as! Int
        if isPublic == 0
        {
            cell.publicizeSwitch.isOn = false
        }
        else
        {
            cell.publicizeSwitch.isOn = true
        }
        cell.layer.cornerRadius = 20
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        nameSelected = String(data: queryResult[indexPath.row]["ghostName"] as! Data, encoding: String.Encoding.utf8)!
        if trashButton.isSelected == false{
            favor = (queryResult[indexPath.row]["favorability"] as? Int)!
            dreamToAllDiaries.dreamName = nameSelected
            dreamToAllDiaries.dreamFavor = favor!
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "dreamToDiaries")
            UIApplication.shared.windows[0].rootViewController = VCMain
            
        }else{
            Diary.DghostName = String(data: queryResult[indexPath.row]["ghostName"] as! Data, encoding: String.Encoding.utf8)!
            Diary.favor = (queryResult[indexPath.row]["favorability"] as? Int)!
            //跳转到删梦界面
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "giveUp")
            UIApplication.shared.windows[0].rootViewController = VCMain
        }
    }
    
    @IBAction func trashButton(_ sender: UIButton) {
        trashButton.isSelected = !trashButton.isSelected
    }
    
    func getDreamLevel(favorability: Int) -> String {
        switch favorability {
        case 0...100:
            return "[level 1]"
        case 101...200:
            return "[level 2]"
        case 201...300:
            return "[level 3]"
        default:
            return "[level 4]"
        }
    }
    
    func getDreamLevelPicture(ghostStyle: String, favorability: Int) -> String{
        switch ghostStyle {
        case "幽灵抱歉":
            if (favorability >= 0) && (favorability <= 100){
                return "幽灵抱歉"
            }else if (favorability > 100) && (favorability <= 200){
                return "幽灵抱歉level2"
            }else if (favorability > 200) && (favorability <= 300){
                return "幽灵抱歉level3"
            }else{
                return "幽灵抱歉level4"
            }
            
        case "幽灵不屑":
            if (favorability >= 0) && (favorability <= 100){
                return "幽灵不屑"
            }else if (favorability > 100) && (favorability <= 200){
                return "幽灵不屑level2"
            }else if (favorability > 200) && (favorability <= 300){
                return "幽灵不屑level3"
            }else{
                return "幽灵不屑level4"
            }
            
        case "幽灵高兴":
            if (favorability >= 0) && (favorability <= 100){
                return "幽灵高兴"
            }else if (favorability > 100) && (favorability <= 200){
                return "幽灵高兴level2"
            }else if (favorability > 200) && (favorability <= 300){
                return "幽灵高兴level3"
            }else{
                return "幽灵高兴level4"
            }
            
        case "幽灵期待":
            if (favorability >= 0) && (favorability <= 100){
                return "幽灵期待"
            }else if (favorability > 100) && (favorability <= 200){
                return "幽灵期待level2"
            }else if (favorability > 200) && (favorability <= 300){
                return "幽灵期待level3"
            }else{
                return "幽灵期待level4"
            }
            
        case "幽灵吐舌头":
            if (favorability >= 0) && (favorability <= 100){
                return "幽灵吐舌头"
            }else if (favorability > 100) && (favorability <= 200){
                return "幽灵吐舌头level2"
            }else if (favorability > 200) && (favorability <= 300){
                return "幽灵吐舌头level3"
            }else{
                return "幽灵吐舌头level4"
            }
        default:
            if (favorability >= 0) && (favorability <= 100){
                return "幽灵炫酷左"
            }else if (favorability > 100) && (favorability <= 200){
                return "幽灵炫酷level2"
            }else if (favorability > 200) && (favorability <= 300){
                return "幽灵炫酷level3"
            }else{
                return "幽灵炫酷level4"
            }
        }
    }
    
    // MARK: -init view2 : data
    func initView2(){
        initDailyData()
        lineChartView.delegate = self
        showChart()
        setDailyData()
        calculateDaily()
    }
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var changeChart: UISegmentedControl!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var view2: UIView!
    var yPureArray1:[Double] = []
    var yPureArray2:[Double] = []
    var positiveDx:Double = 0.0
    var positiveaver:Double = 0.0
    var negativeDx:Double = 0.0
    let day7 = Date().toFormat("MM.dd", locale: Locale.current)
    let day6 = (Date() - 1.days).toFormat("MM.dd", locale: Locale.current)
    let day5 = (Date() - 2.days).toFormat("MM.dd", locale: Locale.current)
    let day4 = (Date() - 3.days).toFormat("MM.dd", locale: Locale.current)
    let day3 = (Date() - 4.days).toFormat("MM.dd", locale: Locale.current)
    let day2 = (Date() - 5.days).toFormat("MM.dd", locale: Locale.current)
    let day1 = (Date() - 6.days).toFormat("MM.dd", locale: Locale.current)
    let year = Date().toFormat("YYYY", locale: Locale.current)
    let encourage1 = [
        "努力就是当好运来临的时候，我觉得我值得。",
        "你值得一切美好的事物。",
        "每天攒一点努力和可爱，换取一束光和辽阔的未来。",
        "你所热爱的东西，有一天会反过来拥抱你。",
        "你能成为命运的主宰，无需等待运气垂青。",
        "努力是会上瘾的，特别是在尝到甜头之后。",
        "总有人要赢的，为什么不能是我呢？"]
    let encourage2 = [
        "做一个只记得快乐和知识点的人。",
        "You have a way of brightening my day.",
        "我看到一个更好的自己被困在躯壳里，我想把它救出来。",
        "你能成为不负众望的人。",
        "丧太简单了，顶着一切依旧热爱生活才是真的酷。"]
    let encourage3 = [
        "我把荆棘当做铺满鲜花的原野，人间便没有什么能将我折磨。",
        "觉得力不从心是因为在走上坡路。",
        "要不。。。你也和我一起住在娃娃机里吧~",
        "当你快顶不住的时候，磨难也快顶不住了。",
        "\"煎\"和\"熬\"都是变美味的方式，加油也是。"]
    let encourage4 = [
        "你要偷偷厉害，万事皆可期待。",
        "只能活一次的人生当然要比谁都炙热。",
        "当你松懈的时候，别人正在努力追上你，等你回过头来，就怎么也赶不上了。",
        "自能生羽翼，何必仰云梯。",
        "记得走出舒适圈。"
    ]
    let encourage5 = [
        "为了使灵魂宁静，人每天要做两件不喜欢的事。",
        "未来的路不会比过去更笔直，更平坦，但是我并不恐惧，我眼前还闪动着道路前方野百合和野蔷薇的影子。",
        "带着一丝暖意的风就像透明的输送带，只带来美好的事物。",
        "\"那么，该倚靠什么呢?\"   \"我想，只有自己曾经努力过的事实。\"",
        "你既是狂澜，也是无人能扑灭的火花。"
    ]
    
    
    @IBAction func changeDMY(_ sender: UISegmentedControl) {
        if changeChart.selectedSegmentIndex == 0{
            initDailyData()
            lineChartView.delegate = self
            showChart()
            setDailyData()
            calculateDaily()
        }else if changeChart.selectedSegmentIndex == 1{
            initMonthlyData()
            lineChartView.delegate = self
            showChart()
            setMonthlyData()
            calculateMonthly()
        }else{
            initYearlyData()
            lineChartView.delegate = self
            showChart()
            setYearlyData()
            calculateYearly()
        }
    }
    
    // MARK: -calculate
    func calculateDaily()
    {
        if positiveDx <= 150 && positiveaver >= 85 { // 一直很积极
            let data = arc4random() % UInt32(encourage1.count)
            adviceLabel.text = encourage1[Int(data)]
        } else if positiveDx <= 1000 && positiveDx > 150 { //波动
            let data = arc4random() % UInt32(encourage2.count)
            adviceLabel.text = encourage2[Int(data)]
        } else if positiveDx <= 150 && positiveaver < 50 { //一直很低落
            let data = arc4random() % UInt32(encourage3.count)
            adviceLabel.text = encourage3[Int(data)]
        } else if positiveDx <= 150 && positiveaver > 50 && positiveaver < 85 {
            let data = arc4random() % UInt32(encourage4.count)
            adviceLabel.text = encourage4[Int(data)]
        }else{
            let data = arc4random() % UInt32(encourage5.count)
            adviceLabel.text = encourage5[Int(data)]
        }
    }
    
    func calculateMonthly()
    {
        if positiveDx <= 1050 && positiveaver >= 85 { // 一直很积极
            let data = arc4random() % UInt32(encourage1.count)
            adviceLabel.text = encourage1[Int(data)]
        } else if positiveDx <= 7000 && positiveDx > 150 { //波动
            let data = arc4random() % UInt32(encourage2.count)
            adviceLabel.text = encourage2[Int(data)]
        } else if positiveDx <= 1050 && positiveaver < 50 { //一直很低落
            let data = arc4random() % UInt32(encourage3.count)
            adviceLabel.text = encourage3[Int(data)]
        } else if positiveDx <= 1050 && positiveaver > 50 && positiveaver < 85 {
            let data = arc4random() % UInt32(encourage4.count)
            adviceLabel.text = encourage4[Int(data)]
        }else{
            let data = arc4random() % UInt32(encourage5.count)
            adviceLabel.text = encourage5[Int(data)]
        }
    }
    
    func calculateYearly()
    {
        if positiveDx <= 1500 && positiveaver >= 85 { // 一直很积极
            let data = arc4random() % UInt32(encourage1.count)
            adviceLabel.text = encourage1[Int(data)]
        } else if positiveDx <= 10000 && positiveDx > 150 { //波动
            let data = arc4random() % UInt32(encourage2.count)
            adviceLabel.text = encourage2[Int(data)]
        } else if positiveDx <= 1500 && positiveaver < 50 { //一直很低落
            let data = arc4random() % UInt32(encourage3.count)
            adviceLabel.text = encourage3[Int(data)]
        } else if positiveDx <= 1500 && positiveaver > 50 && positiveaver < 85 {
            let data = arc4random() % UInt32(encourage4.count)
            adviceLabel.text = encourage4[Int(data)]
        }else{
            let data = arc4random() % UInt32(encourage5.count)
            adviceLabel.text = encourage5[Int(data)]
        }
    }
    // MARK: -init data
    
    func initDailyData(){
        yPureArray1 = []
        yPureArray2 = []
        let data1 = Diary.getaverageday(day: year + "." + day1)
        //let data1 = [95.0,5.0]
        yPureArray1.append(data1[0])
        yPureArray2.append(data1[1])
        let data2 = Diary.getaverageday(day: year + "." + day2)
        //let data2 = [90.0,10.0]
        yPureArray1.append(data2[0])
        yPureArray2.append(data2[1])
        let data3 = Diary.getaverageday(day: year + "." + day3)
        //let data3 = [70.0,30.0]
        yPureArray1.append(data3[0])
        yPureArray2.append(data3[1])
        let data4 = Diary.getaverageday(day: year + "." + day4)
        //let data4 = [30.0,70.0]
        yPureArray1.append(data4[0])
        yPureArray2.append(data4[1])
        let data5 = Diary.getaverageday(day: year + "." + day5)
        //let data5 = [50.0,50.0]
        yPureArray1.append(data5[0])
        yPureArray2.append(data5[1])
        let data6 = Diary.getaverageday(day: year + "." + day6)
        //let data6 = [67.0,33.0]
        yPureArray1.append(data6[0])
        yPureArray2.append(data6[1])
        let data7 = Diary.getaverageday(day: year + "." + day7)
        //let data7 = [82.0,18.0]
        yPureArray1.append(data7[0])
        yPureArray2.append(data7[1])
    }
    func initMonthlyData()
    {
        let day = Date().toFormat("YYYY.MM.dd", locale: Locale.current)
        let data = Diary.getaverageweek(day: day)
        //let data = [90.0,10.0,70.0,30.0,30.0,70.0,95.0,5.0,50.0,50.0,67.0,33.0,82.0,18.0]
        for i in 0...13
        {
            if i % 2 == 0
            {
                yPureArray1.append(data[i])
            }
            else
            {
                yPureArray2.append(data[i])
            }
        }
        //print(yPureArray1,yPureArray2)
    }
    
    func initYearlyData()
    {
        let month12 = year + ".12"
        let month11 = year + ".11"
        let month10 = year + ".10"
        let month9 = year + ".09"
        let month8 = year + ".08"
        let month7 = year + ".07"
        let month6 = year + ".06"
        let month5 = year + ".05"
        let month4 = year + ".04"
        let month3 = year + ".03"
        let month2 = year + ".02"
        let month1 = year + ".01"
        let month = [month12, month11, month10, month9, month8, month7, month6, month5, month4, month3, month2, month1]
        for i in 0...11
        {
            let data = Diary.getaveragemonth(year: month[11 - i])
            yPureArray1.append(data[0])
            yPureArray2.append(data[1])
        }
        /*
        for i in 0...9
        {
            let data = Diary.getaveragemonth(year: month[11 - i])
            yPureArray1.append(data[0])
            yPureArray2.append(data[1])
        }
        for _ in 10...11
        {
            let data = [0.0,0.0]
            yPureArray1.append(data[0])
            yPureArray2.append(data[1])
        }*/
    }
    
    // MARK: -show chart
    
    func showChart(){
        
        lineChartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lineChartView.noDataText = "暂无数据"
        
        //设置交互样式
        lineChartView.scaleYEnabled = true //Y轴缩放
        lineChartView.doubleTapToZoomEnabled = true //双击缩放
        lineChartView.dragEnabled = true //启用拖动手势
        lineChartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        lineChartView.dragDecelerationFrictionCoef = 0.9  //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        //  - x轴样式设置
        let xAxis = lineChartView.xAxis
        xAxis.axisLineWidth = 1.0/UIScreen.main.scale //设置X轴线宽
        xAxis.labelPosition = .bottom //X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = false //不绘制网格线
        xAxis.spaceMin = 0 //设置label间隔
        xAxis.axisMinimum = 0
        xAxis.labelTextColor = #colorLiteral(red: 0.4955857396, green: 0.3626317978, blue: 0.6115945578, alpha: 1) //label文字颜色
        xAxis.labelFont = UIFont(name: "Marker Felt", size: 10)!
        //  - y轴样式设置
        lineChartView.rightAxis.enabled = false  //是否绘制右边轴
        let leftAxis = lineChartView.leftAxis
        leftAxis.labelCount = 16 //Y轴label数量，数值不一定
        leftAxis.forceLabelsEnabled = false //不强制绘制指定数量的label
        leftAxis.axisMinimum = 0 //设置Y轴的最小值
        leftAxis.drawZeroLineEnabled = true //从0开始绘制
        leftAxis.axisMaximum = 100 //设置Y轴的最大值
        leftAxis.inverted = false //是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 1.0/UIScreen.main.scale //设置Y轴线宽
        leftAxis.axisLineColor = #colorLiteral(red: 0.4955857396, green: 0.3626317978, blue: 0.6115945578, alpha: 1) //Y轴颜色
        leftAxis.labelPosition = .outsideChart//label位置
        leftAxis.labelTextColor = #colorLiteral(red: 0.4955857396, green: 0.3626317978, blue: 0.6115945578, alpha: 1)
        leftAxis.labelFont = UIFont(name: "Marker Felt", size: 10)!
        
        //设置网格样式
        leftAxis.gridLineDashLengths = [3.0,3.0]  //设置虚线样式的网格线
        leftAxis.gridColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1) //网格线颜色
        leftAxis.gridAntialiasEnabled = true //开启抗锯齿
        
        //  - 设置网格样式
        let litmitLine = ChartLimitLine(limit: 260, label: "限制线")
        litmitLine.lineWidth = 2
        litmitLine.lineColor = UIColor.green
        litmitLine.lineDashLengths = [5.0,5.0] //虚线样式
        litmitLine.labelPosition = .topRight  // 限制线位置
        litmitLine.valueTextColor = UIColor.brown
        litmitLine.valueFont = UIFont.systemFont(ofSize: 12)
        leftAxis.addLimitLine(litmitLine)
        leftAxis.drawLimitLinesBehindDataEnabled = true //设置限制线绘制在折线图的后面
        
        //设置折线图描述及图例样式
        //lineChartView.chartDescription?.text = "" //折线图描述
        lineChartView.chartDescription?.textColor = UIColor.cyan  //描述字体颜色
        lineChartView.legend.form = .line  // 图例的样式
        lineChartView.legend.formSize = 20  //图例中线条的长度
        lineChartView.legend.textColor = UIColor.darkGray
        
    }
    // MARK: -set data
    
    func setDailyData(){
        // - x轴数据数组
        let xValues = [day1, day2, day3, day4, day5, day6, day7]
        lineChartView.xAxis.valueFormatter = KMChartAxisValueFormatter.init(xValues as NSArray)
        let leftValueFormatter = NumberFormatter()  //自定义格式
        leftValueFormatter.positiveSuffix = "%"  //数字后缀单位
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: leftValueFormatter)
        // -  y轴数据数组
        //positive数据数组
        var yDataArray1 = [ChartDataEntry]()
        
        for i in 0...xValues.count-1 {
            let entry = ChartDataEntry.init(x: Double(i), y: yPureArray1[i])
            yDataArray1.append(entry)
        }
        let math1 = Math()
        positiveDx = math1.getSquaredDistance(datas: yPureArray1, average: math1.getAverage(datas: yPureArray1))
        positiveaver = math1.getAverage(datas: yPureArray1)
        //positive样式设置
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: "positive")
        set1.colors = [#colorLiteral(red: 0.4338570833, green: 0.2872386575, blue: 0.5238974094, alpha: 1)]
        set1.drawCirclesEnabled = false //是否绘制转折点
        set1.lineWidth = 1
        set1.mode = .horizontalBezier  //设置曲线是否平滑
        
        //negative数据数组
        var yDataArray2 = [ChartDataEntry]()
        
        for i in 0...(xValues.count-1) {
            let entry = ChartDataEntry.init(x: Double(i), y: yPureArray2[i])
            yDataArray2.append(entry);
        }
        let math2 = Math()
        negativeDx = math2.getSquaredDistance(datas: yPureArray2, average: math2.getAverage(datas: yPureArray2))
        //negative数据样式
        let set2 = LineChartDataSet.init(entries: yDataArray2, label: "negative")
        set2.colors = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
        set2.drawCirclesEnabled = false
        set2.lineWidth = 1
        set2.mode = .horizontalBezier  //设置曲线是否平滑
        
        let data = LineChartData.init(dataSets: [set1,set2])
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 0.5)  //设置动画时间
    }
    func setMonthlyData(){
        // MARK: - x轴数据数组
        let xValues = ["week1", "week2", "week3", "week4", "week5", "week6", "week7"]
        
        lineChartView.xAxis.valueFormatter = KMChartAxisValueFormatter.init(xValues as NSArray)
        
        let leftValueFormatter = NumberFormatter()  //自定义格式
        leftValueFormatter.positiveSuffix = "%"  //数字后缀单位
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: leftValueFormatter)
        // MARK: -  y轴数据数组
        //positive数据数组
        var yDataArray1 = [ChartDataEntry]()
        
        for i in 0...xValues.count-1 {
            let entry = ChartDataEntry.init(x: Double(i), y: yPureArray1[i])
            yDataArray1.append(entry)
        }
        let math1 = Math()
        positiveDx = math1.getSquaredDistance(datas: yPureArray1, average: math1.getAverage(datas: yPureArray1))
        positiveaver = math1.getAverage(datas: yPureArray1)
        //positive样式设置
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: "positive")
        set1.colors = [#colorLiteral(red: 0.4941176471, green: 0.3607843137, blue: 0.6156862745, alpha: 1)]
        set1.drawCirclesEnabled = false //是否绘制转折点
        set1.lineWidth = 1
        set1.mode = .horizontalBezier  //设置曲线是否平滑
        
        //negative数据数组
        var yDataArray2 = [ChartDataEntry]()
        
        for i in 0...(xValues.count-1) {
            let entry = ChartDataEntry.init(x: Double(i), y: yPureArray2[i])
            yDataArray2.append(entry);
        }
        let math2 = Math()
        negativeDx = math2.getSquaredDistance(datas: yPureArray2, average: math2.getAverage(datas: yPureArray2))
        //negative数据样式
        let set2 = LineChartDataSet.init(entries: yDataArray2, label: "negative")
        set2.colors = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
        set2.drawCirclesEnabled = false
        set2.lineWidth = 1
        set2.mode = .horizontalBezier  //设置曲线是否平滑
        
        let data = LineChartData.init(dataSets: [set1,set2])
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 0.5)  //设置动画时间
    }
    func setYearlyData(){
        // MARK: - x轴数据数组
        let xValues = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Octo", "Nov", "Dec"]
        
        lineChartView.xAxis.valueFormatter = KMChartAxisValueFormatter.init(xValues as NSArray)
        
        let leftValueFormatter = NumberFormatter()  //自定义格式
        leftValueFormatter.positiveSuffix = "%"  //数字后缀单位
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: leftValueFormatter)
        // MARK: -  y轴数据数组
        //positive数据数组
        var yDataArray1 = [ChartDataEntry]()
        
        for i in 0...xValues.count-1 {
            let entry = ChartDataEntry.init(x: Double(i), y: yPureArray1[i])
            yDataArray1.append(entry)
        }
        let math1 = Math()
        positiveDx = math1.getSquaredDistance(datas: yPureArray1, average: math1.getAverage(datas: yPureArray1))
        positiveaver = math1.getAverage(datas: yPureArray1)
        //positive样式设置
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: "positive")
        set1.colors = [#colorLiteral(red: 0.4941176471, green: 0.3607843137, blue: 0.6156862745, alpha: 1)]
        set1.drawCirclesEnabled = false //是否绘制转折点
        set1.lineWidth = 1
        set1.mode = .horizontalBezier  //设置曲线是否平滑
        
        //negative数据数组
        var yDataArray2 = [ChartDataEntry]()
        
        for i in 0...(xValues.count-1) {
            let entry = ChartDataEntry.init(x: Double(i), y: yPureArray2[i])
            yDataArray2.append(entry);
        }
        let math2 = Math()
        negativeDx = math2.getSquaredDistance(datas: yPureArray2, average: math2.getAverage(datas: yPureArray2))
        //negative数据样式
        let set2 = LineChartDataSet.init(entries: yDataArray2, label: "negative")
        set2.colors = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
        set2.drawCirclesEnabled = false
        set2.lineWidth = 1
        set2.mode = .horizontalBezier  //设置曲线是否平滑
        
        let data = LineChartData.init(dataSets: [set1,set2])
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 0.5)  //设置动画时间
        lineChartView.setVisibleXRangeMaximum(6)
    }
    
    
    
    // MARK: - 数据格式化
    func showMarkerView(value:String)
    {
        let marker = MarkerView.init(frame: CGRect(x: 20, y: 20, width: 60, height: 20))
        marker.chartView = self.lineChartView
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        label.text = value
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        marker.addSubview(label)
        self.lineChartView.marker = marker
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        self.showMarkerView(value: "\(entry.y)")
    }
    
    
    class KMChartAxisValueFormatter: NSObject,IAxisValueFormatter,IValueFormatter{
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
            //print("======\(value)")
            return String(format:"%.2f%%",value)
        }
        
        var values:NSArray?
        override init()
        {
            super.init()
        }
        
        init(_ values: NSArray)
        {
            super.init()
            self.values = values
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            //此处的value指的是x轴上的第几个数据
            if values == nil {
                return "\(value)"
            }
            return self.values![Int(value)] as! String;
        }
    }
    
    
    
    // MARK: -view3: showcase
    @IBOutlet weak var view3: UIView!
    func initView3(){
        middledSelectedImage.isHidden = true
        qianRate = Test.getUserNumber(user: userName)
        allGhostStyles = Test.userD.getAllDreamStyle(user: userName)
        changeStyle(style: allGhostStyles.count - 1)
    }
    var isItemSelected = false
    var guidanceName = "引导页幽灵不屑"
    var guidanceNo = 1
    //let userName = Test.userD.LoginUserName()
    var allGhostStyles: [String] = []
    var qianRate = 0  //获取签到比例
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var middleImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var middledSelectedImage: UIImageView!
    @IBAction func onChangeButtonPressed(_ sender: UIButton) {
        selectImageView.image = UIImage(named: "sc0.png")
        if allGhostStyles.count > 0{
            showcaseImageStyle = (showcaseImageStyle + 1) % allGhostStyles.count
        }
        changeStyle(style: showcaseImageStyle)
    }
    @IBAction func onSelectPressed(_ sender: UIButton) {
        var images = [UIImage]()
        for i in 0...9{
            let filename = "sc\(i).png"
            let image = UIImage(named: filename)
            images.append(image!)
        }
        self.selectImageView.animationImages = images
        self.selectImageView.animationRepeatCount = 1
        self.selectImageView.animationDuration = 3
        self.selectImageView.startAnimating()
        
        if whetherLiftTheGhost(rate: qianRate) == true{
            //2.9秒之后显示被抓起的那张图
            let time: TimeInterval = 2.9
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
                self.middleImage.isHidden = true
                self.middledSelectedImage.image = self.middleImage.image
                self.middledSelectedImage.isHidden = false
            }
            
            //3.4秒之后跳转到引导页
            let time1: TimeInterval = 3.4
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time1){
                self.isItemSelected = true
                self.ifToARGuidance()
            }
        }
    }
    
    var showcaseImageStyle = 0
    func changeStyle(style: Int){
        switch style {
        case 0:
            leftImage.image = nil
            if allGhostStyles.count > 0{
                middleImage.image = UIImage(named: allGhostStyles[0])!
            }else{
                middleImage.image = nil
            }
            
            if allGhostStyles.count >= 2{
                rightImage.image = UIImage(named: allGhostStyles[1])!
            }else{
                rightImage.image = nil
            }
            if allGhostStyles.count != 0
            {
                guidanceName = getGuidanceNameAndNo(allGhostStyles[0]).name
                guidanceNo = getGuidanceNameAndNo(allGhostStyles[0]).No
            }
            
        case 1: //至少两张
            leftImage.image = UIImage(named:allGhostStyles[0])!
            middleImage.image = UIImage(named: allGhostStyles[1])!
            
            if allGhostStyles.count >= 3{
                rightImage.image = UIImage(named: allGhostStyles[2])!
            }else{
                rightImage.image = nil
            }
            
            guidanceName = getGuidanceNameAndNo(allGhostStyles[1]).name
            guidanceNo = getGuidanceNameAndNo(allGhostStyles[1]).No
            
        case 2: //至少三张
            leftImage.image = UIImage(named:allGhostStyles[1])!
            middleImage.image = UIImage(named: allGhostStyles[2])!
            
            if allGhostStyles.count >= 4{
                rightImage.image = UIImage(named: allGhostStyles[3])!
            }else{
                rightImage.image = nil
            }
            guidanceName = getGuidanceNameAndNo(allGhostStyles[2]).name
            guidanceNo = getGuidanceNameAndNo(allGhostStyles[2]).No
        case 3:
            leftImage.image = UIImage(named:allGhostStyles[2])!
            middleImage.image = UIImage(named: allGhostStyles[3])!
            
            if allGhostStyles.count >= 5{
                rightImage.image = UIImage(named: allGhostStyles[4])!
            }else{
                rightImage.image = nil
            }
            
            guidanceName = getGuidanceNameAndNo(allGhostStyles[3]).name
            guidanceNo = getGuidanceNameAndNo(allGhostStyles[3]).No
        case 4:
            leftImage.image = UIImage(named:allGhostStyles[3])!
            middleImage.image = UIImage(named: allGhostStyles[4])!
            
            if allGhostStyles.count >= 6{
                rightImage.image = UIImage(named: allGhostStyles[5])!
            }else{
                rightImage.image = nil
            }
            
            guidanceName = getGuidanceNameAndNo(allGhostStyles[4]).name
            guidanceNo = getGuidanceNameAndNo(allGhostStyles[4]).No
        case 5:
            leftImage.image = UIImage(named:allGhostStyles[4])!
            middleImage.image = UIImage(named: allGhostStyles[5])!
            rightImage.image = nil
            
            guidanceName = getGuidanceNameAndNo(allGhostStyles[5]).name
            guidanceNo = getGuidanceNameAndNo(allGhostStyles[5]).No
        default:
            break
        }
        print(showcaseToGuidance.self)
    }
    
    func getGuidanceNameAndNo(_ name:String) -> showcaseToGuidance{
        switch name{
        case "幽灵不屑":
            let gui1 = showcaseToGuidance(name: "引导页幽灵不屑", No: 1)
            return gui1
        case "幽灵吐舌头":
            return showcaseToGuidance(name: "引导页幽灵吐舌头", No: 2)
        case "幽灵高兴":
            return showcaseToGuidance(name: "引导页幽灵高兴", No: 3)
        case "幽灵炫酷左":
            return showcaseToGuidance(name: "引导页幽灵炫酷", No: 4)
        case "幽灵期待":
            return showcaseToGuidance(name: "引导页幽灵期待", No: 5)
        default:
            return showcaseToGuidance(name: "引导页幽灵抱歉", No: 6)
        }
    }
    
    func ifToARGuidance(){
        if isItemSelected == true{
            //toARGuidance
            toARGuidance.ARGuidanceName = guidanceName
            toARGuidance.ARGuidanceNo = guidanceNo
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "toARGuidance")
            UIApplication.shared.windows[0].rootViewController = VCMain
        }
    }
    
    func whetherLiftTheGhost(rate: Int) -> Bool{  // rate:2 1 0
        if rate == 2{
            let rand = arc4random_uniform(5) + 1  //1~5的随机数
            return rand < 5  //80%的几率抓到幽灵
        }else if rate == 1{
            let rand = arc4random_uniform(1) //0 1
            return rand < 1  //50%的几率抓到幽灵
        }else{
            let rand = arc4random_uniform(3) //0 1 2 3
            return rand < 1 //25%的几率抓到幽灵
        }
    }
}

struct showcaseToGuidance {
    var name: String
    var No: Int
}


