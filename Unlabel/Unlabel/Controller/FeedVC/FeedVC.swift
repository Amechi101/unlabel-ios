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
        parseCallFetchBrands()
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
        feedVCCell.IBlblBrandName.text = arrBrandList[indexPath.row].sBrandName.uppercaseString
        feedVCCell.IBlblLocation.text = arrBrandList[indexPath.row].sLocation
        if let brandMainImage:UIImage = arrBrandList[indexPath.row].imgBrandImage{
            feedVCCell.IBimgBrandImage.image = brandMainImage
        }
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
        handleLeftMenuSelection(forIndexPath:indexPath)
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
        openFilterScreen()
    }
}


//
//MARK:- Parse Call Methods
//
extension FeedVC{
    func parseCallFetchBrands(){
        
        let query = PFQuery(className:PARSE_BRAND)
        query.findObjectsInBackgroundWithBlock {
            (brandObjects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                UnlabelHelper.showAlert(onVC: self, title: "Something Went Wrong!", message: error.debugDescription, onOk: { () -> () in
                })
            } else {
                print(brandObjects)
                if let brandData = brandObjects?.count where brandData > 0{
                    self.handleBrandObjs(brandObjects!)
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.arrBrandList = [Brand]()
                        self.IBcollectionViewFeed.reloadData()
                    })
                    UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                    })
                    print("no data found")
                }
            }
        }
    }
    
    func handleBrandObjs(brandObjects:[PFObject]){
        arrBrandList = [Brand]()
        for brandObj in brandObjects{
            let currentBrand = Brand()
            currentBrand.sObjectID      = brandObj.objectId!
            currentBrand.sBrandName     = brandObj[PRM_BRAND_NAME] as! String
            currentBrand.sDescription   = brandObj[PRM_DESCRIPTION] as! String
            currentBrand.sLocation      = brandObj[PRM_LOCATION] as! String
            
            let imageFile:PFFile = brandObj[PRM_MAIN_IMAGE] as! PFFile
            imageFile.getDataInBackgroundWithBlock({ (imageData:NSData?, error:NSError?) -> Void in
                if let error = error{
                    print("Try again")
                }else{
                    let image = UIImage(data: imageData!)
                    currentBrand.imgBrandImage = image!
                    self.IBcollectionViewFeed.reloadData()
                }
            })
            
            arrBrandList.append(currentBrand)
        }
        
        defer{
            self.IBcollectionViewFeed.reloadData()
        }
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
     Open Filter Screen as child view controller
     */
    func openFilterScreen(){
        addChildVC(forViewController: S_ID_FILTER_VC)
    }
    
    /**
     Open ChildViewController for given ViewController's Storyboard ID
     - parameter VCName: ViewController's Storyboard ID
     */
    func addChildVC(forViewController VCName:String){
        self.removeChildVCIfExists(VCName)
        
        if VCName == S_ID_LEFT_MENU_VC{
            addLeftMenuAsChildVC(viewControllerName: VCName)
        }else if VCName == S_ID_FILTER_VC{
            addFilterVCAsChildVC(viewControllerName: VCName)
        }
    }
    
    /**
     Adding Left Menu As Child VC
     */
    func addLeftMenuAsChildVC(viewControllerName VCName:String){
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
    
    /**
     Adding Filter VC As Child VC
     */
    func addFilterVCAsChildVC(viewControllerName VCName:String){
        let filterVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as! FilterVC
//        filterVC.delegate = self
        filterVC.view.frame.size = self.view.frame.size
        
        //Animate filterVC entry
        filterVC.view.frame.origin.x = self.view.frame.size.width
        filterVC.view.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            filterVC.view.alpha = 1
            filterVC.view.frame.origin.x = 0
        }
        
        self.navigationController!.addChildViewController(filterVC)
        filterVC.didMoveToParentViewController(self)
        
        self.navigationController!.view.addSubview(filterVC.view)
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

    func handleLeftMenuSelection(forIndexPath indexPath:NSIndexPath){
        print(indexPath.row)
    }
    
    func addTestData(){
        for (var i = 0 ; i < 40 ; i++){
            arrBrandList.append(Brand())
        }
    }
}

