//
//  TagCollectionViewTableViewCell.swift
//  Janeous
//
//  Created by singsys on 09/03/18.
//

import UIKit

class TagCollectionViewTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView : UICollectionView!
    
    var dataArray = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = getCollectionViewFlowLayout()
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
       let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell

        tempCell.titleLabel.text = "\(dataArray.object(at: indexPath.row))"
        tempCell.deleteTagButton.addTarget(self, action: #selector(deleteTagPressed(_sender:)), for: .touchUpInside)
        
        tempCell.deleteTagButton.tag = indexPath.row
        
        return tempCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(widthForView(text: "\(dataArray.object(at: indexPath.row))", font: UIFont(name: defaultRegular, size: textFontSize14)!, height: 18).width  + 58 < collectionView.frame.size.width)
        {
            return CGSize(width: widthForView(text: "\(dataArray.object(at: indexPath.row))", font: UIFont(name: defaultRegular, size: textFontSize14)!, height: 18).width + 58, height: 25)
        }
        else
        {
            return CGSize(width: collectionView.frame.size.width - 10, height: heightForView(text: "\(dataArray.object(at: indexPath.row))", font: UIFont(name: defaultRegular, size: textFontSize14)!, width: collectionView.frame.size.width - 58 - 16 - 38).height + 16)
        }
        
        
    }
    
    //MARK:- Actions
    @objc func deleteTagPressed(_sender:UIButton)
    {
        dataArray.removeObject(at: _sender.tag)
        collectionView.reloadData()
    }
    
    func addTag(tag:String)
    {
        self.dataArray.add(tag)
        collectionView.reloadData()
    }
}
