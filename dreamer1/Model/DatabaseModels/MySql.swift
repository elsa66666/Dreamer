//
//  MySql.swift
//  dreamer1
//
//  Created by 陈宥伊 on 2020/9/20.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import Foundation
import OHMySQL

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
    
    //MARK: userlogin表格
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
        Connect()
        var response: [[String:Any]]
        var name: String = ""
        let queryresult = OHMySQLQueryRequestFactory.select("userlogin", condition: nil)
        if checkConnectStatus()
        {
            do
            {
                response = try self.context!.executeQueryRequestAndFetchResult(queryresult)
                if response.count != 0
                {
                    for row in response {
                        name = String(data: row["name"] as! Data, encoding: String.Encoding.utf8)!
                    }
                }
            }
            catch {
                 print("MySQL_Error:\(error)")
            }
        }
        return name
    }
    
    //MARK: allDream表格
    // allDream插入一个梦想
    func AddNewDream(name: String, ghostName: String, favorablity: Int, ghostStyle: String, tag: String, ispublic: Int)
    {
        Connect()
        let user0 = OHMySQLQueryRequestFactory.insert("allDream", set: ["name": "\(name)", "ghostName": "\(ghostName)", "favorability": "\(favorablity)", "ghostStyle": "\(ghostStyle)", "tag": "\(tag)", "ispublic": "\(ispublic)"])
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
    func getUserPublicDream() -> [[String:Any]]
    {
        Connect()
        let user = LoginUserName()
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
    
    //MARK: detailDream
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

    // detailDream：获得当前用户当前梦想的日记个数
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
    
    // detailDream: 获取某一个日记
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
    
    // detailDream: 删除指定日记
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
    
    // MARK: driftMessage漂流瓶
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
    func getMaxId() -> Int
    {
        Connect()
        var id = 0
        var response: [[String: Any]]
        let queryresult = OHMySQLQueryRequestFactory.select("driftMessage", condition: "")
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
}

