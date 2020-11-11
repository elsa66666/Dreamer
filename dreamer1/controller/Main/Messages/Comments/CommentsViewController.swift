//
//  CommentsViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {


    var queryresult:[[String:Any]]?
    @IBOutlet weak var commentsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.rowHeight = 128
        commentsTableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "comments")
        queryresult = MySql().getDriftCommentMessageForMe()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queryresult!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath) as! CommentsTableViewCell
        cell.userName.text = String(data: queryresult![indexPath.row]["commentorName"] as! Data, encoding: String.Encoding.utf8)!
        cell.commentWords.text = String(data: queryresult![indexPath.row]["comment"] as! Data, encoding: String.Encoding.utf8)!
        cell.commentTime.text = (queryresult![indexPath.row]["commentTime"] as! String)
        let id = queryresult![indexPath.row]["autoID"] as! Int
        cell.onButtonTapped = {
            MySql().knowCommentMessageToMe(autoID: id)
            self.queryresult = MySql().getDriftCommentMessageForMe()
            self.commentsTableView.reloadData()
        }
        return cell
    }
}
