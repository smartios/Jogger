//
//  AddYearOfExperienceController.swift
//  Janeous
//
//  Created by SS21 on 09/03/18.
//

import UIKit

class AddYearOfExperienceController: MyBaseViewController, UITableViewDataSource, UITableViewDelegate,pickerViewGetValue
{
    
     @IBOutlet weak var tableView: UITableView!
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    let numberOfYearArray = [Int](1...100)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        
        tableView.register(UINib(nibName: "SkipButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SkipButtonTableViewCell")
        
        self.dataDic.setValue(userData.experience, forKey: "experience")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let str:NSString = Localization("Add Total Years of Professional Experience") as NSString
        
        let attributedString1 = NSMutableAttributedString(string: "\(str)")
        
        self.setGrayNavigationbarWithTitle(AttributedString: attributedString1)
    }
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == 0{
            
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
          
            tempCell.textField.isUserInteractionEnabled = false
            tempCell.textField.text = ""
            tempCell.titleLabel.text = Localization("YEARS OF PROFESSIONAL EXPERIENCE")
         
            
            if dataDic.value(forKey: "experience") != nil
            {
                tempCell.textField.text = "\(dataDic.value(forKey: "experience")!)"
            }
            
            if errorDic.value(forKey: "experience") != nil
            {
                tempCell.showError(message: errorDic.value(forKey: "experience") as! String)
            }
            
            cell = tempCell
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell")
            let cancelButton = cell.viewWithTag(12) as! UIButton
            let doneButton = cell.viewWithTag(13) as! UIButton
            
            cancelButton.setTitle(Localization("CANCEL"), for: .normal)
            doneButton.setTitle(Localization("DONE"), for: .normal)
            
            cancelButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            doneButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)

        }
        else if indexPath.row == 2
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "SkipButtonTableViewCell")
            //let skipButton = cell.viewWithTag(1) as! UIButton
        }

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let vc = PickerViewController()
            vc.pickerViewGetValue = self
            vc.modalPresentationStyle = .overCurrentContext
            vc.pickerValue = self.numberOfYearArray as NSArray
            self.present(vc, animated: true, completion: nil)
        }
        
    }

    //MARK:- Picker Delegate
    func pickerViewGetValue(pickerView:UIPickerView, withValue:Int)
    {
        self.dataDic.setValue(numberOfYearArray[withValue], forKeyPath: "experience")
        self.tableView.reloadData()
    }
    
    //MARK:- Actions
    @IBAction  func saveButtonClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.errorDic.removeAllObjects()
        
        if self.dataDic.value(forKey: "experience") == nil && "\(self.dataDic.value(forKey: "experience")!)" != ""
        {
            self.errorDic.setValue(Localization("Please enter experience years."), forKey: "experience")
        }
        
        if self.errorDic.count == 0
        {
            self.addExperienceYearsWebService()
            return
        }
        
        self.tableView.reloadData()
    }

    //    MARK:- Web Services
    func addExperienceYearsWebService()
    {
        let cv = CommonValidations()
        let params = self.dataDic

        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: addExpYears, parameter: params) { (JSON) in
            
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
