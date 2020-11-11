//
//  Util.swift
//  dreamer1
//
//  Created by Elsa Shaw on 2020/11/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import Foundation
class Util{
    /// Date类型转化为日期字符串
    ///
    /// - Parameters:
    ///   - date: Date类型
    ///   - dateFormat: 格式化样式默认“yyyy-MM-dd”
    /// - Returns: 日期字符串
    static func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    /// 日期字符串转化为Date类型
      ///
      /// - Parameters:
      ///   - string: 日期字符串
      ///   - dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
      /// - Returns: Date类型
      static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
          let dateFormatter = DateFormatter.init()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let date = dateFormatter.date(from: string)
          return date!
      }
}


