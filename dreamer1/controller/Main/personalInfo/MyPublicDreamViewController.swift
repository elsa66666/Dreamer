//
//  MyPublicDreamViewController.swift
//  dreamer1
//
//  Created by Elsa Shaw on 2020/11/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MyPublicDreamViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var dreamLikeLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var favorLabel: UILabel!
    @IBOutlet weak var dreamNameLabel: UILabel!
    
    @IBOutlet weak var dreamImageView: UIImageView!
    
    var commentResult:[[String: Any]] = []

    var favor:Int? = 0
    var dreamName:String? = ""
    var likeCount:Int? = 0
    var tag:String? = ""
    var dreamStyle:String? = ""
    @IBOutlet weak var dreamTagLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dreamNameLabel.text = dreamName
        dreamLikeLabel.text = "\(likeCount ?? 0)"
        favorLabel.text = "\(favor ?? 0)"
        dreamTagLabel.text = tag
        dreamImageView.image = UIImage(named: dreamStyle!)
        commentTableView.delegate = self
        commentTableView.register(UINib(nibName: "CommentBottleTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentBottle")
        
        commentResult = MySql().getDreamComment(friendName: MySql().LoginUserName(), dreamName: dreamName!)!
        commentCountLabel.text = "\(commentResult.count)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         commentResult.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CommentBottle", for: indexPath) as! CommentBottleTableViewCell
         let commentor = String(data: commentResult[indexPath.row]["myName"] as! Data, encoding: String.Encoding.utf8)!
         let comment = String(data: commentResult[indexPath.row]["commentContent"] as! Data, encoding: String.Encoding.utf8)!
         let time = commentResult[indexPath.row]["commentTime"] as! String

         let imageName = commentor.getFirstAlphabet() + ".circle"
         cell.personImageView.image = UIImage(systemName: imageName)
         cell.commentTime.text = time
         cell.personComment.text = comment
         cell.personName.text = commentor
         
         return cell
     }
}
