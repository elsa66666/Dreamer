//
//  MessageDetailTableViewCell.swift
//  dreamer1
//
//  Created by Elsa Shaw on 2020/10/28.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class MessageDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var meImageView: UIImageView!
    @IBOutlet weak var youImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }
    
}
