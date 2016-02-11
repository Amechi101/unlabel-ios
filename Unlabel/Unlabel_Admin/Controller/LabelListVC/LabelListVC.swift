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
    
    var arrLabelList = [Label]()
    var selectedBrand = Brand()
    var activityIndicator = UIActivityIndicatorView()
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        self.title = "\(selectedBrand.dynamoDB_Brand.BrandName) Labels"
        awsCallFetchLabels()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        }
        
        return labelCell!
    }

    //
    //MARK:- IBAction Methods
    //
    

    //
    //MARK:- Navigation Methods
    //
//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == S_ID_ADDLABEL_VC{
            if let addLabelVC:AddLabelVC = segue.destinationViewController as? AddLabelVC{
                    if let brand:Brand = selectedBrand{
                        addLabelVC.selectedBrand = brand
                    }
                }
            }
        }
}


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
        dynamoDBObjectMapper.scan(DynamoDB_Label.self, expression: nil).continueWithSuccessBlock { (task:AWSTask) -> AnyObject? in
            
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
                        for label in arrItems{
                            var labelObj = Label()
                            labelObj.dynamoDB_Label = label
                            
                            AWSHelper.downloadImageWithCompletion(forImageName: label.LabelImageName, uploadPathKey: pathKeyLabels, completionHandler: { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
                                if let downloadedData = data{
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        if let image = UIImage(data: downloadedData){
                                            labelObj.imgLabelImage = image
                                            self.tableView.reloadData()
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
}