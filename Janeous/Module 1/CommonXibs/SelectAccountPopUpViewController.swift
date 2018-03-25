//
//  SelectAccountPopUpViewController.swift
//  Janeous
//
//  Created by singsys on 23/02/18.
//

import UIKit

protocol selectAccountDelegate
{
    func accountTypeValue(value:String)
}
class SelectAccountPopUpViewController: UIViewController {

    @IBOutlet var closeButton:UIButton!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var accountTypeLabel:UILabel!
    @IBOutlet var candidateButton:UIButton!
    @IBOutlet var companyButton:UIButton!
    @IBOutlet var nextButton:UIButton!
    var selectAccountDelegate:selectAccountDelegate!
    var accountType:String = "candidate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configView()
        self.companyButtonClicked()
        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configView()
    {
        titleLabel.text = Localization("Select your account type")
        titleLabel.font = UIFont(name: defaultLight, size: headingFontSize25)
        titleLabel.textColor = defaultDarkTextColor()
        
        accountTypeLabel.text = Localization("ACCOUNT TYPE")
        accountTypeLabel.font = UIFont(name: defaultRegular, size: textFontSize14)
        accountTypeLabel.textColor = defaultLightTextColor()
        
        candidateButton.setTitle(Localization("CANDIDATE"), for: .normal)
        candidateButton.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
        candidateButton.setTitleColor(defaultLightTextColor(), for: .normal)
        candidateButton.setImage(#imageLiteral(resourceName: "candidate_unselected"), for: .normal)
        candidateButton.setTitleColor(defaultWhiteTextColor(), for: .selected)
        candidateButton.setImage(#imageLiteral(resourceName: "candidate_selected"), for: .selected)
        
        companyButton.setTitle(Localization("COMPANY"), for: .normal)
        companyButton.titleLabel?.font = UIFont(name: defaultMedium, size: buttonFontSize16)!
        companyButton.setTitleColor(defaultLightTextColor(), for: .normal)
        companyButton.setImage(#imageLiteral(resourceName: "company_unselected"), for: .normal)
        companyButton.setTitleColor(defaultWhiteTextColor(), for: .selected)
        companyButton.setImage(#imageLiteral(resourceName: "company_selected"), for: .selected)
        
        nextButton.setTitle(Localization("NEXT"), for: .normal)

    }
    
    @IBAction func crossButtonClicked()
    {
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func candidateButtonClicked()
    {
        accountType = "candidate"
        candidateButton.isSelected = true
        companyButton.isSelected = false
        candidateButton.backgroundColor = defaultLightTextColor()
        companyButton.backgroundColor = defaultWhiteButtonBackgroundColor()
    }
    
    @IBAction func companyButtonClicked()
    {
        accountType = "company"
        candidateButton.isSelected = false
        companyButton.isSelected = true
        candidateButton.backgroundColor = defaultWhiteButtonBackgroundColor()
        companyButton.backgroundColor = defaultLightTextColor()
    }
    
    @IBAction func nextButtonClicked()
    {
        self.dismiss(animated: true)
        {
            self.selectAccountDelegate.accountTypeValue(value: self.accountType)
        }
    }
    

}
