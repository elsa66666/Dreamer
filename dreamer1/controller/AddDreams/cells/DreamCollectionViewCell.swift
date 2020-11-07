//
//  DreamCollectionViewCell.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/8/27.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class DreamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ghostImageView: UIImageView!
    @IBOutlet weak var dreamLevel: UILabel!
    @IBOutlet weak var dreamName: UILabel!

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dreamFavorability: UILabel!
    
    @IBOutlet weak var publicizeSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImage.layer.cornerRadius = 20
        publicizeSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    
}
