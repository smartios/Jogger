//
//  defaultGrayButton.swift
//  Janeous
//
//  Created by SS21 on 21/02/18.
//

import UIKit
import Foundation
class defaultGrayButton: UIButton { 

    override func awakeFromNib()
    {
//        self.backgroundColor = defaultGreenColor()
        self.setTitleColor(defaultLightTextColor(), for: .normal)
        self.layer.borderWidth = 2
        self.layer.borderColor = defaultLightTextColor().cgColor
        self.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
        
    }

}
