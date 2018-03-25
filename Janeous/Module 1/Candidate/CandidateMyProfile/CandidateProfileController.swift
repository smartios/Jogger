//
//  CandidateProfileController.swift
//  Janeous
//
//  Created by SS21 on 13/02/18.
//

import UIKit

class CandidateProfileController: MyBaseViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var nib = UINib()
    var sectionArray = NSMutableArray()
    let headerArr = ["My Profile","Work Experience", "Education Experience","Top Skils","Certificates","Languages","Personal Information","Preferences"]
    var arrayData = ["Software Engineer","Developer","Software Engineer","Developer","Software Engineer","Senior Developer"]
    
    var showMoreIndexPath = IndexPath()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.backgroundColor = defaultWhiteButtonBackgroundColor()
        
        tableView.register(UINib(nibName: "TagCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TagCollectionViewTableViewCell")
        
        tableView.register(UINib(nibName: "CandidateProfileViewCell", bundle: nil), forCellReuseIdentifier: "ProfileImage")
        
        tableView.register(UINib(nibName: "WorkExpProfileCell", bundle: nil), forCellReuseIdentifier: "WorkExpCell")
        
        tableView.register(UINib(nibName: "CertificateProfileCell", bundle: nil), forCellReuseIdentifier: "CertificateProfileCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setWhiteNavigationbarWithTitleImageAndSideMenu()
        self.tableView.reloadData()
    }
    
    //    MARK:- TableView delegate and datasource Methods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)![0] as! ProfileHeaderView
        
        headerView.frame  = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        
        headerView.headerLabel.text = Localization(headerArr[section])
        
        headerView.privacyButtonIsHidden(value: true)
        headerView.editButtonIsHidden(value: true)
        headerView.addMoreButtonIsHidden(value: true)
        
        headerView.addMoreButton.addTarget(self, action: #selector(addButtonClicked(sender:)), for: .touchUpInside)
        
       
        if section == 3
        {
            headerView.privacyButtonIsHidden(value: false)
            headerView.editButtonIsHidden(value: false)
            headerView.addMoreButtonIsHidden(value: false)
        }
        else
        {
            headerView.addMoreButtonIsHidden(value: false)
            
            if section == 0
            {
               headerView.addMoreButton.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
            }
            else
            {
                headerView.addMoreButton.setImage(#imageLiteral(resourceName: "add_icon"), for: .normal)
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else if section == 1 && userData.workExperienceArray.count > 0
        {
            return userData.workExperienceArray.count
        }
        else if section == 2
        {
            return 1
        }
        else if section == 3
        {
            return 1
        }
        else if section == 4
        {
            return userData.certificateArray.count
        }
        else if section == 5
        {
            return userData.languageArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 342
        }
        else if indexPath.section == 1
        {
            if showMoreIndexPath == indexPath
            {
                return UITableViewAutomaticDimension
            }
            else
            {
                return 170
            }
        }
        else{
            return UITableViewAutomaticDimension
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerArr.count - 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if  indexPath.section == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier:"ProfileImage")
            
            cell.backgroundColor = defaultWhiteButtonBackgroundColor()
            
            let profileImageView =  cell.viewWithTag(1) as! UIImageView
            let userNameLabel =  cell.viewWithTag(2) as! UILabel
            let designationLabel =  cell.viewWithTag(3) as! UILabel
            let countryLabel =  cell.viewWithTag(4) as! UILabel
            let completionLabel =  cell.viewWithTag(5) as! UILabel
            let completionPercentLabel =  cell.viewWithTag(6) as! UILabel
            let progressBar =  cell.viewWithTag(7) as! UIProgressView
            let fillMessageLabel =  cell.viewWithTag(8) as! UILabel
            let experienceLabel =  cell.viewWithTag(10) as! UILabel
             let editYearsOfExpButton =  cell.viewWithTag(11) as! UIButton
            
             let editButton =  cell.viewWithTag(666) as! UIButton
            
            
            editYearsOfExpButton.addTarget(self, action: #selector(editButtonClicked(sender:)), for: .touchUpInside)
             editButton.addTarget(self, action: #selector(editButtonClicked(sender:)), for: .touchUpInside)
            
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
            profileImageView.clipsToBounds = true
            
            if URL(string: userData.userImage) != nil
            {
                profileImageView.setImageWith(URL(string: userData.userImage)!, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
            }
            else
            {
                profileImageView.image = #imageLiteral(resourceName: "userPlaceHolder")
            }
            
            userNameLabel.textColor = defaultWhiteTextColor()
            userNameLabel.font = UIFont(name: defaultRegular, size: textFontSize18)
            userNameLabel.text = userData.name
            
            
            designationLabel.textColor = defaultWhiteTextColor()
            designationLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            
            countryLabel.textColor = defaultWhiteTextColor()
            countryLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            countryLabel.text = userData.country_of_residence_Dic.value(forKey: "name") as? String
            
            completionLabel.textColor = defaultDarkTextColor()
            completionLabel.font = UIFont(name: defaultMedium, size: textFontSize13)
            
            completionPercentLabel.textColor = defaultDarkTextColor()
            completionPercentLabel.font = UIFont(name: defaultMedium, size: textFontSize13)
            
            progressBar.progressTintColor = defaultGreenColor()
            progressBar.trackTintColor = defaultWhiteTextColor()
            
            fillMessageLabel.textColor = defaultLightTextColor()
            fillMessageLabel.font = UIFont(name: defaultMedium, size: textFontSize13)
            
            fillMessageLabel.text = Localization("Fill this section out as best you can so our algorithm can find you the best job in the market!")
            
            experienceLabel.textColor = defaultDarkTextColor()
            experienceLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            
            var expString = "0"
            
            if userData.experience != ""
            {
               expString = userData.experience
            }
            
            experienceLabel.text = "\(Localization("Total Years Of Professional Experience")): \(expString)"
        }
        else if indexPath.section == 1
        {
            
            cell = tableView.dequeueReusableCell(withIdentifier:"WorkExpCell")
            cell.backgroundColor = defaultWhiteButtonBackgroundColor()
            
            let jobTitleLabel =  cell.viewWithTag(1) as! UILabel
            let companyNameLabel  = cell.viewWithTag(2) as! UILabel
            let durationLabel = cell.viewWithTag(3) as! UILabel
            let expLevelButton = cell.viewWithTag(4) as! UIButton
            let industryLabel = cell.viewWithTag(5) as! UILabel
            let jobTagTitleLabel = cell.viewWithTag(6) as! UILabel
            let jobTagView = cell.viewWithTag(7)!
            let jobFunctionTitleLabel = cell.viewWithTag(8) as! UILabel
            let jobFucntionViewLabel = cell.viewWithTag(9)!
            let descriptionLabel = cell.viewWithTag(10) as! UILabel
            
            let showLessButton = cell.viewWithTag(11) as! UIButton
            let deleteButton = cell.viewWithTag(12) as! UIButton
            let editButton = cell.viewWithTag(13) as! UIButton
            
            showLessButton.addTarget(self, action: #selector(showMoreButtonClicked(sender:)), for: .touchUpInside)
            editButton.addTarget(self, action: #selector(editButtonClicked(sender:)), for: .touchUpInside)
            
            let workExp = userData.workExperienceArray[indexPath.row]
            
            showLessButton.setTitleColor(defaultGreenColor(), for: .normal)
            showLessButton.titleLabel?.font = UIFont(name: defaultMedium, size: textFontSize14)
            
            if showMoreIndexPath != indexPath
            {
                showLessButton.setTitle(Localization("View Details"), for: .normal)
                expLevelButton.isHidden = true
                industryLabel.isHidden = true
                jobTagTitleLabel.isHidden = true
                jobTagView.isHidden = true
                jobFunctionTitleLabel.isHidden = true
                jobFucntionViewLabel.isHidden = true
                descriptionLabel.isHidden = true
            }
            else
            {
                 showLessButton.setTitle(Localization("Show Less"), for: .normal)
                expLevelButton.isHidden = false
                industryLabel.isHidden = false
                jobTagTitleLabel.isHidden = false
                jobTagView.isHidden = false
                jobFunctionTitleLabel.isHidden = false
                jobFucntionViewLabel.isHidden = false
                descriptionLabel.isHidden = false
            }
            
            jobTitleLabel.font = UIFont(name: defaultRegular, size: textFontSize18)
            jobTitleLabel.textColor = defaultDarkTextColor()
            jobTitleLabel.text = workExp.jobtitle
            
            companyNameLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            companyNameLabel.textColor = defaultDarkTextColor()
            companyNameLabel.text = workExp.company_name
            
            durationLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            durationLabel.textColor = defaultLightTextColor()
            
            if userData.workExperienceArray[indexPath.row].is_currently_working == false
            {
                durationLabel.text = "\(workExp.joining_month.value(forKeyPath: "name")!) \(workExp.joining_year.value(forKeyPath: "name")!) - \(workExp.relieving_month.value(forKeyPath: "name")!) \(workExp.relieving_year.value(forKeyPath: "name")!)"
            }
            else
            {
                durationLabel.text = "\(workExp.joining_month.value(forKeyPath: "name")!) \(workExp.joining_year.value(forKeyPath: "name")!) - Currently working"
            }
            
            expLevelButton.layer.borderColor = defaultLightTextColor().cgColor
            expLevelButton.layer.borderWidth = 1.0
            expLevelButton.setTitleColor(defaultLightTextColor(), for: .normal)
            expLevelButton.setTitle(" \(workExp.experience_level_name!) ", for: .normal)
            
            industryLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            industryLabel.textColor = defaultDarkTextColor()
            industryLabel.text = workExp.industry.object(forKey: "name") as? String
            
            jobTagTitleLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            jobTagTitleLabel.textColor = defaultDarkTextColor()
            jobTagTitleLabel.text = Localization("JOB TAGS")
            
            jobFunctionTitleLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            jobFunctionTitleLabel.textColor = defaultDarkTextColor()
            jobFunctionTitleLabel.text = Localization("JOB FUNCTIONS")
            
            let tempCell:TagCollectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TagCollectionViewTableViewCell") as! TagCollectionViewTableViewCell
            tempCell.updateTagArry(tagArr: workExp.tags.mutableCopy() as! NSMutableArray)
            jobTagView.addSubview(tempCell.collectionView)
            
            for constraint in jobTagView.constraints
            {
                if constraint.identifier == "height"
                {
                    constraint.constant = tempCell.bgViewHeightConstraint.constant
                }
            }
            
            durationLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            durationLabel.textColor = defaultDarkTextColor()
            descriptionLabel.text = workExp.description
            
        }
        else if indexPath.section == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier:"WorkExpCell")
            
           
        }
        else if indexPath.section == 3
        {
            let tempCell:TagCollectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TagCollectionViewTableViewCell") as! TagCollectionViewTableViewCell
            
            tempCell.contentView.backgroundColor = defaultWhiteButtonBackgroundColor()
            tempCell.collectionView.backgroundColor = .white
            tempCell.updateTagArry(tagArr: userData.skillArray)
            
            cell = tempCell
        }
        else if indexPath.section == 4
        {
             cell = tableView.dequeueReusableCell(withIdentifier:"CertificateProfileCell")
            let certificateNameLabel = cell.viewWithTag(1) as! UILabel
            let authorityNameLabel = cell.viewWithTag(2) as! UILabel
            let durationLabel = cell.viewWithTag(3) as! UILabel
            
            let shareButton = cell.viewWithTag(4) as! UIButton
            let editButton = cell.viewWithTag(5) as! UIButton
            let deleteButton = cell.viewWithTag(6) as! UIButton
            
            
             cell.backgroundColor = defaultWhiteButtonBackgroundColor()
            
            editButton.addTarget(self, action: #selector(editButtonClicked(sender:)), for: .touchUpInside)
            
             let certificate = userData.certificateArray[indexPath.row]
            
            certificateNameLabel.font = UIFont(name: defaultRegular, size: textFontSize18)
            certificateNameLabel.textColor = defaultDarkTextColor()
            certificateNameLabel.text = certificate.name.value(forKey: "name") as? String
            
            authorityNameLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            authorityNameLabel.textColor = defaultDarkTextColor()
            authorityNameLabel.text = certificate.authority
            
            durationLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            durationLabel.textColor = defaultLightTextColor()
            
             durationLabel.text = "\(certificate.received_month.value(forKeyPath: "name")!) \(certificate.received_year.value(forKeyPath: "name")!) - \(certificate.till_month.value(forKeyPath: "name")!) \(certificate.till_year.value(forKeyPath: "name")!)"
            
            if certificate.share_status == "public"
            {
                shareButton.setImage(#imageLiteral(resourceName: "share_icon"), for: .normal)
            }
            else if certificate.share_status == "private"
            {
                shareButton.setImage(#imageLiteral(resourceName: "share_after"), for: .normal)
            }
            else
            {
                 shareButton.setImage(#imageLiteral(resourceName: "never_Share"), for: .normal)
            }
        }
        else if indexPath.section == 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier:"CertificateProfileCell")
            
            let languageNameLabel = cell.viewWithTag(1) as! UILabel
            let ILRLevelLabel = cell.viewWithTag(2) as! UILabel
            let descriptionLabel = cell.viewWithTag(3) as! UILabel
            
            let shareButton = cell.viewWithTag(4) as! UIButton
            let editButton = cell.viewWithTag(5) as! UIButton
            let deleteButton = cell.viewWithTag(6) as! UIButton
            
             cell.backgroundColor = defaultWhiteButtonBackgroundColor()
            
            editButton.addTarget(self, action: #selector(editButtonClicked(sender:)), for: .touchUpInside)
            
            let language = userData.languageArray[indexPath.row]
            
            languageNameLabel.font = UIFont(name: defaultRegular, size: textFontSize18)
            languageNameLabel.textColor = defaultDarkTextColor()
            languageNameLabel.text = language.name
            
            ILRLevelLabel.font = UIFont(name: defaultRegular, size: textFontSize15)
            ILRLevelLabel.textColor = defaultLightTextColor()
            ILRLevelLabel.text = language.ilr_level_description.value(forKey: "level") as? String
            
            descriptionLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
            descriptionLabel.textColor = defaultLightTextColor()
            descriptionLabel.text = language.ilr_level_description.value(forKey: "label") as? String
            
            if language.share_status == "public"
            {
                shareButton.setImage(#imageLiteral(resourceName: "share_icon"), for: .normal)
            }
            else if language.share_status == "private"
            {
                shareButton.setImage(#imageLiteral(resourceName: "share_after"), for: .normal)
            }
            else
            {
                shareButton.setImage(#imageLiteral(resourceName: "never_Share"), for: .normal)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:- Actions
    
    @IBAction func addButtonClicked(sender:UIButton)
    {
        let hitPoint: CGPoint = sender.convert(.zero, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.section == 1
        {
            let vc = AddWorkExperienceController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 2
        {
            let vc = AddEducationExpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 3
        {
            let vc = AddTopSkillsViewController()
            vc.dataArray = userData.skillArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 4
        {
            let vc = AddCertificateController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 5
        {
            let vc = LanguageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func editButtonClicked(sender:UIButton)
    {
        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.section == 0
        {
            if sender.tag == 11
            {
                let vc = AddYearOfExperienceController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
            let vc = AddGeneralInfoControllerViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.section == 1
        {
            let vc = AddWorkExperienceController()
            vc.from = "edit"
            
            let workExp = userData.workExperienceArray[indexPath.row]
            
            let tempDic = NSMutableDictionary()
            tempDic.setValue(workExp.id, forKey: "id")
            tempDic.setValue(workExp.jobtitle, forKey: "jobtitle")
            tempDic.setValue(["id" : workExp.experience_level , "name" : workExp.experience_level_name], forKey: "experience_level")
            tempDic.setValue(workExp.industry, forKey: "industry")
            tempDic.setValue(workExp.company_name, forKey: "company_name")
            tempDic.setValue(workExp.location, forKey: "location")
            tempDic.setValue(workExp.is_currently_working, forKey :"is_currently_working")
            tempDic.setValue(workExp.joining_month, forKey: "joining_month")
            tempDic.setValue(workExp.joining_year, forKey: "joining_year")
            tempDic.setValue(workExp.relieving_month, forKey: "relieving_month")
            tempDic.setValue(workExp.relieving_year, forKey: "relieving_year")
            tempDic.setValue(workExp.functions.value(forKey: "name"), forKey: "function")
            tempDic.setValue(workExp.description, forKey: "description")
            
            vc.jobTagArray = workExp.tags.mutableCopy() as! NSMutableArray
            vc.dataDic = tempDic
            vc.currentJobBool = workExp.is_currently_working
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 2
        {
            let vc = AddEducationExpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 3
        {
            let vc = AddTopSkillsViewController()
            vc.dataArray = userData.skillArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 4
        {
            let vc = AddCertificateController()
            vc.from = "edit"
            
            let certificate = userData.certificateArray[indexPath.row]
            
            let tempDic = NSMutableDictionary()
            tempDic.setValue(certificate.id, forKey: "id")
            tempDic.setValue(certificate.name.value(forKey: "name"), forKey: "name")
            tempDic.setValue(certificate.authority, forKey: "authority")
            tempDic.setValue(certificate.received_month, forKey: "received_month")
            tempDic.setValue(certificate.received_year, forKey: "received_year")
            tempDic.setValue(certificate.till_month, forKey: "till_month")
            tempDic.setValue(certificate.till_year, forKey: "till_year")
            
            vc.dataDic = tempDic
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 5
        {
            let vc = LanguageViewController()
            vc.from = "edit"
           
            let langauge = userData.languageArray[indexPath.row]
            
            let tempDic = NSMutableDictionary()
            tempDic.setValue(langauge.id, forKey: "id")
            tempDic.setValue(langauge.name, forKey: "name")
            tempDic.setValue("\(langauge.ilr_level_description.value(forKey: "id")!)", forKey: "ilr_level")
           
            vc.dataDic = tempDic
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func deleteButtonClicked(sender:UIButton)
    {
        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        if indexPath.section == 1
        {
            let vc = AddWorkExperienceController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func showMoreButtonClicked(sender:UIButton)
    {
        let hitPoint: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
        
        var indexPathArr:[IndexPath] = []
        if self.showMoreIndexPath == indexPath
        {
            self.showMoreIndexPath = IndexPath()
        }
        else
        {
            if self.showMoreIndexPath.count > 0
            {
                 indexPathArr.append(self.showMoreIndexPath)
            }
            self.showMoreIndexPath = indexPath
        }
        
        indexPathArr.append(indexPath)
        self.tableView.reloadRows(at: indexPathArr, with: .none)
    }
    
}

