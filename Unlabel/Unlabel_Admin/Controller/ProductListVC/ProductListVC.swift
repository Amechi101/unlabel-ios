//
//  ProductListVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 11/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSS3
import AWSDynamoDB

class ProductListVC: UITableViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    var activityIndicator = UIActivityIndicatorView()
    var didSelectIndexPath = NSIndexPath()
    var shouldReloadData = true
    var arrProductList = [Product]()
    var selectedBrand = Brand()
    

    var didClickEditAtIndexPath:NSIndexPath?
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        self.title = "\(selectedBrand.dynamoDB_Brand.BrandName) Products"
    }
    
    override func viewWillAppear(animated: Bool) {
        if shouldReloadData{
            awsCallFetchProducts()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        shouldReloadData = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

    

    //
    //MARK:- Navigation Methods
    //
//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == S_ID_ADD_PRODUCT_VC{
            if let addProductVC:AddProductVC = segue.destinationViewController as? AddProductVC{
                addProductVC.delegate = self
                    if let brand:Brand = selectedBrand{
                        addProductVC.selectedBrand = brand
                            if let editIndexPath = didClickEditAtIndexPath{
                                if let product:Product = arrProductList[editIndexPath.row]{
                                addProductVC.selectedProduct = product
                                didClickEditAtIndexPath = nil
                            }
                        }
                    }
                }
            }
        }
    }



//
//MARK:- UITableViewDataSource,UITableViewDelegate Methods
//

extension ProductListVC{
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrProductList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var productCell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if productCell == nil{
            productCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        productCell!.textLabel?.text = arrProductList[indexPath.row].dynamoDB_Product.ProductName
        productCell?.detailTextLabel?.numberOfLines = 0
        productCell?.detailTextLabel?.text = "Price: \(arrProductList[indexPath.row].dynamoDB_Product.ProductPrice),\n URL:\(arrProductList[indexPath.row].dynamoDB_Product.ProductURL) \n isActive:\(arrProductList[indexPath.row].dynamoDB_Product.isActive)"
        productCell!.imageView?.contentMode = UIViewContentMode.ScaleToFill
        if let productImage:UIImage = arrProductList[indexPath.row].imgProductImage{
            productCell?.imageView?.image = productImage
        }else{
            productCell?.imageView?.image = nil
        }
        
        return productCell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        didSelectIndexPath = indexPath
//        self.navigationController!.performSegueWithIdentifier(S_ID_PRODUCT_LIST_VC, sender: self)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            UnlabelHelper.showConfirmAlert(self, title: "Delete \(self.arrProductList[indexPath.row].dynamoDB_Product.ProductName)", message: sARE_YOU_SURE, onCancel: { () -> () in
                
                }, onOk: { () -> () in
                    self.deleteProductAtIndexPath(indexPath)
            })
        })
        delete.backgroundColor = UIColor.redColor()
        
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.editProductAtIndexPath(indexPath)
        })
        edit.backgroundColor = UIColor.blueColor()

        
        return [delete,edit]
    }
    
    func deleteProductAtIndexPath(indexPath:NSIndexPath){
        awsCallDeleteProduct(atIndexPath: indexPath)
    }
    
    func editProductAtIndexPath(indexPath:NSIndexPath){
        didClickEditAtIndexPath = indexPath
        performSegueWithIdentifier(S_ID_ADD_PRODUCT_VC, sender: self)
    }
    
    
}


//
//MARK:- AddProductVCDelegate Methods
//
extension ProductListVC:AddProductVCDelegate{
    func shouldReloadData(shouldReload: Bool) {
        shouldReloadData = shouldReload
    }
}


//
//MARK:- IBAction Methods
//



//
//MARK:- Custom Methods
//
extension ProductListVC{
    func showLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator.frame = self.view.frame
            self.activityIndicator.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
            self.activityIndicator.startAnimating()
            self.view.addSubview(self.activityIndicator)
        }
    }
    
    func hideLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}

//
//MARK:- AWS Call Methods
//
extension ProductListVC{
    func awsCallFetchProducts(){
        showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        var scanExpression: AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "BrandName = :val"
        scanExpression.expressionAttributeValues = [":val": selectedBrand.dynamoDB_Brand.BrandName]
        
        dynamoDBObjectMapper.scan(DynamoDB_Product.self, expression: scanExpression).continueWithSuccessBlock { (task:AWSTask) -> AnyObject? in
            
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
                if let arrItems:[DynamoDB_Product] = result.items as? [DynamoDB_Product] where arrItems.count>0{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.arrProductList = [Product]()
                        for (index, product) in arrItems.enumerate() {
                            var productObj = Product()
                            productObj.dynamoDB_Product = product
                            
                            AWSHelper.downloadImageWithCompletion(forImageName: product.ProductImageName, uploadPathKey: pathKeyProducts, completionHandler: { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
                                if let downloadedData = data{
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        if let image = UIImage(data: downloadedData){
                                            productObj.imgProductImage = image
                                            if let _ = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)){
                                                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
                                            }

                                            
                                        }
                                    })
                                }
                            })
                            self.arrProductList.append(productObj)
                        }
                        defer{
                            self.hideLoading()
                            self.tableView.reloadData()
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
    
    
    func awsCallDeleteProduct(atIndexPath indexPath:NSIndexPath){
        self.showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        dynamoDBObjectMapper.remove(arrProductList[indexPath.row].dynamoDB_Product).continueWithBlock { (task:AWSTask) -> AnyObject? in
            self.hideLoading()
            if (task.error != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.error.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.exception != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.exception.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.result != nil) {
                self.awsCallDeleteProductImage(atIndexPath: indexPath)
                self.arrProductList.removeAtIndex(indexPath.row)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            return nil
        }
    }

    func awsCallDeleteProductImage(atIndexPath indexPath:NSIndexPath){
        
        AWSHelper.deleteImageWithCompletion(inBucketName: S3_BUCKET_NAME, imageName: arrProductList[indexPath.row].dynamoDB_Product.ProductImageName, deletePathKey: "\(pathKeyProducts)") { (task) -> () in
            if (task.error != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.error.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.exception != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.exception.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.result != nil) {
                UnlabelHelper.showAlert(onVC: self, title: "Success", message: "Product Deleted Successfully", onOk: { () -> () in
//                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
        }
    }
}