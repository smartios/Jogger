//
//  baseTextFieldTableViewCell.swift
//  Janeous
//
//  Created by SS21 on 19/02/18.
//

import UIKit

class baseTextFieldTableViewCell: UITableViewCell {

  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var textField : UITextField!
  @IBOutlet var lineImageView : UIImageView!
  @IBOutlet var errorView : UIView!
  @IBOutlet var errorLabel : UILabel!
  @IBOutlet var mobileCodeTextField : UITextField!
  @IBOutlet var mobileLineImageView : UIImageView!
  @IBOutlet var rightButtonWidthConstant : NSLayoutConstraint!
  @IBOutlet var mobileCodeFieldWidthConstant : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let titleLabel = self.viewWithTag(1) as! UILabel
//
         self.selectionStyle = .none
        
        titleLabel.textColor = defaultLightTextColor()
        titleLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
        textField.textColor = defaultDarkTextColor()
        textField.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
        
        lineImageView.backgroundColor = defaultLightTextColor()
        
        errorView.backgroundColor = defaultErrorColor()
        errorLabel.textColor = defaultWhiteTextColor()
        errorLabel.font = UIFont(name: defaultLight, size: textFontSize12)
        
        mobileCodeTextField.textColor = defaultDarkTextColor()
        mobileCodeTextField.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
        mobileLineImageView.backgroundColor = defaultLightTextColor()
        
        self.notMobileField()
        self.hideRightButton()
        self.hideError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Attributed Placeholder
    func setPlaceholder(string:String)
    {
        //placeholder
        let attributes = [
            NSAttributedStringKey.foregroundColor: defaultLightTextColor(),
            NSAttributedStringKey.font : UIFont(name: defaultLightItalic, size: textFieldFontSize18)! // Note the !
        ]
        textField.attributedPlaceholder = NSAttributedString(string: string, attributes:attributes)
    }
    
    //MARK:- Manage Error
    func showError(message:String)
    {
        errorView.isHidden = false
        errorLabel.text = message
        lineImageView.backgroundColor = defaultErrorColor()
    }
    
    func hideError()
    {
        errorView.isHidden = true
        errorLabel.text = ""
        lineImageView.backgroundColor = defaultLightTextColor()
    }
    
    //MARK:- Mobile Number
    func thisIsMobileField()
    {
        mobileCodeFieldWidthConstant.constant = 73
    }
    
    func notMobileField()
    {
        mobileCodeFieldWidthConstant.constant = 0
    }
    
    //MARK:- Right Button
    func showRightButton()
    {
        rightButtonWidthConstant.constant = 30
    }
    
    func hideRightButton()
    {
        rightButtonWidthConstant.constant = 0
    }
    
}

