//
//  ViewController.swift
//  Unlabel
//
//  Created by Amechi Egbe on 12/11/15.
//  Copyright © 2015 Unlabel. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBbarBtnHamburger: UIBarButtonItem!
    @IBOutlet weak var IBbarBtnFilter: UIBarButtonItem!
    @IBOutlet weak var IBbtnUnlabel: UIButton!
    @IBOutlet weak var IBcollectionViewFeed: UICollectionView!
    
    private let FEED_CELL_HEIGHT:CGFloat = 211
    var arrBrandList:[Brand] = [Brand]()

    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        addTestData()
        setupUIOnLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//
//MARK:- UICollectionViewDelegate Methods
//
extension FeedVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

//
//MARK:- UICollectionViewDataSource Methods
//
extension FeedVC:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrBrandList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let feedVCCell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_FeedVCCell, forIndexPath: indexPath) as! FeedVCCell
        
        return feedVCCell
    }
}


//
//MARK:- UICollectionViewDelegateFlowLayout Methods
//
extension FeedVC:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, FEED_CELL_HEIGHT)
    }
}


//
//MARK:- LeftMenuVCDelegate Methods
//
extension FeedVC:LeftMenuVCDelegate{
    func didSelectRowAtIndexPath(indexPath: NSIndexPath) {
        print(indexPath.row)
    }
}


//
//MARK:- IBAction Methods
//
extension FeedVC{
    @IBAction func IBActionHamburger(sender: UIButton) {
        openLeftMenu()
    }
    
    @IBAction func IBActionFilter(sender: UIBarButtonItem) {
     
    }
}

    
//
//MARK:- Custom Methods
//
extension FeedVC{
    /**
     Setup UI on VC Load.
     */
    func setupUIOnLoad(){
        IBbarBtnFilter.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Neutraface2Text-Demi", size: 15)!],
                forState: UIControlState.Normal)
        IBcollectionViewFeed.registerNib(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    /**
     Open Left Menu as child view controller
     */
    func openLeftMenu(){
        addChildVC(forViewController: S_ID_LEFT_MENU_VC)
    }
    
    /**
     Open ChildViewController for given ViewController's Storyboard ID
     - parameter VCName: ViewController's Storyboard ID
     */
    func addChildVC(forViewController VCName:String){
        self.removeChildVCIfExists(VCName)
        
        if VCName == S_ID_LEFT_MENU_VC{
                let leftMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as! LeftMenuVC
                leftMenuVC.delegate = self
                leftMenuVC.view.frame.size = self.view.frame.size
            
                //Animate leftViewController entry
                leftMenuVC.view.frame.origin.x = -self.view.frame.size.width
                leftMenuVC.view.alpha = 0
                UIView.animateWithDuration(0.3) { () -> Void in
                    leftMenuVC.view.alpha = 1
                    leftMenuVC.view.frame.origin.x = 0
                }
                
                self.navigationController!.addChildViewController(leftMenuVC)
                leftMenuVC.didMoveToParentViewController(self)
                
                self.navigationController!.view.addSubview(leftMenuVC.view)
            }
    }
    
    /**
     Removes ChildViewController for given ViewController's Storyboard ID
     if already it exists, this happens when user click action to open
     ChildVC more than once.
     - parameter VCName: ViewController's Storyboard ID
     */
    func removeChildVCIfExists(VCName:String){
        for vc in self.childViewControllers{
            let childVC:UIViewController = vc
            let childVCFromStoryboard:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(VCName)
            
            if childVC.nibName == childVCFromStoryboard.nibName{ //This condition prevents user to open any child VC twice at a time
                childVC.willMoveToParentViewController(nil)
                childVC.view.removeFromSuperview()
                childVC.removeFromParentViewController()
            }
        }
    }

    func addTestData(){
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
        arrBrandList.append(Brand())
    }
}

