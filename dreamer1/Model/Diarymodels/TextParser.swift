//
//  TextParser.swift
//  dreamer1
//
//  Created by xdcheng on 2020/5/19.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit

class TextParser: NSObject, YYTextParser {
    
    let normalFont = UIFont(name: "Marker Felt", size: 25)
    var normalColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let atTextColor = UIColor.orange
    
    func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
        let change = false
        
        if text?.length == 0 { return change }
        
        text?.yy_font = normalFont
        text?.yy_color = normalColor
        
        return change
    }
}

