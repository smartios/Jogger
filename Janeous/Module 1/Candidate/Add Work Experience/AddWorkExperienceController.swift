//
//  AddWorkExperienceController.swift
//  Janeous
//
//  Created by SS21 on 22/02/18.
//

import UIKit

class AddWorkExperienceController: MyBaseViewController ,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,TagCollectionViewDelegate,selectCountryDelegate,pickerViewGetValue{
    @IBOutlet var  tableView : UITableView!
    @IBOutlet var  checkBoxCell : UITableViewCell!
    @IBOutlet var  jobDescriptionCell : UITableViewCell!
    
    let TitleArr = ["JOB TITLE*","EXPERIENCE LEVEL*", "INDUSTRY*","COMPANY*","JOB LOCATION*","This is my current job","DURATION","","JOB TAGS (MAX 6)*","","JOB FUNCTIONS","JOB DESCRIPTION"]
    
    var monthArray = NSArray()
    var yearArray = NSArray()
    var jobTagListArray = NSArray()
    var jobFuncitonListArray = NSArray()
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    var jobTagArray = NSMutableArray()
    
    var currentJobBool:Bool = false
    var from = "add"
    
    let dropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddWorkExperienceController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddWorkExperienceController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddWorkExperienceController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        Bundle.main.loadNibNamed("AddWorkExperienceCell", owner: self, options: nil)
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "DurationCell", bundle: nil), forCellReuseIdentifier: "DurationCell")
        
        tableView.register(UINib(nibName: "TagCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TagCollectionViewTableViewCell")
        
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        tableView.register(UINib(nibName: "FullWidthButtonCell", bundle: nil), forCellReuseIdentifier: "BtnCell")
        
        monthArray = appDel.generalFunction.getValuesInTable(month_Table, forKeys: generalTableKey)! as NSArray
        yearArray = appDel.generalFunction.getValuesInTable(workExperienceYear_Table, forKeys: generalTableKey)! as NSArray
        jobTagListArray = appDel.generalFunction.getValuesInTable(job_tags_Table, forKeys: generalTableKey)! as NSArray
        jobFuncitonListArray = appDel.generalFunction.getValuesInTable(job_functions_Table, forKeys: generalTableKey)! as NSArray
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Setting navigation bar title
        
        let str:NSString = Localization("Add Work Experience (max 6)") as NSString
        
        var attributedString1 = NSMutableAttributedString(string: "\(str)")
        
        if(from == "add")
        {
            attributedString1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: defaultMedium, size: textFontSize14)!, range: str.range(of: "(max 6)"))
        }
        else
        {
            attributedString1 = NSMutableAttributedString(string: Localization("Edit Work Experience"))
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
    
    //MARK:- Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleArr.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        
        if indexPath.row < 5 || indexPath.row == 8 || indexPath.row == 10
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
                textfield.isUserInteractionEnabled = false
                tempCell.showRightButton()
                
                if dataDic.value(forKey: "experience_level") != nil
                {
                    textfield.text = "\((dataDic.value(forKey: "experience_level") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "experience_level") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "experience_level") as! String)
                }
            }
            else if indexPath.row == 2
            {
                textfield.isUserInteractionEnabled = false
                tempCell.showRightButton()
                
                if dataDic.value(forKey: "industry") != nil
                {
                    textfield.text = "\((dataDic.value(forKey: "industry") as! NSDictionary).value(forKey: "name")!)"
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
                
                textfield.isUserInteractionEnabled = false
                tempCell.showRightButton()
                
                if dataDic.value(forKey: "location") != nil
                {
                    textfield.text = "\((dataDic.value(forKey: "location") as! NSDictionary).value(forKey: "name")!)"
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
        else if indexPath.row == 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "checkBoxCell")
            if cell == nil{
                cell = checkBoxCell
                checkBoxCell = nil
            }
            
            let checkButton = cell.viewWithTag(1) as! UIButton
            let titleLabel = cell.viewWithTag(2) as! UILabel
            
            checkButton.isSelected = currentJobBool
            
            titleLabel.text = Localization(TitleArr[indexPath.row])
            
            checkButton.addTarget(self, action: #selector(currentJobButtonClicked(_:)), for: .touchUpInside)
        }
        else if indexPath.row == 6 || indexPath.row == 7
        {
            let tempCell:DurationCell = tableView.dequeueReusableCell(withIdentifier: "DurationCell") as! DurationCell
            
            tempCell.hideError()
            
        tempCell.setPlaceholder(string:Localization("Month").replacingOccurrences(of: "*", with: ""))
        tempCell.setPlaceholder2(string:Localization("Year").replacingOccurrences(of: "*", with: ""))
            
            tempCell.titleLabel2.text = ""
            
            if indexPath.row == 6
            {
                tempCell.headerLabel.text = Localization("DURATION")
                tempCell.titleLabel.text = Localization("From")
                
                
                if dataDic.value(forKey: "joining_month") != nil
                {
                    tempCell.textField.text =  "\((dataDic.value(forKey: "joining_month") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if dataDic.value(forKey: "joining_year") != nil
                {
                    tempCell.textField2.text = "\((dataDic.value(forKey: "joining_year") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "joining_month") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "joining_month") as! String)
                }
                
                if errorDic.value(forKey: "joining_year") != nil
                {
                    tempCell.showError2(message: errorDic.value(forKey: "joining_year") as! String)
                }
            }
            else
            {
                tempCell.headerLabel.text = ""
                tempCell.titleLabel.text = "To"
                
                if dataDic.value(forKey: "relieving_month") != nil
                {
                    tempCell.textField.text = "\((dataDic.value(forKey: "relieving_month") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if dataDic.value(forKey: "relieving_year") != nil
                {
                    tempCell.textField2.text = "\((dataDic.value(forKey: "relieving_year") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if self.currentJobBool == false
                {
                    if errorDic.value(forKey: "relieving_month") != nil
                    {
                        tempCell.showError(message: errorDic.value(forKey: "relieving_month") as! String)
                    }
                    
                    if errorDic.value(forKey: "relieving_year") != nil
                    {
                        tempCell.showError2(message: errorDic.value(forKey: "relieving_year") as! String)
                    }
                }
            }
            
            tempCell.topButton.addTarget(self, action: #selector(openDataPicker(sender:)), for: .touchUpInside)
            tempCell.topButton2.addTarget(self, action: #selector(openDataPicker(sender:)), for: .touchUpInside)
            
            cell = tempCell
        }
        else if indexPath.row == 9
        {
            let tempCell:TagCollectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TagCollectionViewTableViewCell") as! TagCollectionViewTableViewCell
            
            tempCell.TagCollectionViewDelegate = self
            tempCell.isTagEditable = true
            tempCell.updateTagArry(tagArr: self.jobTagArray)
            
            cell = tempCell
        }
        else if indexPath.row == 11
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "jobDetailsCell")
            if cell == nil{
                cell = jobDescriptionCell
                jobDescriptionCell = nil
            }
            
            let titleLabel = cell.viewWithTag(1) as! UILabel
            let descriptionTextView = cell.viewWithTag(2) as! UITextView
            let lineImageView = cell.viewWithTag(3) as! UIImageView
            
            titleLabel.textColor = defaultLightTextColor()
            titleLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            descriptionTextView.textColor = defaultDarkTextColor()
            descriptionTextView.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
            
            lineImageView.backgroundColor = defaultLightTextColor()
            
            titleLabel.text = Localization(TitleArr[indexPath.row])
            descriptionTextView.delegate = self
            descriptionTextView.text = ""
            
            if dataDic.value(forKey: "description") != nil
            {
                descriptionTextView.text = dataDic.value(forKey: "description") as? String
            }
        }
        else if indexPath.row == 12
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1
        {
            let vc = CountryListingController()
            vc.from = "experience_level"
            vc.selectCountryDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2
        {
            let vc = CountryListingController()
            vc.from = "industry"
            vc.selectCountryDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 4
        {
            let vc = CountryListingController()
            vc.from = "country"
            vc.selectCountryDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Country Protocol
    func countryValue(from:String, withDic:NSDictionary)
    {
        if from == "experience_level"
        {
           self.dataDic.setValue(withDic, forKey: "experience_level")
        }
        else if from == "industry"
        {
            self.dataDic.setValue(withDic, forKey: "industry")
        }
        else if from == "country"
        {
            self.dataDic.setValue(withDic, forKey: "location")
        }
        
        self.tableView.reloadData()
        
    }
    
    //MARK:- Picker Delegate
    func pickerViewGetValue(pickerView:UIPickerView, withValue:Int)
    {
        if pickerView.tag == 1
        {
            self.dataDic.setValue(monthArray[withValue], forKeyPath: "joining_month")
        }
        else if pickerView.tag == 2
        {
            self.dataDic.setValue(yearArray[withValue], forKeyPath: "joining_year")
        }
        else if pickerView.tag == 3
        {
            self.dataDic.setValue(monthArray[withValue], forKeyPath: "relieving_month")
        }
        else
        {
            self.dataDic.setValue(yearArray[withValue], forKeyPath: "relieving_year")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK:- Tag CollectionViewDelegate
    func tagDeleted(collectionView:UICollectionView, forIndex:Int)
    {
        self.jobTagArray.removeObject(at: forIndex)
        self.tableView.reloadData()
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.returnKeyType = .next
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row == 8 && textField.text!.count >= 30
        {
            return false
        }
        
        if indexPath.row == 8 || indexPath.row == 10
        {
         self.setupDropDown(indexPath:indexPath)
        }
        
        return true
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
        else if indexPath.row == 8 && textField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.jobTagArray.count < 6
        {
            let newIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            self.jobTagArray.add(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            textField.text = ""
            self.tableView.reloadRows(at: [newIndexPath], with: .none)
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
    
    // MARK: - UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == defaultLightTextColor() {
            textView.text = ""
            textView.textColor = defaultDarkTextColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = Localization("Enter job description here..")
            
            textView.textColor = defaultLightTextColor()
        }else{
            self.dataDic.setObject(textView.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), forKey: "description" as NSCopying)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //MARK: - Drop Down Methods
    func setupDropDown(indexPath : IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)!
        let txtField = cell.viewWithTag(2) as! UITextField
        
        dropDownUISetup()
        
        dropDown.anchorView = txtField
        
        dropDown.width = txtField.bounds.width
        
        dropDown.bottomOffset = CGPoint(x: 0, y: txtField.bounds.height )
        
        var tempSearchCategory : NSArray!
        
        if indexPath.row == 8
        {
             var searchPredicate:NSPredicate!
             searchPredicate = NSPredicate(format: "name contains[cd] %@",txtField.text!)
            tempSearchCategory = self.jobTagListArray.filtered(using: searchPredicate) as NSArray
            dropDown.dataSource = tempSearchCategory.value(forKey: "name") as! [String]
        }
        else
        {
            var searchPredicate:NSPredicate!
            searchPredicate = NSPredicate(format: "name contains[cd] %@",txtField.text!)
            tempSearchCategory = self.jobFuncitonListArray.filtered(using: searchPredicate) as NSArray
            dropDown.dataSource = tempSearchCategory.value(forKey: "name") as! [String]
        }
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index, item) in
            txtField.text = item
            if indexPath.row == 8 && self.jobTagArray.count < 6
            {
                let newIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: 0)
                self.jobTagArray.add((tempSearchCategory[index] as! NSDictionary).value(forKey: "name")!)
                txtField.text = ""
                self.tableView.reloadRows(at: [newIndexPath], with: .none)
            }
            else if indexPath.row == 10
            {
                txtField.text = (tempSearchCategory[index] as! NSDictionary).value(forKey: "name") as? String
            }
        }
        
        if dropDown.dataSource.count > 0
        {
             self.dropDown.hide()
             self.dropDown.show()
        }
       
    }
    
    //MARK:- Actions
    @IBAction  func currentJobButtonClicked(_ sender: UIButton)
    {
        if currentJobBool == false
        {
            self.currentJobBool = true
        }
        else
        {
            self.currentJobBool = false
        }
        
        self.tableView.reloadData()
    }
    
    @objc func openDataPicker(sender:UIButton)
    {
        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        let vc = PickerViewController()
        vc.pickerViewGetValue = self
        vc.modalPresentationStyle = .overCurrentContext
        
        
        if indexPath.row == 6
        {
            if sender.tag == 7
            {
                vc.tag = 1
                vc.pickerValue = self.monthArray.value(forKey: "name") as! NSArray
            }
            else
            {
                vc.tag = 2
                vc.pickerValue = self.yearArray.value(forKey: "name") as! NSArray
            }
        }
        else
        {
            if sender.tag == 7
            {
                vc.tag = 3
                vc.pickerValue = self.monthArray.value(forKey: "name") as! NSArray
            }
            else
            {
                vc.tag = 4
                vc.pickerValue = self.yearArray.value(forKey: "name") as! NSArray
            }
        }
        
        self.present(vc, animated: true, completion: nil)
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
        else if self.currentJobBool == false && self.dataDic.value(forKey: "relieving_month") == nil
        {
            
            row = 6
            
            self.errorDic.setValue(Localization("Please enter your relieving month."), forKey: "relieving_month")
        }
        else if self.currentJobBool == false && self.dataDic.value(forKey: "relieving_year") == nil
        {
            
            row = 6
            
            self.errorDic.setValue(Localization("Please enter your relieving year."), forKey: "relieving_year")
        }
        else if self.jobTagArray.count == 0
        {
            
            row = 7
            
            self.errorDic.setValue(Localization("Please enter a job tag."), forKey: "tags")
        }
        
        if self.errorDic.count == 0
        {
            if sender.tag == 1
            {
                self.addWorkExperienceWebService(addAnotherBool: true)
            }
            else
            {
                self.addWorkExperienceWebService(addAnotherBool: false)
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
    
    //    MARK:- Web Services
    func addWorkExperienceWebService(addAnotherBool:Bool)
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.dataDic.value(forKey: "jobtitle"), forKey: "jobtitle")
        params.setValue((self.dataDic.value(forKey: "experience_level") as! NSDictionary).value(forKey: "id"), forKey: "experience_level")
        params.setValue((self.dataDic.value(forKey: "industry")  as! NSDictionary).value(forKey: "id"), forKey: "industry")
        params.setValue(self.dataDic.value(forKey: "company_name"), forKey: "company_name")
        params.setValue((self.dataDic.value(forKey: "location")   as! NSDictionary).value(forKey: "id"), forKey: "location")
        
        if currentJobBool
        {
             params.setValue("yes", forKey: "is_currently_working")
        }
        else
        {
             params.setValue("no", forKey: "is_currently_working")
        }
       
        params.setValue((self.dataDic.value(forKey: "joining_month") as! NSDictionary).value(forKey: "id"), forKey: "joining_month")
        params.setValue((self.dataDic.value(forKey: "joining_year") as! NSDictionary).value(forKey: "id"), forKey: "joining_year")
        params.setValue((self.dataDic.value(forKey: "relieving_month") as! NSDictionary).value(forKey: "id"), forKey: "relieving_month")
        params.setValue((self.dataDic.value(forKey: "relieving_year") as! NSDictionary).value(forKey: "id"), forKey: "relieving_year")
        params.setValue(self.jobTagArray, forKey: "tags")
        params.setValue(self.dataDic.value(forKey: "function"), forKey: "function")
        params.setValue(self.dataDic.value(forKey: "description"), forKey: "description")
        
        var URL = addWorkExperience
        if from != "add"
        {
            URL = editWorkExperience
            params.setValue(self.dataDic.value(forKey: "id"), forKey: "id")
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
                self.jobTagArray = NSMutableArray()
                self.currentJobBool = false
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

