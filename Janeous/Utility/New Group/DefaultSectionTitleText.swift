//
//  DefaultSectionTitleText.swift
//  Janeous
//
//  Created by SS21 on 05/03/18.
//

import UIKit

class DefaultSectionTitleText: UILabel {
 
        
        override func awakeFromNib()
        {
            self.font = UIFont(name: defaultRegular, size: textFontSize18)
            self.textColor = defaultLightTextColor()
            
        }
}
