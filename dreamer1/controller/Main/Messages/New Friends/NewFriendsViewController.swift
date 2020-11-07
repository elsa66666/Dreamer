//
//  NewFriendsViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class NewFriendsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseFriends", for: indexPath) as! NewFriendsTableViewCell
        /*
        let userName = "数据库-好友申请表中取"
        let imageName = userName.getFirstAlphabet()+".circle"
        cell.userPhoto.image = UIImage(systemName: imageName)
        */
        return cell
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
            print(friendName!, addFMessage!)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        newFriendsTableView.delegate = self
        newFriendsTableView.rowHeight = 86
        newFriendsTableView.register(UINib(nibName: "NewFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseFriends")
    }
}
