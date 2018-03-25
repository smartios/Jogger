//
//  ViewUserCompanyProfile.swift
//  Janeous
//
//  Created by SS21 on 12/03/18.
//

import UIKit

class ViewUserCompanyProfile: MyBaseViewController, UITableViewDelegate, UITableViewDataSource {
    //    MARK:- IBOutlets
    @IBOutlet var profileCell : UITableViewCell!
    @IBOutlet var descriptionCell : UITableViewCell!
    @IBOutlet var contactDetailscell : UITableViewCell!
    @IBOutlet var headerCell : UITableViewCell!
    @IBOutlet var associatedConferenceCell : UITableViewCell!
    @IBOutlet var tableView : UITableView!
    
    
//    MARK:- Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.backgroundColor = defaultWhiteButtonBackgroundColor()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       self.setWhiteNavigationbarWithSideMenuAndTitle(titleStrng: Localization("User Profile"))
     
        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "edit_green").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editButtonClicked(sender:)))
        self.navigationItem.rightBarButtonItem  = editButton
    }
    
    
    //MARK:- Tableview delegates and datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 3
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1
        {
            return 45
        }else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)![0] as! ProfileHeaderView
        
        headerView.frame  = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        
        headerView.headerLabel.text = Localization("Associated Conferences")
        
        headerView.privacyButtonIsHidden(value: true)
        headerView.editButtonIsHidden(value: true)
        headerView.addMoreButtonIsHidden(value: false)
        
        headerView.addMoreButton.setImage(#imageLiteral(resourceName: "export_icon"), for: .normal)
       // headerView.addMoreButton.addTarget(self, action: #selector(editButtonClicked(sender:)), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        Bundle.main.loadNibNamed("ViewUserProfileCell", owner: self, options: nil)
        
        var cell : UITableViewCell!
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell")
                if cell == nil
                {
                    cell =  profileCell
                    profileCell = nil
                }
                
                let imageView = cell.viewWithTag(1) as! UIImageView
                let nameLabel = cell.viewWithTag(2) as! UILabel
                let statusLabel = cell.viewWithTag(3) as! UILabel
                let companyIdLabel = cell.viewWithTag(4) as! UILabel
                let userTypeLabel = cell.viewWithTag(5) as! UILabel
                let branchLabel = cell.viewWithTag(6) as! UILabel
                let companyLabel = cell.viewWithTag(7) as! UILabel
                
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = imageView.frame.size.width/2
                
                nameLabel.textColor = defaultDarkTextColor()
                nameLabel.font = UIFont(name: defaultMedium, size: textFontSize16)
                
                statusLabel.textColor = defaultErrorColor()
                statusLabel.font = UIFont(name: defaultRegular, size: textFontSize13)
                
                companyIdLabel.textColor = defaultLightTextColor()
                companyIdLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
                
                userTypeLabel.textColor = defaultDarkTextColor()
                userTypeLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
                
                userTypeLabel.layer.borderColor = defaultLightTextColor().cgColor
                userTypeLabel.layer.borderWidth = 1.0
                
                branchLabel.textColor = defaultDarkTextColor()
                branchLabel.font = UIFont(name: defaultMedium, size: textFontSize15)
                
                companyLabel.textColor = defaultDarkTextColor()
                companyLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
                
            }else if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailscell")
                if cell == nil
                {
                    cell =  contactDetailscell
                    contactDetailscell = nil
                }
                
                let numberLabel = cell.viewWithTag(1) as! UILabel
                let emailLabel = cell.viewWithTag(2) as! UILabel
                let locationLabel = cell.viewWithTag(3) as! UILabel
                
                numberLabel.textColor = defaultDarkTextColor()
                numberLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
                
                emailLabel.textColor = defaultDarkTextColor()
                emailLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
                
                locationLabel.textColor = defaultDarkTextColor()
                locationLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
                
            }else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell")
                if cell == nil
                {
                    cell =  descriptionCell
                    descriptionCell = nil
                }
                
                let descriptionLabel = cell.viewWithTag(1) as! UILabel
                
                descriptionLabel.textColor = defaultDarkTextColor()
                descriptionLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            }
            
        }
        else if indexPath.section == 1
        {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "associatedConferenceCell")
            if cell == nil
            {
                cell =  associatedConferenceCell
                associatedConferenceCell = nil
            }
            
        }
        
        cell.contentView.backgroundColor = defaultWhiteButtonBackgroundColor()
        return cell
    }
    
    //MARK:- Actions
    @objc func editButtonClicked(sender:UIButton)
    {
        
    }
    
}
