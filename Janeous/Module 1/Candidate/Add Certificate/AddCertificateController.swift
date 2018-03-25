//
//  AddCertificateController.swift
//  Janeous
//
//  Created by SS21 on 07/03/18.
//

import UIKit

class AddCertificateController: MyBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,pickerViewGetValue
{
//    var month = NSArray()
    
    @IBOutlet var  tableView : UITableView!
    @IBOutlet var calenderCell:UITableViewCell!
    
    let TitleArr = ["CERTIFICATE NAME*","CERTIFYING AUTHORITY", "DATE RECEIVED","VALID TILL"]
    
    var monthArray = NSArray()
    var startYearArray = NSArray()
    var endYearArray = NSArray()
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    var from = "add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        NotificationCenter.default.addObserver(self, selector: #selector(AddWorkExperienceController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddWorkExperienceController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "DurationCell", bundle: nil), forCellReuseIdentifier: "DurationCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        tableView.register(UINib(nibName: "FullWidthButtonCell", bundle: nil), forCellReuseIdentifier: "BtnCell")
        
        monthArray = appDel.generalFunction.getValuesInTable(month_Table, forKeys: generalTableKey)! as NSArray
        startYearArray = appDel.generalFunction.getValuesInTable(cerificate_start_year_Table, forKeys: generalTableKey)! as NSArray
        endYearArray = appDel.generalFunction.getValuesInTable(cerificate_end_year_Table, forKeys: generalTableKey)! as NSArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let str:NSString = Localization("Add Certificate (max 3)") as NSString
        
        var attributedString1 = NSMutableAttributedString(string: "\(str)")
        
        if(from == "add")
        {
           attributedString1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: defaultMedium, size: textFontSize14)!, range: str.range(of: "(max 3)"))
        }
        else
        {
            attributedString1 = NSMutableAttributedString(string: Localization("Edit Certificate"))
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
    
    //MARK:- TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleArr.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        
        if indexPath.row == 0 || indexPath.row == 1
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
            
        tempCell.setPlaceholder(string:Localization(TitleArr[indexPath.row]).replacingOccurrences(of: "*", with: ""))
            
            if indexPath.row == 0
            {
                if self.dataDic.value(forKey: "name") != nil
                {
                    textfield.text = "\(self.dataDic.value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "name") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "name") as! String)
                }
            }
            else if indexPath.row == 1
            {
                if self.dataDic.value(forKey: "authority") != nil
                {
                    textfield.text = "\(self.dataDic.value(forKey: "authority")!)"
                }
                
                if errorDic.value(forKey: "authority") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "authority") as! String)
                }
            }
            
            cell = tempCell
        }
        else if indexPath.row == 2 || indexPath.row == 3
        {
            
            let tempCell:DurationCell = tableView.dequeueReusableCell(withIdentifier: "DurationCell") as! DurationCell
            
            tempCell.hideError()
            
        tempCell.setPlaceholder(string:Localization("Month").replacingOccurrences(of: "*", with: ""))
        tempCell.setPlaceholder2(string:Localization("Year").replacingOccurrences(of: "*", with: ""))
            
            tempCell.titleLabel2.text = ""
            
            if indexPath.row == 2
            {
                tempCell.headerLabel.text = Localization(TitleArr[indexPath.row])
                tempCell.titleLabel.text = Localization("From")
                
                if self.dataDic.value(forKey: "received_month") != nil
                {
                    tempCell.textField.text = "\((dataDic.value(forKey: "received_month") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "received_month") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "received_month") as! String)
                }
                
                if self.dataDic.value(forKey: "received_year") != nil
                {
                    tempCell.textField2.text = "\((dataDic.value(forKey: "received_year") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "received_year") != nil
                {
                    tempCell.showError2(message: errorDic.value(forKey: "received_year") as! String)
                }
            }
            else
            {
                tempCell.headerLabel.text = Localization(TitleArr[indexPath.row])
                tempCell.titleLabel.text = Localization("To")
                
                if self.dataDic.value(forKey: "till_month") != nil
                {
                    tempCell.textField.text = "\((dataDic.value(forKey: "till_month") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "till_month") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "received_month") as! String)
                }
                
                if self.dataDic.value(forKey: "till_year") != nil
                {
                    tempCell.textField2.text = "\((dataDic.value(forKey: "till_year") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "till_year") != nil
                {
                    tempCell.showError2(message: errorDic.value(forKey: "till_year") as! String)
                }
            }
            
            tempCell.topButton.addTarget(self, action: #selector(openDataPicker(sender:)), for: .touchUpInside)
              tempCell.topButton2.addTarget(self, action: #selector(openDataPicker(sender:)), for: .touchUpInside)
            
            cell = tempCell
        }
        else if indexPath.row == 4
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
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row == 0
        {
            textField.returnKeyType = .next
        }
        
        textField.returnKeyType = .done
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        
        if indexPath.row == 0
        {
            self.dataDic.setValue(textField.text, forKey: "name")
        }
        else if indexPath.row == 1
        {
            self.dataDic.setValue(textField.text, forKey: "authority")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(indexPath.row > 0)
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
    
    //MARK:- Picker Delegate
    func pickerViewGetValue(pickerView:UIPickerView, withValue:Int)
    {
        if pickerView.tag == 1
        {
            self.dataDic.setValue(monthArray[withValue], forKeyPath: "received_month")
        }
        else if pickerView.tag == 2
        {
             self.dataDic.setValue(startYearArray[withValue], forKeyPath: "received_year")
        }
        else if pickerView.tag == 3
        {
            self.dataDic.setValue(monthArray[withValue], forKeyPath: "till_month")
        }
        else
        {
              self.dataDic.setValue(endYearArray[withValue], forKeyPath: "till_year")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK:- Actions
    @objc func openDataPicker(sender:UIButton)
    {
        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        let vc = PickerViewController()
        vc.pickerViewGetValue = self
        vc.modalPresentationStyle = .overCurrentContext
       
        
        if indexPath.row == 2
        {
            if sender.tag == 7
            {
                 vc.pickerValue = self.monthArray.value(forKey: "name") as! NSArray
                vc.tag = 1
            }
            else
            {
                 vc.pickerValue = self.startYearArray.value(forKey: "name") as! NSArray
                vc.tag = 2
            }
        }
        else
        {
            if sender.tag == 7
            {
                vc.pickerValue = self.monthArray.value(forKey: "name") as! NSArray
                vc.tag = 3
            }
            else
            {
                vc.pickerValue = self.endYearArray.value(forKey: "name") as! NSArray
                vc.tag = 4
            }
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        if self.dataDic.value(forKey: "name") == nil || (self.dataDic.value(forKey: "name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter your certificate name."), forKey: "jobtitle")
        }
        
        if self.errorDic.count == 0
        {
            if sender.tag == 1
            {
                self.addCertificateWebService(addAnotherBool: true)
            }
            else
            {
                self.addCertificateWebService(addAnotherBool: false)
            }
            return
        }
        
        self.tableView.reloadData()
    }
    
    //    MARK:- Web Services
    func addCertificateWebService(addAnotherBool:Bool)
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()

        params.setValue(self.dataDic.value(forKey: "name"), forKey: "name")
        params.setValue(self.dataDic.value(forKey: "authority"), forKey: "authority")
        
        if self.dataDic.value(forKey: "received_month") != nil
        {
           params.setValue((self.dataDic.value(forKey: "received_month") as! NSDictionary).value(forKey: "id"), forKey: "received_month")
        }
       
        if self.dataDic.value(forKey: "received_year") != nil
        {
            params.setValue((self.dataDic.value(forKey: "received_year") as! NSDictionary).value(forKey: "id"), forKey: "received_year")
        }
        
        if self.dataDic.value(forKey: "till_month") != nil
        {
            params.setValue((self.dataDic.value(forKey: "till_month") as! NSDictionary).value(forKey: "id"), forKey: "till_month")
        }
        
        if self.dataDic.value(forKey: "till_year") != nil
        {
            params.setValue((self.dataDic.value(forKey: "till_year") as! NSDictionary).value(forKey: "id"), forKey: "till_year")
        }
        
        var URL = addCertificate
        if from != "add"
        {
            URL = editCertificate
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
