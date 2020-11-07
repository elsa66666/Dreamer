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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        getALetter()
        
        commentTableView.delegate = self
        commentTableView.register(UINib(nibName: "CommentBottleTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentBottle")
    }
    
    func getALetter(){
        let sum = Test.userD.getMaxId()
        let random = Int(arc4random()) % sum + 1
        let message = Test.userD.getRandomMessage(id: random)
        print(random)
        for row in message!
        {
            let title = String(data: row["title"] as! Data, encoding: String.Encoding.utf8)!
            titleText.text = title
            print("title: \(title)")
            contentText.text = String(data: row["context"] as! Data, encoding: String.Encoding.utf8)!
        }
    }
    
    @IBAction func commentOnLetter(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        getALetter()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentBottle", for: indexPath) as! CommentBottleTableViewCell
        return cell
    }
}
