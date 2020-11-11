//
//  MyBottleViewController.swift
//  dreamer1
//
//  Created by Elsa Shaw on 2020/11/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MyBottleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var driftLabel: UILabel!
    @IBOutlet weak var driftContent: UITextView!
    @IBOutlet weak var driftCommentTableView: UITableView!
    var queryResult:[[String: Any]] = []
    var commentResult:[[String: Any]] = []
    var driftID: Int?
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driftCommentTableView.register(UINib(nibName: "CommentBottleTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentBottle")
        queryResult = MySql().getAllDriftMessages()
        getALetter()
    }
    
    func getALetter(){
        var row :[String: Any]?
        for r in queryResult{
            if (r["id"] as! Int) == driftID{
                row = r
            }
        }
        let title = String(data: row!["title"] as! Data, encoding: String.Encoding.utf8)!
        titleText.text = title
        contentText.text = String(data: row!["context"] as! Data, encoding: String.Encoding.utf8)!
        commentResult = MySql().getDriftComment(driftID: driftID!) ?? []
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
