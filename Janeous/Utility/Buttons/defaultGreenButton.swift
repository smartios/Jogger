//
//  defaultGreenButton.swift
//  Janeous
//
//  Created by singsys on 16/02/18.
//

import Foundation
import UIKit

class defaultGreenButton: UIButton
{
    override func awakeFromNib()
    {
        self.backgroundColor = defaultGreenColor()
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
        
    }
}
