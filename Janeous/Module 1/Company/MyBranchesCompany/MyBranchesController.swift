//
//  MyBranchesController.swift
//  Janeous
//
//  Created by SS21 on 13/03/18.
//

import UIKit

class MyBranchesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView : UITableView!
    @IBOutlet var branchDetailCell: UITableViewCell!
    @IBOutlet var headerCell: UITableViewCell!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    MARK:- tableView Delegate and dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        Bundle.main.loadNibNamed("MyBranchCell", owner: self, options: nil)
        
        var cell : UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        if cell == nil{
            cell = headerCell
            headerCell = nil
        }
        let headerLbl = cell.viewWithTag(20) as! UILabel
        let filterBtn = cell.viewWithTag(21) as! UIButton
          let exportBtn = cell.viewWithTag(22) as! UIButton
          let addMoreBtn = cell.viewWithTag(23) as! UIButton
        headerLbl.text = "My Branches(50)"
        headerLbl.font = UIFont(name: defaultRegular, size: textFontSize18)
        headerLbl.textColor = defaultDarkTextColor()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: cell.contentView.frame.size.height)
        cell.contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: cell.contentView.frame.size.height)
        headerView.addSubview(cell.contentView)
        
        return headerView
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Bundle.main.loadNibNamed("MyBranchCell", owner: self, options: nil)
        var cell : UITableViewCell!
        if indexPath.row == 0
        {
        cell = tableView.dequeueReusableCell(withIdentifier: "branchDetailCell")
        if cell == nil
        {
            cell = branchDetailCell
            branchDetailCell = nil
        }
         let contactLbl = cell.viewWithTag(1) as! UILabel
            let locationLbl = cell.viewWithTag(2) as! UILabel
            let emailLbl = cell.viewWithTag(3) as! UILabel
            let moreBtn = cell.viewWithTag(4) as! UIButton
            let view = cell.viewWithTag(5) as! UIView
           let companyName = cell.viewWithTag(6) as! UILabel
            let departmentLbl = cell.viewWithTag(7) as! UILabel
//            set font color and style and button action
            
            moreBtn.addTarget(self, action: #selector(moreBtnClick), for: UIControlEvents.touchUpInside)
            view.isHidden = true
            
            companyName.font = UIFont(name: defaultRegular, size: textFontSize18)
            companyName.textColor = defaultDarkTextColor()
            
            contactLbl.font = UIFont(name: defaultRegular, size: textFontSize15)
            contactLbl.textColor = defaultDarkTextColor()
            
            locationLbl.font = UIFont(name: defaultRegular, size: textFontSize15)
            locationLbl.textColor = defaultDarkTextColor()
            
            emailLbl.font = UIFont(name: defaultRegular, size: textFontSize15)
            emailLbl.textColor = defaultDarkTextColor()
        }
        return cell
    }

    @IBAction func moreBtnClick(_sender : UIButton)
    {
        let hitPoint: CGPoint = (_sender as AnyObject).convert((_sender as AnyObject).bounds.origin, to: self.tableView)
        let indexPath:IndexPath = (self.tableView?.indexPathForRow(at: hitPoint)!)!
         var cell : UITableViewCell!
      
        cell =  tableView.cellForRow(at: indexPath)
         let view = cell.viewWithTag(5) as! UIView
        
        if _sender.isSelected == true{
            _sender.isSelected = false
            view.isHidden = true
        }
        else{
            _sender.isSelected = true
            view.isHidden = false
        }
        
    }
}
