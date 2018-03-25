//
//  AddTopSkillsViewController.swift
//  Janeous
//
//  Created by singsys on 09/03/18.
//

import UIKit

class AddTopSkillsViewController: MyBaseViewController, UITableViewDataSource , UITableViewDelegate,UITextFieldDelegate,TagCollectionViewDelegate {
    
    @IBOutlet weak var  tableView : UITableView!
    
    var errorDic = NSMutableDictionary()
    
    var TagCollectionViewCell = TagCollectionViewTableViewCell()
    
    var from = "skill"
    var dataArray = NSMutableArray()
    var suggestionArray = NSArray()
    
    let dropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Setting navigation bar title
        let attributedString1:NSMutableAttributedString!
        
        if from == "jobTitles"
        {
            let str:NSString = Localization("Desired Job Titles (max 3)") as NSString
            
            attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: defaultMedium, size: textFontSize14)!, range: str.range(of: "(max 3)"))
        }
        else
        {
            let str:NSString = Localization("Add Top Skills (max 6)") as NSString
            
            attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: defaultMedium, size: textFontSize14)!, range: str.range(of: "(max 6)"))
        }
        
        self.setGrayNavigationbarWithTitle(AttributedString: attributedString1)
    }
    
    func initialSetUp()
    {
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "TagCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TagCollectionViewTableViewCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        
        if from == "skill"
        {
            suggestionArray = appDel.generalFunction.getValuesInTable(skills_Table, forKeys: generalTableKey)! as NSArray
        }
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
    
    //MARK:- Buttons
    @objc func doneButtonClicked()
    {
        if from == "skill" && self.TagCollectionViewCell.dataArray.count < 2
        {
            supportingfuction.showMessageHudWithMessage(message: "Minimum 2 skills required.", delay: 2.0)
            return
        }
        
        self.addSkillWebService()
    }
    
    
    //MARK:- Table View
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 1)
        {
            var string = ""
            
            
            for str in self.dataArray
            {
                string = "\(string)\(str)\(str)"
            }
            
            
            if string == ""
            {
                return 0
            }
            
            return  heightForView(text: string, font: UIFont(name: defaultRegular, size: textFontSize14)!, width: self.view.frame.size.width - 58).height + 58 + 10
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row == 0
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            //let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            tempCell.hideRightButton()
            tempCell.hideError()
            textfield.isSecureTextEntry = false
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            var str:NSString = Localization("ADD TOP SKILLS (MIN 2)*") as NSString
            
            if from == "jobTitles"
            {
                str = Localization("JOB TITLES") as NSString
                tempCell.setPlaceholder(string: "Select your job titles")
            }
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
            
            cell = tempCell
        }
        else if indexPath.row == 1
        {
            let tempCell:TagCollectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TagCollectionViewTableViewCell") as! TagCollectionViewTableViewCell
            
            tempCell.TagCollectionViewDelegate = self
            tempCell.isTagEditable = true
            tempCell.updateTagArry(tagArr: self.dataArray)
            
            cell = tempCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell")
            let cancelButton = cell.viewWithTag(12) as! UIButton
            let doneButton = cell.viewWithTag(13) as! UIButton
            
            cancelButton.setTitle(Localization("CANCEL"), for: .normal)
            doneButton.setTitle(Localization("DONE"), for: .normal)
            
            cancelButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        }
        
        return cell
    }
    
    //MARK:- Textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        self.setupDropDown(indexPath:indexPath)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.dataArray.add(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        textField.text = ""
        self.tableView.reloadData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.hideKeyboard()
        
        return true
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
        
        var searchPredicate:NSPredicate!
        searchPredicate = NSPredicate(format: "name contains[cd] %@",txtField.text!)
        tempSearchCategory = self.suggestionArray.filtered(using: searchPredicate) as NSArray
        dropDown.dataSource = tempSearchCategory.value(forKey: "name") as! [String]
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index, item) in
            txtField.text = item
            let newIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            self.dataArray.add((tempSearchCategory[index] as! NSDictionary).value(forKey: "name")!)
            txtField.text = ""
            self.tableView.reloadRows(at: [newIndexPath], with: .none)
        }
        
        if dropDown.dataSource.count > 0
        {
            self.dropDown.hide()
            self.dropDown.show()
        }
        
    }
    
    //MARK:- Tag CollectionViewDelegate
    func tagDeleted(collectionView:UICollectionView, forIndex:Int)
    {
        self.dataArray.removeObject(at: forIndex)
        self.tableView.reloadData()
    }
    
    //MARK:- Webservice
    func addSkillWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.dataArray, forKey: "skills")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: addSkills, parameter: params) { (JSON) in
            
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
