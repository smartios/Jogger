//
//  AddEducationExpViewController.swift
//  Janeous
//
//  Created by singsys on 08/03/18.
//

import UIKit

class AddEducationExpViewController: MyBaseViewController, UITableViewDataSource , UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var  tableView : UITableView!
    @IBOutlet var checkBoxCell: UITableViewCell!
    
    let TitleArr = ["DEGREE TITLE*","DEGREE LEVEL*", "GRADE POINT AVERAGE","FIELD OF STUDY*","MINOR","SCHOOL"]
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.initialSetUp()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
//
//        for subview in (self.navigationController?.navigationBar.subviews)! {
//            if NSStringFromClass(subview.classForCoder).contains("BarBackground") {
//                var subViewFrame: CGRect = subview.frame
//                // subViewFrame.origin.y = -20;
//
//                 var statusHeight:CGFloat = 20
//
//                if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
//                    statusHeight = statusBar.frame.size.height
//                }
//
//                subViewFrame.size.height = 64 + statusHeight
//                subview.frame = subViewFrame
//
//            }
//    }
   }
    
    func initialSetUp()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        
        tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
        tableView.register(UINib(nibName: "DurationCell", bundle: nil), forCellReuseIdentifier: "DurationCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        tableView.register(UINib(nibName: "FullWidthButtonCell", bundle: nil), forCellReuseIdentifier: "BtnCell")
 
        Bundle.main.loadNibNamed("AddEducationCells", owner: self, options: nil)
        
        //Setting navigation bar title
        let str:NSString = Localization("Add Work Experience (max 6)") as NSString
        
        let attributedString1 = NSMutableAttributedString(string: "\(str)")
       attributedString1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: defaultMedium, size: textFontSize14)!, range: str.range(of: "(max 6)"))
        
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
    
    //MARK:- Button Actions
    @IBAction func durationButtonClicked(_sender:UIButton)
    {
        
    }
    
    func scrollToIndexPath(indexPath:IndexPath)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    
    //MARK:- Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return TitleArr.count + 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row < TitleArr.count
        {
            let tempCell:baseTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "baseTextFieldTableViewCell") as! baseTextFieldTableViewCell
            
            let titleLabel = tempCell.viewWithTag(1) as! UILabel
            let textfield = tempCell.viewWithTag(2) as! UITextField
            let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            tempCell.hideRightButton()
            tempCell.hideError()
            textfield.isSecureTextEntry = false
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            rightButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
            rightButton.isUserInteractionEnabled = false
            
            let str:NSString = Localization(TitleArr[indexPath.row]) as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
        attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
            if indexPath.row == 1 || indexPath.row == 3
            {
                tempCell.showRightButton()
            }
            
            cell = tempCell
        }
        else if indexPath.row == TitleArr.count
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "checkBoxCell")
            if cell == nil{
                cell = checkBoxCell
                checkBoxCell = nil
            }
        }
        else if indexPath.row == TitleArr.count + 1
        {
            let tempCell:DurationCell = tableView.dequeueReusableCell(withIdentifier: "DurationCell") as! DurationCell
            
            tempCell.headerLabel.text = Localization("DURATION")
            tempCell.titleLabel.text = Localization("FROM")
            tempCell.titleLabel2.text = Localization("TO")
            
            tempCell.textField.placeholder = Localization("Year")
            tempCell.textField2.placeholder = Localization("Year")
            
            tempCell.textField.text = ""
            tempCell.textField2.text = ""
            
            tempCell.hideError()
            tempCell.hideError2()
            
            tempCell.topButton.addTarget(self, action:  #selector(durationButtonClicked(_sender:)), for: .touchUpInside)
            
            tempCell.topButton2.addTarget(self, action:  #selector(durationButtonClicked(_sender:)), for: .touchUpInside)
            
            cell = tempCell
            
        }
        else if indexPath.row == TitleArr.count + 2
        {
             cell = tableView.dequeueReusableCell(withIdentifier: "BtnCell") as! UITableViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! UITableViewCell
            
        }
        
        return cell
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        let hitPoint: CGPoint = (textField as AnyObject).convert((textField as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if(indexPath.row == 7)
        {
            textField.returnKeyType = .done
        }
        else
        {
            textField.returnKeyType = .next
        }
        
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
        
        if(indexPath.row == self.TitleArr.count - 1)
        {
            self.hideKeyboard()
        }
        else
        {
            let nextIndexPath:IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let cell:UITableViewCell = self.tableView.cellForRow(at: nextIndexPath)!
            let nextTextField = cell.viewWithTag(2) as! UITextField
            
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    //MARK:- Delegate
    func countryValue(dic:NSDictionary)
    {
        self.dataDic.setValue(dic, forKey: "phone_code")
        self.tableView.reloadData()
    }
}
