//
//  LabelVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSS3
import AWSDynamoDB
import SafariServices

class LabelVC: UIViewController,UIViewControllerTransitioningDelegate {

    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBbtnTitle: UIButton!
    @IBOutlet weak var IBbtnFilter: UIBarButtonItem!
    @IBOutlet weak var IBcollectionViewLabel: UICollectionView!
    
    var activityIndicator:UIActivityIndicatorView?
    var arrLabelList = [Label]()
    var selectedBrand = Brand()
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        awsCallFetchLabels()
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
        //Not Header Cell
        if indexPath.row > 0{
            openSafariForIndexPath(indexPath)
        }
    }
}

//
//MARK:- UICollectionViewDataSource Methods
//
extension LabelVC:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrLabelList.count + 1           //+1 for header cell
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if indexPath.row == 0{
            return getLabelHeaderCell(forIndexPath: indexPath)
        }else{
            return getLabelCell(forIndexPath: indexPath)
        }
    }
    
    //Custom methods
    func getLabelHeaderCell(forIndexPath indexPath:NSIndexPath)->LabelHeaderCell{
        let labelHeaderCell = IBcollectionViewLabel.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_LabelHeaderCell, forIndexPath: indexPath) as! LabelHeaderCell
        
        if let brandImage:UIImage = selectedBrand.imgBrandImage{
            labelHeaderCell.IBimgHeaderImage.image = brandImage
        }else{
            labelHeaderCell.IBimgHeaderImage.image = UIImage(named: "splash")
        }
        
        if let brandDescription:String = selectedBrand.dynamoDB_Brand.Description{
            labelHeaderCell.IBlblLabelDescription.text = brandDescription
        }else{
            labelHeaderCell.IBlblLabelDescription.text = ""
        }
        
        if let brandLocation:String = selectedBrand.dynamoDB_Brand.Location{
            labelHeaderCell.IBlblLabelLocation.text = brandLocation
        }else{
            labelHeaderCell.IBlblLabelLocation.text = ""
        }
        
        return labelHeaderCell
    }
    
    func getLabelCell(forIndexPath indexPath:NSIndexPath)->LabelCell{
        let labelCell = IBcollectionViewLabel.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_LabelCell, forIndexPath: indexPath) as! LabelCell
        
        if let labelName:String = arrLabelList[indexPath.row-1].dynamoDB_Label.LabelName{
            labelCell.IBlblLabelName.text = labelName
        }else{
            labelCell.IBlblLabelName.text = "Label"
        }

        if let labelPrice:CGFloat = arrLabelList[indexPath.row-1].dynamoDB_Label.LabelPrice{
            labelCell.IBlblLabelPrice.text = "$\(labelPrice)"
        }else{
            labelCell.IBlblLabelName.text = ""
        }
        
        if let labelImage:UIImage = arrLabelList[indexPath.row-1].imgLabelImage{
            labelCell.IBimgLabelImage.image = labelImage
        }else{
            labelCell.IBimgLabelImage.image = UIImage(named: "splash")
        }
        
        return labelCell
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
//MARK:- SFSafariViewControllerDelegate Methods
//
extension LabelVC:SFSafariViewControllerDelegate{
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity]{
        return []
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController){
    
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
    
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
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        IBbtnFilter.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Neutraface2Text-Demi", size: 15)!],
            forState: UIControlState.Normal)
        
        if let brandName:String = selectedBrand.dynamoDB_Brand.BrandName{
            IBbtnTitle.setTitle(brandName.uppercaseString, forState: .Normal)
        }
        
        IBcollectionViewLabel.registerNib(UINib(nibName: REUSABLE_ID_LabelHeaderCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_LabelHeaderCell)
        IBcollectionViewLabel.registerNib(UINib(nibName: REUSABLE_ID_LabelCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_LabelCell)
        
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    func showLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator!.frame = self.view.frame
            self.activityIndicator!.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
            self.activityIndicator!.startAnimating()
            self.view.addSubview(self.activityIndicator!)
        }
    }
    
    func hideLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator!.stopAnimating()
            self.activityIndicator!.removeFromSuperview()
        }
    }
    
    func openSafariForIndexPath(indexPath:NSIndexPath){
        if let labelURLString:String = arrLabelList[indexPath.row-1].dynamoDB_Label.LabelURL{
            if let labelURL:NSURL = NSURL(string: labelURLString){
                let safariVC = UnlabelSafariVC(URL: labelURL)
                safariVC.delegate = self
                safariVC.transitioningDelegate = self
                self.presentViewController(safariVC, animated: true) { () -> Void in
                    
                }
            }else{ showAlertWebPageNotAvailable() }
        }else{ showAlertWebPageNotAvailable() }
    }
    
    func showAlertWebPageNotAvailable(){
        UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
            
        }
    }

}


//
//MARK:- AWS Call Methods
//
extension LabelVC{
    func awsCallFetchLabels(){
        showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        var scanExpression: AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "BrandName = :brandNameKey AND isActive = :isActiveKey"
        scanExpression.expressionAttributeValues = [":brandNameKey": selectedBrand.dynamoDB_Brand.BrandName,":isActiveKey":true]
        
        dynamoDBObjectMapper.scan(DynamoDB_Label.self, expression: scanExpression).continueWithSuccessBlock { (task:AWSTask) -> AnyObject? in
            
            //If error
            if let error = task.error{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.localizedDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If exception
            if let exception = task.exception{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: exception.debugDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If got result
            if let result = task.result{
                //If result items count > 0
                if let arrItems:[DynamoDB_Label] = result.items as? [DynamoDB_Label] where arrItems.count>0{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.arrLabelList = [Label]()
                        for (index, label) in arrItems.enumerate() {
                            var labelObj = Label()
                            labelObj.dynamoDB_Label = label
                            
                            AWSHelper.downloadImageWithCompletion(forImageName: label.LabelImageName, uploadPathKey: pathKeyLabels, completionHandler: { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
                                if let downloadedData = data{
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        if let image = UIImage(data: downloadedData){
                                            labelObj.imgLabelImage = image
                                            self.IBcollectionViewLabel.reloadItemsAtIndexPaths([NSIndexPath(forRow: index+1, inSection: 0)])
                                        }
                                    })
                                }
                            })
                            self.arrLabelList.append(labelObj)
                        }
                        defer{
                            self.hideLoading()
                            self.IBcollectionViewLabel.reloadData()
                        }
                    })
                }else{
                    self.hideLoading()
                    UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                    })
                }
            }else{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                })
            }
            
            
            return nil
        }
    }
}
