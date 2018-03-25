//
//  AddGeneralInfoControllerViewController.swift
//  Janeous
//
//  Created by SS21 on 21/02/18.
//

import UIKit

class AddGeneralInfoControllerViewController: MyBaseViewController, UITableViewDataSource , UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,selectImageSourceDelegate,selectCountryDelegate {
    //    MARK:- IBOutlets Declartion here
    @IBOutlet weak var  tableView : UITableView!
    @IBOutlet weak var  userImageCell : UITableViewCell!
    @IBOutlet weak var  aboutYouCell : UITableViewCell!
    
    let TitleArr = ["","FIRST NAME*","LAST NAME*", "ABOUT YOU","NATIONALITY* +","COUNTRY OF RESIDENCE* +",""]
    
    var monthArray =             ["January","Feburary","March","April","May","June","July","August","September","October","November","December","January","Feburary","March","April","May","June","July","August","September","October","November","December"]
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    var imagePicker = UIImagePickerController()
    var profileImage:UIImage!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddGeneralInfoControllerViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddGeneralInfoControllerViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddGeneralInfoControllerViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        Bundle.main.loadNibNamed("AddGeneralInfoCell", owner: self, options: nil)
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        
        self.initalValueSetup()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let attributedString1 = NSMutableAttributedString(string: Localization("Add General Information"))
        self.setGrayNavigationbarWithTitle(AttributedString: attributedString1)
    }
    
    func initalValueSetup()
    {
        self.dataDic.setValue(userData.userFirstName, forKey: "first_name")
        self.dataDic.setValue(userData.userLastName, forKey: "last_name")
        self.dataDic.setValue(userData.description, forKey: "about_you")
        self.dataDic.setValue(userData.nationality_Dic, forKey: "nationality")
        self.dataDic.setValue(userData.country_of_residence_Dic, forKey: "country_of_residence")
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
    
    //    MARK:- Table view Delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        if indexPath.row == 0 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "userImageCell")
            if cell == nil{
                cell = userImageCell
                userImageCell = nil
            }
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = imageView.frame.size.width/2
            imageView.contentMode = .scaleAspectFill
            imageView.image = #imageLiteral(resourceName: "user_icon")
            
            if profileImage != nil
            {
                imageView.image = profileImage
            }
            else if URL(string: userData.userImage) != nil
            {
                imageView.setImageWith(URL(string: userData.userImage)!, placeholderImage: #imageLiteral(resourceName: "user_icon"))
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }
        else if indexPath.row == 3{
            //
            cell = tableView.dequeueReusableCell(withIdentifier: "aboutYouCell")
            if cell == nil{
                cell = aboutYouCell
                aboutYouCell = nil
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
            
            if dataDic.value(forKey: "about_you") != nil
            {
                descriptionTextView.text = dataDic.value(forKey: "about_you") as? String
            }
            
            if descriptionTextView.text.isEmpty {
                descriptionTextView.text = Localization("Enter text here..")
                
                descriptionTextView.textColor = defaultLightTextColor()
                descriptionTextView.font = UIFont(name: defaultLightItalic, size: textFieldFontSize18)
                
            }else{
                
                descriptionTextView.textColor = defaultDarkTextColor()
                descriptionTextView.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
            }
        }
        else if indexPath.row == TitleArr.count - 1{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell")
            
            let cancelButton = cell.viewWithTag(12) as! UIButton
            let doneButton = cell.viewWithTag(13) as! UIButton
            
            cancelButton.setTitle(Localization("CANCEL"), for: .normal)
            doneButton.setTitle(Localization("DONE"), for: .normal)
            
            cancelButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
            
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
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            rightButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
            rightButton.isUserInteractionEnabled = false
            
            let str:NSString = Localization(TitleArr[indexPath.row]) as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "+"))
            
            titleLabel.attributedText = attributedString1
            
        tempCell.setPlaceholder(string:Localization(TitleArr[indexPath.row]).replacingOccurrences(of: "*", with: ""))
           
        tempCell.setPlaceholder(string:textfield.placeholder!.replacingOccurrences(of: "+", with: ""))
           
            
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
            else if indexPath.row == 4 {
                
                textfield.isUserInteractionEnabled = false
                tempCell.showRightButton()
                
                if dataDic.value(forKey: "nationality") != nil
                {
                    textfield.text = "\((dataDic.value(forKey: "nationality") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "nationality") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "nationality") as! String)
                }
                
            }
            else if indexPath.row == 5{
                
                textfield.isUserInteractionEnabled = false
                tempCell.showRightButton()
                
                if dataDic.value(forKey: "country_of_residence") != nil
                {
                    textfield.text = "\((dataDic.value(forKey: "country_of_residence") as! NSDictionary).value(forKey: "name")!)"
                }
                
                if errorDic.value(forKey: "country_of_residence") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "country_of_residence") as! String)
                }
                
            }
            
            cell = tempCell
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 4 || indexPath.row == 5
        {
            let vc = CountryListingController()
            
            if indexPath.row == 4
            {
              vc.from = "nationality"
            }
            else
            {
              vc.from = "country_of_residence"
            }
            
            vc.selectCountryDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    
    
    //MARK:- Country delegate
     func countryValue(from:String, withDic:NSDictionary)
     {
        if from == "nationality"
        {
            self.dataDic.setValue(withDic, forKey: "nationality")
        }
        else
        {
            self.dataDic.setValue(withDic, forKey: "country_of_residence")
        }
        
        self.tableView.reloadData()
     }
    
    //MARK:- Actions
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let vc = SelectImagePopUpViewController()
        vc.selectImageSourceDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func doneButtonClicked()
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        var row = 0
        
        if self.dataDic.value(forKey: "first_name") == nil || (self.dataDic.value(forKey: "first_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            row = 1
            
            self.errorDic.setValue(Localization("Please enter your first name."), forKey: "first_name")
        }
        else if self.dataDic.value(forKey: "last_name") == nil || (self.dataDic.value(forKey: "last_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            row = 2
            self.errorDic.setValue(Localization("Please enter your last name."), forKey: "last_name")
        }
        else if self.dataDic.value(forKey: "nationality") == nil
        {
            row = 4
            
            self.errorDic.setValue(Localization("Please enter your nationality."), forKey: "nationality")
        }
        else if self.dataDic.value(forKey: "country_of_residence") == nil
        {
            row = 5
            
            self.errorDic.setValue(Localization("Please enter your country of residence."), forKey: "country_of_residence")
        }
        
        
        if self.errorDic.count == 0
        {
            self.updateProfile()
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
    
    //MARK:- SelectImageSource Delegate
    func selectImageSourceDelegate(tag:Int)
    {
        if tag == 1
        {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = false
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        else
        {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK:- PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        self.profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
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
        
        
        if indexPath.row == 1
        {
            self.dataDic.setValue(textField.text, forKey: "first_name")
        }
        else if indexPath.row == 2
        {
            self.dataDic.setValue(textField.text, forKey: "last_name")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(indexPath.row > 2)
        {
            self.hideKeyboard()
        }
        else
        {
            let nextIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let cell:UITableViewCell = self.tableView.cellForRow(at: nextIndexPath)!
            if cell.viewWithTag(2) is UITextField
            {
                let nextTextField = cell.viewWithTag(2) as! UITextField
                nextTextField.becomeFirstResponder()
            }
            else
            {
                let nextTextView = cell.viewWithTag(2) as! UITextView
                nextTextView.becomeFirstResponder()
                
            }
            
            
            
        }
        
        return true
    }
    
    // MARK: - UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == defaultLightTextColor() {
            textView.text = ""
            textView.textColor = defaultDarkTextColor()
            textView.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = Localization("Enter text here..")
            
            textView.textColor = defaultLightTextColor()
            textView.font = UIFont(name: defaultLightItalic, size: textFieldFontSize18)
            
        }else{
            self.dataDic.setObject(textView.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), forKey: "about_you" as NSCopying)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //MARK:- Webservice
    func updateProfile()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.dataDic.value(forKey: "first_name"), forKey: "first_name")
        params.setValue(self.dataDic.value(forKey: "last_name"), forKey: "last_name")
        params.setValue(self.dataDic.value(forKey: "about_you"), forKey: "about_you")
         params.setValue(self.dataDic.value(forKey: "about_you"), forKey: "description")
        params.setValue((self.dataDic.value(forKey: "nationality") as! NSDictionary).value(forKey: "id"), forKey: "nationality")
        params.setValue((self.dataDic.value(forKey: "country_of_residence")  as! NSDictionary).value(forKey: "id"), forKey: "country_of_residence")
        
        let tempImageDic = NSMutableDictionary()
        if self.profileImage != nil
        {
        tempImageDic.setObject(UIImageJPEGRepresentation(self.profileImage, 0.8)!, forKey: "profile_picture" as NSCopying)
        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeFormDataWebServiceCall(url: addCandidateGeneralInfo, parameter: params,ImageDataDic: tempImageDic) { (JSON) in
            
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
                
                overwriteDefaultUserDataValues(tempDic: params)
                self.backButtonClicked()
                
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
