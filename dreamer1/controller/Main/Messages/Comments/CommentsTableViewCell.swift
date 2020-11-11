//
//  CommentsTableViewCell.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var commentWords: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var onButtonTapped : (() -> Void)? = nil
    @IBAction func knownClicked(sender: UIButton) {
     if let onButtonTapped = self.onButtonTapped {
      onButtonTapped()
     }
    }
}
