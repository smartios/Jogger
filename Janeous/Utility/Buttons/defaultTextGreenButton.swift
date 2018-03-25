//
//  defaultTextGreenButton.swift
//  Janeous
//
//  Created by SS21 on 20/02/18.
//
import Foundation
import UIKit

class defaultTextGreenButton: UIButton {

    override func awakeFromNib()
    {
//        self.backgroundColor = defaultGreenColor()
        self.titleLabel?.textColor = defaultGreenColor()
        self.titleLabel?.font = UIFont(name: "FiraSans-Medium", size: 16.0)!
        
    }

}
