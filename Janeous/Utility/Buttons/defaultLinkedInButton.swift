//
//  defaultLinkedInButton.swift
//  Janeous
//
//  Created by singsys on 19/02/18.
//

import UIKit

class defaultLinkedInButton: UIButton {

    override func awakeFromNib()
    {
        self.backgroundColor = defaultLinkedInColor()
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
        
    }
}
