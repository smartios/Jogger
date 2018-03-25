//
//  DurationCell.swift
//  Janeous
//
//  Created by SS21 on 22/02/18.
//

import UIKit

class DurationCell: UITableViewCell {
    
    @IBOutlet var headerLabel : UILabel!
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var titleLabel2 : UILabel!
    
    @IBOutlet var textField : UITextField!
    @IBOutlet var topButton : UIButton!
    @IBOutlet var lineImageView : UIImageView!
    @IBOutlet var errorView : UIView!
    @IBOutlet var errorLabel : UILabel!
    
    @IBOutlet var textField2 : UITextField!
    @IBOutlet var topButton2 : UIButton!
    @IBOutlet var lineImageView2 : UIImageView!
    @IBOutlet var errorView2 : UIView!
    @IBOutlet var errorLabel2 : UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.selectionStyle = .none
        
        headerLabel.textColor = defaultDarkTextColor()
        headerLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
        
        //1st View
        titleLabel.textColor = defaultLightTextColor()
        titleLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
        
        textField.textColor = defaultDarkTextColor()
        textField.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
        
        lineImageView.backgroundColor = defaultLightTextColor()
        
        errorView.backgroundColor = .red
        errorLabel.textColor = defaultWhiteTextColor()
        errorLabel.font = UIFont(name: defaultLight, size: textFontSize12)
        
        //2nd view
        titleLabel2.textColor = defaultLightTextColor()
        titleLabel2.font = UIFont(name: defaultRegular, size: textFontSize14)
        
        textField2.textColor = defaultDarkTextColor()
        textField2.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
        lineImageView2.backgroundColor = defaultLightTextColor()
        
        errorView2.backgroundColor = .red
        errorLabel2.textColor = defaultWhiteTextColor()
        errorLabel2.font = UIFont(name: defaultLight, size: textFontSize12)
        
        self.hideError()
        self.hideError2()
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
    
    func setPlaceholder2(string:String)
    {
        //placeholder
        let attributes = [
            NSAttributedStringKey.foregroundColor: defaultLightTextColor(),
            NSAttributedStringKey.font : UIFont(name: defaultLightItalic, size: textFieldFontSize18)! // Note the !
        ]
        textField2.attributedPlaceholder = NSAttributedString(string: string, attributes:attributes)
    }
    
    //MARK:- Manage Error
    func showError(message:String)
    {
        errorView.backgroundColor = defaultErrorColor()
        errorLabel.text = message
        lineImageView.backgroundColor = defaultErrorColor()
    }
    
    func hideError()
    {
        errorView.backgroundColor = defaultWhiteTextColor()
        errorLabel.text = ""
        lineImageView.backgroundColor = defaultLightTextColor()
    }
    
    func showError2(message:String)
    {
        errorView2.backgroundColor = defaultErrorColor()
        errorLabel2.text = message
        lineImageView2.backgroundColor = defaultErrorColor()
    }
    
    func hideError2()
    {
        errorView2.backgroundColor = defaultWhiteTextColor()
        errorLabel2.text = ""
        lineImageView2.backgroundColor = defaultLightTextColor()
    }
    
}
