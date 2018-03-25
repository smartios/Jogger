//
//  MyProfileCompanyController.swift
//  Janeous
//
//  Created by SS21 on 13/03/18.
//

import UIKit

class MyProfileCompanyController: MyBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var profileCell : UITableViewCell!
    @IBOutlet var contactCell : UITableViewCell!
     @IBOutlet var descriptionCell : UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Bundle.main.loadNibNamed("MyProfileCell", owner: self, options: nil)
        
         self.tableView.backgroundColor = defaultWhiteButtonBackgroundColor()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK:- Tableview Delegate and datasource methods
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.setWhiteNavigationbarWithSideMenuAndTitle(titleStrng: Localization("My Profile"))
        
        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "edit_green").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editButtonClicked(sender:)))
        self.navigationItem.rightBarButtonItem  = editButton
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        

        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell")
            if cell == nil
            {
                cell = profileCell
                profileCell = nil
            }

            let imageView = cell.viewWithTag(1) as! UIImageView
            let nameLabel = cell.viewWithTag(2) as! UILabel
            let companyNameLabel = cell.viewWithTag(3) as! UILabel
            let countryLabel = cell.viewWithTag(4) as! UILabel
            
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = imageView.frame.size.width/2
            
            nameLabel.textColor = defaultDarkTextColor()
            nameLabel.font = UIFont(name: defaultMedium, size: textFontSize16)

            companyNameLabel.textColor = defaultDarkTextColor()
            companyNameLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            
            countryLabel.textColor = defaultLightTextColor()
            countryLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            
            
        } else if indexPath.row == 1{

            cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailscell")
            if cell == nil
            {
                cell = contactCell
                contactCell = nil
            }
            let numberLabel = cell.viewWithTag(1) as! UILabel
            let emailLabel = cell.viewWithTag(2) as! UILabel
            
            numberLabel.textColor = defaultDarkTextColor()
            numberLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            
            emailLabel.textColor = defaultDarkTextColor()
            emailLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            
        }else if indexPath.row == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell")
            if cell == nil
            {
                cell = descriptionCell
                descriptionCell = nil
            }
            let descriptionLabel = cell.viewWithTag(1) as! UILabel
            
            descriptionLabel.textColor = defaultDarkTextColor()
            descriptionLabel.font = UIFont(name: defaultRegular, size: textFontSize15)

        }
        
         cell.contentView.backgroundColor = defaultWhiteButtonBackgroundColor()
        cell.selectionStyle = .none
        
        return cell
    }
    
    //MARK:- Actions
    @objc func editButtonClicked(sender:UIButton)
    {
        
    }
}
