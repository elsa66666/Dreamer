//
//  NewFriendsTableViewCell.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class NewFriendsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userWords: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptButton.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var onButtonTapped : (() -> Void)? = nil
    @IBAction func onAcceptClicked(_ sender: UIButton) {
        if let onButtonTapped = self.onButtonTapped {
         onButtonTapped()
        } 
    }
    
}
