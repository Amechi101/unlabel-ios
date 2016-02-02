//
//  LabelVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class LabelVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBbtnTitle: UIButton!
    @IBOutlet weak var IBbtnFilter: UIBarButtonItem!
    @IBOutlet weak var IBcollectionViewLabel: UICollectionView!
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


//
//MARK:- UICollectionViewDelegate Methods
//
extension LabelVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

//
//MARK:- UICollectionViewDataSource Methods
//
extension LabelVC:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 10//arrBrandList.count
    }
    
    func getLabelHeaderCell(forIndexPath indexPath:NSIndexPath)->LabelHeaderCell{
        let labelHeaderCell = IBcollectionViewLabel.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_LabelHeaderCell, forIndexPath: indexPath) as! LabelHeaderCell
        return labelHeaderCell
    }
    
    func getLabelCell(forIndexPath indexPath:NSIndexPath)->LabelCell{
        let labelCell = IBcollectionViewLabel.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_LabelCell, forIndexPath: indexPath) as! LabelCell
        return labelCell
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if indexPath.row == 0{
            return getLabelHeaderCell(forIndexPath: indexPath)
        }else{
            return getLabelCell(forIndexPath: indexPath)
        }
    }
}


//
//MARK:- UICollectionViewDelegateFlowLayout Methods
//
extension LabelVC:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSizeMake(collectionView.frame.size.width, 360)
        }else{
            return CGSizeMake((collectionView.frame.size.width/2)-6, 260)
        }
    }
}


//
//MARK:- IBAction Methods
//
extension LabelVC{
    @IBAction func IBActionBack(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func IBActionFilter(sender: UIBarButtonItem) {
//        openFilterScreen()
    }
}


//
//MARK:- Custom Methods
//
extension LabelVC{
    func setupUIOnLoad(){
        IBbtnFilter.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Neutraface2Text-Demi", size: 15)!],
            forState: UIControlState.Normal)
        IBcollectionViewLabel.registerNib(UINib(nibName: REUSABLE_ID_LabelHeaderCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_LabelHeaderCell)
        IBcollectionViewLabel.registerNib(UINib(nibName: REUSABLE_ID_LabelCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_LabelCell)
        
        self.automaticallyAdjustsScrollViewInsets = false

    }
}
