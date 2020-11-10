//
//  FriendHomeViewController.swift
//  dreamer1
//
//  Created by Elsa Shaw on 2020/11/10.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class FriendHomeViewController:UIViewController,UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    

    @IBOutlet weak var friendNameTitle: UINavigationItem!
    
    @IBOutlet weak var pdreamCollectionView: UICollectionView!
    @IBOutlet weak var selectedDreamStarsLabel: UILabel!
    @IBOutlet weak var selectedDreamCommentLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    var friendName:String?
    var result: [[String:Any]]?
    var commentResult:[[String: Any]] = []
    var starNumber:Int = 25
    var commentNumber:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        friendNameTitle.title = "\(friendName!)'s Home"
        pdreamCollectionView.register(UINib(nibName: "PublicDreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "pdreamCell")
        pdreamCollectionView.delegate = self
        result = Test.userD.getUserPublicDream(user: friendName!)
        commentResult = MySql().getDriftComment(driftID: 2) ?? []
        commentNumber = commentResult.count
        commentTableView.delegate = self
        commentTableView.register(UINib(nibName: "CommentBottleTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentBottle")
        commentShow(show: false)
        starButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: .normal)
        starButton.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: .selected)
        selectedDreamStarsLabel.text = String(starNumber)
        selectedDreamCommentLabel.text = String(commentNumber)
    }
    func commentShow(show: Bool){
        if show == false{
            starButton.isHidden = true
            selectedDreamStarsLabel.isHidden = true
            selectedDreamCommentLabel.isHidden = true
            commentButton.isHidden = true
            commentTableView.isHidden = true
        }else{
            starButton.isHidden = false
            selectedDreamStarsLabel.isHidden = false
            selectedDreamCommentLabel.isHidden = false
            commentButton.isHidden = false
            commentTableView.isHidden = false
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result!.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height*0.75*5/3, height: collectionView.frame.height*0.6)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pdreamCell", for: indexPath) as! PublicDreamCollectionViewCell
        cell.dreamName.text = String(data: result![indexPath.row]["ghostName"] as! Data, encoding: String.Encoding.utf8)
        cell.ghostImageView.image = UIImage(named: String(data: result![indexPath.row]["ghostStyle"] as! Data, encoding: String.Encoding.utf8)!)
        cell.dreamFavorability.text = "\(result![indexPath.row]["favorability"] as! Int)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        commentShow(show: true)
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        starButton.isSelected = !starButton.isSelected
        if (starButton.state == UIControl.State(rawValue: 5)){
            starNumber += 1
            selectedDreamStarsLabel.text = String(starNumber)
            //update db
        }else{
            starNumber -= 1
            selectedDreamStarsLabel.text = String(starNumber)
            //update db
        }
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

