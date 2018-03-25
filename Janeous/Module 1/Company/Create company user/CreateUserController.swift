//
//  CreateUserController.swift
//  Janeous
//
//  Created by SS21 on 14/02/18.
//

import UIKit

class CreateUserController: MyBaseViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,selectCountryDelegate {
    
    
    @IBOutlet var tableView:UITableView!
    
    let TitleArr = ["FIRST NAME*","LAST NAME*","PRIMARY BRANCH*","MOBILE NUMBER","WORK EMAIL ADDRESS*","PASSWORD*","USER TYPE*","STATUS*"]
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    var isPasswordSecureBool: Bool! = true
    var from = "add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddWorkExperienceController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddWorkExperienceController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddWorkExperienceController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        tableView.register(UINib(nibName: "FullWidthButtonCell", bundle: nil), forCellReuseIdentifier: "BtnCell")
        
        let tempDic = NSMutableDictionary()
        tempDic.setValue("91", forKey: "id")
        tempDic.setValue("+91", forKey: "name")
        self.dataDic.setValue(tempDic, forKey: "phone_code")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let str:NSString = Localization("Create user") as NSString
        
        let attributedString1 = NSMutableAttributedString(string: "\(str)")
        
        self.setGrayNavigationbarWithTitle(AttributedString: attributedString1)
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
    
    //MARK:- Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleArr.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == self.TitleArr.count
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "BtnCell")
            
            let saveAndAddButton = cell.viewWithTag(1) as! UIButton
            saveAndAddButton.setTitle(Localization("SAVE AND ADD"), for: .normal)
            saveAndAddButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
        }
        else if indexPath.row == self.TitleArr.count + 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell")
            let cancelButton = cell.viewWithTag(12) as! UIButton
            let doneButton = cell.viewWithTag(13) as! UIButton
            
            cancelButton.setTitle(Localization("CANCEL"), for: .normal)
            doneButton.setTitle(Localization("DONE"), for: .normal)
            
            cancelButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            doneButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
        }
        else
        {
            
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
            textfield.isUserInteractionEnabled = true
            rightButton.isUserInteractionEnabled = false
            
            rightButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
            
            let str:NSString = Localization(TitleArr[indexPath.row]) as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
       tempCell.setPlaceholder(string:Localization(TitleArr[indexPath.row]).replacingOccurrences(of: "*", with: ""))
            
            if(indexPath.row == 0)
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
            else if(indexPath.row == 1)
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
            else if(indexPath.row == 2)
            {
                tempCell.showRightButton()
                
                textfield.isUserInteractionEnabled = false
                
                if dataDic.value(forKey: "primary_branch") != nil
                {
                    textfield.text = dataDic.value(forKey: "primary_branch") as? String
                }
                
                if errorDic.value(forKey: "primary_branch") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "primary_branch") as! String)
                }
            }
            else if(indexPath.row == 3)
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
                rightButton.isUserInteractionEnabled = true
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
            else if(indexPath.row == 6)
            {
                tempCell.showRightButton()
                
                textfield.isUserInteractionEnabled = false
                
                if dataDic.value(forKey: "user_type") != nil
                {
                    textfield.text = dataDic.value(forKey: "user_type") as? String
                }
                
                if errorDic.value(forKey: "user_type") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "user_type") as! String)
                }
            }
            else if(indexPath.row == 7)
            {
                tempCell.showRightButton()
                textfield.isUserInteractionEnabled = false
                
                if dataDic.value(forKey: "status") != nil
                {
                    textfield.text = dataDic.value(forKey: "status") as? String
                }
                
                if errorDic.value(forKey: "status") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "status") as! String)
                }
            }
            
            cell = tempCell
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.returnKeyType = .next
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        

                if indexPath.row == 0
                {
                    self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "first_name")
                }
                else if indexPath.row == 1
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(indexPath.row > 5)
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
    
    //MARK:- Delegate
    func countryValue(from:String, withDic:NSDictionary)
    {
        self.dataDic.setValue(withDic, forKey: "phone_code")
        self.tableView.reloadData()
    }
    
    //MARK:- Actions
    @IBAction  func countryCodeButtonClicked(_ sender:UIButton)
    {
        let vc = CountryListingController(nibName: "CountryListingController", bundle: nil)
        vc.from = "mobile_code"
        vc.selectCountryDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction  func saveButtonClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        var row = 0
        
        if self.dataDic.value(forKey: "first_name") == nil || (self.dataDic.value(forKey: "first_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter your first name."), forKey: "first_name")
        }
        else if self.dataDic.value(forKey: "last_name") == nil || (self.dataDic.value(forKey: "last_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            row = 1
            
            self.errorDic.setValue(Localization("Please enter your last name."), forKey: "last_name")
        }
        else if self.dataDic.value(forKey: "primary_branch") == nil
        {
            
            row = 2
            
            self.errorDic.setValue(Localization("Please enter primary branch."), forKey: "primary_branch")
        }
        else if self.dataDic.value(forKey: "mobile_number") == nil || (self.dataDic.value(forKey: "mobile_number") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            row = 3
            
            self.errorDic.setValue(Localization("Please enter your mobile number."), forKey: "mobile_number")
        }
        else if numberFiler(string: (self.dataDic.value(forKey: "mobile_number") as! String).trimmingCharacters(in: .whitespacesAndNewlines)) &&  (self.dataDic.value(forKey: "mobile_number") as! String).trimmingCharacters(in: .whitespacesAndNewlines).count < 8
        {
            
            row = 3
            
            self.errorDic.setValue(Localization("Please enter valid mobile number."), forKey: "mobile_number")
        }
        else if self.dataDic.value(forKey: "email") == nil || (self.dataDic.value(forKey: "email") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            row = 4
            
            self.errorDic.setValue(Localization("Please enter your email."), forKey: "email")
        }
        else if !isValidEmail(testStr: (self.dataDic.value(forKey: "email") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
        {
            
            row = 4
            
            self.errorDic.setValue(Localization("Please enter valid email."), forKey: "email")
        }
        else if self.dataDic.value(forKey: "password") == nil || (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            row = 5
            self.errorDic.setValue(Localization("Please enter your password."), forKey: "password")
        }
        else if self.dataDic.value(forKey: "user_type") == nil
        {
            row = 6
            self.errorDic.setValue(Localization("Please enter your user type."), forKey: "user_type")
        }
        else if self.dataDic.value(forKey: "status") == nil
        {
            row = 7
            self.errorDic.setValue(Localization("Please enter your status."), forKey: "status")
        }
        
        if self.errorDic.count == 0
        {
            if sender.tag == 1
            {
                self.addUserWebService(addAnotherBool: true)
            }
            else
            {
                self.addUserWebService(addAnotherBool: false)
            }
            return
        }
        
        self.tableView.reloadData()
        self.scrollToIndexPath(indexPath:  IndexPath(row: row, section: 0))
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
    
    func scrollToIndexPath(indexPath:IndexPath)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    //MARK:- Web Services
    func addUserWebService(addAnotherBool:Bool)
    {
        let cv = CommonValidations()
        let params = self.dataDic
        
        var URL = clientAddUser
        if from != "add"
        {
            URL = clientEditUser
        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: URL, parameter: params) { (JSON) in
            
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
                
                if addAnotherBool == false
                {
                    self.backButtonClicked()
                    return
                }
                
                self.dataDic = NSMutableDictionary()
                self.from = "add"
                self.tableView.reloadData()
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


