//
//  FilterVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

//
//MARK:- FilterVC Protocols
//
protocol FilterVCDelegate{

}


class FilterVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBtblFilter: UITableView!
    
    private let sAllCategories = "All categories"
    private let sAllStyles     = "All styles"

    let arrFilterTitles:[String] = ["SEX","CATEGORY","STYLE","LOCATION"]

    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- UITableViewDelegate Methods
//
extension FilterVC:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        delegate?.didSelectRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        close()
    }
}

//
//MARK:- UITableViewDataSource Methods
//
extension FilterVC:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 8
    }
    
    func cellWithTitle(title title:String)->UITableViewCell{
        let cellWithTitle = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cellWithTitle.textLabel?.text = title
        cellWithTitle.layoutMargins = UIEdgeInsetsZero
        cellWithTitle.separatorInset = UIEdgeInsetsMake(0, 0, 0, 2)
        cellWithTitle.textLabel?.textColor = UnlabelHelper.getGrayTextColor()
        cellWithTitle.textLabel?.font = UnlabelHelper.getNeutraface2Text(style: FONT_STYLE_BOLD, size: 16)
        
        return cellWithTitle
    }
    
    func genderCell()->GenderCell{
        let genderCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_GenderCell) as! GenderCell
        return genderCell
    }

    func categoryStyleCell(title title:String)->CategoryStyleCell{
        let categoryStyleCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_CategoryStyleCell) as! CategoryStyleCell
        return categoryStyleCell
    }

    func locationCell()->LocationCell{
        let locationCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_LocationCell) as! LocationCell
        
        return locationCell
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 {
            return cellWithTitle(title: arrFilterTitles[indexPath.row/2])
        }else if indexPath.row == 1{
            return genderCell()
        }else if indexPath.row == 3{
            return categoryStyleCell(title: sAllCategories)
        }else if indexPath.row == 5{
            return categoryStyleCell(title: sAllStyles)
        }else if indexPath.row == 7{
            return locationCell()
        }else{
            return UITableViewCell()
        }
        
       
    }
}

//
//MARK:- IBAction Methods
//
extension FilterVC{
    @IBAction func IBActionClose(sender: AnyObject) {
        close()
    }
}



//
//MARK:- Custom Methods
//
extension FilterVC{
    /**
     Setup UI on VC Load.
     */
    func setupUIOnLoad(){
        registerCell(withID: REUSABLE_ID_GenderCell)
        registerCell(withID: REUSABLE_ID_CategoryStyleCell)
        registerCell(withID: REUSABLE_ID_LocationCell)

        IBtblFilter.estimatedRowHeight = 200
        IBtblFilter.rowHeight = UITableViewAutomaticDimension
        IBtblFilter.tableFooterView = UIView()
    }
    
    /**
     Register nib for given ID.
     */
    func registerCell(withID reusableID:String){
        IBtblFilter.registerNib(UINib(nibName: reusableID, bundle: nil), forCellReuseIdentifier: reusableID)
    }
    
    /**
     Remove self from parentViewController
     */
    func close(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 0
            self.view.frame.origin.x = SCREEN_WIDTH
            }) { (value:Bool) -> Void in
                self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    
}



