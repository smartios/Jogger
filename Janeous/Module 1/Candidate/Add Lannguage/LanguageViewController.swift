//
//  LanguageViewController.swift
//  Janeous
//
//  Created by singsys on 25/03/18.
//

import UIKit

class LanguageViewController: MyBaseViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var  tableView : UITableView!
    
    var ilr_LevelArray = NSArray()
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    var from = "add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddWorkExperienceController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddWorkExperienceController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddWorkExperienceController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
     
        
       tableView.register(UINib(nibName: "AddLanguageCells", bundle: nil), forCellReuseIdentifier: "proficiencyCell")
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        tableView.register(UINib(nibName: "FullWidthButtonCell", bundle: nil), forCellReuseIdentifier: "BtnCell")
        
        tableView.register(UINib(nibName: "SkipButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SkipButtonTableViewCell")
        
        
        
        ilr_LevelArray = appDel.generalFunction.getValuesInTable(ilr_level_Table, forKeys: ilr_level_Table_Key)! as NSArray
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let str:NSString = Localization("Add Languages") as NSString
        
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
    
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ilr_LevelArray.count + 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        
        if indexPath.row == 0
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            
            tempCell.hideRightButton()
            tempCell.hideError()
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            let str:NSString = Localization("LANGUAGE NAME") as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
            tempCell.setPlaceholder(string:Localization("Enter language"))
            
            
            if dataDic.value(forKey: "name") != nil
            {
                textfield.text = dataDic.value(forKey: "name") as? String
            }
            
            if errorDic.value(forKey: "name") != nil
            {
                tempCell.showError(message: errorDic.value(forKey: "name") as! String)
            }
            
            cell = tempCell
        }
        else if indexPath.row > 0 && indexPath.row <= ilr_LevelArray.count
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "proficiencyCell")
            let headerLabel = cell.viewWithTag(1) as! UILabel
            let imageView = cell.viewWithTag(2) as! UIImageView
            let titleLabel = cell.viewWithTag(3) as! UILabel
            let subTitleLabel = cell.viewWithTag(4) as! UILabel
            
            headerLabel.textColor = defaultLightTextColor()
            headerLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            
            headerLabel.text = ""
            
            if indexPath.row == 1
            {
                headerLabel.text =  Localization("PROFICIENCY")
            }
            
            if dataDic.value(forKey: "ilr_level") != nil && "\(dataDic.value(forKey: "ilr_level")!)" == "\((ilr_LevelArray.object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "id")!)"
            {
                imageView.image = #imageLiteral(resourceName: "bullet_selected")
            }
            else
            {
                imageView.image = #imageLiteral(resourceName: "bullet")
            }
            
            titleLabel.font = UIFont(name: defaultRegular, size: textFontSize18)
            titleLabel.textColor = defaultDarkTextColor()
            
            titleLabel.text = "\((ilr_LevelArray.object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "level")!)"
            
            subTitleLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            subTitleLabel.textColor = defaultDarkTextColor()
            subTitleLabel.text = "\((ilr_LevelArray.object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "label")!)"
            
        }
        else if indexPath.row == ilr_LevelArray.count + 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "BtnCell")
            
            let saveAndAddButton = cell.viewWithTag(1) as! UIButton
            saveAndAddButton.setTitle(Localization("SAVE AND ADD"), for: .normal)
            saveAndAddButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
        }
        else if indexPath.row == ilr_LevelArray.count + 2
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
            cell = tableView.dequeueReusableCell(withIdentifier: "SkipButtonTableViewCell")
            //let skipButton = cell.viewWithTag(1) as! UIButton
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row > 0 && indexPath.row <= ilr_LevelArray.count
        {
            dataDic.setValue("\((ilr_LevelArray.object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "id")!)", forKey: "ilr_level")
            self.tableView.reloadData()
        }
        
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.returnKeyType = .done
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.dataDic.setValue(textField.text, forKey: "name")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.hideKeyboard()
        return true
    }
    
    //MARK:- Actions
    @IBAction  func saveButtonClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        if self.dataDic.value(forKey: "name") == nil || (self.dataDic.value(forKey: "name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter language."), forKey: "name")
        }
        else if self.dataDic.value(forKey: "ilr_level") == nil
        {
            self.errorDic.setValue(Localization("Please enter your ILR Level."), forKey: "ilr_level")
        }
        
        if self.errorDic.count == 0
        {
            if sender.tag == 1
            {
                self.addLanguageWebService(addAnotherBool: true)
            }
            else
            {
                self.addLanguageWebService(addAnotherBool: false)
            }
            return
        }
        
        self.tableView.reloadData()
    }
    
    // MARK:- Web Services
    func addLanguageWebService(addAnotherBool:Bool)
    {
        let cv = CommonValidations()
        let params = self.dataDic
        
        
        var URL = addLanguage
        if from != "add"
        {
            URL = editLanguage
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
