//
//  SuggestionsTableViewCell.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/19.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class SuggestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var suggestTitle: UILabel!
    @IBOutlet weak var suggestContent: UILabel!
    @IBOutlet weak var suggestImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
