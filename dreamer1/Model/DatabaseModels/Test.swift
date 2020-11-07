import UIKit
import SwiftDate

class Test {
    static var amount: Int = 0
    static var fullPath: String = ""
    static var jumpD: MainViewController? = nil
    static var jumpDia: Bool = false
    static var jumpSta: Bool = false
    static var userD = MySql()
    
// MARK: - register
    static func initUserDB() {
        let sqlite = SQliteManager.sharedInstance
        
        if !sqlite.openDB(){ return }
        
        let createSql = "CREATE TABLE IF NOT EXISTS user('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "+" 'name' TEXT,"+"'password' TEXT,"+"'gender' Text,"+"'style' Text);"
        
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB() 
    }
    
    static func AddUser(name: String, password: String, gender: String, style: String) {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){ return }
        let user0 = "INSERT INTO user(name,password,gender,style) VALUES('\(name)','\(password)','\(gender)','\(style)');"
        if !sqlite.execNoneQuerySQL(sql: user0) { sqlite.closeDB(); return; }
        sqlite.closeDB()
    }

    static func getUserStyle() ->String
    {
        var style = ""
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() { return style}
        let queryresult = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin")
        if queryresult != nil{
            for row in queryresult! {
                if row["num"]! as! Int == queryresult!.count {
                    style = row["style"]! as! String
                }
            }
        }
        return style
    }
    
    static func getUserQian() ->String
    {
        let userName = Test.LoginUserName()
        var qian = ""
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() { return qian}
        let queryresult = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin WHERE name = '\(userName)'")
        if queryresult != nil{
            for row in queryresult! {
                if row["qian"] as? String != nil {
                    qian = row["qian"] as! String
                }
            }
        }
        return qian
    }
    
    static func getUserQian1(user: String) ->String
    {
        var qian = ""
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() { return qian}
        let queryresult = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin WHERE name = '\(user)'")
        if queryresult != nil{
            for row in queryresult! {
                if row["qian"] as? String != nil {
                    qian = row["qian"] as! String
                }
            }
        }
        return qian
    }
    
    static func getUserNumber(user: String) ->Int
    {
        var num = 0
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() { return num}
        let queryresult = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin WHERE name = '\(user)'")
        if queryresult != nil{
            for row in queryresult! {
                if row["number"] as? Int != nil {
                    num = row["number"] as! Int
                }
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
        return num
    }
    
// MARK: - timeline
    static func initTimelineDB() {
        let sqlite = SQliteManager.sharedInstance
        
        if !sqlite.openDB(){ return }
        
        let createSql = "CREATE TABLE IF NOT EXISTS timeline('num' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "+"'id' INTEGER,"+"'date' TEXT,"+"'content' TEXT,"+"'color' Text);"
        
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
        
    }
    
    static func AddTimelineItem(content: String, color: String){
       let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){ return }
        
        let id = (LoginUserId() as NSString).integerValue
        
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = timeFormatter.string(from: date as Date) as String
        let user0 = "INSERT INTO timeline(id,date,content,color) VALUES('\(id)','\(date1)','\(content)','\(color)');"
        if !sqlite.execNoneQuerySQL(sql: user0) { sqlite.closeDB(); return; }
        sqlite.closeDB()

    }
    
    static func DeleteTimelineItem(time: String) {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){ return }
        let user0 = "DELETE FROM timeline WHERE date='\(time)'"
        if !sqlite.execNoneQuerySQL(sql: user0) { sqlite.closeDB(); return; }
    }
    
    
// MARK: - login
    static func initUserLoginDB() {
        let sqlite = SQliteManager.sharedInstance
        
        if !sqlite.openDB(){ return }
        
        let createSql = "CREATE TABLE IF NOT EXISTS userLogin('num' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"+"'name' TEXT,"+"'id' INTEGER,"+"'style' Text,"+"'qian' Text,"+"'number' INTEGER);"
        
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
    }
    
    static func LoginSuccess(id: Int, name: String, style: String, user: String) {
        let num = Test.getUserNumber(user: user)
        print("num="+"\(num)")
        let qian = Test.getUserQian1(user: user)
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){ return }
        let user0 = "INSERT INTO userLogin(id,name,style,qian,number) VALUES('\(id)','\(name)','\(style)','\(qian)',\(num));"
        if !sqlite.execNoneQuerySQL(sql: user0) { sqlite.closeDB(); return; }
    }
    
    static func qianDao()
    {
        let userName = Test.LoginUserName()
        let date0 = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let date = timeFormatter.string(from: date0 as Date) as String
        let num = Test.getUserNumber(user: userName) + 1
        
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){ return }
        if date.hasSuffix("01")
        {
            let updateSql = "UPDATE userLogin SET number = 0 WHERE name = '\(userName)'"
            if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB(); return}
        }
        let updateSql1 = "UPDATE userLogin SET qian = '\(date)' WHERE name = '\(userName)'"
        if !sqlite.execNoneQuerySQL(sql: updateSql1){sqlite.closeDB(); return}
        let updateSql2 = "UPDATE userLogin SET number = '\(num)' WHERE name = '\(userName)'"
        if !sqlite.execNoneQuerySQL(sql: updateSql2){sqlite.closeDB(); return}
        sqlite.closeDB()
    }
    
    static func LoginUserName() ->String
    {
        var userName: String = ""
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return userName}
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin")
        for row in querySql!
        {
            userName = row["name"] as? String ?? ""
        }
        sqlite.closeDB()
        return userName
    }
    
    static func LoginUserId() ->String
     {
         var userId: String = ""
         let sqlite = SQliteManager.sharedInstance
         if !sqlite.openDB() {return userId}
         let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM userLogin")
         for row in querySql!
         {
             userId = "\(row["id"] as? Int ?? 0)"
         }
         sqlite.closeDB()
         return userId
     }

// MARK: - dreams
    static func initAllDreamDB() {
        let sqlite = SQliteManager.sharedInstance
        
        if !sqlite.openDB(){ return }
        
        let createSql = "CREATE TABLE IF NOT EXISTS allDream('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "+" 'name' TEXT,"+" 'ghostName' Text,"+"'favorability' INTEGER,"+"'ghostStyle' Text,"+"'rf' INTEGER);"
        
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
    }
    
    static func getAllDreamStyle() -> [String]
    {
        let userName = Test.LoginUserName()
        var alldream: [String] = []
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return alldream}
        let sql = sqlite.executeQuerySQL(sql: "SELECT * FROM allDream WHERE name = '\(userName)'")
        if sql != nil
        {
            for row in sql!
            {
                if alldream.contains(row["ghostStyle"] as! String) == false
                {
                    alldream.append(row["ghostStyle"] as! String)
                }
            }
        }
        sqlite.closeDB()
        return alldream
    }
    
    static func getDreamID() -> Int
    {
        let userName = Test.LoginUserName()
        var did = 0
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return did}
        let queryResult = sqlite.executeQuerySQL(sql: "SELECT * FROM allDream WHERE name = '\(userName)'")
        for row in queryResult!
        {
            did = row["rf"] as! Int
        }
        sqlite.closeDB()
        return did
    }
    
    static func deleteDB(name: String)
    {
        let userName = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let deleteSql = "DELETE FROM allDream "+" WHERE ghostName = '\(name)' AND name = '\(userName)'"
        if !sqlite.execNoneQuerySQL(sql: deleteSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
    }
    
    
    static func AddDream(name: String, ghostName: String, favorablity: Int, ghostStyle: String) {
        let did = Test.getDreamID()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){ return }
        if did == 0
        {
            let user0 = "INSERT INTO allDream(name,ghostName,favorability, ghostStyle,rf) VALUES('\(name)','\(ghostName)',\(favorablity),'\(ghostStyle)',1);"
            if !sqlite.execNoneQuerySQL(sql: user0) { sqlite.closeDB(); return; }
        }
        else
        {
            let user0 = "INSERT INTO allDream(name,ghostName,favorability, ghostStyle,rf) VALUES('\(name)','\(ghostName)',\(favorablity),'\(ghostStyle)',0);"
            if !sqlite.execNoneQuerySQL(sql: user0) { sqlite.closeDB(); return; }
        }
        sqlite.closeDB()
    }
    
    static func Rearrangement()
    {
        let userName = Test.LoginUserName()
        var num = 0
        var user = ""
        var ghost = ""
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM allDream WHERE name = '\(userName)'")
        for row in querySql!
        {
            user = row["name"] as! String
            ghost = row["ghostName"] as! String
            if num % 2 == 0
            {
                let updateSql = "UPDATE allDream SET rf = 1 WHERE name = '\(user)' AND ghostName = '\(ghost)'"
                if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB(); return}
            }
            else
            {
                let updateSql = "UPDATE allDream SET rf = 0 WHERE name = '\(user)' AND ghostName = '\(ghost)'"
                if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB(); return}
            }
            num += 1
        }
        sqlite.closeDB()
    }
    
    static func AddFavor(ghostName: String, add: Int)
    {
        let userName = Test.LoginUserName()
        var favor = 0
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM allDream WHERE name = '\(userName)' AND ghostName = '\(ghostName)'")
        for row in querySql!
        {
            favor = row["favorability"] as! Int + add
        }
        let updateSql = "UPDATE allDream SET favorability = \(favor) WHERE name = '\(userName)' AND ghostName = '\(ghostName)'"
        if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB();return}
        sqlite.closeDB()
    }
    
    static func GiveUpDelete(favor: Int, name: String)
    {
        let userName = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let updateSql = "UPDATE allDream SET favorability = \(favor) WHERE name = '\(userName)' AND ghostName = '\(name)'"
        if !sqlite.execNoneQuerySQL(sql: updateSql) {sqlite.closeDB(); return}
        sqlite.closeDB()
    }
    
    static func getfavor() -> [Int]
    {
        var favor = [0,0,0,0,0,0]
        let userName = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return favor}
        let sql = sqlite.executeQuerySQL(sql: "SELECT * from allDream WHERE name = '\(userName)'")
        for row in sql!
        {
            if row["ghostStyle"] as! String == "幽灵不屑" && row["favorability"] as! Int > favor[0]
            {
                favor[0] = row["favorability"] as! Int
            }
            if row["ghostStyle"] as! String == "幽灵吐舌头" && row["favorability"] as! Int > favor[1]
            {
                favor[1] = row["favorability"] as! Int
            }
            if row["ghostStyle"] as! String == "幽灵高兴" && row["favorability"] as! Int > favor[2]
            {
                favor[2] = row["favorability"] as! Int
            }
            if row["ghostStyle"] as! String == "幽灵炫酷左" && row["favorability"] as! Int > favor[3]
            {
                favor[3] = row["favorability"] as! Int
            }
            if row["ghostStyle"] as! String == "幽灵期待" && row["favorability"] as! Int > favor[4]
            {
                favor[4] = row["favorability"] as! Int
            }
            if row["ghostStyle"] as! String == "幽灵抱歉" && row["favorability"] as! Int > favor[5]
            {
                favor[5] = row["favorability"] as! Int
            }
        }
        sqlite.closeDB()
        return favor
    }
    
    static func drop()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let dropSql1 = "DROP TABLE allDream"
        let dropSql2 = "DROP TABLE detailDream"
        let dropSql3 = "DROP TABLE user"
        let dropSql4 = "DROP TABLE userLogin"
        let dropSql5 = "DROP TABLE invite"
        let dropSql6 = "DROP TABLE timeline"
        if !sqlite.execNoneQuerySQL(sql: dropSql1) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dropSql2) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dropSql3) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dropSql4) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dropSql5) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dropSql6) {sqlite.closeDB();return}
        sqlite.closeDB()
    }

    static func getDB()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM allDream")
        print(querySql!)
        sqlite.closeDB()
    }
    
    static func DeleteDB()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let deleteSql = "DELETE FROM detailDream"
        if !sqlite.execNoneQuerySQL(sql: deleteSql) {sqlite.closeDB(); return}
        let updateSql = "UPDATE sqlite_sequence SET seq=0 WHERE name = detailDream"
        if !sqlite.execNoneQuerySQL(sql: updateSql) {sqlite.closeDB(); return}
    }
    
    static func DeleteDB1()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let deleteSql = "DELETE FROM allDream"
        if !sqlite.execNoneQuerySQL(sql: deleteSql) {sqlite.closeDB(); return}
        let updateSql = "UPDATE sqlite_sequence SET seq=0 WHERE name = allDream"
        if !sqlite.execNoneQuerySQL(sql: updateSql) {sqlite.closeDB(); return}
    }
    /*
    static func getDB1()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        
        let createSql = "CREATE TABLE IF NOT EXISTS allDream('num' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "+"'name'TEXT,'id' TEXT, 'ghostName' TEXT, 'favorability'INTEGER, 'ghostStyle'TEXT);"
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        
        let insertSql1 = "INSERT INTO allDream (name,id,ghostName,favorability,ghostStyle) VALUES('q','2','dance',5,'幽灵期待');"
        if !sqlite.execNoneQuerySQL(sql: insertSql1) {sqlite.closeDB(); return}
        let querySql2 = sqlite.executeQuerySQL(sql: "SELECT * FROM allDream")
        print(querySql2!)
        sqlite.closeDB()
    }*/
}

// MARK: - diary
class Diary
{
    static var ghostName: String = ""
    static var DghostName: String = ""
    static var favor: Int = 0
    static var image: NSData?
    static var id = 0//当前选中的修改日记的id
    static var new = true
    static var query: [[String:Any]] = []
    
    static func Drop()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return}
        let drop = "DROP TABLE detailDream"
        if !sqlite.execNoneQuerySQL(sql: drop){sqlite.closeDB(); return}
        sqlite.closeDB()
    }
    
    static func initDB()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let createSql = "CREATE TABLE IF NOT EXISTS detailDream('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "+"'user'TEXT,"+"'ghostName' TEXT,"+"'backPicture' BLOB,"+"'type' INTEGER,"+"'words' TEXT,"+"'picture' BLOB,"+"'style' TEXT,"+"'media' TEXT,"+"'rf' INTEGER, "+"'time' TEXT,"+"'positive' TEXT,"+"'negative' TEXT);"
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        sqlite.closeDB()
    }
    
    static func getId(name: String) -> Int
    {
        var id = 0
        let userName = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return id}
        let queryResult = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream "+" WHERE user = '\(userName)' AND ghostName = '\(name)'")
            for row in queryResult!
            {
                id = row["id"] as! Int
            }
        sqlite.closeDB()
            return id
            
    }
    
    static func getpicID(name: String) -> [Int]
    {
        let userName = Test.LoginUserName()
        var id :[Int] = []
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return id}
        let sql = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream "+" WHERE user = '\(userName)' AND ghostName = '\(name)'")
        for row in sql!
        {
            id.append(row["id"] as! Int) 
        }
        return id
    }
    
    static func getDetailId() -> Int
    {
        var id = 0

        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return id}
        let queryResult = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream ")
            for row in queryResult!
            {
                id = row["rf"] as! Int
            }
        sqlite.closeDB()
            return id
    }

    static func insertDB(name: String,back: UIImage, type: Int,words: String,voice: String,media: String,positive: String,negative: String)
    {
        let userName = Test.LoginUserName()
        let did = Diary.getDetailId()
        let sqlite = SQliteManager.sharedInstance
        let time = Date().toFormat("YYYY.MM.dd", locale: Locale.current)
        if !sqlite.openDB() {return}
        if did == 0
        {
            let insertSql = "INSERT INTO detailDream (user,ghostName,type,words,style,media,rf,time,positive,negative) VALUES('\(userName)','\(name)',\(type),'\(words)','\(voice)','\(media)',1,'\(time)','\(positive)','\(negative)');"
            if !sqlite.execNoneQuerySQL(sql: insertSql) {sqlite.closeDB();print("failed"); return}
        }
        else
        {
            let insertSql = "INSERT INTO detailDream (user,ghostName,type,words,style,media,rf,time,positive,negative) VALUES('\(userName)','\(name)',\(type),'\(words)','\(voice)','\(media)',0,'\(time)','\(positive)','\(negative)');"
            if !sqlite.execNoneQuerySQL(sql: insertSql) {sqlite.closeDB();print("failed"); return}
        }
        sqlite.closeDB()
    }
    
    static func updateDB()
    {
        var id:[Int] = []
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return}
        for row in query
        {
            id.append(row["id"] as! Int)
        }
        
        var i = 0
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream")
        for row in querySql!
        {
            if row["id"] as! Int == id[i]
            {
                deleteARow(id: id[i])
                i += 1
            }
        }
    }
    
    static func Rearrangement(name: String)
    {
        let userName = Test.LoginUserName()
        var num = 0
        var uid = 0
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream WHERE user = '\(userName)' AND ghostName = '\(name)' AND type = 0")
        for row in querySql!
        {
            uid = row["id"] as! Int
            if num % 2 == 0
            {
                let updateSql = "UPDATE detailDream SET rf = 1 WHERE id = \(uid)"
                if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB(); return}
            }
            else
            {
                let updateSql = "UPDATE detailDream SET rf = 0 WHERE id = \(uid)"
                if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB(); return}
            }
            num += 1
            //print(num)
        }
    }
    
    static func SaveImage(img:UIImage?,id: Int)
    {
        
        if img == nil{return}
        
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        let sql = "UPDATE detailDream SET backPicture = ? WHERE id = '\(id)'"
        if !sqlite.openDB(){return}
        
        let data = img!.jpegData(compressionQuality: 1.0) as NSData?
        sqlite.execSaveBlob(sql: sql, blob: data!)
    
        sqlite.closeDB()
        return
    }
    
    static func SaveImage1(img:Data?,id: Int)
    {
        
        if img == nil{return}
        
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        let sql = "UPDATE detailDream SET picture = ? WHERE id = '\(id)'"
        if !sqlite.openDB(){return}

        sqlite.execSaveBlob(sql: sql, blob: img! as NSData)
    
        sqlite.closeDB()
        return
    }
    
    static func LoadImage(id: Int) ->UIImage
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return UIImage(named: "nopic")!}
        
        let sql = "SELECT backPicture FROM detailDream WHERE id = '\(id)'"
        let data = sqlite.execLoadBlob(sql: sql)
        
        sqlite.closeDB()
        
        if data != nil
        {
            return UIImage(data: data!)!
        }
        else
        {
            return UIImage(named: "transparent")!
        }
    }
    
    static func LoadImage1(id: Int) ->Data?
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return nil}
        
        let sql = "SELECT picture FROM detailDream WHERE id = '\(id)'"
        let data = sqlite.execLoadBlob(sql: sql)
        
        sqlite.closeDB()
        
        if data != nil
        {
            return data
        }
        else
        {
            return nil
        }
    }
    
    static func deleteDB(name: String)
    {
        let userName = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let deleteSql = "DELETE FROM detailDream "+" WHERE ghostName = '\(name)' AND user = '\(userName)'"
        if !sqlite.execNoneQuerySQL(sql: deleteSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
    }
    
    static func deleteARow(id: Int)
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let deleteSql = "DELETE FROM detailDream "+" WHERE id = \(id)"
        if !sqlite.execNoneQuerySQL(sql: deleteSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
    }
   
    static func getDB() -> [[String : AnyObject]]?
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return []}
        let queryResult = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream")
        return queryResult
    }
    
    static func getDB1(id: Int) -> [[String : AnyObject]]?
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return []}
        let queryResult = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream WHERE id = \(id)")
        return queryResult
    }
    
    static func getaverageday(day: String) -> [Double]
    {
        let userName = Test.LoginUserName()
        var v: [Double] = []
        var posiaver = 0.0
        var negaaver = 0.0
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return []}
        let sql = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream "+" WHERE time = '\(day)' AND user = '\(userName)'")
        if sql?.count != 0
        {
            for row in sql!
            {
                let num1 = row["positive"] as! NSString
                posiaver = posiaver + num1.doubleValue * 100.0
                let num2 = row["negative"] as! NSString
                negaaver = negaaver + num2.doubleValue * 100.0
            }
            posiaver = posiaver / Double(sql!.count)
            negaaver = negaaver / Double(sql!.count)
        }
        v.append(posiaver)
        v.append(negaaver)
        print(v)
        return v
    }
    
    static func getaverageweek(day: String) -> [Double]
    {
        var data: [Double] = []
        var num1 = 0.0
        var num2 = 0.0
        for i in 0...6
        {
            for j in 0...6
            {
                let day = (Date() - (i * 7 + j).days).toFormat("YYYY.MM.dd", locale: Locale.current)
                num1 += getaverageday(day: day)[0]
                num2 += getaverageday(day: day)[1]
            }
            data.append(num1/7.0)
            data.append(num2/7.0)
            num1 = 0.0
            num2 = 0.0
        }
        return data
    }
    
    static func getaveragemonth(year: String) -> [Double]
    {
        let userName = Test.LoginUserName()
        var v: [Double] = []
        var posiaver = 0.0
        var negaaver = 0.0
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return []}
        let sql = sqlite.executeQuerySQL(sql: "SELECT * FROM detailDream "+" WHERE time like '"+year+"%' AND user = '\(userName)'")
        if sql?.count != 0
        {
            for row in sql!
            {
                let num1 = row["positive"] as! NSString
                posiaver = posiaver + num1.doubleValue * 100.0
                let num2 = row["negative"] as! NSString
                negaaver = negaaver + num2.doubleValue * 100.0
            }
            posiaver = posiaver / Double(30)
            negaaver = negaaver / Double(30)
        }
        v.append(posiaver)
        v.append(negaaver)
        print(v)
        return v
    }
}

class inviteCode
{
    static func initDB()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let createSql = "CREATE TABLE IF NOT EXISTS invite('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "+"'user'TEXT,"+"'code' TEXT);"
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        sqlite.closeDB()
        
    }
    
    static func getDB()
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM invite")
        print(querySql!)
        sqlite.closeDB()
    }
    
    static func insertDB(code: String)
    {
        let user = Test.LoginUserName()
        var judge = false
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() {return}
        let querySql = sqlite.executeQuerySQL(sql: "SELECT * FROM invite")
        for row in querySql!
        {
            if user == row["user"] as! String
            {
                judge = true
            }
        }
        if judge == false
        {
            let insertSql = "INSERT INTO invite (user,code) VALUES('\(user)','\(code)');"
            if !sqlite.execNoneQuerySQL(sql: insertSql) {sqlite.closeDB(); return}
        }
        else
        {
            let updateSql = "UPDATE invite SET code = '\(code)' WHERE user = '\(user)'"
            if !sqlite.execNoneQuerySQL(sql: updateSql) {sqlite.closeDB(); return}
        }
        sqlite.closeDB()
    }
}

class testData
{
    static func initDB() {
        let sqlite = SQliteManager.sharedInstance
        
        if !sqlite.openDB(){ return }
        
        let createSql = "CREATE TABLE IF NOT EXISTS test('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "+" 'username' TEXT,"+"'Strength' TEXT,"+"'Optimism' Text,"+"'Toughness' Text,"+"'Confidence' Text,"+"'Boundary' Text);"
        
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
    }
    
    static func insertDB(user: String)
    {
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return}
        let insertSql = "INSERT INTO test (username,Strength,Optimism,Toughness,Confidence,Boundary) VALUES('\(user)','0', '0', '0', '0', '0');"
        if !sqlite.execNoneQuerySQL(sql: insertSql){sqlite.closeDB(); return}
        sqlite.closeDB()
    }
    
    static func updateDB(strength: String, optimism: String, toughness: String, confidence: String, boundary: String)
    {
        var marks1 = [Int(strength), Int(optimism), Int(toughness), Int(confidence), Int(boundary)]
        var marks = [0,0,0,0,0]
        let user = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return}
        let selectSql = sqlite.executeQuerySQL(sql: "SELECT * FROM test "+" WHERE username = '\(user)'")
        for row in selectSql!
        {
            marks[0] = Int(row["Strength"] as! String)!
            marks[1] = Int(row["Optimism"] as! String)!
            marks[2] = Int(row["Toughness"] as! String)!
            marks[3] = Int(row["Confidence"] as! String)!
            marks[4] = Int(row["Boundary"] as! String)!
        }
        for mark in 0...4
        {
            if marks[mark] != 0 && marks1[mark] == 0
            {
                marks1[mark] = marks[mark]
            }
        }
        let updateSql = "UPDATE test SET Strength = \(marks1[0] ?? 0), Optimism = \(marks1[1] ?? 0), Toughness = \(marks1[2] ?? 0), Confidence = \(marks1[3] ?? 0), Boundary = \(marks1[4] ?? 0) WHERE username = '\(user)'"
        if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB(); return}
        sqlite.closeDB()
    }
    
    static func refresh()
    {
        let user = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return}
        let updateSql = "UPDATE test SET Strength = 0, Optimism = 0, Toughness = 0, Confidence = 0, Boundary = 0 WHERE username = '\(user)'"
        if !sqlite.execNoneQuerySQL(sql: updateSql){sqlite.closeDB(); return}
        sqlite.closeDB()
    }
    
    static func allmasks() ->[Int]
    {
        var marks = [0,0,0,0,0]
        let user = Test.LoginUserName()
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB(){return marks}
        let selectSql = sqlite.executeQuerySQL(sql: "SELECT * FROM test "+" WHERE username = '\(user)'")
        for row in selectSql!
        {
            marks[0] = Int(row["Strength"] as! String)!
            marks[1] = Int(row["Optimism"] as! String)!
            marks[2] = Int(row["Toughness"] as! String)!
            marks[3] = Int(row["Confidence"] as! String)!
            marks[4] = Int(row["Boundary"] as! String)!
        }
        sqlite.closeDB()
        return marks
    }
}

extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
     
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
}

protocol Arbitrary {
    static func arbitrary() -> Self
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return Character(UnicodeScalar(Int.random(from: 65, to: 90))!)
    }
}

extension Int {
    static func random(from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % (to - from))
    }
}

extension String: Arbitrary {
    
    static func arbitrary() -> String {
        let Length = 6
        let randomCharacters = tabulate(times: Length) { _ in
            Character.arbitrary()
        }
        return String(randomCharacters)
    }
    
   static func tabulate<A>(times: Int, transform: (Int) -> A) -> [A] {
        return (0..<times).map(transform)
    }

}
