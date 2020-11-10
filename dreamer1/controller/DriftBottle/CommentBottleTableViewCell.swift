//
//  CommentBottleTableViewCell.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/19.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class CommentBottleTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personComment: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
