//
//  FollowingVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 28/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class FollowingVC: UIViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBcollectionViewFollowing: UICollectionView!
    private var arrBrands = [[String:AnyObject]]()
    
    //
    //MARK:- VC Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        addTestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//
//MARK:- UICollectionViewDelegate Methods
//
extension FollowingVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Not Header Cell
        if indexPath.row > 0{
          
        }
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if let _ = lastEvaluatedKey{
//            return CGSizeMake(collectionView.frame.width, fFooterHeight)
//        }else{
//            return CGSizeZero
//        }
//        
//    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionFooter:
            let footerView:ProductFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: REUSABLE_ID_ProductFooterView, forIndexPath: indexPath) as! ProductFooterView
            
            return footerView
            
        default:
            assert(false, "No such element")
            return UICollectionReusableView()
        }
    }
}

//
//MARK:- UICollectionViewDataSource Methods
//
extension FollowingVC:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return arrBrands.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        return getProductCell(forIndexPath: indexPath)
    }
    
    func getProductCell(forIndexPath indexPath:NSIndexPath)->ProductCell{
        let productCell = IBcollectionViewFollowing.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_ProductCell, forIndexPath: indexPath) as! ProductCell
        
        return productCell
    }
}


//
//MARK:- UICollectionViewDelegateFlowLayout Methods
//
extension FollowingVC:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.frame.size.width/2)-6, 260)
    }
}


//
//MARK:- IBAction Methods
//
extension FollowingVC{
    @IBAction func IBActionBack(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}


//
//MARK:- Custom Methods
//
extension FollowingVC{
    private func addTestData(){
        for i in 0...30{
            arrBrands.append(["ok":i])
        }
        IBcollectionViewFollowing.reloadData()
    }
    
    private func setupOnLoad(){
        IBcollectionViewFollowing.registerNib(UINib(nibName: REUSABLE_ID_ProductCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductCell)
    }
}