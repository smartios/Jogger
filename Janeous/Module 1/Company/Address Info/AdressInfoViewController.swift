//
//  AdressInfoViewController.swift
//  Janeous
//
//  Created by singsys on 22/03/18.
//

import UIKit

class AdressInfoViewController: MyBaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet var  tableView : UITableView!
    @IBOutlet var  checkBoxCell : UITableViewCell!
    @IBOutlet var  headerLabelCell : UITableViewCell!
    
    let TitleArr = ["BILLING ADDRESS INFORMATION","STREET", "CITY","STATE","CODE","COUNTRY","LOCATION ADDRESS INFORMATION","Same as billing address","STREET","CITY","STATE"]
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()

    var sameBilling:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(AdressInfoViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AdressInfoViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AdressInfoViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        Bundle.main.loadNibNamed("AddressInfoCells", owner: self, options: nil)
    
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Setting navigation bar title
        
        let attributedString1 = NSMutableAttributedString(string: Localization("Edit Address Information"))
        
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
        return TitleArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == 0 || indexPath.row == 7
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerLabelCell")
            if cell == nil{
                cell = headerLabelCell
                //headerLabelCell = nil
            }
            
            let headerLabel = cell.viewWithTag(1) as! UILabel
            headerLabel.textColor = defaultDarkTextColor()
            headerLabel.font = UIFont(name: defaultMedium, size: textFontSize13)
            headerLabel.text = Localization(TitleArr[indexPath.row])
        }
        else if indexPath.row == 8
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "checkBoxCell")
            if cell == nil{
                cell = checkBoxCell
                checkBoxCell = nil
            }
            
            let checkButton = cell.viewWithTag(1) as! UIButton
            let titleLabel = cell.viewWithTag(2) as! UILabel
            
            checkButton.isSelected = sameBilling
            
            titleLabel.text = Localization(TitleArr[indexPath.row])
            
            checkButton.addTarget(self, action: #selector(sameAsBillingAddressButtonClicked(_:)), for: .touchUpInside)
        }
        else if indexPath.row == TitleArr.count
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
            //let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            tempCell.hideRightButton()
            tempCell.hideError()
            textfield.isUserInteractionEnabled = true
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            let str:NSString = Localization(TitleArr[indexPath.row]) as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
            tempCell.setPlaceholder(string:Localization(TitleArr[indexPath.row]).replacingOccurrences(of: "*", with: ""))
            
            if indexPath.row == 0
            {
                if dataDic.value(forKey: "jobtitle") != nil
                {
                    textfield.text = dataDic.value(forKey: "jobtitle") as? String
                }
                
                if errorDic.value(forKey: "jobtitle") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "jobtitle") as! String)
                }
            }
            else if indexPath.row == 1
            {
                
                if dataDic.value(forKey: "experience_level") != nil
                {
                    textfield.text = dataDic.value(forKey: "experience_level") as? String
                }
                
                if errorDic.value(forKey: "experience_level") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "experience_level") as! String)
                }
            }
            else if indexPath.row == 2
            {
                if dataDic.value(forKey: "industry") != nil
                {
                    textfield.text = dataDic.value(forKey: "industry") as? String
                }
                
                if errorDic.value(forKey: "industry") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "industry") as! String)
                }
            }
            else if indexPath.row == 3
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
            else if indexPath.row == 4
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
            else if indexPath.row == 8
            {
                if errorDic.value(forKey: "tags") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "tags") as! String)
                }
                
                tempCell.setPlaceholder(string:Localization("Start typing to select job tages").replacingOccurrences(of: "*", with: ""))
                
            }
            else if indexPath.row == 10
            {
                if dataDic.value(forKey: "function") != nil
                {
                    textfield.text = dataDic.value(forKey: "function") as? String
                }
                
                if errorDic.value(forKey: "function") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "function") as! String)
                }
                
                tempCell.setPlaceholder(string:Localization("Start typing to select job functions").replacingOccurrences(of: "*", with: ""))
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
        
        if(indexPath.row == self.TitleArr.count - 1 || indexPath.row == 6)
        {
            textField.returnKeyType = .done
        }
        else
        {
            textField.returnKeyType = .next
        }
    }

    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        
        if indexPath.row == 0
        {
            self.dataDic.setValue(textField.text, forKey: "jobtitle")
        }
        else if indexPath.row == 3
        {
            self.dataDic.setValue(textField.text, forKey: "company_name")
        }
        else if indexPath.row == 10
        {
            self.dataDic.setValue(textField.text, forKey: "function")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(indexPath.row == self.TitleArr.count - 1 || indexPath.row == 6)
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
    @IBAction  func sameAsBillingAddressButtonClicked(_ sender: UIButton)
    {
        if sameBilling == false
        {
            self.sameBilling = true
        }
        else
        {
            self.sameBilling = false
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction  func saveButtonClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        var row = 0
        
        if self.dataDic.value(forKey: "jobtitle") == nil || (self.dataDic.value(forKey: "jobtitle") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            self.errorDic.setValue(Localization("Please enter your job title."), forKey: "jobtitle")
        }
        else if self.dataDic.value(forKey: "experience_level") == nil
        {
            row = 1
            
            self.errorDic.setValue(Localization("Please enter your experience level."), forKey: "experience_level")
        }
        else if self.dataDic.value(forKey: "industry") == nil
        {
            row = 2
            
            self.errorDic.setValue(Localization("Please enter your industry."), forKey: "industry")
        }
        else if self.dataDic.value(forKey: "company_name") == nil || (self.dataDic.value(forKey: "company_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            row = 3
            
            self.errorDic.setValue(Localization("Please enter your company name."), forKey: "company_name")
        }
        else if self.dataDic.value(forKey: "location") == nil
        {
            row = 4
            
            self.errorDic.setValue(Localization("Please enter your location."), forKey: "location")
        }
        else if self.dataDic.value(forKey: "joining_month") == nil
        {
            
            row = 5
            
            self.errorDic.setValue(Localization("Please enter your joining month."), forKey: "joining_month")
        }
        else if self.dataDic.value(forKey: "joining_year") == nil
        {
            
            row = 5
            
            self.errorDic.setValue(Localization("Please enter your joining year."), forKey: "joining_year")
        }
        
        if self.errorDic.count == 0
        {
            if sender.tag == 1
            {
                //self.addWorkExperienceWebService(addAnotherBool: true)
            }
            else
            {
                //self.addWorkExperienceWebService(addAnotherBool: false)
            }
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
}
