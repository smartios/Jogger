//
//  CreateBranchController.swift
//  Janeous
//
//  Created by SS21 on 19/02/18.
//

import UIKit

class CreateBranchController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,selectCountryDelegate {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var industryCell : UITableViewCell!
    @IBOutlet var addMoreCell : UITableViewCell!
    @IBOutlet var industryAddMoreCell : UITableViewCell!
    @IBOutlet var interViewerAddCell : UITableViewCell!
    var addIndustry = 2
    var addInterviewer = 3
    var nib = UINib()
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.white
        }
        
        self.title = "Create Branch"
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: defaultMedium, size: textFontSize15)!]
        
        let height: CGFloat = 500 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: bounds.width, height: bounds.height + height)
        
        //let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "cross_black").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked(_:)))
        //self.navigationItem.leftBarButtonItem  = backButton
        self.navigationController?.navigationBar.barTintColor = defaultLightTextColor()
        self.navigationController?.navigationBar.tintColor = defaultLightTextColor()
        self.navigationController?.navigationBar.isTranslucent = false;
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func initialSetUp()
    {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        
        nib = UINib(nibName: "ButtonCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "buttonCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 6
        }
        else if section == 1{
            return addIndustry + 1
        }
        else{
            return addInterviewer + 1
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = ""
        if section == 2
        {
            sectionTitle = "ASSOCIATED INTERVIEWERS"
            return sectionTitle
        }
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        Bundle.main.loadNibNamed("CreateBranchCell", owner: self, options: nil)
        if indexPath.section == 0 {
            
            
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            //let errorLabel = cell.viewWithTag(5) as! UILabel
            //let lineImageView = cell.viewWithTag(6) as! UIImageView
            let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            let mobileCodeTextField = tempCell.viewWithTag(21) as! UITextField
            let mobileCodeButton = tempCell.viewWithTag(22) as! UIButton
            
            rightButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)

            
            tempCell.notMobileField()
            tempCell.hideRightButton()
            tempCell.hideError()
            //textfield.isSecureTextEntry = false
            textfield.text = ""
            
            if indexPath.row == 0 {
                titleLabel.text = Localization("COMPANY NAME*")
                if errorDic.value(forKey: "first_name") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                }
            }
            else if indexPath.row == 1{
                
                titleLabel.text = "POINT OF CONTACT"
                
                if errorDic.value(forKey: "first_name") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                }
            }
            else if indexPath.row == 2{
                
                titleLabel.text = "COMPANY WEBSITE"
                
                if errorDic.value(forKey: "first_name") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                }
            }
            else if indexPath.row == 3 {
                titleLabel.text = "COMPANY EMAIL*"
                
                if errorDic.value(forKey: "first_name") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                }
            }
                //  Row Mobile Number
            else if indexPath.row == 4 {
            
                tempCell.thisIsMobileField()
                titleLabel.text = "COMPANY NUMBER"
                
                if errorDic.value(forKey: "first_name") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                }
            }
            else
            {
                tempCell.showRightButton()
                titleLabel.text = "LOCATION*"
                
                if errorDic.value(forKey: "first_name") != nil
                {
                    tempCell.showError(message: errorDic.value(forKey: "first_name") as! String)
                }
            }
            
            let str:NSString = titleLabel.text! as NSString
            
            let string:NSMutableAttributedString = NSMutableAttributedString(string: "\(str)")
            string.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            titleLabel.attributedText = string
            
            cell = tempCell
        }
            //            section 1
        else if indexPath.section == 1 {
            
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "industryCell")
                if cell == nil{
                    cell = industryCell
                    industryCell = nil
                }
            }
            else if indexPath.row == addIndustry
            {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell")
                if cell == nil{
                    cell = addMoreCell
                    addMoreCell = nil
                }
                let addMoreBtn = cell.viewWithTag(1) as! UIButton
                addMoreBtn.setTitle("+ADD MORE", for: UIControlState.normal)
                addMoreBtn.titleLabel?.font = UIFont(name: defaultMedium, size: textFontSize14)
                addMoreBtn.setTitleColor(defaultGreenColor(), for: .normal)
                //                    addMoreBtn.titleLabel?.text =  "+Add MORE"
                addMoreBtn.addTarget(self, action: #selector(addIndustryAction), for: UIControlEvents.touchUpInside)
                
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "industryAddMoreCell")
                if cell == nil{
                    cell = industryAddMoreCell
                    industryAddMoreCell = nil
                }
                let removeIndustryBtn = cell.viewWithTag(2) as! UIButton
                removeIndustryBtn.addTarget(self, action: #selector(removeIndustryAction), for: UIControlEvents.touchUpInside)
            }
        }
            //        section 2
            
        else{
            
           
            
            if indexPath.row == 0
            {
                let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
                
                let titleLabel = tempCell.viewWithTag(1) as! UILabel
                let textfield = tempCell.viewWithTag(2) as! UITextField
                //let errorLabel = cell.viewWithTag(5) as! UILabel
                //let lineImageView = cell.viewWithTag(6) as! UIImageView
                let rightButton = tempCell.viewWithTag(7) as! UIButton
                
                let mobileCodeTextField = tempCell.viewWithTag(21) as! UITextField
                let mobileCodeButton = tempCell.viewWithTag(22) as! UIButton
                
                rightButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
                
                
                tempCell.notMobileField()
                tempCell.hideRightButton()
                tempCell.hideError()
                //textfield.isSecureTextEntry = false
                textfield.text = ""
                
                titleLabel.text = "INTERVIEWER NAME"
                
                cell = tempCell
            }
            else if (indexPath.row == addInterviewer - 1)
            {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell")
                if cell == nil{
                    cell = addMoreCell
                    addMoreCell = nil
                }
                let addInterViewerBtn = cell.viewWithTag(1) as! UIButton
                
                
                addInterViewerBtn.setTitle("+ADD MORE", for: UIControlState.normal)
                addInterViewerBtn.titleLabel?.font = UIFont(name: defaultMedium, size: textFontSize14)
                addInterViewerBtn.setTitleColor(defaultGreenColor(), for: .normal)
                //                  addInterViewerBtn.titleLabel?.text =  "+Add MORE"
                
                
                addInterViewerBtn.addTarget(self, action: #selector(addInterViewerAction), for: UIControlEvents.touchUpInside)
                
            }
            else if indexPath.row == addInterviewer{
                cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
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
                
                rightButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
                
                
                tempCell.notMobileField()
                tempCell.hideRightButton()
                tempCell.hideError()
                //textfield.isSecureTextEntry = false
                textfield.text = ""
                titleLabel.text = "INTERVIEWER NAME"
                
                cell = tempCell
//                var removeInterViewerBtn = cell.viewWithTag(3) as! UIButton
//                removeInterViewerBtn.addTarget(self, action: #selector(removeInterViewerAction), for: UIControlEvents.touchUpInside)
            }
        }
        
        
        return cell
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
    
        
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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        
        return true
    }
    
    //MARK:- Delegate
    func countryValue(from:String, withDic:NSDictionary)
    {
        self.dataDic.setValue(withDic, forKey: "phone_code")
        self.tableView.reloadData()
    }
    
    //    MARK:- Buttons Action
    
    @IBAction func addIndustryAction(_ sender: UIButton){
        addIndustry = addIndustry + 1
         tableView.reloadData()
//        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
//        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
//        self.tableView.reloadSections([indexPath.section], with: .automatic)
        
    }
    @IBAction func removeIndustryAction(_ sender: UIButton){
        addIndustry  = addIndustry - 1
        tableView.reloadData()
//        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
//        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
//        self.tableView.reloadSections([indexPath.section], with: .automatic)
        
    }
    @IBAction func addInterViewerAction(_ sender: UIButton){
        addInterviewer = addInterviewer + 1
           tableView.reloadData()
//        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
//        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
//        self.tableView.reloadSections([indexPath.section], with: .automatic)
        
    }
    @IBAction func removeInterViewerAction(_ sender: UIButton){
        addInterviewer  = addInterviewer - 1
           tableView.reloadData()
//        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
//        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
//        self.tableView.reloadSections([indexPath.section], with: .automatic)
        
    }
    
}
