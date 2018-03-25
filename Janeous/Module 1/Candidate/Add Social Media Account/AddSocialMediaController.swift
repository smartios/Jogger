//
//  AddSocialMediaController.swift
//  Janeous
//
//  Created by SS21 on 21/02/18.
//

import UIKit
class AddSocialMediaController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UITextFieldDelegate {
    
    //    MARK:- IBOutlet declartion
    @IBOutlet weak var  titleLabel : UILabel!
    
    @IBOutlet weak var  tableView : UITableView!
    @IBOutlet var  addSocialMediaCell : UITableViewCell!
    @IBOutlet var  addMoreCell : UITableViewCell!
    @IBOutlet var  skipCell : UITableViewCell!
    
    var tapGesture = UITapGestureRecognizer()
    
    var nib = UINib()
    var socialLinks = 3
    //    MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
       
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup()
    {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        //self.tableView.removeGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        titleLabel.text = Localization("YOUR SOCIAL MEDIA ACCOUNTS")
        titleLabel.font = UIFont(name: defaultRegular, size: textFontSize21)
        titleLabel.textColor = defaultDarkTextColor()
        
        
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
    
    
    
    
    
//    MARK:- TableView Delegate and dataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialLinks + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        Bundle.main.loadNibNamed("AddSocialMediaCell", owner: self, options: nil)
        //        if indexPath.row == 0{
        //        cell = tableView.dequeueReusableCell(withIdentifier: "addSocialMediaCell")
        //        if cell == nil{
        //            cell = addSocialMediaCell
        //            addSocialMediaCell = nil
        //        }
        //        }
        if indexPath.row == socialLinks - 1
        {
            nib = UINib(nibName: "ButtonCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "buttonCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            
        }
        else if indexPath.row == socialLinks - 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell")
            if cell == nil{
                cell = addMoreCell
                addMoreCell = nil
            }
            
            let addMoreBtn = cell.viewWithTag(5) as! UIButton
            addMoreBtn.addTarget(self, action: #selector(addMoreBtnAction), for: UIControlEvents.touchUpInside)
        }
        else if indexPath.row == socialLinks  {
            cell = tableView.dequeueReusableCell(withIdentifier: "skipCell")
            if cell == nil{
                cell = skipCell
                skipCell = nil
            }
            let skipBtn =  cell.viewWithTag(6) as! UIButton
            skipBtn.addTarget(self, action: #selector(skipBtnAction), for: UIControlEvents.touchUpInside)
            
            
        }
        else
        {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "addSocialMediaCell")
            if cell == nil{
                cell = addSocialMediaCell
                addSocialMediaCell = nil
            }
            
            
            
            let textField = cell.viewWithTag(3) as! UITextField
            textField.delegate = self
            let removeBtn = cell.viewWithTag(2) as! UIButton
            removeBtn.addTarget(self, action: #selector(removeBtnAction), for: UIControlEvents.touchUpInside)
        }
        return cell
    }
    
    
    
//    MARK:- IBActions Definitions
    
    @IBAction func addMoreBtnAction(_sender : UIButton){
        socialLinks =  socialLinks + 1
        tableView.reloadData()
    }
    @IBAction func removeBtnAction(_sender : UIButton)
    {
        //        if socialLinks > 3 {
        socialLinks = socialLinks - 1
        tableView.reloadData()
        //        }
        
        
    }
    @IBAction func skipBtnAction(_sender :  UIButton)
    {
        print("skip button pressed")
    }
    //MARK:- TextField
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row < (socialLinks - 3)
        {
            textField.returnKeyType = .next
        }
        else
        {
            textField.returnKeyType = .done
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row < (socialLinks - 3)

        {
            let nextIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let cell:UITableViewCell = self.tableView.cellForRow(at: nextIndexPath)!
            let nextTextField = cell.viewWithTag(3) as! UITextField
            nextTextField.becomeFirstResponder()
        }
        else
        {
            self.hideKeyboard()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.row == 0
        {
//            self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "username")
        }
        else if indexPath.row == 2
        {
//            self.dataDic.setValue(textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
        }
    }
    
}
