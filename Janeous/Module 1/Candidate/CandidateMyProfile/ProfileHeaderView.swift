//
//  ProfileHeaderView.swift
//  Janeous
//
//  Created by singsys on 22/03/18.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet var headerLabel : UILabel!
    
    @IBOutlet var privacyButton : UIButton!
    @IBOutlet var editButton : UIButton!
    @IBOutlet var addMoreButton : UIButton!
    
     @IBOutlet var privacyButtonWidthConstant : NSLayoutConstraint!
     @IBOutlet var editButtonWidthConstant : NSLayoutConstraint!
     @IBOutlet var addMoreButtonWidthConstant : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = defaultWhiteButtonBackgroundColor()
        
        headerLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
        headerLabel.textColor = defaultDarkTextColor()
        
//        self.privacyButtonIsHidden(value: true)
//        self.editButtonIsHidden(value: true)
//        self.addMoreButtonIsHidden(value: true)
    }

    //MARK:- Manage Buttons
    
    func privacyButtonIsHidden(value:Bool)
    {
        if value
        {
            privacyButtonWidthConstant.constant = 0
        }
        else
        {
            privacyButtonWidthConstant.constant = 45
        }
    }
    
    func editButtonIsHidden(value:Bool)
    {
        if value
        {
            editButtonWidthConstant.constant = 0
        }
        else
        {
            editButtonWidthConstant.constant = 45
        }
    }
    
    func addMoreButtonIsHidden(value:Bool)
    {
        if value
        {
            addMoreButtonWidthConstant.constant = 0
        }
        else
        {
            addMoreButtonWidthConstant.constant = 45
        }
    }
}
