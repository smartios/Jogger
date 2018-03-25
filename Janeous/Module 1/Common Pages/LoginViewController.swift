//
//  LoginViewController.swift
//  Janeous
//
//  Created by SL-167 on 2/7/18.
//

import UIKit
import ReCaptcha

class LoginViewController: MyBaseViewController ,UITableViewDelegate, UITableViewDataSource ,UITextViewDelegate,UITextFieldDelegate,selectAccountDelegate{
    var dataDic = NSMutableDictionary()
    var tapGesture = UITapGestureRecognizer()
    @IBOutlet weak var tableView: UITableView!
    
    var errorDic = NSMutableDictionary()
    let recaptcha = try? ReCaptcha()
    
    var linkedInDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "CaptchaTableViewCell", bundle: nil), forCellReuseIdentifier: "CaptchaTableViewCell")
        
        tableView.estimatedRowHeight = 100
        
        recaptcha?.configureWebView { [weak self] webview in
            webview.frame = self?.view.bounds ?? CGRect.zero
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Localization("Done")
        self.setWhiteNavigationBarWithSideMenu()
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
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if(indexPath.row == 0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
            let signInLabel = cell.viewWithTag(2) as! UILabel
            signInLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
            signInLabel.text = Localization("Sign In")
        }
        else if(indexPath.row == 3)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "signInCell")!
            
            let forgotButton = cell.viewWithTag(1) as! UIButton
            let signInButton = cell.viewWithTag(2) as! defaultGreenButton
            let orSignUpLabel = cell.viewWithTag(3) as! UILabel
            let linkedInButton = cell.viewWithTag(4) as! defaultLinkedInButton
            let textView = cell.viewWithTag(5) as! CustomTextView
            let lineImageViewLeft = cell.viewWithTag(6) as! UIImageView
            let lineImageViewRight = cell.viewWithTag(7) as! UIImageView
            
            lineImageViewLeft.backgroundColor = defaultLightTextColor()
            lineImageViewRight.backgroundColor = defaultLightTextColor()
            
            forgotButton.setTitle(Localization("Forgot Password?"), for: .normal)
            forgotButton.setTitleColor(defaultGreenColor(), for: .normal)
            forgotButton.titleLabel?.font = UIFont(name: defaultRegular, size: buttonFontSize14)
            
            signInButton.setTitle(Localization("SIGN IN"), for: .normal)
            
            orSignUpLabel.text = Localization("Or Sign In Using")
            orSignUpLabel.font = UIFont(name: defaultRegular, size: textFontSize13)
            orSignUpLabel.textColor = defaultLightTextColor()
            
            linkedInButton.setTitle(Localization("SIGN IN WITH LINKEDIN"), for: .normal)
            
            let str:NSString = Localization("New here? Create Account") as NSString
            let string:NSMutableAttributedString = NSMutableAttributedString(string: "\(str)")
            string.addAttributes([NSAttributedStringKey.font: UIFont(name: defaultRegular, size: textFontSize14)!], range: str.range(of: str as String))
            string.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultDarkTextColor(), range: str.range(of: str as String))
            string.addAttribute(NSAttributedStringKey.link, value: "create", range: str.range(of: Localization("Create Account")))
            textView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:defaultGreenColor()]
            textView.attributedText = string
            textView.textAlignment = .center
        }
        else
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            let label = tempCell.viewWithTag(1) as! UILabel
            let textfField = tempCell.viewWithTag(2) as! UITextField
            
            textfField.delegate = self
            textfField.text = ""
            label.textColor = defaultLightTextColor()
            label.font = UIFont(name: defaultRegular, size: textFontSize14)
            textfField.textColor = defaultDarkTextColor()
            textfField.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
            textfField.isSecureTextEntry = false
            
            tempCell.hideError()
            
            if(indexPath.row == 1)
            {
                label.text = Localization("EMAIL/MOBILE NUMBER")
            tempCell.setPlaceholder(string:Localization(label.text!).replacingOccurrences(of: "*", with: ""))
                
                if(dataDic.value(forKey: "username") != nil && "\(dataDic.value(forKey: "username")!)" != "")
                {
                    textfField.text = "\(dataDic.value(forKey: "username")!)"
                }
                
                if errorDic.value(forKey: "username") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "username") as! String)
                }
            }
            else if(indexPath.row == 2)
            {
                label.text = Localization("PASSWORD")
                
            tempCell.setPlaceholder(string:Localization(label.text!).replacingOccurrences(of: "*", with: ""))
                textfField.isSecureTextEntry = true
                
                if(dataDic.value(forKey: "password") != nil && "\(dataDic.value(forKey: "password")!)" != "")
                {
                    textfField.text = "\(dataDic.value(forKey: "password")!)"
                }
                
                if errorDic.value(forKey: "password") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "password") as! String)
                }
            }
            
            cell = tempCell
        }
        return cell
    }
    
    
    //MARK:- TextView
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        self.hideKeyboard()
        
        if( URL.absoluteString ==  "create")
        {
            for vc in self.navigationController!.viewControllers
            {
                if(vc is CreateAccountControllerView)
                {
                    self.navigationController?.popToViewController(vc, animated: true)
                    return true
                }
            }
            
            let vc = CreateAccountControllerView(nibName: "CreateAccountControllerView", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
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
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row == 1
        {
            self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "username")
        }
        else if indexPath.row == 2
        {
            self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
        }
    }
    
    //MARK:- Button Actions
    @IBAction func sideMenu(_sender: UIBarButtonItem)
    {
        appDel.mainContainer.toggleLeftSideMenuCompletion(nil)
    }
    
    
    //    Forget Password button click event
    @IBAction func forgetButtonAction(_sender : UIButton){
        self.hideKeyboard()
        let vc = ForgetPassword(nibName: "ForgetPassword", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signButtonTapped(_sender: UIButton)
    {
        self.errorDic.removeAllObjects()
        self.hideKeyboard()
        self.tableView.reloadData() //removing all errors
        self.linkedInDic = NSMutableDictionary()
        
        if self.dataDic.value(forKey: "username") == nil || (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter your email or mobile number."), forKey: "username")
        }
        else if  (!numberFiler(string: (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines))) && !isValidEmail(testStr: (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
        {
            self.errorDic.setValue(Localization("Please enter valid email."), forKey: "username")
        }
        else if numberFiler(string: (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines)) &&  (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines).count < 8
        {
            self.errorDic.setValue(Localization("Please enter valid mobile number."), forKey: "username")
        }
        else if self.dataDic.value(forKey: "password") == nil || (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter your password."), forKey: "password")
        }
        //        else if !isValidPassword(testStr: (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
        //        {
        //            self.errorDic.setValue(Localization("Your password must be a combination of alphanumeric characters and atleast 8 characters long."), forKey: "password")
        //        }
        
        if self.errorDic.count == 0
        {
            self.loginWebService()
            return
        }
        
        self.tableView.reloadData() // showing all errors
    }
    
    @IBAction func signInWithLinkedIn(sender: UIButton)
    {
        self.linkedInDic = NSMutableDictionary()
        appDel.linkedInSignin()
        NotificationCenter.default.addObserver(self, selector:  #selector(gotLinkedInResponse(notification:)), name: NSNotification.Name(rawValue: "linkedInInfo"), object: nil)
    }
    
    @IBAction func verifyButtonClicked(_sender : UIButton){
        
        recaptcha?.validate(on: view) { [weak self] result in
            print(try? result.dematerialize())
        }
    }
    
    //MARK:- LinkedIn response
    @objc func gotLinkedInResponse(notification: NSNotification)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "linkedInInfo"), object: nil)
        self.linkedInDic = (notification.object as! NSDictionary).mutableCopy() as! NSMutableDictionary
        DispatchQueue.main.async {
            self.loginWebService()
        }
    }
    
    //MARK:- Account Type Delegate
    func accountTypeValue(value:String)
    {
        if value == "candidate" && self.linkedInDic.value(forKey: "first_name") != nil && "\(self.linkedInDic.value(forKey: "first_name")!)" != "" && self.linkedInDic.value(forKey: "last_name") != nil && "\(self.linkedInDic.value(forKey: "last_name")!)" != "" && self.linkedInDic.value(forKey: "email") != nil && "\(self.linkedInDic.value(forKey: "email")!)" != ""
        {
            self.candidateSignUpWebService()
        }
        else if value == "company" && self.linkedInDic.value(forKey: "company_name") != nil && "\(self.linkedInDic.value(forKey: "company_name")!)" != "" && self.linkedInDic.value(forKey: "location") != nil && "\(self.linkedInDic.value(forKey: "location")!)" != "" && self.linkedInDic.value(forKey: "first_name") != nil && "\(self.linkedInDic.value(forKey: "first_name")!)" != "" && self.linkedInDic.value(forKey: "last_name") != nil && "\(self.linkedInDic.value(forKey: "last_name")!)" != "" && self.linkedInDic.value(forKey: "email") != nil && "\(self.linkedInDic.value(forKey: "email")!)" != ""
        {
            self.companySignUpWebService()
        }
        else
        {
            let vc = CreateAccountControllerView(nibName: "CreateAccountControllerView", bundle: nil)
            vc.type = value
            vc.dataDic = self.linkedInDic
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //    MARK:- Web Services
    func loginWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        
        if self.linkedInDic.value(forKey: "linkedin") != nil
        {
            params.setValue(linkedInDic.value(forKey: "linkedin"), forKey: "linkedin")
        }
        else
        {
            params.setValue(self.dataDic.value(forKey: "username"), forKey: "username")
            params.setValue(self.dataDic.value(forKey: "password"), forKey: "password")
        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: login, parameter: params) { (JSON) in
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                if((JSON as! NSDictionary).object(forKey: "data") is NSDictionary)
                {
                    
                supportingfuction.showMessageHudWithMessage(message: "Success!", delay: 2.0)
                    //return
                        
                    let tempDic = removeAllNullValues(tempDic: ((JSON as! NSDictionary).object(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                    
                    UserDefaults.standard.setValue(tempDic, forKey: "userData")
                    UserDefaults.standard.synchronize()
                    initialiseUserData()
                    
                    let vc = CandidateProfileController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: "Data Not in Correct Format!", delay: 2.0)
                }
                
                
            }
            else
            {
                
                if self.linkedInDic.value(forKey: "linkedin") != nil
                {
                    let vc = SelectAccountPopUpViewController(nibName: "SelectAccountPopUp", bundle: nil)
                    vc.selectAccountDelegate = self
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                }
                else
                {
                    
                    //                // Showing message irrespective of Status
                    if (JSON as! NSDictionary).object(forKey: "errors") != nil && (JSON as! NSDictionary).object(forKey: "errors") is NSArray
                    {
                        let tempArray = ((JSON as! NSDictionary).object(forKey: "errors") as! NSArray).mutableCopy() as! NSMutableArray
                        
                        for item in tempArray
                        {
                            
                            
                            if((item as! NSDictionary).value(forKey: "key") as! String != "username" && (item as! NSDictionary).value(forKey: "key") as! String != "password")
                            {
                                supportingfuction.showMessageHudWithMessage(message: "\((item as! NSDictionary).value(forKey: "value")!)", delay: 2.0)
                                return
                            }
                            
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
    
    func companySignUpWebService()
    {
        let cv = CommonValidations()
        let params = linkedInDic
        params.setValue("", forKey: "mobile_number")
        params.setValue("", forKey: "phone_code")
        params.setValue("", forKey: "password")
        params.setValue("client_admin", forKey: "type")
        params.setValue(UserDefaults.standard.value(forKey: "device_token"), forKey: "device_token")
        params.setValue("iOS", forKey: "device_type")
        params.setValue("", forKey: "experience")
        params.setValue(UIDevice.current.model, forKey: "device_name")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: companySignUp, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                
                //Do something on success
                if((JSON as! NSDictionary).object(forKey: "message") != nil)
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: "Success!", delay: 2.0)
                }
                
                
                
                //                for vc in self.navigationController!.viewControllers
                //                {
                //                    if(vc is LoginViewController)
                //                    {
                //                        self.navigationController?.popToViewController(vc, animated: true)
                //                        return
                //                    }
                //                }
                //
                //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                //                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                //                self.navigationController?.pushViewController(loginVC, animated: true)
                
            }
            else
            {
                
                // Showing message irrespective of Status
                supportingfuction.showMessageHudWithMessage(message: "Something went wrong!", delay: 2.0)
            }
            
            
        }
    }
    
    func candidateSignUpWebService()
    {
        let cv = CommonValidations()
        let params = linkedInDic
        params.setValue("", forKey: "mobile_number")
        params.setValue("", forKey: "phone_code")
        params.setValue("", forKey: "password")
        params.setValue("candidate", forKey: "type")
        params.setValue(UserDefaults.standard.value(forKey: "device_token"), forKey: "device_token")
        params.setValue("iOS", forKey: "device_type")
        params.setValue("", forKey: "experience")
        params.setValue(UIDevice.current.model, forKey: "device_name")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: candidateSignUp, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                if((JSON as! NSDictionary).object(forKey: "message") != nil)
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: "Success!", delay: 2.0)
                }
                
                //for vc in self.navigationController!.viewControllers
                //                {
                //                    if(vc is LoginViewController)
                //                    {
                //                        self.navigationController?.popToViewController(vc, animated: true)
                //                        return
                //                    }
                //                }
                //
                //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                //                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                //                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            else
            {
                supportingfuction.showMessageHudWithMessage(message: "Something went wrong!", delay: 2.0)
            }
            
            
        }
    }
    
    
}

