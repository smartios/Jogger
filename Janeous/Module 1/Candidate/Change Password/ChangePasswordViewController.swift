//
//  ChangePasswordViewController.swift
//  Janeous
//
//  Created by singsys on 18/03/18.
//

import UIKit

class ChangePasswordViewController: MyBaseViewController,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttonCell:UITableViewCell!
    @IBOutlet var headerLabelCell:UITableViewCell!
    
    let changePasswordTitleArr = ["PASSWORD MUST BE AT LEAST 6 CHARACTERS","TYPE YOUR CURRENT PASSWORD*", "TYPE YOUR NEW PASSWORD*","RETYPE YOUR NEW PASSWORD*",""]
    let createPasswordTitleArr = ["ADD ABILITY TO LOGIN WITH EMAIL","PERSONAL EMAIL ADDRESS","PASSWORD*",""]
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    var from = "change"
    var isPasswordSecureBool: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
         Bundle.main.loadNibNamed("ChangePasswordCells", owner: self, options: nil)
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var string = Localization("Change Password")
        
        if from != "change"
        {
            string = Localization("Create Password")
        }
        self.setWhiteNavigationbarWithBackButtonAndTitle(titleStrng: string)
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
        if from == "change"
        {
            return changePasswordTitleArr.count
        }
        else
        {
            return createPasswordTitleArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        var tempTitleArray = changePasswordTitleArr
        
        if from != "change"
        {
            tempTitleArray = createPasswordTitleArr
        }
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerLabelCell")
            if cell == nil{
                cell = headerLabelCell
                headerLabelCell = nil
            }
            
            let headerLabel = cell.viewWithTag(1) as! UILabel
            headerLabel.textColor = defaultDarkTextColor()
            headerLabel.font = UIFont(name: defaultMedium, size: textFontSize13)
            headerLabel.text = Localization(tempTitleArray[indexPath.row])
        }
        else if indexPath.row == tempTitleArray.count - 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            if cell == nil{
                cell = buttonCell
                buttonCell = nil
            }
            
            let saveButton = cell.viewWithTag(1) as! UIButton
            saveButton.setTitle(Localization("SAVE"), for: .normal)
            saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        }
        else
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            tempCell.hideRightButton()
            tempCell.hideError()
            textfield.isUserInteractionEnabled = true
            textfield.isSecureTextEntry = true
            
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
            
            let str:NSString = Localization(tempTitleArray[indexPath.row]) as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
        tempCell.setPlaceholder(string:Localization(tempTitleArray[indexPath.row]).replacingOccurrences(of: "*", with: ""))
     
            
            if from == "change"
            {
                if indexPath.row == 1
                {
                    if dataDic.value(forKey: "old_password") != nil
                    {
                        textfield.text = dataDic.value(forKey: "old_password") as? String
                    }
                    
                    if errorDic.value(forKey: "old_password") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "old_password") as! String)
                    }
                }
                else if indexPath.row == 2
                {
                    if dataDic.value(forKey: "password") != nil
                    {
                        textfield.text = dataDic.value(forKey: "password") as? String
                    }
                    
                    if errorDic.value(forKey: "password") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "password") as! String)
                    }
                }
                else
                {
                    if dataDic.value(forKey: "confirm_password") != nil
                    {
                        textfield.text = dataDic.value(forKey: "confirm_password") as? String
                    }
                    
                    if errorDic.value(forKey: "confirm_password") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "confirm_password") as! String)
                    }
                }
            }
            else
            {
                if indexPath.row == 1
                {
                    textfield.isUserInteractionEnabled = false
                    textfield.isSecureTextEntry = false
                    
                    if dataDic.value(forKey: "email") != nil
                    {
                        textfield.text = dataDic.value(forKey: "email") as? String
                    }
                    
                    if errorDic.value(forKey: "email") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "email") as! String)
                    }
                }
                else
                {
                    tempCell.showRightButton()
                    textfield.isSecureTextEntry = isPasswordSecureBool
                    
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
        
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(from == "change" && indexPath.row == 3) || (from != "change" && indexPath.row == 2)
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
        
        if from == "change"
        {
            if indexPath.row == 1
            {
                self.dataDic.setValue(textField.text, forKey: "old_password")
            }
            else if indexPath.row == 2
            {
                self.dataDic.setValue(textField.text, forKey: "password")
            }
            else if indexPath.row == 3
            {
                self.dataDic.setValue(textField.text, forKey: "confirm_password")
            }
        }
        else
        {
            if indexPath.row == 2
            {
                self.dataDic.setValue(textField.text, forKey: "password")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(from == "change" && indexPath.row == 3) || (from != "change" && indexPath.row == 2)
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
    
    //MARK:- Actions
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
    
    @objc func saveButtonClicked()
    {
        self.errorDic.removeAllObjects()
        self.hideKeyboard()
        self.tableView.reloadData() //removing all errors
        
        if  from == "change" && (self.dataDic.value(forKey: "old_password") == nil || (self.dataDic.value(forKey: "old_password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            self.errorDic.setValue(Localization("Please enter your old password."), forKey: "old_password")
        }
        else if (self.dataDic.value(forKey: "password") == nil || (self.dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            self.errorDic.setValue(Localization("Please enter your password."), forKey: "password")
        }
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
            self.changePasswordWebService()
            return
        }
        
        self.tableView.reloadData()
    }
    
    //MARK:- Web Services
    func changePasswordWebService()
    {
        let cv = CommonValidations()
        let params = self.dataDic
        
        var URL = candidateChangePassword
        if from != "change"
        {
            URL = createPassword
        }
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: URL, parameter: params) { (JSON) in
            
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
