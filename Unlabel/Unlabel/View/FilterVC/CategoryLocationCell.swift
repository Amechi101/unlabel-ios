//
//  CategoryLocationCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func didSelectLocation(location:String?)
}

enum CategoryLocationCellType{
    case Unknown
    case Category
    case Location
}

enum TableViewType:Int{
    case Unknown = 0
    case Category = 1
    case Location = 2
}

class CategoryLocationCell: UITableViewCell {
    
    @IBOutlet weak var IBcollectionView: UICollectionView!
    @IBOutlet weak var IBconstraintCollectionViewHeight: NSLayoutConstraint!
    
    var cellType = CategoryLocationCellType.Unknown
    var shouldClearCategories = false

    private let arrCategories:[String] = ["All categories","Clothing","Accessories","Jewelry","Shoes","Bags"]
    var arrLocations:[Location] = []
    
    var selectedLocationIndex:NSIndexPath?
    var locationChoices:LocationChoices = LocationChoices.International
    
    var delegate:CategoryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        IBcollectionView.registerNib(UINib(nibName: REUSABLE_ID_TitleBoxCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_TitleBoxCell)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
   
   
}

//MARK:- UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource methods
extension CategoryLocationCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLocations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let titleBoxCell = IBcollectionView.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_TitleBoxCell, forIndexPath: indexPath) as? TitleBoxCell
        titleBoxCell?.IBlblBoxTitle.text = arrLocations[indexPath.row].stateOrCountry
      
        if indexPath == selectedLocationIndex{
            titleBoxCell?.IBlblBoxTitle.textColor = MEDIUM_GRAY_TEXT_COLOR
            titleBoxCell?.layer.borderColor = DARK_GRAY_COLOR.colorWithAlphaComponent(0.8).CGColor
        }else{
            titleBoxCell?.IBlblBoxTitle.textColor = LIGHT_GRAY_TEXT_COLOR
            titleBoxCell?.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.colorWithAlphaComponent(0.5).CGColor
        }
     
        return titleBoxCell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((IBcollectionView.frame.size.width/2)-4, 32)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath == selectedLocationIndex{
            selectedLocationIndex = nil
            delegate?.didSelectLocation(nil)
        }else{
            selectedLocationIndex = indexPath
            delegate?.didSelectLocation(arrLocations[indexPath.row].stateOrCountry)
        }
        
        reloadData()
    }
    
}


//MARK:- Custom methods
extension CategoryLocationCell{
    func reloadData(){
        IBcollectionView.performBatchUpdates({
            self.IBcollectionView.reloadSections(NSIndexSet(index: 0))
            }, completion: nil)
    }
}