//
//  BottleReceivedViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/10.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class BottleReceivedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var commentTableView: UITableView!
    var sum = 0
    var random = 0
    var queryResult:[[String: Any]] = []
    var commentResult:[[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        queryResult = MySql().getAllDriftMessages()
        sum = queryResult.count
        random = Int(arc4random_uniform(UInt32(sum)))
        getALetter()
        commentTableView.delegate = self
        commentTableView.register(UINib(nibName: "CommentBottleTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentBottle")
    }
    
    var receiverName = ""
    func getALetter(){
        random = Int(arc4random_uniform(UInt32(sum)))
        let row = queryResult[random]
        let title = String(data: row["title"] as! Data, encoding: String.Encoding.utf8)!
        titleText.text = title
        contentText.text = String(data: row["context"] as! Data, encoding: String.Encoding.utf8)!
        commentResult = MySql().getDriftComment(driftID: random + 1) ?? []
        receiverName = String(data: row["sender"] as! Data, encoding: String.Encoding.utf8)!
    }
    
    @IBAction func commentOnLetter(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "评论", message: "", preferredStyle: .alert)
        let alertAction2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            MySql().AddDriftComment(content: textField.text!, receiver: self.receiverName, forDriftID: self.random+1)
            self.commentResult = MySql().getDriftComment(driftID: self.random + 1) ?? []
            self.commentTableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "（add your comment here）"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        getALetter()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentBottle", for: indexPath) as! CommentBottleTableViewCell
        let commentor = String(data: commentResult[indexPath.row]["commentorName"] as! Data, encoding: String.Encoding.utf8)!
        let comment = String(data: commentResult[indexPath.row]["comment"] as! Data, encoding: String.Encoding.utf8)!
        let time = commentResult[indexPath.row]["commentTime"] as! String

        let imageName = commentor.getFirstAlphabet() + ".circle"
        cell.personImageView.image = UIImage(systemName: imageName)
        cell.commentTime.text = time
        cell.personComment.text = comment
        cell.personName.text = commentor
        
        return cell
    }
}
