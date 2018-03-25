//
//  SkipButtonTableViewCell.swift
//  Janeous
//
//  Created by singsys on 25/03/18.
//

import UIKit

class SkipButtonTableViewCell: UITableViewCell {

    @IBOutlet var skipButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        skipButton.setTitleColor(defaultGreenColor(), for: .normal)
        skipButton.titleLabel?.font = UIFont(name: defaultMedium, size: textFontSize14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
