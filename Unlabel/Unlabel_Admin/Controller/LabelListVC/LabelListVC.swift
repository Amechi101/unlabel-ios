//
//  LabelListVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 11/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSS3
import AWSDynamoDB

class LabelListVC: UITableViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    var activityIndicator = UIActivityIndicatorView()
    var didSelectIndexPath = NSIndexPath()
    var shouldReloadData = true
    var arrLabelList = [Label]()
    var selectedBrand = Brand()
    

    var didClickEditAtIndexPath:NSIndexPath?
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        self.title = "\(selectedBrand.dynamoDB_Brand.BrandName) Labels"
    }
    
    override func viewWillAppear(animated: Bool) {
        if shouldReloadData{
            awsCallFetchLabels()
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
        if segue.identifier == S_ID_ADD_LABEL_VC{
            if let addLabelVC:AddLabelVC = segue.destinationViewController as? AddLabelVC{
                addLabelVC.delegate = self
                    if let brand:Brand = selectedBrand{
                        addLabelVC.selectedBrand = brand
                            if let editIndexPath = didClickEditAtIndexPath{
                                if let label:Label = arrLabelList[editIndexPath.row]{
                                addLabelVC.selectedLabel = label
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

extension LabelListVC{
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrLabelList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var labelCell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if labelCell == nil{
            labelCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        labelCell!.textLabel?.text = arrLabelList[indexPath.row].dynamoDB_Label.LabelName
        labelCell?.detailTextLabel?.numberOfLines = 0
        labelCell?.detailTextLabel?.text = "Price: \(arrLabelList[indexPath.row].dynamoDB_Label.LabelPrice),\n URL:\(arrLabelList[indexPath.row].dynamoDB_Label.LabelURL) \n isActive:\(arrLabelList[indexPath.row].dynamoDB_Label.isActive)"
        labelCell!.imageView?.contentMode = UIViewContentMode.ScaleToFill
        if let labelImage:UIImage = arrLabelList[indexPath.row].imgLabelImage{
            labelCell?.imageView?.image = labelImage
        }else{
            labelCell?.imageView?.image = nil
        }
        
        return labelCell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        didSelectIndexPath = indexPath
//        self.navigationController!.performSegueWithIdentifier(S_ID_LABEL_LIST_VC, sender: self)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            UnlabelHelper.showConfirmAlert(self, title: "Delete \(self.arrLabelList[indexPath.row].dynamoDB_Label.LabelName)", message: sARE_YOU_SURE, onCancel: { () -> () in
                
                }, onOk: { () -> () in
                    self.deleteLabelAtIndexPath(indexPath)
            })
        })
        delete.backgroundColor = UIColor.redColor()
        
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.editLabelAtIndexPath(indexPath)
        })
        edit.backgroundColor = UIColor.blueColor()

        
        return [delete,edit]
    }
    
    func deleteLabelAtIndexPath(indexPath:NSIndexPath){
        awsCallDeleteLabel(atIndexPath: indexPath)
    }
    
    func editLabelAtIndexPath(indexPath:NSIndexPath){
        didClickEditAtIndexPath = indexPath
        performSegueWithIdentifier(S_ID_ADD_LABEL_VC, sender: self)
    }
    
    
}


//
//MARK:- AddLabelVCDelegate Methods
//
extension LabelListVC:AddLabelVCDelegate{
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
extension LabelListVC{
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
extension LabelListVC{
    func awsCallFetchLabels(){
        showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        var scanExpression: AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "BrandName = :val"
        scanExpression.expressionAttributeValues = [":val": selectedBrand.dynamoDB_Brand.BrandName]
        
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
                                            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
                                        }
                                    })
                                }
                            })
                            self.arrLabelList.append(labelObj)
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
    
    
    func awsCallDeleteLabel(atIndexPath indexPath:NSIndexPath){
        self.showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        dynamoDBObjectMapper.remove(arrLabelList[indexPath.row].dynamoDB_Label).continueWithBlock { (task:AWSTask) -> AnyObject? in
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
                self.awsCallDeleteLabelImage(atIndexPath: indexPath)
                self.arrLabelList.removeAtIndex(indexPath.row)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            return nil
        }
    }

    func awsCallDeleteLabelImage(atIndexPath indexPath:NSIndexPath){
        
        AWSHelper.deleteImageWithCompletion(inBucketName: S3_BUCKET_NAME, imageName: arrLabelList[indexPath.row].dynamoDB_Label.LabelImageName, deletePathKey: "\(pathKeyLabels)") { (task) -> () in
            if (task.error != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.error.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.exception != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.exception.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.result != nil) {
                UnlabelHelper.showAlert(onVC: self, title: "Success", message: "Label Deleted Successfully", onOk: { () -> () in
//                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
        }
    }
}