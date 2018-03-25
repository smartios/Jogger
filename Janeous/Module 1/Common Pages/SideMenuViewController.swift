//
//  SideMenuViewController.swift
//  Janeous
//
//  Created by SL-167 on 2/6/18.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let logOutNameArr = ["", "Sign In","Create Account","Home","About","Contact Us","Terms & Conditions","Privacy Policy"]
    let logOutImageArr = ["", "menu_SignIn","menu_createAccount","home","menu_about","menu_contactus","menu_Terms","menu_Privacy"]
    let loggedInCandidateArr = ["","Dashboard","Conferences", "Jobs", "My Interviews", "My Applications", "Support", "Logout"]
    let loggedInCandidateImageArr = ["","home", "Conference","jobs","MyInterview","myApplication","Support",""]
    let loggedInClientArr = ["","Dashboard","Conferences", "Manage Jobs", "Manage Interviews", "My Company", "My Profile","Manage Tokens", "Reports", "Logout"]
    let loggedInClientImageArr = ["","Dashboard","Conferences", "Manage Jobs", "Manage Interviews", "My Company", "My Profile","Manage Tokens", "Reports", "Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.backgroundColor = defaultDarkTextColor()
        // Do any additional setup after loading the view.
        
       NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: Notification.Name("menuAltered"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sideMenu(_sender: UIButton)
    {
        appDel.mainContainer.toggleLeftSideMenuCompletion(nil)
    }
    
    @objc func reload()
    {
        self.tableView.reloadData()
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(userData.userID != "")
        {
            if userData.type == "candidate"
            {
                return loggedInCandidateArr.count
            }
            else
            {
                return loggedInClientArr.count
            }
        }
        else
        {
            return logOutNameArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 0)
        {
            if userData.userID == ""
            {
                return 80
            }
            return 190
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        
        if(indexPath.row == 0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            let imageView = cell.viewWithTag(1) as! UIImageView
            let titleLabel = cell.viewWithTag(2) as! UILabel
            let viewProfileButton = cell.viewWithTag(3) as! UIButton
            let notificationButton = cell.viewWithTag(4) as! UIButton
            let chatButton = cell.viewWithTag(5) as! UIButton
            // let crossButton = cell.viewWithTag(6) as! UIButton
            
            viewProfileButton.setTitleColor(defaultGreenColor(), for: .normal)
            viewProfileButton.titleLabel?.font = UIFont(name: defaultRegular, size: buttonFontSize14)
            
            imageView.layer.cornerRadius = imageView.frame.size.width/2
            imageView.clipsToBounds = true
            
            titleLabel.font = UIFont(name: defaultRegular, size: textFontSize21)
            titleLabel.textColor = defaultWhiteTextColor()
            
            if userData.userID != ""
            {
                if URL(string: userData.userImage) != nil
                {
                    imageView.setImageWith(URL(string: userData.userImage)!, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
                }
                else
                {
                    imageView.image = #imageLiteral(resourceName: "userPlaceHolder")
                }
                
                titleLabel.text = userData.name
                imageView.isHidden = false
                notificationButton.isHidden = false
                chatButton.isHidden = false
            }
            else
            {
                imageView.isHidden = true
                notificationButton.isHidden = true
                chatButton.isHidden = true
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            let label = cell.viewWithTag(2) as! UILabel
            let imageViewLine = cell.viewWithTag(3) as! UIImageView
            
            label.font = UIFont(name: defaultRegular, size: textFieldFontSize18)
            label.textColor = defaultWhiteTextColor()
            label.textAlignment = .left
            imageViewLine.backgroundColor = defaultLineColor()
            
            if(userData.userID != "" && indexPath.row  != 0)
            {
                
                var tempArr = [String]()
                var tempImageArr = [String]()
                
                if(userData.type == "candidate")
                {
                    tempArr = loggedInCandidateArr
                    tempImageArr = loggedInCandidateImageArr
                }
                else
                {
                    tempArr = loggedInClientArr
                    tempImageArr = loggedInClientImageArr
                }
                
                label.text = Localization(tempArr[indexPath.row])
                imageView.image = UIImage(named: tempImageArr[indexPath.row])
                
                if(indexPath.row == tempArr.count-1)
                {
                    label.textAlignment = .center
                    label.textColor = defaultLightTextColor()
                    imageView.isHidden = true
                }
                else
                {
                    imageView.isHidden = false
                }
            }
            else
            {
                label.text = Localization(logOutNameArr[indexPath.row])
                imageView.image = UIImage(named: logOutImageArr[indexPath.row])
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        appDel.mainContainer.toggleLeftSideMenuCompletion(nil)
        
        if userData.userID != ""
        {
            if userData.type == "candidate"
            {
                if(indexPath.row == loggedInCandidateArr.count - 1)
                {
                    appDel.logout()
                }
            }
            else
            {
                if(indexPath.row == loggedInClientArr.count - 1)
                {
                    appDel.logout()
                }
            }
            
            return
        }
        else
        {
            var nextViewController = UIViewController()
            let navigation = UINavigationController()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            if(indexPath.row == 0)
            {
                return
            }
            else if(indexPath.row == 1)
            {
                nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            }
            else if (indexPath.row == 2)
            {
                nextViewController = CreateAccountControllerView(nibName: "CreateAccountControllerView", bundle: nil)
            }
            else if (indexPath.row == 3)
            {
                nextViewController = storyBoard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
            }
            else
            {
                return
            }
            
            navigation.viewControllers = [nextViewController]
            let leftVC = storyBoard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            appDel.mainContainer = MFSideMenuContainerViewController.container(withCenter: navigation, leftMenuViewController: leftVC, rightMenuViewController: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.viewControllers = [appDel.mainContainer]
            }
            
        }
        
        
        
    }
    
    //MARK:- Actions
    @IBAction func viewProfileButtonClicked(sender:UIButton)
    {
        appDel.mainContainer.toggleLeftSideMenuCompletion(nil)
        
        var nextViewController = UIViewController()
        let navigation = UINavigationController()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        nextViewController = CandidateProfileController()
        navigation.viewControllers = [nextViewController]
        let leftVC = storyBoard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        appDel.mainContainer = MFSideMenuContainerViewController.container(withCenter: navigation, leftMenuViewController: leftVC, rightMenuViewController: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.viewControllers = [appDel.mainContainer]
    }
    }

}
