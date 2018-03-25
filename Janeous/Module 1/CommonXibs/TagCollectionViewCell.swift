//
//  TagCollectionViewCell.swift
//  Janeous
//
//  Created by singsys on 09/03/18.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var deleteTagButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
        titleLabel.textColor = defaultDarkTextColor()
        self.backgroundColor = defaultWhiteButtonBackgroundColor()
    }

}
