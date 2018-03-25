//
//  AddPreferenceControllerViewController.swift
//  Janeous
//
//  Created by SS21 on 07/03/18.
//

import UIKit

class AddPreferenceControllerViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //    MARK:-  IBOutlets initilaiztion
    
    @IBOutlet var preferenceTitleCell:UITableViewCell!
    @IBOutlet var assessmentBtnCell:UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK:- Table view delegate and dataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        Bundle.main.loadNibNamed("AddPreferenceCell", owner: self, options: nil)
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "preferenceTitleCell")
            if cell == nil
            {
                cell = preferenceTitleCell
                preferenceTitleCell = nil
            }
            
            let titleLbl =  cell.viewWithTag(1) as! UILabel
            titleLbl.text = Localization("Preference Assessment")
            titleLbl.font = UIFont(name: defaultRegular, size: textFontSize21)
            titleLbl.textColor = defaultDarkTextColor()
            
            let detailLbl = cell.viewWithTag(2) as!UILabel
            detailLbl.text = Localization("This preference assessment will assess your personal preferences,that is, how you like to work.\n\nIt is not concerenced with your typical resume skills,but how you see yourself relating to others,what type of enviornment you prefer to work,how you approch problems, and how you think you deal with feelings and emotions. With this type of assessment ,there is no right or wrong answers.")
            detailLbl.font = UIFont(name: defaultRegular, size: textFontSize15)
            detailLbl.textColor = defaultDarkTextColor()
            
            let imageView = cell.viewWithTag(3) as! UIImageView
            imageView.image = UIImage(named: "preference Assessmet")!
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "assessmentBtnCell")
            if cell == nil
            {
                cell = assessmentBtnCell
                assessmentBtnCell = nil
            }
            let submitBtn = cell.viewWithTag(4) as! UIButton
            submitBtn.setTitle(Localization("START ASSESSMENT"),for: .normal)
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
