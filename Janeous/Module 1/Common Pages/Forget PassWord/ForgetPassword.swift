//
//  ForgetPassword.swift
//  Janeous
//
//  Created by SS21 on 19/02/18.
//

import UIKit

class ForgetPassword: MyBaseViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate {
    var nib = UINib()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ForgetPassWordView:UITableViewCell!
    @IBOutlet var continueBtnCell:UITableViewCell!
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nib = UINib(nibName: "ButtonCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "buttonCell")
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
    
    
    @IBAction func continueBtnClick(_sender : UIButton)
    {
        self.errorDic.removeAllObjects()
        self.hideKeyboard()
        self.tableView.reloadData() //removing all errors
        
        if self.dataDic.value(forKey: "username") == nil || (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.errorDic.setValue(Localization("Please enter your email or mobile number."), forKey: "username")
        }
        else if  (!numberFiler(string: (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines))) && !isValidEmail(testStr: (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
        {
            self.errorDic.setValue(Localization("Please enter valid email."), forKey: "username")
        }
        else if numberFiler(string: (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines)) &&  (self.dataDic.value(forKey: "username") as! String).trimmingCharacters(in: .whitespacesAndNewlines).count < 8
        {
            self.errorDic.setValue(Localization("Please enter valid mobile number."), forKey: "username")
        }
        
        if self.errorDic.count == 0
        {
            self.sendOTPWebService()
            return
        }
        
        self.tableView.reloadData() // showing all errors
    }
    
    //    MARK:- Table View Methods
    
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
            
            if(height < 241)
            {
                height = 241
            }
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
            Bundle.main.loadNibNamed("ForgetPasswordCell", owner: self, options: nil)
            cell = tableView.dequeueReusableCell(withIdentifier: "forgetPassWordView")
            if cell == nil{
                cell = ForgetPassWordView
                ForgetPassWordView = nil
            }
            
            let titleLabel = cell.viewWithTag(2) as! UILabel
            let subTitleLabel = cell.viewWithTag(3) as! UILabel
            
            titleLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
            titleLabel.textColor = defaultDarkTextColor()
            titleLabel.text = Localization("Forgot Password?")
            
            subTitleLabel.font = UIFont(name: defaultLight, size: textFontSize15)
            subTitleLabel.textColor = defaultLightTextColor()
            subTitleLabel.text = Localization("We'll send instrutions to the registered \nemail or mobile number below")
            
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
            
            titleLabel.text = Localization("EMAIL/MOBILE NUMBER")
            
            if dataDic.value(forKey: "username") != nil
            {
                textfield.text = dataDic.value(forKey: "username") as? String
            }
            
            if errorDic.value(forKey: "username") != nil
            {
                tempCell.showError(message: errorDic.value(forKey: "username") as! String)
            }
            
            cell = tempCell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "continueBtnCell")
            if cell == nil
            {
                cell = continueBtnCell
                continueBtnCell = nil
            }
            let continueBtn =  cell.viewWithTag(10) as! defaultGreenButton
            let signTextView = cell.viewWithTag(3) as! UITextView
            
            signTextView.delegate = self
            continueBtn.setTitle(Localization("CONTINUE"), for: .normal)
            
            continueBtn.addTarget(self, action: #selector(continueBtnClick), for: UIControlEvents.touchUpInside)
            
            //Sign In text View
            let str2:NSString = Localization("Back to Sign In") as NSString
            let string2:NSMutableAttributedString = NSMutableAttributedString(string: "\(str2)")
            string2.addAttributes([NSAttributedStringKey.font: UIFont(name: defaultRegular, size: textFontSize14)!], range: str2.range(of: str2 as String))
            string2.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultDarkTextColor(), range: str2.range(of: str2 as String))
            string2.addAttribute(NSAttributedStringKey.link, value: "sign_in", range: str2.range(of: Localization("Sign In")))
            signTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:defaultGreenColor()]
            signTextView.attributedText = string2
            signTextView.textAlignment = .center
            
        }
        
        return cell
    }
    
    //MARK:- TextField
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "username")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    //MARK:- TextView
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if("\(url)" ==  "sign_in")
        {
            for vc in self.navigationController!.viewControllers
            {
                if(vc is LoginViewController)
                {
                    self.navigationController?.popToViewController(vc, animated: true)
                    return true
                }
            }
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        return true
    }
    
    //MARK:- Web Services
    func sendOTPWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        params.setValue(self.dataDic.value(forKey: "username"), forKey: "username")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: forgotPassword, parameter: params) { (JSON) in
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                if (JSON as! NSDictionary).object(forKey: "message") != nil
                {
                    supportingfuction.showMessageHudWithMessage(message: "\((JSON as! NSDictionary).object(forKey: "message")!)", delay: 2.0)
                }
                
                let vc = OTPViewController()
                vc.username = "\(self.dataDic.value(forKey: "username")!)"
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
