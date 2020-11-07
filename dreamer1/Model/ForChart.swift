import UIKit
import Charts

class Math{
    static var datas:[Double] = []
    
    func getAverage(datas: [Double]) -> Double{
        var sum:Double = 0.0
        for data in datas{
            sum += data
        }
        return sum/Double(datas.count)
    }
    
    func getSquaredDistance(datas: [Double], average: Double) -> Double{
        var sum1:Double = 0.0
        for data in datas{
            sum1 += (data - average) * (data - average)
        }
        return Double(sum1)/Double(datas.count)
    }
}
