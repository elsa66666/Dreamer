//
//  MySql.swift
//  dreamer1
//
//  Created by 陈宥伊 on 2020/9/20.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import Foundation
import OHMySQL
import SwiftDate
class MySql
{
    private var dbUser: OHMySQLUser?
    private var coordinator: OHMySQLStoreCoordinator?
    private var context: OHMySQLQueryContext?
    
    init() {
        self.dbUser = OHMySQLUser(userName: "dreamer", password: "12354678", serverName: "rm-bp10uvurff224u40pro.mysql.rds.aliyuncs.com", dbName: "dreamers", port: 3306, socket: nil)
        self.coordinator = OHMySQLStoreCoordinator(user: self.dbUser!)
        self.context = OHMySQLQueryContext()
    }
    
    func Connect()
    {
        self.coordinator?.connect()
    }
    
    func Close()
    {
        self.coordinator?.disconnect()
    }
    
    //检查链接状态
    func checkConnectStatus() -> Bool {
        let status = self.coordinator?.isConnected ?? false
        if status {
            if self.context?.storeCoordinator == nil {
                self.context?.storeCoordinator = self.coordinator!
            }
        } else {
            Connect()
        }
        return status
    }
    
    //MARK: user表格
    //user：新增一个用户
    func AddUser(name: String, password: String, gender: String, style: String) {
        Connect()
        if checkConnectStatus()
        {
            let user0 = OHMySQLQueryRequestFactory.insert("user", set: ["name": "\(name)", "password": "\(password)", "gender": "\(gender)", "style": "\(style)", "motto": "Somehow, we are all dreamers."])
            do {
                try self.context!.execute(user0)
            }catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    //user: 获取所有用户的账号以及密码
    func getUserInfo() -> [[String : Any]]
    {
        Connect()
        var response: [[String : Any]]
        if checkConnectStatus()
        {
            let sql = OHMySQLQueryRequestFactory.select("user", condition: nil)
            do{
                response = try context!.executeQueryRequestAndFetchResult(sql)
                return response
            }
            catch{
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return []
    }
    
    func judgeName(name: String) -> Bool
    {
        Connect()
        var response: [[String : Any]]
        if checkConnectStatus()
        {
            let sql = OHMySQLQueryRequestFactory.select("user", condition: nil)
            do{
                response = try context!.executeQueryRequestAndFetchResult(sql)
                if response.count != 0
                {
                    for row in response
                    {
                        let n = String(data: row["name"] as! Data, encoding: String.Encoding.utf8)!
                        if(name == n)
                        {
                            Close()
                            return true
                        }
                    }
                }
                Close()
                return false
            }
            catch{
                print("MySQL_Error:\(error)")
                Close()
                return false
            }
        }
        Close()
        return false
    }
    
    //user: 修改用户名称
    func alterUserName(newName: String)
    {
        Connect()
        let user = LoginUserName()
        let user0 = OHMySQLQueryRequestFactory.update("user", set: ["name": newName], condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        let user1 = OHMySQLQueryRequestFactory.update("userlogin", set: ["name": newName], condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user1)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    //user: 修改用户简介
    func alterUserIntro(intro: String)
    {
        Connect()
        let user = LoginUserName()
        let user0 = OHMySQLQueryRequestFactory.update("user", set: ["motto": intro], condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    //user: 获取用户简介
    func getUserIntro() -> String
    {
        Connect()
        var motto = ""
        let user = LoginUserName()
        var response: [[String : Any]]
        let queryresult = OHMySQLQueryRequestFactory.select("user", condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do{
                response = try context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0{
                    for row in response {
                        motto = String(data: row["motto"] as! Data, encoding: String.Encoding.utf8)!
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return motto
    }
    
    //MARK:- userlogin表格
    //userlogin: 获取用户这个月中已经登陆的天数
    func getUserNumber(user: String) ->Int
    {
        Connect()
        var response: [[String : Any]]
        var num = 0
        let queryresult = OHMySQLQueryRequestFactory.select("userlogin", condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do{
                response = try context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0{
                    for row in response {
                        if row["number"] as? Int != nil {
                            num = row["number"] as! Int
                        }
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        
        if num <= 10
        {
            num = 0
        }
        else if num > 10 && num <= 20
        {
            num = 1
        }
        else
        {
            num = 2
        }
        Close()
        return num
    }
    
    //userlogin: 获取用户最近签到的时间
    func getUserQian1(user: String) -> String
    {
        Connect()
        var response: [[String : Any]]
        var qian = ""
        let queryresult = OHMySQLQueryRequestFactory.select("userlogin", condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response {
                        if row["qian"] as? String != nil {
                            qian = row["qian"] as! String
                        }
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return qian
    }
    
    //userlogin：用户登陆新增一条
     func LoginSuccess(id: Int, name: String, style: String, user: String) {
        let num = getUserNumber(user: user)
         print("num="+"\(num)")
        let qian = getUserQian1(user: user)
        let date = Date()
        let timeFormatter = DateFormatter()
        //日期显示格式，可按自己需求显示
        timeFormatter.dateFormat = "yyy-MM-dd' at 'HH:mm:ss.SSS"
        let strNowTime = timeFormatter.string(from: date) as String
        Connect()
        let user0 = OHMySQLQueryRequestFactory.insert("userlogin", set: ["id": "\(id)", "name": "\(name)", "style": "\(style)", "qian": "\(qian)", "number": "\(num)", "time": "\(strNowTime)"])
        print(checkConnectStatus())
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
     }
    
    func getUserStyle() -> [Any]
    {
        //查询数据库"userLogin"的最后一行，即刚刚登录时存入的数据
        Connect()
        var response: [[String : Any]]
        var result: [Any]
        var style: String = ""
        var id = 0
        var name = ""
        let queryresult = OHMySQLQueryRequestFactory.select("userlogin", condition: nil)
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response {
                        if row["num"]! as! Int == response.count
                        {
                            style = String(data: row["style"] as! Data, encoding: String.Encoding.utf8)!
                            id = row["id"]! as! Int
                            name = String(data: row["name"] as! Data, encoding: String.Encoding.utf8)!
                        }
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        result = [style, id, name]
        print(result)
        Close()
        return result
    }
    
    // userlogin：返回当前登陆的用户名字
    func LoginUserName() -> String
    {
        return Test.name
    }
    //登录的user的ID
    func LoginUserID() -> Int
    {
        Connect()
        var response: [[String:Any]]
        var id: Int = 0
        let queryresult = OHMySQLQueryRequestFactory.select("userlogin", condition: nil)
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response {
                        id = row["id"] as! Int
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        return (id + 10000)
    }
    //MARK:- allDream表格
    // allDream插入一个梦想
    func AddNewDream(name: String, ghostName: String, favorablity: Int, ghostStyle: String, tag: String, ispublic: Int)
    {
        Connect()
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let date1 = timeFormatter.string(from: date as Date) as String
        let user0 = OHMySQLQueryRequestFactory.insert("allDream", set: ["name": "\(name)",
            "ghostName": "\(ghostName)",
            "favorability": "\(favorablity)",
            "ghostStyle": "\(ghostStyle)",
            "tag": "\(tag)",
            "ispublic": "\(ispublic)",
            "likeCount": 0,
            "createDate": "\(date1)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    func deleteDream(ghostName: String)
    {
        Connect()
        let queryresult = OHMySQLQueryRequestFactory.delete("allDream", condition: "ghostName = '\(ghostName)'")
        if checkConnectStatus()
        {
            do
            {
                try self.context!.execute(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    // allDream获取用户所有梦想的名字
    func getAllDreamName(user: String) -> [String]
    {
        Connect()
        var Name: [String] = []
        var response: [[String: Any]]
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response {
                        if String(data: row["ghostName"] as! Data, encoding: String.Encoding.utf8) != nil  {
                            Name.append(String(data: row["ghostName"] as! Data, encoding: String.Encoding.utf8)!)
                        }
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return Name
    }
    
    //获取用户所有的好感度之和
    func getAllDreamFavorSum() -> Int
    {
        Connect()
        let user = LoginUserName()
        var response: [[String: Any]]
        var sum = 0
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response {
                        sum += row["favorability"] as! Int
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return sum
    }
    
    // allDream获取全部梦想信息
    func getAllDreamInfo(user: String) -> [[String:Any]]
    {
        Connect()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                Close()
                return response
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    // allDream: 好感度变化
    func AddFavor(ghostName: String, add: Int)
    {
        Connect()
        var response: [[String:Any]] = []
        let userName = LoginUserName()
        var favor = 0
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(userName)' AND ghostName = '\(ghostName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        favor = row["favorability"] as! Int + add
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        let user0 = OHMySQLQueryRequestFactory.update("allDream", set: ["favorability": favor], condition: "name = '\(userName)' AND ghostName = '\(ghostName)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    func changeDreamPublicize(ghostName: String)
    {
        Connect()
        var response: [[String:Any]] = []
        let userName = LoginUserName()
        var publicize = 0
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(userName)' AND ghostName = '\(ghostName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        publicize = row["ispublic"] as! Int
                        if (publicize == 0){
                            publicize = 1
                        }else{
                            publicize = 0
                        }
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        let user0 = OHMySQLQueryRequestFactory.update("allDream", set: ["ispublic": publicize], condition: "name = '\(userName)' AND ghostName = '\(ghostName)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    // 点赞
    func AddLikeToDream(ghostName: String)
    {
        Connect()
        var response: [[String:Any]] = []
        let userName = LoginUserName()
        var likeCount = 0
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(userName)' AND ghostName = '\(ghostName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        likeCount = row["likeCount"] as! Int + 1
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        let user0 = OHMySQLQueryRequestFactory.update("allDream", set: ["favorability": likeCount], condition: "name = '\(userName)' AND ghostName = '\(ghostName)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    // 娃娃机不重复款式
    func getAllDreamStyle(user: String) -> [String]
    {
        Connect()
        var response: [[String:Any]] = []
        var style: [String] = []
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(user)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        if style.contains(String(data: row["ghostStyle"] as! Data, encoding: String.Encoding.utf8)!) == false
                        {
                            style.append(String(data: row["ghostStyle"] as! Data, encoding: String.Encoding.utf8)!)
                        }
                    }
                }
                Close()
                return style
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return style
    }
    
    //allDream: 获取所有公开梦想
    func getUserPublicDream(user: String) -> [[String:Any]]
    {
        Connect()
        //let user = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("allDream", condition: "name = '\(user)' AND ispublic = 1")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }        
        Close()
        return response
    }
    
    //MARK:- detailDream
    // detailDream插入一个新日记1(保存背景图片)
    
    func SaveImage(img:UIImage?,id: Int)
    {
        /*
        Connect()
        let data = img!.jpegData(compressionQuality: 1.0)! as NSData
        let user0 = OHMySQLQueryRequestFactory.update("detailDream", set: ["backPicture": data as Any], condition: "id = '\(id)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()*/
    }
    
    // detailDream插入一个新日记2(保存文字中间图片)
    func SaveImage1(img:Data?, id: Int)
    {
        /*
        Connect()
        let data = img! as NSData
        let user0 = OHMySQLQueryRequestFactory.update("detailDream", set: ["picture": data as Any], condition: "id = '\(id)'")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()*/
    }
    
    // detailDream插入一个新日记3(保存除图片以外的信息）
    func insertDB(name: String,back: UIImage, type: Int,words: String,voice: String,positive: String,negative: String)
    {
        /*
        Connect()
        let userName = LoginUserName()
        let time = Date().toFormat("YYYY.MM.dd", locale: Locale.current)
        let user0 = OHMySQLQueryRequestFactory.insert("detailDream", set: ["user": "\(userName)", "ghostName": "\(name)", "type": "\(type)", "words": "\(words)", "style": "\(voice)", "time": "\(time)", "positive": "\(positive)", "negative": "\(negative)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()*/
    }
    
    // detailDream: 展现背景图片
    func LoadImage(id: Int) ->UIImage
    {
        /*
        Connect()
        var response: [[String:Any]] = []
        var data: NSData?
        let queryresult = OHMySQLQueryRequestFactory.select("detailDream", condition: "id = '\(id)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        data = row["backPicture"] as? NSData
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        if data != nil
        {
            Close()
            let data0 = Data(bytes: data!.bytes, count: data!.length)
            return UIImage(data: data0)!
        }
        else
        {
            Close()
            return UIImage(named: "transparent")!
        }*/
        return UIImage(named: "transparent")!
    }
    
    // detailDream: 展现表情包
    func LoadImage1(id: Int) ->Data?
    {
        /*
        Connect()
        var response: [[String:Any]] = []
        var data: NSData?
        let queryresult = OHMySQLQueryRequestFactory.select("detailDream", condition: "id = '\(id)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        data = row["picture"] as? NSData
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        if data != nil
        {
            Close()
            return Data(bytes: data!.bytes, count: data!.length)
        }
        else
        {
            Close()
            let image = UIImage(named: "transparent")
            return image!.pngData()
        }*/
        return nil
    }


    // detailDream: 获得当前用户当前梦想的日记个数(不使用此函数！)
    func getId(name: String) -> Int
    {
        Connect()
        var response: [[String:Any]] = []
        var id = 0
        let userName = LoginUserName()
        let queryresult = OHMySQLQueryRequestFactory.select("detailDream", condition: "user = '\(userName)' AND ghostName = '\(name)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        id = row["id"] as! Int
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return id
    }
    
    // detailDream: 获取当前用户当前梦想下所有日记
    func getAllDiaries(userName: String, ghostName: String) -> [[String:Any]]
    {
        Connect()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("detailDream", condition: "user = '\(userName)' AND ghostName = '\(ghostName)' AND type = 0")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    // detailDream: 获取某一个日记（不使用）
    func getSpeDiary(userName: String, ghostName: String, words: String, style: String) -> [[String:Any]]
    {
        Connect()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("detailDream", condition: "user = '\(userName)' AND ghostName = '\(Diary.ghostName)' AND words = '\(words)' AND style = '\(style)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    // detailDream: 删除指定日记（不使用）
    func deleteARow(id: Int)
    {
        Connect()
        let queryresult = OHMySQLQueryRequestFactory.delete("detailDream", condition: "id = \(id)")
        if checkConnectStatus()
        {
            do
            {
                try self.context!.execute(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    
    // detailDream: 展示日记重新加载
    func reload(userName: String, ghostName: String) -> [[String:Any]]
    {
        Connect()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("detailDream", condition: "user = '\(userName)' AND ghostName = '\(ghostName)' AND type = 0")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    // detailDream: 获取当前用户当前梦想所有日记的id
    func getpicID(name: String) -> [Int]
    {
        Connect()
        let userName = LoginUserName()
        var id: [Int] = []
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("detailDream", condition: "user = '\(userName)' AND ghostName = '\(name)' AND type = 0")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        id.append(row["id"] as! Int)
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return id
    }
    
    // MARK: - user data(emotion)
    func addUserEmotion(positive: Float, negative:Float){
        Connect()
        let name = LoginUserName()
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "YYYY-MM-dd"
        let date1 = timeFormatter.string(from: date as Date) as String
        let user0 = OHMySQLQueryRequestFactory.insert("userData", set: ["user": "\(name)",
            "positive": "\(positive)",
            "negative": "\(negative)",
            "time": "\(date1)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    func getAverageDay(date: String) -> [Double]{
        Connect()
        let userName = LoginUserName()
        var average: [Double] = [0.0,0.0]
        var response: [[String:Any]] = []
        var positiveAverage = 0.0
        var negativeAverage = 0.0
        let queryresult = OHMySQLQueryRequestFactory.select("userdata", condition: "user = '\(userName)' AND time = '\(date)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        let numP = row["positive"] as! NSNumber
                        let numN = row["negative"] as! NSNumber
                        print(numP, numN)
                        positiveAverage += numP.doubleValue * 100.0
                        negativeAverage += numN.doubleValue * 100.0
                    }
                    positiveAverage = positiveAverage / Double(response.count)
                    negativeAverage = negativeAverage / Double(response.count)
                    average[0] = positiveAverage
                    average[1] = negativeAverage
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return average
    }

    
    // MARK: - driftMessage漂流瓶
    // driftMessage: 发送一个新漂流瓶
    func sendDriftMessage(title: String, cont: String)
    {
        let userName = LoginUserName()
        Connect()
        let user0 = OHMySQLQueryRequestFactory.insert("driftMessage", set: ["title": "\(title)", "context": "\(cont)", "sender": "\(userName)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    // driftMessage: 获取最大id数
    func getAllDriftMessages() -> [[String: Any]]
    {
        Connect()
        var response: [[String: Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("driftMessage", condition: "")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    // driftMessage: 返回指定message
    func getRandomMessage(id: Int) -> [[String: Any]]?
    {
        Connect()
        var response: [[String: Any]]?
        let queryresult = OHMySQLQueryRequestFactory.select("driftMessage", condition: "id = '\(id)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    func getDriftComment(driftID: Int) -> [[String: Any]]?{
        Connect()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("driftcomment", condition: "driftID = '\(driftID)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    func AddDriftComment(content: String, receiver: String,forDriftID: Int)
    {
        let userName = LoginUserName()
        Connect()
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = timeFormatter.string(from: date as Date) as String
        let user0 = OHMySQLQueryRequestFactory.insert("driftcomment", set:
            ["driftID": forDriftID,
             "commentorName": "\(userName)",
                "comment": "\(content)",
                "receiverName":"\(receiver)",
                "commentTime": "\(date1)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    func getDriftCommentMessageForMe() -> [[String:Any]]{
        Connect()
        var response: [[String:Any]] = []
        let myName = LoginUserName()
        let queryresult = OHMySQLQueryRequestFactory.select("driftcomment", condition: "receiverName = '\(myName)' AND visible=1")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    func knowCommentMessageToMe(autoID: Int)
    {
        Connect()
        let user1 = OHMySQLQueryRequestFactory.update("driftcomment",
        set: ["visible": 0],
        condition: "autoID = '\(autoID)'")
        if checkConnectStatus()
        {
            do
            {
                try self.context!.execute(user1)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    //所有我发送的漂流瓶
    func getAllMyPosts() -> [[String:Any]]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("driftmessage", condition: "sender = '\(userName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }

     // MARK: - timeline
    func getAllNoteContentForBubble() ->[String]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("timeline", condition: "userName = '\(userName)'")
        var content = ""
        var contentArray:[String] = []
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response
                    {
                        content = String(data: row["content"] as! Data, encoding: String.Encoding.utf8)!
                        contentArray.append(content)
                    }
                }
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return contentArray
    }
    
    func getAllNotes() ->[[String:Any]]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("timeline", condition: "userName = '\(userName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    func AddNewNote(content: String, color: String)
    {
        let userName = LoginUserName()
        Connect()
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = timeFormatter.string(from: date as Date) as String
        let user0 = OHMySQLQueryRequestFactory.insert("timeline", set:
            ["userName": "\(userName)",
                "date": "\(date1)",
                "content": "\(content)",
                "color": "\(color)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    func deleteNote(id: Int)
    {
        Connect()
        let queryresult = OHMySQLQueryRequestFactory.delete("timeline", condition: "id = \(id)")
        if checkConnectStatus()
        {
            do
            {
                try self.context!.execute(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    // MARK: - friendRequest
    func AddFriendRequest(receiverName: String,senderWord:String)
    {
        let senderName = LoginUserName()
        Connect()
        let user0 = OHMySQLQueryRequestFactory.insert("friendrequest", set:
            [
             "senderName": "\(senderName)",
                "receiverName":"\(receiverName)",
                "senderWord": "\(senderWord)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    func getRequestsToMe() ->[[String:Any]]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("friendRequest", condition: "receiverName = '\(userName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    func deleteRequest(id: Int)
    {
        Connect()
        let queryresult = OHMySQLQueryRequestFactory.delete("friendrequest", condition: "requestID = \(id)")
        if checkConnectStatus()
        {
            do
            {
                try self.context!.execute(queryresult)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    func AcceptFriend(friendName: String){
        Connect()
        let userName = LoginUserName()
        let user0 = OHMySQLQueryRequestFactory.insert("messageindex", set: ["personA": "\(friendName)",
            "personB": "\(userName)",
            "messageContent": ""])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    // MARK: - like friend‘s dream
    // add like to friend's dream
    func LikeFriendDream(friendName: String, dreamName: String, likeCount: Int)
    {
        Connect()
        let myName = LoginUserName()
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = timeFormatter.string(from: date as Date) as String
        let user0 = OHMySQLQueryRequestFactory.insert("likedream", set: ["likeSenderName": "\(myName)",
            "likeReceiverName": "\(friendName)",
            "likedDreamName": "\(dreamName)",
            "likedTime": "\(date1)"])
        let user1 = OHMySQLQueryRequestFactory.update("alldream",
        set: ["likeCount": likeCount],
        condition: "name = '\(friendName)' AND ghostName = '\(dreamName)'")
        
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
                try context!.execute(user1)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    func ifILikedThisDream(friendName: String, dreamName: String) ->Bool{
        Connect()
        let userName = LoginUserName()
        var flag = false
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("likedream", condition: "likeSenderName = '\(userName)' AND likeReceiverName = '\(friendName)' AND likedDreamName = '\(dreamName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count == 0
                {
                    flag = false
                }else{
                    flag = true
                }
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return flag
    }

    func dislikeFriendDream(friendName: String, dreamName: String, likeCount: Int)
    {
        Connect()
        let userName = LoginUserName()
        let queryresult = OHMySQLQueryRequestFactory.delete("likedream", condition: "likeSenderName = '\(userName)' AND likeReceiverName = '\(friendName)' AND likedDreamName = '\(dreamName)'")
        let user1 = OHMySQLQueryRequestFactory.update("alldream",
        set: ["likeCount": likeCount],
        condition: "name = '\(friendName)' AND ghostName = '\(dreamName)'")
        if checkConnectStatus()
        {
            do
            {
                try self.context!.execute(queryresult)
                try self.context!.execute(user1)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    func getAllLikeMessagesToMe() -> [[String:Any]]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("likedream", condition: "likeReceiverName = '\(userName)' AND visible = 1")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    func knowLikeMessageToMe(friendName: String, dreamName: String)
    {
        Connect()
        let userName = LoginUserName()
        let user1 = OHMySQLQueryRequestFactory.update("likedream",
        set: ["visible": 0],
        condition: "likeSenderName = '\(friendName)' AND likeReceiverName = '\(userName)' AND likedDreamName = '\(dreamName)'")
        if checkConnectStatus()
        {
            do
            {
                try self.context!.execute(user1)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    // MARK: - comment friend dream
    func getDreamComment(friendName: String, dreamName: String) -> [[String: Any]]?{
          Connect()
          var response: [[String:Any]] = []
          let queryresult = OHMySQLQueryRequestFactory.select("commentdream", condition: "friendName = '\(friendName)' AND friendDreamName = '\(dreamName)'")
          if checkConnectStatus()
          {
              do
              {
                  response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
              }
              catch {
                  print("MySQL_Error:\(error)")
              }
          }
          Close()
          return response
      }
      
      func AddpDreamComment(content: String, friendName: String,friendDreamName: String){
          let userName = LoginUserName()
          Connect()
          let date = NSDate()
          let timeFormatter = DateFormatter()
          timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let date1 = timeFormatter.string(from: date as Date) as String
          
        let user0 = OHMySQLQueryRequestFactory.insert("commentdream", set:
              ["myName": "\(userName)",
               "friendDreamName": "\(friendDreamName)",
                  "commentContent": "\(content)",
                  "friendName":"\(friendName)",
                  "commentTime": "\(date1)"])
          if checkConnectStatus()
          {
              do{
                  try context!.execute(user0)
              }
              catch {
                   print("MySQL_Error:\(error)")
              }
          }
          Close()
      }

    
    // MARK: - message(Chat)
    func getChatInShort() ->[[String:Any]]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("messageIndex", condition: "personA = '\(userName)' OR personB = '\(userName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }
    
    func getChatMessageInDetail(friendName: String) -> [[String: Any]]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        let queryresult = OHMySQLQueryRequestFactory.select("messagedetail", condition: "(senderName = '\(userName)' AND receiverName = '\(friendName)') OR (senderName = '\(friendName)' AND receiverName = '\(userName)')")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return response
    }

    func AddMessage(receiver:String, content: String){
        Connect()
        let userName = LoginUserName()
        let user0 = OHMySQLQueryRequestFactory.insert("messagedetail", set: ["senderName": "\(userName)",
            "receiverName": "\(receiver)",
            "content": "\(content)"])
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    // 修改聊天内容in short
    func ChangeMessageIndexContent(friendName: String, content: String)
    {
        Connect()
        let userName = LoginUserName()
        let user0 = OHMySQLQueryRequestFactory.update("messageindex",
                  set: ["messageContent": content],
                  condition: "(personA = '\(userName)' AND personB = '\(friendName)') OR (personB = '\(userName)' AND personA = '\(friendName)')")
        if checkConnectStatus()
        {
            do{
                try context!.execute(user0)
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        Close()
    }
    
    // MARK: -  心理测评
    func getFavorForMentalTest() -> [Int]{
        Connect()
        let userName = LoginUserName()
        var response: [[String:Any]] = []
        var favor = [0,0,0,0,0,0]
        let queryresult = OHMySQLQueryRequestFactory.select("alldream", condition: "name = '\(userName)'")
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                for row in response
                {
                    let style = String(data: row["ghostStyle"] as! Data, encoding: String.Encoding.utf8)
                    if (style == "幽灵不屑") && (row["favorability"] as! Int > favor[0])
                    {
                        favor[0] = row["favorability"] as! Int
                    }
                    if style == "幽灵吐舌头" && row["favorability"] as! Int > favor[1]
                    {
                        favor[1] = row["favorability"] as! Int
                    }
                    if style == "幽灵高兴" && row["favorability"] as! Int > favor[2]
                    {
                        favor[2] = row["favorability"] as! Int
                    }
                    if style == "幽灵炫酷左" && row["favorability"] as! Int > favor[3]
                    {
                        favor[3] = row["favorability"] as! Int
                    }
                    if style == "幽灵期待" && row["favorability"] as! Int > favor[4]
                    {
                        favor[4] = row["favorability"] as! Int
                    }
                    if style == "幽灵抱歉" && row["favorability"] as! Int > favor[5]
                    {
                        favor[5] = row["favorability"] as! Int
                    }
                }
            }
            catch {
                print("MySQL_Error:\(error)")
            }
        }
        Close()
        return favor
    }
}

