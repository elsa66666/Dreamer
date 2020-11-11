//
//  MessagesViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var queryresult:[[String: Any]] = []
    @IBOutlet weak var messageTableView: UITableView!
    var connectFriendName:String?
    var connectFriendList:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        queryresult = MySql().getChatInShort()
        messageTableView.delegate = self
        messageTableView.rowHeight = 86
        messageTableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "message")
    }
    
    
    @IBAction func onNewFriendsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toNFriends", sender: self)
    }
    @IBAction func onLikedButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toBeLiked", sender: self)
    }
    
    @IBAction func onCommentsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toComments", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queryresult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessagesTableViewCell
        let personA = String(data: queryresult[indexPath.row]["personA"] as! Data, encoding: String.Encoding.utf8)!
        let personB = String(data: queryresult[indexPath.row]["personB"] as! Data, encoding: String.Encoding.utf8)!
        let messageContent = String(data: queryresult[indexPath.row]["messageContent"] as! Data, encoding: String.Encoding.utf8)!
        var friendName = ""
        if (personA == MySql().LoginUserName()){
            friendName = personB
        }else{
            friendName = personA
        }
        let imageName = friendName.getFirstAlphabet()+".circle"
        cell.friendImageView.image = UIImage(systemName: imageName)
        cell.friendNameLabel.text = friendName
        cell.friendMessageLabel.text = messageContent
        connectFriendList?.append(friendName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personA = String(data: queryresult[indexPath.row]["personA"] as! Data, encoding: String.Encoding.utf8)!
        let personB = String(data: queryresult[indexPath.row]["personB"] as! Data, encoding: String.Encoding.utf8)!
        if (personA == MySql().LoginUserName()){
            connectFriendName = personB
        }else{
            connectFriendName = personA
        }
        performSegue(withIdentifier: "toMessageDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageDetail"{
            let destinationVC = segue.destination as! MessageDetailViewController
            destinationVC.friendName = connectFriendName!
        }else if segue.identifier == "toNFriends"{
            let destinationVC = segue.destination as! NewFriendsViewController
            destinationVC.alreadyFriendList = connectFriendList
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        queryresult = MySql().getChatInShort()
        messageTableView.reloadData()
    }

}
