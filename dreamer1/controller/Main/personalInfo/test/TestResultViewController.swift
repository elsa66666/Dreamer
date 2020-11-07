//
//  TestResultViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/8/12.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
import Charts
class TestResultViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var testResultChartView: RadarChartView!
    var resultArray:[Int]?
    var whichKnowledge: Int?
    var introName =
        ["Introduction of Strength","Introduction of Optimism","Introduction of Toughness","Introduction of Confidence","Introduction of Boundary"]
    var marks = [Double]()
    func showChart(){
        resultArray = testData.allmasks()
        
        let result1 = Double(resultArray![0]) / Double(32)
        let str1 = String(format: "%.2f", Double(result1))
        let result11 = Double(str1)
        
        let result2 = Double(resultArray![1]) / Double(16)
        let str2 = String(format: "%.2f", Double(result2))
        let result21 = Double(str2)
        
        let result3 = Double(resultArray![2]) / Double(52)
        let str3 = String(format: "%.2f", Double(result3))
        let result31 = Double(str3)
        
        let result4 = Double(resultArray![3]) / Double(40)
        let str4 = String(format: "%.2f", Double(result4))
        let result41 = Double(str4)
        
        let result5 = Double(resultArray![4]) / Double(72)
        let str5 = String(format: "%.2f", Double(result5))
        let result51 = Double(str5)
        marks = [result11!, result21!, result31!, result41!, result51!]
        
        let dataset = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: result11!),
                RadarChartDataEntry(value: result21!),
                RadarChartDataEntry(value: result31!),
                RadarChartDataEntry(value: result41!),
                RadarChartDataEntry(value: result51!)
            ]
        )
        testResultChartView.data = RadarChartData(dataSet: dataset)
        
        dataset.lineWidth = 2
        dataset.colors = [#colorLiteral(red: 0.3279706538, green: 0.2370257378, blue: 0.4071422517, alpha: 1)]
        dataset.fillColor = #colorLiteral(red: 0.7637575865, green: 0.67724365, blue: 0.8177868128, alpha: 1)
        dataset.drawFilledEnabled = true
        dataset.valueFormatter = DataSetValueFormatter()
        
        testResultChartView.webLineWidth = 1.5
        testResultChartView.innerWebLineWidth = 1.5
        testResultChartView.webColor = .lightGray
        testResultChartView.innerWebColor = .lightGray
        
        // 3
        let xAxis = testResultChartView.xAxis
        xAxis.labelFont = UIFont(name: "Marker Felt", size: 10)!
        xAxis.labelTextColor = .black
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = XAxisFormatter()
        
        // 4
        let yAxis = testResultChartView.yAxis
        yAxis.labelFont = UIFont(name: "Marker Felt", size: 10)!
        yAxis.labelCount = 4
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        yAxis.valueFormatter = YAxisFormatter()
        
        // 5
        testResultChartView.rotationEnabled = true
        testResultChartView.legend.enabled = false
        
        
    }
    class DataSetValueFormatter: IValueFormatter {
        
        func stringForValue(_ value: Double,
                            entry: ChartDataEntry,
                            dataSetIndex: Int,
                            viewPortHandler: ViewPortHandler?) -> String {
            return String(format:"%.2f",value)
        }
    }
    
    // 2
    class XAxisFormatter: IAxisValueFormatter {
        
        let titles = ["Strength","Optimism","Toughness","Confidence","Boundary"]
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            titles[Int(value) % titles.count]
        }
    }
    
    class YAxisFormatter: IAxisValueFormatter {
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            String(format:"%.2f",value)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showChart()
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "IntroductionCell", bundle: nil), forCellWithReuseIdentifier: "IntroCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell", for: indexPath) as! IntroductionCell
        cell.introName.text = introName[indexPath.row]
        
        cell.backgroundColor = #colorLiteral(red: 0.7637575865, green: 0.67724365, blue: 0.8177868128, alpha: 1)
        cell.layer.cornerRadius = 5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        whichKnowledge = indexPath.row
        performSegue(withIdentifier: "toKnowledge", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! KnowledgeViewController
        if segue.identifier == "toKnowledge" {
            destination.whichKnowledge = whichKnowledge!
            destination.marks = marks
        }
    }
    
    @IBAction func testAgainPressed(_ sender: UIButton) {
        let p = UIAlertController(title: "提示", message: "点击确定会重置所有数值哦！", preferredStyle: .alert)
        p.addAction(UIAlertAction(title: "确定", style: .default, handler: {(act: UIAlertAction) in testData.refresh();
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
            UIApplication.shared.windows[0].rootViewController = VCMain
            MTest.returnToTestEntrance = true
        }))
        p.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        present (p,animated: false,completion: nil)
    }
    
    @IBAction func returnPressed(_ sender: UIButton) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
        MTest.returnToTestEntrance = true
    }
    
}
