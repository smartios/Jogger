//
//  AddPersonalInformationController.swift
//  Janeous
//
//  Created by SS21 on 09/03/18.
//

import UIKit

class AddPersonalInformationController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var titleArray = ["CONTACT INFORMATION","EMAIL ADDRESS","MOBILE NUMBER","PERSONAL INFORMATION", "DATE OF BIRTH*+","Prefer not to answer","GENDER*+","Prefer not to answer","WHICH COUNTRIES CAN YOU WORK FROM?","COUNTRY NAME","Add New"]
    @IBOutlet var headTitleCell : UITableViewCell!
    @IBOutlet var dobCell : UITableViewCell!
    @IBOutlet var preferAnswerCell : UITableViewCell!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var genderSelectCell : UITableViewCell!
    @IBOutlet var addCountryCell : UITableViewCell!
    @IBOutlet var  addNewCell : UITableViewCell!
    var dataDic = NSMutableDictionary()
    var appendData = 0
    var maxPer = 0
    var rowCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TitleLabelCellTableViewCell", bundle: nil), forCellReuseIdentifier: "nameCell")
        
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "DurationCell", bundle: nil), forCellReuseIdentifier: "DurationCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK:- Table View Delegate and dataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 8
        }
        else if section == 1
        {
            return appendData + 3
        }
        else
        {
            return maxPer + 2
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        Bundle.main.loadNibNamed("PersonalInfoCell2", owner: self, options: nil)
        
        
        if indexPath.section == 0
            
        {
            if indexPath.row == 2 || indexPath.row == 1
            {
                
                
                let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! baseTextFieldTableViewCell
                
                let label = tempCell.viewWithTag(1) as! UILabel
                let textfField = tempCell.viewWithTag(2) as! UITextField
                let rightButton = tempCell.viewWithTag(7) as! UIButton
                let mobileField = tempCell.mobileCodeTextField
                textfField.delegate = self
                textfField.text = ""
                label.textColor = defaultLightTextColor()
                label.font = UIFont(name: defaultRegular, size: textFontSize14)
                textfField.textColor = defaultDarkTextColor()
                textfField.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
                textfField.isSecureTextEntry = false
                
                tempCell.hideError()
                
                
                
                if(indexPath.row == 1)
                {
                    label.text = Localization("\(titleArray[indexPath.row])")
                }
                else if indexPath.row == 2
                {
                    rightButton.setImage(UIImage(named: "arrow"), for: .normal)
                    tempCell.thisIsMobileField()
                    
                    tempCell.showRightButton()
                }
                
                cell = tempCell
            }
                
            else{
                if indexPath.row == 0
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "headTitleCell")
                    if cell == nil
                    {
                        cell = headTitleCell
                        headTitleCell = nil
                    }
                    var title = cell.viewWithTag(1) as! UILabel
                    var imageView = cell.viewWithTag(2) as! UIImageView
                    imageView.isHidden = true
                    title.text = Localization("\(titleArray[indexPath.row])")
                }
                else if indexPath.row == 3{
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: "headTitleCell")
                    if cell == nil
                    {
                        cell = headTitleCell
                        headTitleCell = nil
                    }
                    var title = cell.viewWithTag(1) as! UILabel
                    var imageView = cell.viewWithTag(2) as! UIImageView
                    imageView.isHidden = true
                    title.text = Localization("\(titleArray[indexPath.row])")
                }
                else if indexPath.row == 4{
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: "dobCell")
                    if cell == nil
                    {
                        cell = dobCell
                        dobCell = nil
                    }
                    let title = cell.viewWithTag(3) as! UILabel
                    let DobTitle = cell.viewWithTag(5) as! UILabel
                    DobTitle.text = "15Sep , 1998"
                    let dobRadioBtn = cell.viewWithTag(4) as! UIButton
                    dobRadioBtn.addTarget(self, action: #selector(dobBtnClick), for:UIControlEvents.touchUpInside)
                    
                    
                    if(dataDic.value(forKey: "DOB") != nil && dataDic != nil && dataDic.value(forKey: "DOB") as! String != "no" && dataDic.value(forKey: "DOB") as! String != "")
                    {
                        dobRadioBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
                        
                    }
                    else
                    {
                        dobRadioBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                        
                    }
                    title.text = "\(titleArray[indexPath.row])"
                }
                else if indexPath.row == 5{
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: "preferAnswerCell")
                    if cell == nil
                    {
                        cell = preferAnswerCell
                        preferAnswerCell = nil
                    }
                    let title = cell.viewWithTag(8) as! UILabel
                    let selectPreference = cell.viewWithTag(7) as! UIButton
                    selectPreference.addTarget(self, action: #selector(dobBtnClick), for:UIControlEvents.touchUpInside)
                    
                    if(dataDic.value(forKey: "DOB") != nil && dataDic.value(forKey: "DOB") as! String == "no" && dataDic.value(forKey: "DOB") as! String != "" && dataDic != nil)
                        
                    {
                        selectPreference.setImage(UIImage(named: "check"), for: UIControlState.normal)
                        
                    }
                    else
                    {
                        selectPreference.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                        
                    }
                    
                    title.text = "\(titleArray[indexPath.row])"
                }
                else if indexPath.row == 6{
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: "genderSelectCell")
                    if cell == nil
                    {
                        cell = genderSelectCell
                        genderSelectCell = nil
                    }
                    let title = cell.viewWithTag(9) as! UILabel
                    
                    let maleLabel = cell.viewWithTag(11) as! UILabel
                    maleLabel.text = Localization("Male")
                    let maleSelectBtn = cell.viewWithTag(10) as! UIButton
                    let femaleLabel =  cell.viewWithTag(13) as! UILabel
                    let femaleSelectBtn = cell.viewWithTag(12) as! UIButton
                    femaleLabel.text = Localization("Female")
                    femaleSelectBtn.addTarget(self, action: #selector(dobBtnClick), for:UIControlEvents.touchUpInside)
                    title.text = "\(titleArray[indexPath.row])"
                    maleSelectBtn.addTarget(self, action: #selector(dobBtnClick), for:UIControlEvents.touchUpInside)
                    if(dataDic.count>0 && dataDic.object(forKey: "Gender") != nil && dataDic.object(forKey: "Gender") as! String != "" && dataDic.object(forKey: "Gender") as! String == "Male" )
                        
                    {
                        maleSelectBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
                        femaleSelectBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                        
                        
                    }
                    else if (dataDic.count>0 && dataDic.object(forKey: "Gender") != nil && dataDic.object(forKey: "Gender") as! String != "" && dataDic.object(forKey: "Gender") as! String == "Female")
                    {
                        maleSelectBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                        femaleSelectBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
                        
                        
                    }else{
                        maleSelectBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                        femaleSelectBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                    }
                    
                    
                }
                else if indexPath.row == 7{
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: "preferAnswerCell")
                    if cell == nil
                    {
                        cell = preferAnswerCell
                        preferAnswerCell = nil
                    }
                    let title = cell.viewWithTag(8) as! UILabel
                    
                    title.text = "\(titleArray[indexPath.row])"
                    let selectPreference = cell.viewWithTag(7) as! UIButton
                    selectPreference.addTarget(self, action: #selector(dobBtnClick), for:UIControlEvents.touchUpInside)
                    if (dataDic.count > 0 && dataDic.object(forKey: "Gender") != nil && dataDic.object(forKey: "Gender") as! String != "" && dataDic.object(forKey: "Gender") as! String == "no" &&  (dataDic.object(forKey: "Gender") as! String != "Male" &&  dataDic.object(forKey: "Gender") as! String != "Female"))
                        
                    {
                        selectPreference.setImage(UIImage(named: "check"), for: UIControlState.normal)
                        
                    }
                    else
                    {
                        selectPreference.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                        
                    }
                }
                
                
            }
            
        }
            
        else if  indexPath.section == 1{
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headTitleCell")
                if cell == nil
                {
                    cell = headTitleCell
                    headTitleCell = nil
                }
                var title = cell.viewWithTag(1) as! UILabel
                var imageView = cell.viewWithTag(2) as! UIImageView
                imageView.isHidden = false
                imageView.image = UIImage(named:"bullet")
                
                title.text = "\(titleArray[indexPath.row])"
                
            }
            else if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "addCountryCell")
                if cell == nil
                {
                    cell = addCountryCell
                    addCountryCell = nil
                }
                var deleteBtn = cell.viewWithTag(15) as! UIButton
                deleteBtn.addTarget(self, action: #selector(deleteBtnClick), for: UIControlEvents.touchUpInside)
                
                
            }
            else if (indexPath.row == appendData + 2)
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "addNewCell")
                if cell == nil
                {
                    cell = addNewCell
                    addNewCell = nil
                }
                let addNewBtn = cell.viewWithTag(14) as! UIButton
                
                
                addNewBtn.setTitle("Add New", for: .normal)
                addNewBtn.addTarget(self, action: #selector(addBtnClick), for: UIControlEvents.touchUpInside)
                
                
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "addCountryCell")
                if cell == nil
                {
                    cell = addCountryCell
                    addCountryCell = nil
                }
                var deleteBtn = cell.viewWithTag(15) as! UIButton
                deleteBtn.addTarget(self, action: #selector(deleteBtnClick), for: UIControlEvents.touchUpInside)
                
            }
        }
        else if indexPath.section == 2
        {
            if (indexPath.row == 0)
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "genderSelectCell")
                if cell == nil
                {
                    cell = genderSelectCell
                    genderSelectCell = nil
                }
                let title = cell.viewWithTag(9) as! UILabel
                title.text = "Willingness To Travel"
                let yesLabel = cell.viewWithTag(11) as! UILabel
                yesLabel.text = Localization("Yes")
                let yesBtn = cell.viewWithTag(10) as! UIButton
                let noLabel =  cell.viewWithTag(13) as! UILabel
                let noBtn = cell.viewWithTag(12) as! UIButton
                noLabel.text = Localization("No")
                
                yesBtn.addTarget(self, action: #selector(dobBtnClick), for:UIControlEvents.touchUpInside)
                
                noBtn.addTarget(self, action: #selector(dobBtnClick), for:UIControlEvents.touchUpInside)
                
                if(dataDic.count>0 && dataDic.object(forKey: "willingness") != nil && dataDic.object(forKey: "willingness") as! String != "" && dataDic.object(forKey: "willingness") as! String == "Yes" )
                    
                {
                    yesBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
                    noBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                    
                    
                }
                else if (dataDic.count>0 && dataDic.object(forKey: "willingness") != nil && dataDic.object(forKey: "willingness") as! String != "" && dataDic.object(forKey: "willingness") as! String == "No")
                {
                    yesBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                    noBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
                    
                    
                }else{
                    yesBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                    noBtn.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
                }
                
                
                
            }
            else if (indexPath.row == 1)
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
                
                
            }
            else if (indexPath.row == 2 && maxPer == 1 )
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
                
                
            }
            
            
        }
        
        
        
        //        else
        //        {
        //            cell = tableView.dequeueReusableCell(withIdentifier: "addCountryCell")
        //            if cell == nil
        //            {
        //                cell = addCountryCell
        //                addCountryCell = nil
        //            }
        //            var deleteBtn = cell.viewWithTag(15) as! UIButton
        //            deleteBtn.addTarget(self, action: #selector(deleteBtnClick), for: UIControlEvents.touchUpInside)
        //
        //        }
        
        
        
        
        return cell
    }
    @IBAction func dobBtnClick(_sender : UIButton){
        let hitPoint: CGPoint = (_sender as AnyObject).convert((_sender as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        var cell = tableView.cellForRow(at: indexPath)
        
        if indexPath.section == 0{
            if indexPath.row == 4
            {
                dataDic.setObject("dob", forKey: "DOB" as NSCopying)
                
                
            }
            else if indexPath.row == 5
            {
                dataDic.setObject("no", forKey: "DOB" as NSCopying)
                
            }
                
            else if indexPath.row == 6
            {
                let maleSelectBtn = cell?.viewWithTag(10) as! UIButton
                let femaleSelectBtn = cell?.viewWithTag(12) as! UIButton
                
                if _sender.tag == 10
                {
                    dataDic.setObject("Male", forKey: "Gender" as NSCopying)
                    
                }
                else if _sender.tag == 12
                {
                    dataDic.setObject("Female", forKey: "Gender" as NSCopying)
                    
                }
                
                
            }
            else if indexPath.row == 7
            {
                
                dataDic.setObject("no", forKey: "Gender" as NSCopying)
                
            }
            
        }
        else if indexPath.section == 2
        {
            if (indexPath.row == 0)
            {
                if(_sender.tag == 10)
                {
                    maxPer = 1
                    dataDic.setObject("Yes", forKey: "willingness" as NSCopying)
                    
                }
                else if(_sender.tag == 12 )
                {
                    maxPer = 0
                    dataDic.setObject("No", forKey: "willingness" as NSCopying)
                }
                
            }
            
        }
        
        self.tableView.reloadData()
        
    }
    
    @IBAction func addBtnClick(_sender : UIButton)
    {
        //        titleArray = titleArray.append("countryAdded")
        appendData = appendData + 1
        tableView.reloadData()
    }
    @IBAction func deleteBtnClick(_sender : UIButton)
    {
        if appendData > 1{
            appendData = appendData - 1
        }
        tableView.reloadData()
    }
}
