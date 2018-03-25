//
//  DefaultTextTitleFormat.swift
//  Janeous
//
//  Created by SS21 on 20/02/18.
//

import UIKit

class DefaultTextTitleFormat: UILabel {

    override func awakeFromNib()
    {
        self.font = UIFont(name: defaultRegular, size: textFontSize14)
        self.textColor = defaultLightTextColor()
        
    }

}
