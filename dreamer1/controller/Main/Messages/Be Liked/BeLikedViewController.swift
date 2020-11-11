//
//  LikesViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class BeLikedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
  
    var queryResult:[[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        beLikedTableView.delegate = self
        beLikedTableView.rowHeight = 86
        beLikedTableView.register(UINib(nibName: "BeLikedTableViewCell", bundle: nil), forCellReuseIdentifier: "beLiked")
        queryResult = MySql().getAllLikeMessagesToMe()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queryResult!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beLiked", for: indexPath) as! BeLikedTableViewCell
        let friendName = String(data: queryResult![indexPath.row]["likeSenderName"] as! Data, encoding: String.Encoding.utf8)!
        let imageName = friendName.getFirstAlphabet()+".circle"
        let dreamName = String(data: queryResult![indexPath.row]["likedDreamName"] as! Data, encoding: String.Encoding.utf8)!
        cell.userName.text = friendName
        cell.userPhoto.image = UIImage(systemName: imageName)
        cell.commentTimeLabel.text = (queryResult![indexPath.row]["likedTime"] as! String)
        cell.onButtonTapped = {
            MySql().knowLikeMessageToMe(friendName: friendName, dreamName: dreamName)
            self.queryResult = MySql().getAllLikeMessagesToMe()
            tableView.reloadData()
        }
        return cell
    }
    
    @IBOutlet weak var beLikedTableView: UITableView!
    
}
