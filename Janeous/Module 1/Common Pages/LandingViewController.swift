//
//  LandingViewController.swift
//  Janeous
//  Created by SL-167 on 2/5/18.
//

import UIKit

class LandingViewController: MyBaseViewController, UITextViewDelegate,selectAccountDelegate{
    
    @IBOutlet weak var linkedIn: defaultLinkedInButton!
    @IBOutlet weak var signInEmail: defaultGreenButton!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var bottomText: CustomTextView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var linkedInDic = NSMutableDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDefaultTitles()
        //navigationItem.setLeftBarButton(sideMenuBtn, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Localization("Done")
      self.setWhiteNavigationBarWithSideMenu()
        setupTextView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK:- Button Actions
    @IBAction func sideMenu(_sender: UIBarButtonItem)
    {
        appDel.mainContainer.toggleLeftSideMenuCompletion(nil)
    }
    
    @IBAction func signInWithLinkedIn(sender: UIButton)
    {
        self.linkedInDic = NSMutableDictionary()
        appDel.linkedInSignin()
        NotificationCenter.default.addObserver(self, selector:  #selector(gotLinkedInResponse(notification:)), name: NSNotification.Name(rawValue: "linkedInInfo"), object: nil)
    }
    
    @IBAction func signInWithEmail(_sender: UIButton)
    {
    let vc = CreateUserController()
        //vc.from = "jobTitles"
    self.navigationController?.pushViewController(vc, animated: true)
    
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createAccountButtonClicked(sender:UIButton)
    {
        let vc = CreateAccountControllerView(nibName: "CreateAccountControllerView", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- LinkedIn response
    @objc func gotLinkedInResponse(notification: NSNotification)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "linkedInInfo"), object: nil)
        self.linkedInDic = (notification.object as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.loginWebService()
    }
    //MARK:- textView
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if("\(url)" == "terms")
        {
            print(">>>>>>>>>>>")
        }
        else if("\(url)" == "policy")
        {
            print(">>>>>>>>>>>")
        }
        return true
    }
    
    func setupTextView()
    {
        //   var range = (main_string as NSString).rangeOfString(string_to_color)
        let str:NSString = Localization("By using Janeous you accept and agree to the\nTerms of Service and Privacy Policy.") as NSString
        let string:NSMutableAttributedString = NSMutableAttributedString(string: "\(str)")
        
        string.addAttributes([NSAttributedStringKey.font: UIFont(name: defaultRegular, size: textFontSize14)!], range: str.range(of: str as String))
        string.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultDarkTextColor(), range: str.range(of: str as String))
        string.addAttribute(NSAttributedStringKey.link, value: "terms", range: str.range(of: Localization("Terms of Service")))
        string.addAttribute(NSAttributedStringKey.link, value: "policy", range: str.range(of: Localization("Privacy Policy")))
        bottomText.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:defaultGreenColor()]
        bottomText.attributedText = string
        bottomText.textAlignment = .center
    }
    
    func setDefaultTitles()
    {
        welcomeLabel.text = Localization("Welcome to Janeous")
        welcomeLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
        linkedIn.setTitle(Localization("SIGN IN WITH LINKEDIN"), for: .normal)
        signInEmail.setTitle(Localization("SIGN IN WITH EMAIL"), for: .normal)
        createAccount.setTitle(Localization("CREATE ACCOUNT"), for: .normal)
        createAccount.titleLabel?.font = UIFont(name: defaultRegular, size: buttonFontSize14)
        createAccount.setTitleColor(defaultGreenColor(), for: .normal)
        createAccount.layer.borderWidth = 2.0
        createAccount.layer.borderColor = defaultGreenColor().cgColor
    }
    
    //MARK:- Account Type Delegate
    func accountTypeValue(value:String)
    {
        let vc = CreateAccountControllerView(nibName: "CreateAccountControllerView", bundle: nil)
        vc.type = value
        vc.dataDic = self.linkedInDic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //    MARK:- Web Services
    func loginWebService()
    {
        let cv = CommonValidations()
        let params = NSMutableDictionary()
        
        params.setValue(linkedInDic.value(forKey: "linkedin"), forKey: "linkedin")
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        cv.makeWebServiceCall(url: login, parameter: params) { (JSON) in
            
            print(JSON)
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                //Do something on success
                
                if((JSON as! NSDictionary).object(forKey: "data") is NSDictionary)
                {
                    
                    supportingfuction.showMessageHudWithMessage(message: "Success!", delay: 2.0)
                    return
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: "Data Not in Correct Format!", delay: 2.0)
                }
                
                
            }
            else
            {
                
                let vc = SelectAccountPopUpViewController(nibName: "SelectAccountPopUp", bundle: nil)
                vc.selectAccountDelegate = self
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
                
            }
            
            
        }
    }
}


