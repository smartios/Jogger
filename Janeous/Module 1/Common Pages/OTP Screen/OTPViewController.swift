//
//  OTPViewController.swift
//  Janeous
//
//  Created by SS21 on 19/02/18.
//

import UIKit

class OTPViewController: MyBaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK:- IBOutlets intitalization
    @IBOutlet var OTPViewCell : UITableViewCell!
    @IBOutlet var signInBtnCell : UITableViewCell!
    @IBOutlet var tableView : UITableView!
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    var username:String!
    
    
    var nib = UINib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.estimatedRowHeight = 100
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setWhiteNavigationbarWithTitleImageAndSideMenu()
    }
    
    //MARK:- Button Actions
    @IBAction func sideMenu(_sender: UIBarButtonItem)
    {
        appDel.mainContainer.toggleLeftSideMenuCompletion(nil)
    }
    
    @IBAction func signInBtnClick(_sender : UIButton)
    {
        self.errorDic.removeAllObjects()
        self.hideKeyboard()
        self.tableView.reloadData() //removing all errors
        
        if self.dataDic.value(forKey: "otp") == nil || (self.dataDic.value(forKey: "otp") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter OTP."), forKey: "otp")
        }
        
        if self.errorDic.count == 0
        {
            self.verifyOTPWebService()
            return
        }
        
        self.tableView.reloadData() // showing all errors
    }
    
    @IBAction func resentOTPButtonClicked(_sender : UIButton)
    {
        self.resendOTPWebService()
    }
    
    //MARK:- tableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 0
        var bottomPadding:CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = (window?.safeAreaInsets.bottom)! // For iPhone X
        }
        
        if(indexPath.row == 0 || indexPath.row == 2)
        {
            height = ((self.view.frame.size.height - bottomPadding)/2) - 90
        }
        else if(indexPath.row == 1)
        {
            height = UITableViewAutomaticDimension
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == 0
        {
            Bundle.main.loadNibNamed("OTPScreenCell", owner: self, options: nil)
            cell = tableView.dequeueReusableCell(withIdentifier: "OTPViewCell")
            if cell == nil{
                cell = OTPViewCell
                OTPViewCell = nil
            }
            
            let titleLabel = cell.viewWithTag(2) as! UILabel
            let subTitleLabel = cell.viewWithTag(3) as! UILabel
            
            titleLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
            titleLabel.textColor = defaultDarkTextColor()
            titleLabel.text = Localization("Enter OTP To Login")
            
            subTitleLabel.font = UIFont(name: defaultLight, size: textFontSize15)
            subTitleLabel.textColor = defaultLightTextColor()
            
            var string = ""
            var stringArr = Array(username)
            
            if(isValidEmail(testStr: username))
            {
                string = "\(Localization("email")) "
            }
            else
            {
                string = "\(Localization("mobile")) "
            }
            
            for var i in (0..<username.count)
            {
                if i < stringArr.count - 4
                {
                    string = "\(string)*"
                }
                else
                {
                    string = "\(string)\(stringArr[i])"
                }
            }
            
            subTitleLabel.text =  "\(Localization("One Time Password (OTP) has been sent to your \n"))\(string)\(Localization(", please enter the \nsame here to login"))"
            
        }
        else if indexPath.row == 1
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            
            tempCell.hideError()
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            titleLabel.text = Localization("OTP")
            
            if dataDic.value(forKey: "otp") != nil
            {
                textfield.text = dataDic.value(forKey: "otp") as? String
            }
            
            if errorDic.value(forKey: "otp") != nil
            {
                tempCell.showError(message: errorDic.value(forKey: "otp") as! String)
            }
            
            cell = tempCell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "signInBtnCell")
            if cell == nil
            {
                cell = signInBtnCell
                signInBtnCell = nil
            }
            
            let resendOTPButton = cell.viewWithTag(1) as! UIButton
            let signInButton = cell.viewWithTag(2) as! UIButton
            
            resendOTPButton.setTitle(Localization("Resend OTP"), for: .normal)
            resendOTPButton.setTitleColor(defaultGreenColor(), for: .normal)
            resendOTPButton.titleLabel?.font = UIFont(name: defaultRegular, size: buttonFontSize14)
            resendOTPButton.addTarget(self, action: #selector(resentOTPButtonClicked(_sender:)), for: UIControlEvents.touchUpInside)
            
            signInButton.setTitle(Localization("SIGN IN"), for: .normal)
            signInButton.addTarget(self, action: #selector(signInBtnClick(_sender:)), for: UIControlEvents.touchUpInside)
            
        }
        
        
        return cell
    }
    
    //MARK:- TextField
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "otp")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    //MARK:- Web Services
    func resendOTPWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.username, forKey: "username")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: forgotPassword, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                
            }
            else
            {
                
                //                // Showing message irrespective of Status
                if (JSON as! NSDictionary).object(forKey: "errors") != nil && (JSON as! NSDictionary).object(forKey: "errors") is NSArray
                {
                    let tempArray = ((JSON as! NSDictionary).object(forKey: "errors") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for item in tempArray
                    {
                        self.errorDic.setValue((item as! NSDictionary).value(forKey: "value"), forKey:(item as! NSDictionary).value(forKey: "key") as! String)
                    }
                    
                    self.tableView.reloadData()
                    
                }
                else if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                
            }
            
            
        }
    }
    
    func verifyOTPWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.username, forKey: "username")
        params.setValue(self.dataDic.value(forKey: "otp"), forKey: "otp")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: verifyOTP, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                let vc = ResetPasswordController()
                vc.username = self.username
                vc.otp = "\(self.dataDic.value(forKey: "otp")!)"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else
            {
                
                //                // Showing message irrespective of Status
                if (JSON as! NSDictionary).object(forKey: "errors") != nil && (JSON as! NSDictionary).object(forKey: "errors") is NSArray
                {
                    let tempArray = ((JSON as! NSDictionary).object(forKey: "errors") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for item in tempArray
                    {
                        self.errorDic.setValue((item as! NSDictionary).value(forKey: "value"), forKey:(item as! NSDictionary).value(forKey: "key") as! String)
                    }
                    
                    self.tableView.reloadData()
                    
                }
                else if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                
            }
            
            
        }
    }
    
    
}
