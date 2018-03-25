//
//  FilterMyUserController.swift
//  Janeous
//
//  Created by SS21 on 18/02/18.
//

import UIKit

class FilterMyUserController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var tableView : UITableView!
      var nib = UINib()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
      
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK:- Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell :UITableViewCell!
        if indexPath.row == 3
        {
            nib = UINib(nibName: "ButtonCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "buttonCell")
        }
        else
        {
            nib = UINib(nibName : "TitleWIthButtonCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "TitleWIthButtonCell")
        }
        if indexPath.row == 0
        {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "TitleWIthButtonCell")
            
            let titleTxt = cell.viewWithTag(1) as! UILabel
            titleTxt.text = "USER TYPE"
        }
        if indexPath.row == 1
        {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "TitleWIthButtonCell")
            
            let titleTxt = cell.viewWithTag(1) as! UILabel
            titleTxt.text = "STATUS"
        }
        else if indexPath.row == 2
        {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "TitleWIthButtonCell")
            let titleTxt = cell.viewWithTag(1) as! UILabel
            titleTxt.text = "BRANCH"
        }
        else{
           cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
        }
      
        
        
        return cell
        
    }
    
}
