//
//  MessageDetailViewController.swift
//  dreamer1
//
//  Created by Elsa Shaw on 2020/10/28.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    struct Message {
        var name: String
        var content: String
    }
    
    
    @IBAction func toHome(_ sender: Any) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    var messageArray = [
        Message(name: "Hua", content: "hahahhahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"),
        Message(name: "Elsa", content: "hahahhahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"),
        Message(name: "Hua", content: "hahahhahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"),
        Message(name: "Elsa", content: "hahahhahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"),
        Message(name: "Hua", content: "hahahhahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
    ]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageDetailTableView.dequeueReusableCell(withIdentifier: "messageDetailCell", for: indexPath) as! MessageDetailTableViewCell
        let name = messageArray[indexPath.row].name
        cell.messageLabel.text = messageArray[indexPath.row].content
        
        if (name == "Elsa"){
            let imageName = name.getFirstAlphabet() + ".circle.fill"
            cell.meImageView.image = UIImage(systemName: imageName)
            cell.youImageView.isHidden = true
        }else{
            let imageName = name.getFirstAlphabet() + ".circle"
            cell.youImageView.image = UIImage(systemName: imageName)
            cell.meImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.3607843137, blue: 0.6156862745, alpha: 1)
            cell.messageLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        let imageName = name.getFirstAlphabet() + ".circle.fill"
        cell.meImageView.image = UIImage(systemName: imageName)
        
        return cell
    }
    
    @IBOutlet weak var MessageDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageDetailTableView.delegate = self
        MessageDetailTableView.register(UINib(nibName: "MessageDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "messageDetailCell")
    }
    
    
}
