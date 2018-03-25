//
//  CountryListingController.swift
//  Janeous
//
//  Created by SS21 on 12/02/18.
//

import UIKit

protocol selectCountryDelegate
{
    func countryValue(from:String, withDic:NSDictionary)
}
class CountryListingController: MyBaseViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    //    Mark:- IBOutlets declartion
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var countryListing:UITableViewCell!
    @IBOutlet var searchBar:UISearchBar!
    
    var selectCountryDelegate:selectCountryDelegate!
    var dataArray = NSMutableArray()
    var searchCode = NSMutableArray()
    var searchActive = false
    var page:Int = 1
    var from:String!
    var multipleSelect = false
    
    //    MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        
        if(from == "country" || from == "country_of_residence")
        {
            self.dataArray = (appDel.generalFunction.getValuesInTable(countries_Table, forKeys: generalTableKey) as NSArray).mutableCopy() as! NSMutableArray
        }
        else if from == "nationality"
        {
            self.dataArray = (appDel.generalFunction.getValuesInTable(nationalities_Table, forKeys: generalTableKey) as NSArray).mutableCopy() as! NSMutableArray
        }
        else if(from == "mobile_code")
        {
            self.dataArray = (appDel.generalFunction.getValuesInTable(country_phone_codes_Table, forKeys: country_phone_codes_Table_Key)! as NSArray).mutableCopy() as! NSMutableArray
        }
        else if from == "experience_level"
        {
            self.dataArray = (appDel.generalFunction.getValuesInTable(experience_level_Table, forKeys: generalTableKey)! as NSArray).mutableCopy() as! NSMutableArray
        }
        else if from == "industry"
        {
            self.dataArray = (appDel.generalFunction.getValuesInTable(industries_Table, forKeys: generalTableKey)! as NSArray).mutableCopy() as! NSMutableArray
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var titleString = "Select Country"
        
        if(from == "country" || from == "nationality" || from == "country_of_residence")
        {
            titleString = "Select Nationality"
        }
        else if(from == "mobile_code")
        {
            titleString = "Select Mobile Code"
        }
        else if from == "experience_level"
        {
            titleString = "Select Experience Level"
        }
        else if from == "industry"
        {
            titleString = "Select Industry"
        }
        
        self.setWhiteNavigationbarWithBackButtonAndTitle(titleStrng: titleString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK:- table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == false
        {
            return self.dataArray.count
        }
        else
        {
            return self.searchCode.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        Bundle.main.loadNibNamed("CountryListingCell", owner: self, options: nil)
        cell = tableView.dequeueReusableCell(withIdentifier:"countryListing")
        
        if cell == nil
        {
            cell = countryListing
            countryListing = nil
        }
        let selectBtn = cell.viewWithTag(1) as! UIButton
        let lblTxt = cell.viewWithTag(2) as! UILabel
        
        lblTxt.font = UIFont(name: defaultLight, size: textFontSize18)
        lblTxt.textColor = defaultDarkTextColor()
        
        if multipleSelect
        {
           selectBtn.isHidden = false
        }
        else
        {
            selectBtn.isHidden = true
        }
        
        selectBtn.setImage(#imageLiteral(resourceName: "bullet"), for: .normal)
        
        if searchActive == false
        {
            if self.dataArray.count > 0 && (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") != nil {
                lblTxt.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
                if(from == "mobile_code")
                {
                    lblTxt.text = "(\((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name")!)) \((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "country_name")!)"
                }
                else
                {
                    lblTxt.text = "\((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name")!)"
                }
            }
        }
        else
        {
            if self.searchCode.count > 0 && (searchCode.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") != nil {
        
                if(from == "mobile_code")
                {
                    lblTxt.text = "(\((searchCode.object(at: indexPath.row) as! NSDictionary).object(forKey: "name")!)) \((searchCode.object(at: indexPath.row) as! NSDictionary).object(forKey: "country_name")!)"
                }
                else
                {
                    lblTxt.text = "\((searchCode.object(at: indexPath.row) as! NSDictionary).object(forKey: "name")!)"
                }
            }
        }
        
        
        if(self.multipleSelect == true && tableView.indexPathsForSelectedRows != nil && tableView.indexPathsForSelectedRows!.contains(indexPath))
        {
            lblTxt.textColor = defaultGreenColor()
            selectBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((from == "country" || from == "nationality" || from == "country_of_residence") && multipleSelect == true)
        {
            self.tableView.reloadData()
        }
        else
        {
            if searchActive == false
            {
                self.selectCountryDelegate.countryValue(from: from, withDic: dataArray.object(at: indexPath.row) as! NSDictionary)
            }
            else
            {
                self.selectCountryDelegate.countryValue(from: from, withDic: searchCode.object(at: indexPath.row) as! NSDictionary)
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        self.tableView.reloadData()
    }
    //    MARK:- Buttons action
    @IBAction func backButtonClicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectBtnClick(_ sender: UIButton)
        
    {
        //        if type == "check"{
        //            sender.setImage(UIImage(named: "bullet"), for: UIControlState.normal)
        //            type = "uncheck"
        //        }
        //        else
        //        {
        //            sender.setImage(UIImage(named: "check"), for: UIControlState.normal)
        //            type = "check"
        //        }
    }
    
    //MARK:- Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchCode.removeAllObjects()
        
        var searchPredicate:NSPredicate!
        
        if(from == "mobile_code")
        {
            searchPredicate = NSPredicate(format: "name contains[cd] %@ OR country_name contains[cd] %@",searchText,searchText)
        }
        else
        {
            searchPredicate = NSPredicate(format: "name contains[cd] %@",searchText)
        }
        
        let tempSearchCategory : NSArray = self.dataArray.filtered(using: searchPredicate) as NSArray
        searchCode.addObjects(from: tempSearchCategory as [AnyObject])
        if(searchCode.count == 0){
            if(searchText.isEmpty){
                searchActive = false;
            }
            else
            {
                searchActive = true;
            }
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    // MARK: - searchBarTextDidBeginEditing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.showsCancelButton = true
    }
    // MARK: - searchBarTextDidEndEditing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = true;
        searchBar.showsCancelButton = false
    }
    // MARK: - searchBarCancelButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false;
    }
    // MARK: - searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
}
