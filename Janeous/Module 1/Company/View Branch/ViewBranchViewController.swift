//
//  ViewBranchViewController.swift
//  Janeous
//
//  Created by singsys on 05/03/18.
//

import UIKit

class ViewBranchViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet var profileCell: UITableViewCell!
    @IBOutlet var headerCell: UITableViewCell!
    @IBOutlet var optionCell: UITableViewCell!
    @IBOutlet var userProfileCell: UITableViewCell!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.frame  = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70)
        headerView.backgroundColor = .gray
        let titleLabel = UILabel()
        titleLabel .frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: 40)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        Bundle.main.loadNibNamed("ViewBranchCells", owner: self, options: nil)
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
            
            if cell == nil
            {
                cell = profileCell
                profileCell = nil
            }
            
        }
        else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
            if cell == nil
            {
                cell = optionCell
                optionCell = nil
            }
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            if cell == nil
            {
                cell = headerCell
                headerCell = nil
            }
        }
        else if indexPath.row == 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell")
            if cell == nil
            {
                cell = userProfileCell
                userProfileCell = nil
            }
        }
        else if indexPath.row == 6
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            if cell == nil
            {
                cell = headerCell
                headerCell = nil
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell")
            if cell == nil
            {
                cell = userProfileCell
                userProfileCell = nil
            }
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
