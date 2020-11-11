//
//  NewFriendsViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class NewFriendsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var queryresult:[[String: Any]] = []
    var alreadyFriendList:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        queryresult = MySql().getRequestsToMe()
        newFriendsTableView.delegate = self
        //newFriendsTableView.rowHeight = 86
        newFriendsTableView.register(UINib(nibName: "NewFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseFriends")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queryresult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseFriends", for: indexPath) as! NewFriendsTableViewCell

        let senderName = String(data: queryresult[indexPath.row]["senderName"] as! Data, encoding: String.Encoding.utf8)!
        let senderWord = String(data: queryresult[indexPath.row]["senderWord"] as! Data, encoding: String.Encoding.utf8)!
        let requestID = queryresult[indexPath.row]["requestID"] as! Int
        let imageName = senderName.getFirstAlphabet()+".circle"
        cell.userPhoto.image = UIImage(systemName: imageName)
        cell.userName.text = senderName
        cell.userWords.text = senderWord
        cell.onButtonTapped = {
            //同意一条好友申请
            if !self.judgeAlreadyFriend(friendName: senderName){
                MySql().AcceptFriend(friendName: senderName)
                MySql().deleteRequest(id: requestID)
            }
            self.queryresult = MySql().getRequestsToMe()
            self.newFriendsTableView.reloadData()
        }
        return cell
    }
    
    func judgeAlreadyFriend(friendName:String) -> Bool{
        var flag = false
        for friend in alreadyFriendList!{
            if (friendName == friend){
                flag = true
            }
        }
        return flag
    }
    
    @IBAction func addAFriend(_ sender: UIBarButtonItem) {
        var addFriendNameTextField = UITextField()
        var addFriendMessageTextField = UITextField()
        let alert = UIAlertController(title: "添加好友", message: "", preferredStyle: .alert)
        let alertAction2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            //数据库添加一条好友申请
            let friendName = addFriendNameTextField.text
            let addFMessage = addFriendMessageTextField.text
            MySql().AddFriendRequest(receiverName: friendName!, senderWord: addFMessage!)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "（请输入好友名字）"
            addFriendNameTextField = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "（请输入申请信息）"
            addFriendMessageTextField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var newFriendsTableView: UITableView!

}
