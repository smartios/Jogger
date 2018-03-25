//
//  DefaultButtonFullGray.swift
//  Janeous
//
//  Created by SS21 on 07/03/18.
//


import Foundation
import UIKit

class DefaultButtonFullGray: UIButton {

    override func awakeFromNib()
    {
        self.backgroundColor = defaultLightTextColor()
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
        
    }

}
