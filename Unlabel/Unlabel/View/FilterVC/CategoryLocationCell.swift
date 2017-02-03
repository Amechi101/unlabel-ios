//
//  CategoryLocationCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func didSelectLocation(_ location:String?)
}

enum CategoryLocationCellType{
    case unknown
    case category
    case location
}

enum TableViewType:Int{
    case unknown = 0
    case category = 1
    case location = 2
}

class CategoryLocationCell: UITableViewCell {
    
    @IBOutlet weak var IBcollectionView: UICollectionView!
    @IBOutlet weak var IBconstraintCollectionViewHeight: NSLayoutConstraint!
    
    var cellType = CategoryLocationCellType.unknown
    var shouldClearCategories = false

    fileprivate let arrCategories:[String] = ["All categories","Clothing","Accessories","Jewelry","Shoes","Bags"]
    var arrLocations:[Location] = []
    
    var selectedLocationIndex:IndexPath?
    var locationChoices:LocationChoices = LocationChoices.International
    
    var delegate:CategoryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        IBcollectionView.register(UINib(nibName: REUSABLE_ID_TitleBoxCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_TitleBoxCell)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
   
   
}

//MARK:- UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource methods
extension CategoryLocationCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let titleBoxCell = IBcollectionView.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_TitleBoxCell, for: indexPath) as? TitleBoxCell
        titleBoxCell?.IBlblBoxTitle.text = arrLocations[indexPath.row].stateOrCountry
      
        if indexPath == selectedLocationIndex{
            titleBoxCell?.IBlblBoxTitle.textColor = MEDIUM_GRAY_TEXT_COLOR
            titleBoxCell?.layer.borderColor = DARK_GRAY_COLOR.withAlphaComponent(0.8).cgColor
        }else{
            titleBoxCell?.IBlblBoxTitle.textColor = LIGHT_GRAY_TEXT_COLOR
            titleBoxCell?.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.withAlphaComponent(0.5).cgColor
        }
     
        return titleBoxCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (IBcollectionView.frame.size.width/2)-4, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            self.IBcollectionView.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
    }
}
