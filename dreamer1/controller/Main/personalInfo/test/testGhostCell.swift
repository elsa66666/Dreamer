//
//  testGhostCell.swift
//  dreamer1
//
//  Created by Xixi Xiao on 2020/8/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//


import UIKit
class testGhostCell: UITableViewCell {

    @IBOutlet weak var cellFullView: UIView!
    @IBOutlet weak var testFullView: UIView!
    @IBOutlet weak var ghostImageView: UIImageView!
    @IBOutlet weak var prograssView: UIProgressView!
    @IBOutlet weak var checkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        testFullView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lockImage: UIImageView!
    @IBAction func onCheckSelected(_ sender: UIButton) {


    }
    
}
