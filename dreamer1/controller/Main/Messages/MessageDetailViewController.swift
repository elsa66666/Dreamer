//
//  MessageDetailViewController.swift
//  dreamer1
//
//  Created by Elsa Shaw on 2020/10/28.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    var queryresult:[[String: Any]] = []
    var friendName:String?
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var FriendName: UINavigationItem!
    @IBOutlet weak var MessageDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendName.title = friendName
        queryresult = MySql().getChatMessageInDetail(friendName: friendName!)
        MessageDetailTableView.delegate = self
        MessageDetailTableView.register(UINib(nibName: "MessageDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "messageDetailCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queryresult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageDetailTableView.dequeueReusableCell(withIdentifier: "messageDetailCell", for: indexPath) as! MessageDetailTableViewCell
        let senderName = String(data: queryresult[indexPath.row]["senderName"] as! Data, encoding: String.Encoding.utf8)!
        cell.messageLabel.text = String(data: queryresult[indexPath.row]["content"] as! Data, encoding: String.Encoding.utf8)!
        
        if (senderName == MySql().LoginUserName()){
            let imageName = senderName.getFirstAlphabet() + ".circle.fill"
            cell.meImageView.image = UIImage(systemName: imageName)
            cell.youView.isHidden = true
        }else{
            let imageName = senderName.getFirstAlphabet() + ".circle"
            cell.youImageView.image = UIImage(systemName: imageName)
            cell.meImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.3607843137, blue: 0.6156862745, alpha: 1)
            cell.messageLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        let imageName = senderName.getFirstAlphabet() + ".circle.fill"
        cell.meImageView.image = UIImage(systemName: imageName)
        cell.onButtonTapped = {
            self.performSegue(withIdentifier: "toFriendHome", sender: self)
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendHome"{
            let destinationVC = segue.destination as! FriendHomeViewController
            destinationVC.friendName = friendName
        }
    }
    
    @IBAction func onSendPressed(_ sender: UIButton) {
        if (messageTextField.text != ""){
            MySql().AddMessage(receiver: friendName!, content: messageTextField.text!)
            queryresult = MySql().getChatMessageInDetail(friendName: friendName!)
            MessageDetailTableView.reloadData()
            messageTextField.text = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let indexPath = queryresult.count - 1
        if queryresult.count != 0
        {
            let newestMessage = String(data: queryresult[indexPath]["content"] as! Data, encoding: String.Encoding.utf8)!
            MySql().ChangeMessageIndexContent(friendName: friendName!, content: newestMessage)
        }
        
    }
}
