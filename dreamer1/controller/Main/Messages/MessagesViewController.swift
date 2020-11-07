//
//  MessagesViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessagesTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMessageDetail", sender: self)
    }
    
    @IBOutlet weak var messageTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.rowHeight = 86
        messageTableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "message")
    }
}
