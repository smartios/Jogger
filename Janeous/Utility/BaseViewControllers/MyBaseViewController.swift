//
//  MyBaseViewController.swift
//  Janeous
//
//  Created by singsys on 10/03/18.
//

import UIKit

class MyBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK:- NAVIGATION BAR
    //MARK:-
    
    //MARK:- White Navigation bar
    func setWhiteNavigationBarWithSideMenu()
    {
        self.title = ""
        self.initialiseWhiteNavigationBar()
        
        //Adding Side menu
        let sideMenuBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openSideMenu))
        self.navigationItem.leftBarButtonItem  = sideMenuBtn
    }
    
    func setWhiteNavigationbarWithTitleImageAndSideMenu()
    {
        self.title = ""
        self.initialiseWhiteNavigationBar()
        
        //Adding Side menu
        let sideMenuBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openSideMenu))
        self.navigationItem.leftBarButtonItem  = sideMenuBtn
        
        //adding title image
        self.navigationItem.titleView = UIImageView.init(image: #imageLiteral(resourceName: "headerLogo"))
        
    }
    
    func setWhiteNavigationbarWithBackButtonAndTitle(titleStrng:String)
    {
        self.title = titleStrng
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: defaultMedium, size: textFontSize15)!]
        
        self.initialiseWhiteNavigationBar()

        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationItem.leftBarButtonItem  = backButton
    }
    
    //MARK:- Gray Navigation Bar
    func setGrayNavigationbarWithTitle(AttributedString:NSMutableAttributedString)
    {
        
        self.title = ""
        self.initialiseGrayNavigationBar()
        
        let container = UIView()
        let titleLabel = UILabel()
        let crossButton = UIButton()
        container.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 84)
        container.clipsToBounds = false
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: defaultLight, size: textFontSize21)
        titleLabel.textColor = defaultWhiteTextColor()
        titleLabel.attributedText = AttributedString
        titleLabel.textAlignment = .left
        
        if widthForView(text: AttributedString.string, font: UIFont(name: defaultLight, size: textFontSize21)!, height: 0).width > self.view.frame.size.width - 57
        {
            titleLabel.font = UIFont(name: defaultLight, size: textFontSize18)
            titleLabel.frame = CGRect(x: 17, y: -12, width: self.view.frame.size.width - 40, height: 74)
        }
        else
        {
            titleLabel.frame = CGRect(x: 17, y: 5, width: self.view.frame.size.width - 40, height: 54)
        }
        
        crossButton.frame = CGRect(x: self.view.frame.size.width - 57, y: 10, width:40, height: 40)
        
        crossButton.setImage(#imageLiteral(resourceName: "cross_white"), for: .normal)
        crossButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        container.addSubview(titleLabel)
        container.addSubview(crossButton)
        self.navigationItem.titleView = container
        self.navigationItem.titleView?.clipsToBounds = false
        
        
        self.view.backgroundColor = defaultLightTextColor()
    }
    
    
    //MARK:- Navigation Bar initialization
    func initialiseWhiteNavigationBar()
    {
        self.clearStattusBarColor()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false;
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func initialiseGrayNavigationBar()
    {
        self.setStatusBarWhite()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = defaultLightTextColor()
        self.navigationController?.navigationBar.tintColor = defaultLightTextColor()
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK:- Status Bar
    func clearStattusBarColor()
    {
        //clearing status bar color
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = .clear
        }
    }
    
    func setStatusBarWhite()
    {
        //clearing status bar color
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = .white
        }
    }
    
    //MARK:- Button Actions
    @objc func openSideMenu()
    {
        appDel.mainContainer.toggleLeftSideMenuCompletion(nil)
    }
    
    @objc func backButtonClicked()
    {
        if self.isBeingPresented
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
