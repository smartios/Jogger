//
//  AddTopSkillsViewController.swift
//  Janeous
//
//  Created by singsys on 09/03/18.
//

import UIKit

class AddTopSkillsViewController: MyBaseViewController, UITableViewDataSource , UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var  tableView : UITableView!
    
    var errorDic = NSMutableDictionary()
    var dataDic = NSMutableDictionary()
    
    var TagCollectionViewCell = TagCollectionViewTableViewCell()
    
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
        let str:NSString = Localization("Add Top Skills (max 6)") as NSString
        
        let attributedString1 = NSMutableAttributedString(string: "\(str)")
        attributedString1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: defaultMedium, size: textFontSize14)!, range: str.range(of: "(max 6)"))
        
        self.setGrayNavigationbarWithTitle(AttributedString: attributedString1)
    }
    
    func initialSetUp()
    {
         tableView.register(UINib(nibName: "baseTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "baseTextFieldTableViewCell")
         tableView.register(UINib(nibName: "TagCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TagCollectionViewTableViewCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
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
    func doneButtonClicked()
    {
        if self.TagCollectionViewCell.dataArray.count < 2
        {
            supportingfuction.showMessageHudWithMessage(message: "Minimum 2 skills required.", delay: 2.0)
        }
    }
    
    
    //MARK:- Table View
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 1)
        {
            var string = ""
            
            if(TagCollectionViewCell != nil)
            {
                for str in TagCollectionViewCell.dataArray
                {
                    string = "\(string)\(str)"
                }
            }
            
            if string == ""
            {
                return 0
            }
            
            print(heightForView(text: string, font: UIFont(name: defaultRegular, size: textFontSize14)!, width: self.view.frame.size.width - 58))
            
            return  heightForView(text: string, font: UIFont(name: defaultRegular, size: textFontSize14)!, width: self.view.frame.size.width - 58).height + 58
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
            let rightButton = tempCell.viewWithTag(7) as! UIButton
            
            tempCell.hideRightButton()
            tempCell.hideError()
            textfield.isSecureTextEntry = false
            
            // errorLabel.text = ""
            textfield.delegate = self
            textfield.text = ""
            
            let str:NSString = Localization("ADD TOP SKILLS (MIN 2)*") as NSString
            
            let attributedString1 = NSMutableAttributedString(string: "\(str)")
            attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: defaultErrorColor(), range: str.range(of: "*"))
            
            titleLabel.attributedText = attributedString1
            
            cell = tempCell
        }
        else if indexPath.row == 1
        {
            TagCollectionViewCell = tableView.dequeueReusableCell(withIdentifier: "TagCollectionViewTableViewCell") as! TagCollectionViewTableViewCell
            
            cell = TagCollectionViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell")
            
            //doneButtonClicked
        }
        
        return cell
    }
    
    //MARK:- Textfield
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
       textField.returnKeyType = .done
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.count >= 60
        {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if self.TagCollectionViewCell.dataArray.count < 6
        {
            self.TagCollectionViewCell.addTag(tag: textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            textField.text = ""
            
            self.tableView.reloadData()
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}
