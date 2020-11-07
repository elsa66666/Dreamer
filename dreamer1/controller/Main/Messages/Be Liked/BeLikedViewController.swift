//
//  LikesViewController.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class BeLikedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBAction func toHome(_ sender: UIBarButtonItem) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beLiked", for: indexPath) as! BeLikedTableViewCell
        return cell
    }
    
    @IBOutlet weak var beLikedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        beLikedTableView.delegate = self
        beLikedTableView.rowHeight = 86
        beLikedTableView.register(UINib(nibName: "BeLikedTableViewCell", bundle: nil), forCellReuseIdentifier: "beLiked")
    }
}
