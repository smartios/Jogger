//
//  ResetPasswordController.swift
//  Janeous
//
//  Created by SS21 on 20/02/18.
//

import UIKit

class ResetPasswordController: MyBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UITextFieldDelegate {
    //    MARK:- @IBActions decalrtions
    @IBOutlet var ResetPasswordView : UITableViewCell!
    @IBOutlet var resetPasswordBtn : UITableViewCell!
    @IBOutlet var tableView : UITableView!
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    var nib = UINib()
    var username:String!
    var otp:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setWhiteNavigationbarWithTitleImageAndSideMenu()
    }
    
    // MARK: - keyboard handling
    @objc func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    
    //MARK:- Button Actions
    
    @IBAction func resetPasswordButtonTapped(_sender: UIButton)
    {
        self.errorDic.removeAllObjects()
        self.hideKeyboard()
        self.tableView.reloadData() //removing all errors
        
        if self.dataDic.value(forKey: "password") == nil || (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter your password."), forKey: "password")
        }
            //        else if !isValidPassword(testStr: (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
            //        {
            //            self.errorDic.setValue(Localization("Your password must be a combination of alphanumeric characters and atleast 8 characters long."), forKey: "password")
            //        }
        else if self.dataDic.value(forKey: "confirm_password") == nil || (self.dataDic.value(forKey: "confirm_password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please confirm your password."), forKey: "confirm_password")
        }
        else if (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) != (self.dataDic.value(forKey: "confirm_password") as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        {
            self.errorDic.setValue(Localization("Your password and confirm password does not match."), forKey: "confirm_password")
        }
        
        if self.errorDic.count == 0
        {
            self.resetPasswordWebService()
            return
        }
        
        self.tableView.reloadData() // showing all errors
    }
    
    //    MARK:- Table View Delegates and Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == 0
        {
            Bundle.main.loadNibNamed("ResetPasswordCell", owner: self, options: nil)
            cell = tableView.dequeueReusableCell(withIdentifier: "ResetPasswordView")
            if cell == nil{
                cell = ResetPasswordView
                ResetPasswordView = nil
            }
            let titleLabel = cell.viewWithTag(2) as! UILabel
            let subTitleLabel = cell.viewWithTag(3) as! UILabel
            
            titleLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
            titleLabel.textColor = defaultDarkTextColor()
            titleLabel.text = Localization("RESET PASSWORD")
            
            subTitleLabel.font = UIFont(name: defaultLight, size: textFontSize15)
            subTitleLabel.textColor = defaultLightTextColor()
            subTitleLabel.text = Localization("Type your new password")
            
        }
        else if indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "resetPasswordBtn")
            if cell == nil
            {
                cell = resetPasswordBtn
                resetPasswordBtn = nil
            }
            
            let resetButton =  cell.viewWithTag(10) as! defaultGreenButton
            let resendTextView = cell.viewWithTag(3) as! UITextView
            
            resendTextView.delegate = self
            
            resetButton.setTitle(Localization("RESET PASSWORD"), for: UIControlState.normal)
            
            resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped(_sender:)), for: UIControlEvents.touchUpInside)
            
            var str:NSString = ""
            
            if(isValidEmail(testStr: username))
            {
                str = "\(Localization("Didn't work? Resend Reset Password OTP to my email")) " as NSString
            }
            else
            {
                str = "\(Localization("Didn't work? Resend Reset Password OTP to my mobile")) " as NSString
            }
            
            let string:NSMutableAttributedString = NSMutableAttributedString(string: "\(str)")
            string.addAttributes([NSAttributedStringKey.font: UIFont(name: defaultRegular, size: textFontSize14)!], range: str.range(of: str as String))
            string.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultDarkTextColor(), range: str.range(of: str as String))
            
            if(isValidEmail(testStr: username))
            {
                string.addAttribute(NSAttributedStringKey.link, value: "resend", range: str.range(of: Localization("Resend Reset Password OTP to my email")))
            }
            else
            {
                string.addAttribute(NSAttributedStringKey.link, value: "resend", range: str.range(of: Localization("Resend Reset Password OTP to my mobile")))
            }
            resendTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:defaultGreenColor()]
            resendTextView.attributedText = string
            resendTextView.textAlignment = .center
        }
        else
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            
            tempCell.hideError()
            
            textfield.delegate = self
            textfield.text = ""
            textfield.isSecureTextEntry = true
            
            if indexPath.row == 1
            {
               titleLabel.text = Localization("NEW PASSWORD")
              tempCell.setPlaceholder(string:Localization("Minimum of 6 characters"))
                
                if(dataDic.value(forKey: "password") != nil && "\(dataDic.value(forKey: "password")!)" != "")
                {
                    textfield.text = "\(dataDic.value(forKey: "password")!)"
                }
                
                if errorDic.value(forKey: "password") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "password") as! String)
                }
            }
            else
            {
                titleLabel.text = Localization("RE-ENTER NEW PASSWORD")
                tempCell.setPlaceholder(string:Localization("Minimum of 6 characters"))
                
                if(dataDic.value(forKey: "confirm_password") != nil && "\(dataDic.value(forKey: "confirm_password")!)" != "")
                {
                    textfield.text = "\(dataDic.value(forKey: "confirm_password")!)"
                }
                
                if errorDic.value(forKey: "confirm_password") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "confirm_password") as! String)
                }
            }
            
            cell = tempCell
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 0
        
        var bottomPadding:CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = (window?.safeAreaInsets.bottom)! // For iPhone X
        }
        
        if(indexPath.row == 0 || indexPath.row == 3)
        {
            height = ((self.view.frame.size.height - bottomPadding)/2) - 90
            
            if(height < 241)
            {
                height = 241
            }
        }
        else if(indexPath.row == 1 || indexPath.row == 2)
        {
            height = UITableViewAutomaticDimension
        }
        return height
    }
    
    //MARK:- TextField
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row == 1
        {
            textField.returnKeyType = .next
        }
        else
        {
            textField.returnKeyType = .done
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row == 1
        {
            self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
        }
        else if indexPath.row == 2
        {
            self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "confirm_password")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row == 1
        {
            let nextIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let cell:UITableViewCell = self.tableView.cellForRow(at: nextIndexPath)!
            let nextTextField = cell.viewWithTag(2) as! UITextField
            nextTextField.becomeFirstResponder()
        }
        else
        {
            self.hideKeyboard()
        }
        return true
    }
    
    //MARK:- TextView
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if("\(url)" ==  "resend")
        {
            self.resendOTPWebService()
        }
        return true
    }
    
    //MARK:- Web Services
    func resendOTPWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.username, forKey: "username")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: sendOTP, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                    
                    for vc in self.navigationController!.viewControllers
                    {
                        if(vc is OTPViewController)
                        {
                            self.navigationController?.popToViewController(vc, animated: true)
                            return
                        }
                    }
                    
                    let vc = OTPViewController(nibName: "OTPViewController", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            else
            {
                
                //                // Showing message irrespective of Status
                if (JSON as! NSDictionary).object(forKey: "errors") != nil && (JSON as! NSDictionary).object(forKey: "errors") is NSArray
                {
                    let tempArray = ((JSON as! NSDictionary).object(forKey: "errors") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for item in tempArray
                    {
                        self.errorDic.setValue((item as! NSDictionary).value(forKey: "value"), forKey:(item as! NSDictionary).value(forKey: "key") as! String)
                    }
                    
                    self.tableView.reloadData()
                    
                }
                else if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                
            }
            
            
        }
    }
    
    func resetPasswordWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        
        params.setValue(self.username, forKey: "username")
        params.setValue(self.otp, forKey: "otp")
        params.setValue(self.dataDic.value(forKey: "password"), forKey: "password")
        params.setValue(self.dataDic.value(forKey: "confirm_password"), forKey: "confirm_password")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: resetPassword, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: "SUCCESS!!", delay: 2.0)
                    
                }
                for vc in self.navigationController!.viewControllers
                {
                    if(vc is LoginViewController)
                    {
                        self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
                
            }
            else
            {
                
                //                // Showing message irrespective of Status
                if (JSON as! NSDictionary).object(forKey: "errors") != nil && (JSON as! NSDictionary).object(forKey: "errors") is NSArray
                {
                    let tempArray = ((JSON as! NSDictionary).object(forKey: "errors") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for item in tempArray
                    {
                        self.errorDic.setValue((item as! NSDictionary).value(forKey: "value"), forKey:(item as! NSDictionary).value(forKey: "key") as! String)
                    }
                    
                    self.tableView.reloadData()
                    
                }
                else if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                
            }
            
            
        }
    }
    
}
