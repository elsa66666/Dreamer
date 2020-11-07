//
//  PublicDreamCollectionViewCell.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/9/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class PublicDreamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ghostImageView: UIImageView!
    @IBOutlet weak var dreamName: UILabel!
    @IBOutlet weak var diaryNumLabel: UILabel!
    @IBOutlet weak var dreamFavorability: UILabel!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var starredPerson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fullView.layer.cornerRadius = 5
    }

}
