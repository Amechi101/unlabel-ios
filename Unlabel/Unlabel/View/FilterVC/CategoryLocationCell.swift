//
//  CategoryLocationCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func didSelectRow(withSelectedCategories dictCategories:[Int:Bool]) //arrCategories is key index
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
    let arrLocations:[String] = ["fsdsdff","fsdsdff","fsdsdff","fsdsdff","fsdsdff","fsdsdff","fsdsdff","fsdsdff","fsdsdff","fsdsdff"]
    var dictSelectedCategories = [Int:Bool]()
    private var dictSelectedLocations = [Int:Bool]()
    var delegate:CategoryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        IBcollectionView.registerNib(UINib(nibName: REUSABLE_ID_TitleBoxCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_TitleBoxCell)
        for (index,_) in arrCategories.enumerate(){
            dictSelectedCategories[index] = false
        }
        
        for (index,_) in arrLocations.enumerate(){
            dictSelectedLocations[index] = false
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CategoryLocationCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLocations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let titleBoxCell = IBcollectionView.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_TitleBoxCell, forIndexPath: indexPath) as? TitleBoxCell
        titleBoxCell?.IBlblBoxTitle.text = arrLocations[indexPath.row]
        return titleBoxCell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((IBcollectionView.frame.size.width/2)-4, 32)
    }
    
}