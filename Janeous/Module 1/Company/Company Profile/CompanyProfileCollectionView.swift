//
//  CompanyProfileCollectionView.swift
//  Janeous
//
//  Created by singsys on 23/03/18.
//

import Foundation

extension CompanyProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewHeaderArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        
        titleLabel.backgroundColor = defaultLightTextColor()
         titleLabel.font = UIFont(name: defaultMedium, size: textFontSize14)
        
        titleLabel.text = Localization(collectionViewHeaderArr[indexPath.row] as! String)
        
        if selectedIndex == indexPath.row
        {
            titleLabel.textColor = defaultWhiteTextColor()
           
        }
        else
        {
            titleLabel.textColor = defaultUnselectedColor()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width/3, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
        self.setScrollViewContent()
    }
}
