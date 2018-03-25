//
//  AddEducationExpViewController.swift
//  Janeous
//
//  Created by singsys on 08/03/18.
//

import UIKit

class AddEducationExpViewController: MyBaseViewController, UITableViewDataSource , UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var  tableView : UITableView!
    @IBOutlet var checkBoxCell: UITableViewCell!
    
    let TitleArr = ["DEGREE TITLE*","DEGREE LEVEL*", "GRADE POINT AVERAGE","FIELD OF STUDY*","MINOR","SCHOOL"]
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    var stillPursuingBool:Bool = false
    var from = "add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetUp()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(AddEducationExpViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddEducationExpViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddEducationExpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "DurationCell", bundle: nil), forCellReuseIdentifier: "DurationCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        tableView.register(UINib(nibName: "FullWidthButtonCell", bundle: nil), forCellReuseIdentifier: "BtnCell")
        
        Bundle.main.loadNibNamed("AddEducationCells", owner: self, options: nil)
        
        //Setting navigation bar title
        let str:NSString = Localization("Add Education Experience (max 3)") as NSString
        
        var attributedString1 = NSMutableAttributedString(string: "\(str)")
        
        if(from == "add")
        {
            attributedString1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: defaultMedium, size: textFontSize14)!, range: str.range(of: "(max 6)"))
        }
        else
        {
            attributedString1 = NSMutableAttributedString(string: Localization("Edit Education Experience"))
        }
        
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
    
    //MARK:- Actions
    @IBAction  func stillPursuingButtonClicked(_ sender: UIButton)
    {
        if self.stillPursuingBool == false
        {
            self.stillPursuingBool = true
        }
        else
        {
            self.stillPursuingBool = false
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction  func saveButtonClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        var row = 0
        
        if self.dataDic.value(forKey: "degree_title") == nil || (self.dataDic.value(forKey: "degree_title") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter your degree title."), forKey: "degree_title")
        }
        else if self.dataDic.value(forKey: "degree_level") == nil
        {
            row = 1
            self.errorDic.setValue(Localization("Please enter your degree level."), forKey: "degree_level")
        }
        else if self.dataDic.value(forKey: "field_of_study") == nil
        {
            row = 3
            self.errorDic.setValue(Localization("Please enter your field of study."), forKey: "field_of_study")
        }
        else if self.dataDic.value(forKey: "minor") == nil || (self.dataDic.value(forKey: "minor") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            row = 4
            self.errorDic.setValue(Localization("Please enter your location."), forKey: "minor")
        }
        else if self.dataDic.value(forKey: "school") == nil || (self.dataDic.value(forKey: "school") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            row = 5
            self.errorDic.setValue(Localization("Please enter your school."), forKey: "school")
        }
        else if self.dataDic.value(forKey: "start") == nil
        {
            
            row = 7
            self.errorDic.setValue(Localization("Please enter your start year."), forKey: "start")
        }
        else if self.stillPursuingBool == false && self.dataDic.value(forKey: "end") == nil
        {
            
            row = 7
            self.errorDic.setValue(Localization("Please enter your end year."), forKey: "end")
        }
        
        
        if self.errorDic.count == 0
        {
            if sender.tag == 1
            {
                self.addEducationExperienceWebService(addAnotherBool: true)
            }
            else
            {
                self.addEducationExperienceWebService(addAnotherBool: false)
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
    
    
    //MARK:- Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleArr.count + 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row < TitleArr.count
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            tempCell.hideRightButton()
            tempCell.hideError()
            textfield.isUserInteractionEnabled = true
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            rightButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
            rightButton.isUserInteractionEnabled = false
            
            let str:NSString = Localization(TitleArr[indexPath.row]) as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
            if indexPath.row == 0
            {
                if dataDic.value(forKey: "degree_title") != nil
                {
                    textfield.text = dataDic.value(forKey: "degree_title") as? String
                }
                
                if errorDic.value(forKey: "degree_title") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "degree_title") as! String)
                }
            }
            else if indexPath.row == 1
            {
                textfield.isUserInteractionEnabled = false
                tempCell.showRightButton()
                
                if dataDic.value(forKey: "degree_level") != nil
                {
                    textfield.text = dataDic.value(forKey: "degree_level") as? String
                }
                
                if errorDic.value(forKey: "degree_level") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "degree_level") as! String)
                }
            }
            else if indexPath.row == 2
            {
                if dataDic.value(forKey: "grade_point") != nil
                {
                    textfield.text = dataDic.value(forKey: "grade_point") as? String
                }
                
                if errorDic.value(forKey: "grade_point") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "grade_point") as! String)
                }
            }
            else if indexPath.row == 3
            {
            
                if dataDic.value(forKey: "field_of_study") != nil
                {
                    textfield.text = dataDic.value(forKey: "field_of_study") as? String
                }
                
                if errorDic.value(forKey: "field_of_study") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "field_of_study") as! String)
                }
            }
            else if indexPath.row == 4
            {
                textfield.isUserInteractionEnabled = false
                tempCell.showRightButton()
                
                if dataDic.value(forKey: "minor") != nil
                {
                    textfield.text = dataDic.value(forKey: "minor") as? String
                }
                
                if errorDic.value(forKey: "minor") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "minor") as! String)
                }
            }
            else if indexPath.row == 5
            {
                if dataDic.value(forKey: "school") != nil
                {
                    textfield.text = dataDic.value(forKey: "school") as? String
                }
                
                if errorDic.value(forKey: "school") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "school") as! String)
                }
            }
            
            
            cell = tempCell
        }
        else if indexPath.row == TitleArr.count
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "checkBoxCell")
            if cell == nil{
                cell = checkBoxCell
                checkBoxCell = nil
            }
        }
        else if indexPath.row == TitleArr.count + 1
        {
            let tempCell:DurationCell = tableView.dequeueReusableCell(withIdentifier: "DurationCell") as! DurationCell
            
            tempCell.hideError()
            
        tempCell.setPlaceholder(string:Localization("Year").replacingOccurrences(of: "*", with: ""))
        tempCell.setPlaceholder2(string:Localization("Year").replacingOccurrences(of: "*", with: ""))
            
            
            tempCell.headerLabel.text = Localization("DURATION")
            tempCell.titleLabel.text = Localization("FROM")
            tempCell.titleLabel2.text = Localization("TO")
            
            if dataDic.value(forKey: "start") != nil
            {
                tempCell.textField.text = dataDic.value(forKey: "start") as? String
            }
            
            if dataDic.value(forKey: "end") != nil
            {
                tempCell.textField2.text = dataDic.value(forKey: "end") as? String
            }
            
            if errorDic.value(forKey: "start") != nil
            {
                tempCell.showError(message: errorDic.value(forKey: "start") as! String)
            }
            
            if errorDic.value(forKey: "end") != nil
            {
                tempCell.showError2(message: errorDic.value(forKey: "end") as! String)
            }
            
            
            cell = tempCell
        }
        else if indexPath.row == TitleArr.count + 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "BtnCell")
            
            let saveAndAddButton = cell.viewWithTag(1) as! UIButton
            saveAndAddButton.setTitle(Localization("SAVE AND ADD"), for: .normal)
            saveAndAddButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell")
            
            let cancelButton = cell.viewWithTag(12) as! UIButton
            let doneButton = cell.viewWithTag(13) as! UIButton
            
            cancelButton.setTitle(Localization("CANCEL"), for: .normal)
            doneButton.setTitle(Localization("DONE"), for: .normal)
            
            cancelButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            doneButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 1 || indexPath.row == 3
        {
            
        }
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(indexPath.row == 7)
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
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
    
                if indexPath.row == 0
                {
                    dataDic.setValue(textField.text!, forKey: "degree_title")
                }
                else if indexPath.row == 2
                {
                    dataDic.setValue(textField.text!, forKey: "grade_point")
                }
                else if indexPath.row == 3
                {
                    dataDic.setValue(textField.text!, forKey: "field_of_study")
                  
                }
                else if indexPath.row == 5
                {
                    dataDic.setValue(textField.text!, forKey: "school")
                }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(indexPath.row == self.TitleArr.count - 1)
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
    
    
    //MARK:- Web Services
    func addEducationExperienceWebService(addAnotherBool:Bool)
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.dataDic.value(forKey: "degree_title"), forKey: "degree_title")
        params.setValue(self.dataDic.value(forKey: "degree_level"), forKey: "degree_level")
        params.setValue(self.dataDic.value(forKey: "grade_point"), forKey: "grade_point")
        params.setValue(self.dataDic.value(forKey: "field_of_study"), forKey: "field_of_study")
        params.setValue(self.dataDic.value(forKey: "minor"), forKey: "minor")
        params.setValue(self.dataDic.value(forKey: "school"), forKey: "school")
        
        if self.stillPursuingBool == false
        {
            params.setValue("passed", forKey: "degree_status")
        }
        else
        {
            params.setValue("pursuing", forKey: "degree_status")
        }
        
        params.setValue(self.dataDic.value(forKey: "start"), forKey: "start")
        params.setValue(self.dataDic.value(forKey: "end"), forKey: "end")
        
        var URL = addEducationExperience
        if from != "add"
        {
            URL = editWorkExperience
            params.setValue(self.dataDic.value(forKey: "id"), forKey: "id")
        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: addEducationExperience, parameter: params) { (JSON) in
            
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
                
                if addAnotherBool == false
                {
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
                    return
                }
                
                self.dataDic = NSMutableDictionary()
                self.stillPursuingBool = false
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
    
    //MARK:- Delegate
    func countryValue(from:String, withDic:NSDictionary)
    {
        self.dataDic.setValue(withDic, forKey: "phone_code")
        self.tableView.reloadData()
    }
}
