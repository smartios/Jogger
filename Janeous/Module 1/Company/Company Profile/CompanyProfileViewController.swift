//
//  CompanyProfileViewController.swift
//  Janeous
//
//  Created by singsys on 26/02/18.
//

import UIKit

class CompanyProfileViewController: MyBaseViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate
{
    
    @IBOutlet var profileCell: UITableViewCell!
     @IBOutlet var headerCell: UITableViewCell!
     @IBOutlet var optionCell: UITableViewCell!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    
    var selectedIndex = 0
    let collectionViewHeaderArr:NSArray = ["Company Profile", "My Branches","My Users"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        collectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCollectionViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    self.setWhiteNavigationbarWithSideMenuAndTitle(titleStrng: Localization("My Company"))
        
    self.view.backgroundColor = defaultWhiteButtonBackgroundColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3, height: self.scrollView.frame.size.height)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        Bundle.main.loadNibNamed("CompanyProfileCells", owner: self, options: nil)

        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
            
            if cell == nil
            {
                cell = profileCell
                profileCell = nil
            }
            
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            if cell == nil
            {
                cell = headerCell
                headerCell = nil
            }
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
            if cell == nil
            {
                cell = optionCell
                optionCell = nil
            }
        }
        else if indexPath.row == 3
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
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
            if cell == nil
            {
                cell = optionCell
                optionCell = nil
            }
        }
        
        return cell
    }
    
    //MARK:- ScrollView
    func setScrollViewContent()
    {
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width * CGFloat(selectedIndex), y: 0), animated: true)
    }
}
