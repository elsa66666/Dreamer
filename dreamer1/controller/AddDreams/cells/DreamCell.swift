//
//  DreamCell.swift
//  dreamer1
//
//  Created by Elsa on 2020/5/18.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class DreamCell: UITableViewCell {

    @IBOutlet weak var drbg: UIImageView!
    
    @IBOutlet weak var dreamLevelLabel: UILabel!
    @IBOutlet weak var ghostStyleImage: UIImageView!
    
    @IBOutlet weak var dreamNameLabel: UILabel!
    
    @IBOutlet weak var dreamPreference: UILabel!
    
    @IBOutlet weak var dreamBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drbg.layer.cornerRadius = 30
        // Initialization code
    }
/*
    override var canBecomeFirstResponder: Bool {
        return true
    }*/
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
