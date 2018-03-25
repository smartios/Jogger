//
//  CreateAccountControllerView.swift
//  Janeous
//
//  Created by SS21 on 12/02/18.
//

import UIKit

class CreateAccountControllerView: MyBaseViewController,UITextFieldDelegate,UITextViewDelegate,selectCountryDelegate {
    
    //    IBOutlets declartion
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var optionCell:UITableViewCell!
    @IBOutlet var createAccountCell:UITableViewCell!
    
    let candidateTitleArr = ["","FIRST NAME", "LAST NAME","MOBILE NUMBER","PERSONAL EMAIL ADDRESS","PASSWORD"]
    let clientTitleArr = ["","COMPANY NAME", "LOCATION","FIRST NAME","LAST NAME","MOBILE NUMBER","WORK EMAIL ADDRESS","PASSWORD"]
    
    var type: String!
    var isPasswordSecureBool: Bool! = true
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    //    MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setWhiteNavigationbarWithTitleImageAndSideMenu()
    }
    
    func initialSetUp()  {
        
        if(type == nil)
        {
            type = "company"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tempDic = NSMutableDictionary()
        tempDic.setValue("91", forKey: "id")
        tempDic.setValue("+91", forKey: "name")
        self.dataDic.setValue(tempDic, forKey: "phone_code")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        
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
    @IBAction func candidateButtonClicked(sender:UIButton)
    {
        self.view.endEditing(true)
        type = "candidate"
        
        self.errorDic = NSMutableDictionary()
        tableView.reloadData()
    }
    
    @IBAction func companyButtonClicked(sender:UIButton)
    {
        self.view.endEditing(true)
        type = "company"
        
        self.errorDic = NSMutableDictionary()
        tableView.reloadData()
    }
    
    @IBAction  func countryCodeButtonClicked(_ sender:UIButton)
    {
        let vc = CountryListingController(nibName: "CountryListingController", bundle: nil)
        vc.from = "mobile_code"
        vc.selectCountryDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction  func securePasswordButtonClicked(_ sender:UIButton)
    {
        if isPasswordSecureBool == true
        {
            isPasswordSecureBool = false
        }
        else
        {
            isPasswordSecureBool = true
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction  func createAccountClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        var row = 0
        
        if  type == "company" && (self.dataDic.value(forKey: "company_name") == nil || (self.dataDic.value(forKey: "company_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            row = 1
            self.errorDic.setValue(Localization("Please enter your company name."), forKey: "company_name")
        }
        else if type == "company" && (self.dataDic.value(forKey: "location") == nil || (self.dataDic.value(forKey: "location") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            row = 2
            self.errorDic.setValue(Localization("Please enter your location."), forKey: "location")
        }
        else if self.dataDic.value(forKey: "first_name") == nil || (self.dataDic.value(forKey: "first_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            if(type == "candidate")
            {
                row = 1
            }
            else
            {
                row = 3
            }
            self.errorDic.setValue(Localization("Please enter your first name."), forKey: "first_name")
        }
        else if self.dataDic.value(forKey: "last_name") == nil || (self.dataDic.value(forKey: "last_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            if(type == "candidate")
            {
                row = 2
            }
            else
            {
                row = 4
            }
            self.errorDic.setValue(Localization("Please enter your last name."), forKey: "last_name")
        }
        else if self.dataDic.value(forKey: "mobile_number") == nil || (self.dataDic.value(forKey: "mobile_number") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            if(type == "candidate")
            {
                row = 3
            }
            else
            {
                row = 5
            }
            self.errorDic.setValue(Localization("Please enter your mobile number."), forKey: "mobile_number")
        }
        else if numberFiler(string: (self.dataDic.value(forKey: "mobile_number") as! String).trimmingCharacters(in: .whitespacesAndNewlines)) &&  (self.dataDic.value(forKey: "mobile_number") as! String).trimmingCharacters(in: .whitespacesAndNewlines).count < 8
        {
            if(type == "candidate")
            {
                row = 3
            }
            else
            {
                row = 5
            }
            self.errorDic.setValue(Localization("Please enter valid mobile number."), forKey: "mobile_number")
        }
        else if self.dataDic.value(forKey: "email") == nil || (self.dataDic.value(forKey: "email") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            if(type == "candidate")
            {
                row = 4
            }
            else
            {
                row = 6
            }
            self.errorDic.setValue(Localization("Please enter your email."), forKey: "email")
        }
        else if !isValidEmail(testStr: (self.dataDic.value(forKey: "email") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
        {
            if(type == "candidate")
            {
                row = 4
            }
            else
            {
                row = 6
            }
            self.errorDic.setValue(Localization("Please enter valid email."), forKey: "email")
        }
        else if self.dataDic.value(forKey: "password") == nil || (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            if(type == "candidate")
            {
                row = 5
            }
            else
            {
                row = 7
            }
            self.errorDic.setValue(Localization("Please enter your password."), forKey: "password")
        }
        //        else if !isValidPassword(testStr: (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
        //        {
        //            if(type == "candidate")
        //            {
        //                row = 5
        //            }
        //            else
        //            {
        //                row = 7
        //            }
        //            self.errorDic.setValue(Localization("Your password must be a combination of alphanumeric characters and atleast 8 characters long."), forKey: "password")
        //        }
        
        if type == "candidate" && self.errorDic.count == 0
        {
            self.candidateSignUpWebService()
            return
        }
        else if self.errorDic.count == 0
        {
            self.companySignUpWebService()
            return
        }
        
        self.tableView.reloadData()
        self.scrollToIndexPath(indexPath:  IndexPath(row: row, section: 0))
    }
    
    func scrollToIndexPath(indexPath:IndexPath)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(type == "candidate" && indexPath.row == 3) || (type == "company" && indexPath.row == 5)
        {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.hideKeyboard))
            
            let items = NSMutableArray()
            items.add(flexSpace)
            items.add(done)
            doneToolbar.setItems([flexSpace,done], animated: true)
            doneToolbar.sizeToFit()
            
            textField.keyboardType = .numberPad
            textField.inputAccessoryView = doneToolbar
        }
        else
        {
            textField.keyboardType = .default
            textField.inputAccessoryView = nil
        }
        
        if(type == "candidate" && indexPath.row == 5) || (type == "company" && indexPath.row == 7)
        {
            textField.returnKeyType = .done
        }
        else
        {
            textField.returnKeyType = .next
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(type == "candidate" && indexPath.row == 3) || (type == "company" && indexPath.row == 5)
        {
            if numberFiler(string: string) && (textField.text!.count < 15 || string == "")
            {
                return true
            }
            else
            {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(type == "candidate")
        {
            if indexPath.row == 1
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "first_name")
            }
            else if indexPath.row == 2
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "last_name")
            }
            else if indexPath.row == 3
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "mobile_number")
            }
            else if indexPath.row == 4
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
            }
            else if indexPath.row == 5
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
            }
            
        }
        else
        {
            if indexPath.row == 1
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "company_name")
            }
            else if indexPath.row == 2
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "location")
            }
            else if indexPath.row == 3
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "first_name")
            }
            else if indexPath.row == 4
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "last_name")
            }
            else if indexPath.row == 5
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "mobile_number")
            }
            else if indexPath.row == 6
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
            }
            else if indexPath.row == 7
            {
                self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(type == "candidate" && indexPath.row == 5) || (type == "company" && indexPath.row == 7)
        {
            self.hideKeyboard()
        }
        else
        {
            let nextIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let cell:UITableViewCell = self.tableView.cellForRow(at: nextIndexPath)!
            let nextTextField = cell.viewWithTag(2) as! UITextField
            
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    //MARK:- TextView
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if("\(url)" ==  "sign_in")
        {
            for vc in self.navigationController!.viewControllers
            {
                if(vc is LoginViewController)
                {
                    self.navigationController?.popToViewController(vc, animated: true)
                    return true
                }
            }
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        else if("\(url)" == "terms")
        {
            print(">>>>>>>>>>>")
        }
        else if("\(url)" == "policy")
        {
            print(">>>>>>>>>>>")
        }
        return true
    }
    
    //MARK:- Delegate
    func countryValue(from:String, withDic:NSDictionary)
    {
        self.dataDic.setValue(withDic, forKey: "phone_code")
        self.tableView.reloadData()
    }
    
    //    MARK:- Web Services
    func companySignUpWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.dataDic.value(forKey: "company_name"), forKey: "company_name")
        params.setValue(self.dataDic.value(forKey: "location"), forKey: "location")
        params.setValue(self.dataDic.value(forKey: "first_name"), forKey: "first_name")
        params.setValue(self.dataDic.value(forKey: "last_name"), forKey: "last_name")
        params.setValue(self.dataDic.value(forKey: "mobile_number"), forKey: "mobile_number")
        params.setValue((self.dataDic.value(forKey: "phone_code") as! NSDictionary).value(forKey: "id"), forKey: "phone_code")
        params.setValue(self.dataDic.value(forKey: "email"), forKey: "email")
        params.setValue(self.dataDic.value(forKey: "password"), forKey: "password")
        params.setValue("client_admin", forKey: "type")
        params.setValue(UserDefaults.standard.value(forKey: "device_token"), forKey: "device_token")
        params.setValue("iOS", forKey: "device_type")
        params.setValue("", forKey: "experience")
        params.setValue(UIDevice.current.model, forKey: "device_name")
        
        if self.dataDic.value(forKey: "linkedin") != nil
        {
            params.setValue(self.dataDic.value(forKey: "linkedin"), forKey: "linkedin")
        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: companySignUp, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                
                self.dataDic = NSMutableDictionary()
                //Do something on success
                if((JSON as! NSDictionary).object(forKey: "message") != nil)
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: "Success!", delay: 2.0)
                }
                
                for vc in self.navigationController!.viewControllers
                {
                    if(vc is LoginViewController)
                    {
                        self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
                
            }
            else
            {
                if (JSON as! NSDictionary).object(forKey: "errors") != nil && (JSON as! NSDictionary).object(forKey: "errors") is NSArray
                {
                    let tempArray = ((JSON as! NSDictionary).object(forKey: "errors") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for item in tempArray
                    {
                        self.errorDic.setValue((item as! NSDictionary).value(forKey: "value"), forKey:(item as! NSDictionary).value(forKey: "key") as! String)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
            
            
        }
    }
    
    func candidateSignUpWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.dataDic.value(forKey: "first_name"), forKey: "first_name")
        params.setValue(self.dataDic.value(forKey: "last_name"), forKey: "last_name")
        params.setValue(self.dataDic.value(forKey: "mobile_number"), forKey: "mobile_number")
        params.setValue((self.dataDic.value(forKey: "phone_code") as! NSDictionary).value(forKey: "id"), forKey: "phone_code")
        params.setValue(self.dataDic.value(forKey: "email"), forKey: "email")
        params.setValue(self.dataDic.value(forKey: "password"), forKey: "password")
        params.setValue("candidate", forKey: "type")
        params.setValue(UserDefaults.standard.value(forKey: "device_token"), forKey: "device_token")
        params.setValue("iOS", forKey: "device_type")
        params.setValue("", forKey: "experience")
        params.setValue(UIDevice.current.model, forKey: "device_name")
        
        if self.dataDic.value(forKey: "linkedin") != nil
        {
            params.setValue(self.dataDic.value(forKey: "linkedin"), forKey: "linkedin")
        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: candidateSignUp, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                
                self.dataDic = NSMutableDictionary()
                if((JSON as! NSDictionary).object(forKey: "message") != nil)
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: "Success!", delay: 2.0)
                }
                
                for vc in self.navigationController!.viewControllers
                {
                    if(vc is LoginViewController)
                    {
                        self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            else
            {
                if (JSON as! NSDictionary).object(forKey: "errors") != nil && (JSON as! NSDictionary).object(forKey: "errors") is NSArray
                {
                    let tempArray = ((JSON as! NSDictionary).object(forKey: "errors") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for item in tempArray
                    {
                        self.errorDic.setValue((item as! NSDictionary).value(forKey: "value"), forKey:(item as! NSDictionary).value(forKey: "key") as! String)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
            
            
        }
    }
    
}

//MARK:- TableView
extension CreateAccountControllerView: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(type == "candidate")
        {
            return candidateTitleArr.count + 1
        }
        else
        {
            return clientTitleArr.count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        Bundle.main.loadNibNamed("CreateAccountViewCell", owner: self, options: nil)
        // Bundle.main.loadNibNamed("CreateAccountViewCell", owner: self, options: nil)
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
            if(cell == nil)
            {
                cell = optionCell
                optionCell = nil
            }
            
            let titleLabel = cell.viewWithTag(1) as! UILabel
            let subTitleLabel = cell.viewWithTag(2) as! UILabel
            let accountTypeLabel = cell.viewWithTag(3) as! UILabel
            let candidateButton = cell.viewWithTag(4) as! UIButton
            let companyButton = cell.viewWithTag(5) as! UIButton
            
            titleLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
            titleLabel.textColor = defaultDarkTextColor()
            titleLabel.text = Localization("Create Account")
            
            subTitleLabel.font = UIFont(name: defaultLight, size: textFontSize15)
            subTitleLabel.textColor = defaultLightTextColor()
            subTitleLabel.text = Localization("Choose an account type and sign up")
            
            accountTypeLabel.font = UIFont(name: defaultLight, size: textFontSize15)
            accountTypeLabel.textColor = defaultLightTextColor()
            accountTypeLabel.text = Localization("ACCOUNT TYPE")
            
            candidateButton.setTitle(Localization("CANDIDATE"), for: .normal)
            candidateButton.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
            candidateButton.setTitleColor(defaultLightTextColor(), for: .normal)
            candidateButton.setImage(#imageLiteral(resourceName: "candidate_unselected"), for: .normal)
            candidateButton.setTitleColor(defaultWhiteTextColor(), for: .selected)
            candidateButton.setImage(#imageLiteral(resourceName: "candidate_selected"), for: .selected)
            
            companyButton.setTitle(Localization("COMPANY"), for: .normal)
            companyButton.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
            companyButton.setTitleColor(defaultLightTextColor(), for: .normal)
            companyButton.setImage(#imageLiteral(resourceName: "company_unselected"), for: .normal)
            companyButton.setTitleColor(defaultWhiteTextColor(), for: .selected)
            companyButton.setImage(#imageLiteral(resourceName: "company_selected"), for: .selected)
            
            if(type == "candidate")
            {
                candidateButton.isSelected = true
                companyButton.isSelected = false
                candidateButton.backgroundColor = defaultLightTextColor()
                companyButton.backgroundColor = defaultWhiteButtonBackgroundColor()
            }
            else
            {
                candidateButton.isSelected = false
                companyButton.isSelected = true
                candidateButton.backgroundColor = defaultWhiteButtonBackgroundColor()
                companyButton.backgroundColor = defaultLightTextColor()
            }
            
        }
        else if (type == "candidate" && indexPath.row == candidateTitleArr.count) || indexPath.row == clientTitleArr.count
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "createAccountCell")
            
            if(cell == nil)
            {
                cell = createAccountCell
                createAccountCell = nil
            }
            
            let policyTextView = cell.viewWithTag(1) as! UITextView
            let signTextView = cell.viewWithTag(3) as! UITextView
            
            policyTextView.delegate = self
            signTextView.delegate = self
            
            //Policy Text View
            let str:NSString = Localization("By clicking `Create Account`, you agree to the\nTerms of Service and Privacy Policy.") as NSString
            let string:NSMutableAttributedString = NSMutableAttributedString(string: "\(str)")
            string.addAttributes([NSAttributedStringKey.font: UIFont(name: defaultRegular, size: textFontSize14)!], range: str.range(of: str as String))
            string.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultDarkTextColor(), range: str.range(of: str as String))
            string.addAttribute(NSAttributedStringKey.link, value: "terms", range: str.range(of: Localization("Terms of Service")))
            string.addAttribute(NSAttributedStringKey.link, value: "policy", range: str.range(of: Localization("Privacy Policy")))
            policyTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:defaultGreenColor()]
            policyTextView.attributedText = string
            policyTextView.textAlignment = .center
            
            //Sign In text View
            let str2:NSString = Localization("Already have an account? Sign In") as NSString
            let string2:NSMutableAttributedString = NSMutableAttributedString(string: "\(str2)")
            string2.addAttributes([NSAttributedStringKey.font: UIFont(name: defaultRegular, size: textFontSize14)!], range: str2.range(of: str2 as String))
            string2.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultDarkTextColor(), range: str2.range(of: str2 as String))
            string2.addAttribute(NSAttributedStringKey.link, value: "sign_in", range: str2.range(of: Localization("Sign In")))
            signTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:defaultGreenColor()]
            signTextView.attributedText = string2
            signTextView.textAlignment = .center
            
            
        }
        else
        {
            //            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! TitleLabelCellTableViewCell
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            //let errorLabel = cell.viewWithTag(5) as! UILabel
            //let lineImageView = cell.viewWithTag(6) as! UIImageView
            let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            let mobileCodeTextField = tempCell.viewWithTag(21) as! UITextField
            let mobileCodeButton = tempCell.viewWithTag(22) as! UIButton
            
            tempCell.notMobileField()
            tempCell.hideRightButton()
            tempCell.hideError()
            textfield.isSecureTextEntry = false
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            
            rightButton.setImage(#imageLiteral(resourceName: "Password_Show"), for: .selected)
            rightButton.setImage(#imageLiteral(resourceName: "Password_Hide"), for: .normal)
            rightButton.addTarget(self, action: #selector(securePasswordButtonClicked(_:)), for: .touchUpInside)
            
            if(self.isPasswordSecureBool == true)
            {
                rightButton.isSelected = false
            }
            else
            {
                rightButton.isSelected = true
            }
            
            if(type == "candidate")
            {
                titleLabel.text = Localization(candidateTitleArr[indexPath.row])
            tempCell.setPlaceholder(string:Localization(candidateTitleArr[indexPath.row]).replacingOccurrences(of: "*", with: ""))
                
                if(indexPath.row == 1)
                {
                    
                    if dataDic.value(forKey: "first_name") != nil
                    {
                        textfield.text = dataDic.value(forKey: "first_name") as? String
                    }
                    
                    if errorDic.value(forKey: "first_name") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                    }
                }
                else if(indexPath.row == 2)
                {
                    if dataDic.value(forKey: "last_name") != nil
                    {
                        textfield.text = dataDic.value(forKey: "last_name") as? String
                    }
                    
                    if errorDic.value(forKey: "last_name") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "last_name") as! String)
                    }
                }
                else if(indexPath.row == 3)
                {
                    tempCell.thisIsMobileField()
                    //phone_code
                    
                    if(dataDic.value(forKey: "phone_code") != nil && dataDic.value(forKey: "phone_code") is NSDictionary && (dataDic.value(forKey: "phone_code") as? NSDictionary)?.value(forKey: "id") != nil)
                    {
                        mobileCodeTextField.text = "\((dataDic.value(forKey: "phone_code") as! NSDictionary).value(forKey: "name")!)"
                    }
                    
                    mobileCodeButton.addTarget(self, action: #selector(countryCodeButtonClicked(_:)), for: .touchUpInside)
                    
                    if dataDic.value(forKey: "mobile_number") != nil
                    {
                        textfield.text = dataDic.value(forKey: "mobile_number") as? String
                    }
                    
                    if errorDic.value(forKey: "mobile_number") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "mobile_number") as! String)
                    }
                    
                }
                else if(indexPath.row == 4)
                {
                    
                    if dataDic.value(forKey: "email") != nil
                    {
                        textfield.text = dataDic.value(forKey: "email") as? String
                    }
                    
                    if errorDic.value(forKey: "email") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "email") as! String)
                    }
                }
                else if(indexPath.row == 5)
                {
                    textfield.isSecureTextEntry = isPasswordSecureBool
                    
                    tempCell.showRightButton()
                    
                    if dataDic.value(forKey: "password") != nil
                    {
                        textfield.text = dataDic.value(forKey: "password") as? String
                    }
                    
                    if errorDic.value(forKey: "password") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "password") as! String)
                    }
                }
            }
            else
            {
                titleLabel.text = Localization(clientTitleArr[indexPath.row])
            tempCell.setPlaceholder(string:Localization(clientTitleArr[indexPath.row]).replacingOccurrences(of: "*", with: ""))
                
                if(indexPath.row == 1)
                {
                    
                    if dataDic.value(forKey: "company_name") != nil
                    {
                        textfield.text = dataDic.value(forKey: "company_name") as? String
                    }
                    
                    if errorDic.value(forKey: "company_name") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "company_name") as! String)
                    }
                    
                }
                else if(indexPath.row == 2)
                {
                    if dataDic.value(forKey: "location") != nil
                    {
                        textfield.text = dataDic.value(forKey: "location") as? String
                    }
                    
                    if errorDic.value(forKey: "location") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "location") as! String)
                    }
                }
                else if(indexPath.row == 3)
                {
                    
                    if dataDic.value(forKey: "first_name") != nil
                    {
                        textfield.text = dataDic.value(forKey: "first_name") as? String
                    }
                    
                    if errorDic.value(forKey: "first_name") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                    }
                }
                else if(indexPath.row == 4)
                {
                    if dataDic.value(forKey: "last_name") != nil
                    {
                        textfield.text = dataDic.value(forKey: "last_name") as? String
                    }
                    
                    if errorDic.value(forKey: "last_name") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "last_name") as! String)
                    }
                }
                else if(indexPath.row == 5)
                {
                    tempCell.thisIsMobileField()
                    
                    if(dataDic.value(forKey: "phone_code") != nil && dataDic.value(forKey: "phone_code") is NSDictionary && (dataDic.value(forKey: "phone_code") as? NSDictionary)?.value(forKey: "id") != nil)
                    {
                        mobileCodeTextField.text = "\((dataDic.value(forKey: "phone_code") as! NSDictionary).value(forKey: "name")!)"
                    }
                    
                    mobileCodeButton.addTarget(self, action: #selector(countryCodeButtonClicked(_:)), for: .touchUpInside)
                    
                    if dataDic.value(forKey: "mobile_number") != nil
                    {
                        textfield.text = dataDic.value(forKey: "mobile_number") as? String
                    }
                    
                    if errorDic.value(forKey: "mobile_number") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "mobile_number") as! String)
                    }
                }
                else if(indexPath.row == 6)
                {
                    if dataDic.value(forKey: "email") != nil
                    {
                        textfield.text = dataDic.value(forKey: "email") as? String
                    }
                    
                    if errorDic.value(forKey: "email") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "email") as! String)
                    }
                    
                }
                else if(indexPath.row == 7)
                {
                    textfield.isSecureTextEntry = isPasswordSecureBool
                    tempCell.showRightButton()
                    
                    if dataDic.value(forKey: "password") != nil
                    {
                        textfield.text = dataDic.value(forKey: "password") as? String
                    }
                    
                    if errorDic.value(forKey: "password") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "password") as! String)
                    }
                }
            }
            
            cell = tempCell
        }
        
        return cell
    }
    
    
}
