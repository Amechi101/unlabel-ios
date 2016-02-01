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
   func willCloseChildVC(childVCName:String)
}


//
//MARK:- FilterVC Enums
//
enum PickerType : Int {
    case Unknown = 0
    case Categories = 1
    case Styles = 2
}

class FilterVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBtblFilter: UITableView!
    @IBOutlet weak var IBpickerView: UIPickerView!
    
    @IBOutlet weak var IBviewPickerMainContainer: UIView!
    @IBOutlet weak var IBviewPickerContainer: UIView!
    
    @IBOutlet weak var IBconstraintPickerMainTop: NSLayoutConstraint!
    @IBOutlet weak var IBconstraintPickerMainBottom: NSLayoutConstraint!
    
    private var sAllCategories = "All categories"
    private var sAllStyles     = "All styles"

    private let arrFilterTitles:[String] = ["SEX","CATEGORY","STYLE","LOCATION"]
    private let arrCategories:[String] = ["Category1","Category2","Category3","Category4","Category5","Category6","Category7","Category8","Category9","Category10"]
    private let arrStyle:[String] = ["Style1","Style2","Style3","Style4","Style5","Style6","Style7","Style8","Style9","Style10"]
    
    private var arrPickerTitle = [String]()
    
    var delegate:FilterVCDelegate?
    var selectedPickerType:PickerType = .Unknown
    
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
        cellWithTitle.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
        cellWithTitle.textLabel?.font = UnlabelHelper.getNeutraface2Text(style: FONT_STYLE_BOLD, size: 16)
        
        return cellWithTitle
    }

    
    func genderCell()->GenderCell{
        let genderCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_GenderCell) as! GenderCell
        return genderCell
    }

    
    func categoryStyleCell(title title:String,tag:Int)->CategoryStyleCell{
        let categoryStyleCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_CategoryStyleCell) as! CategoryStyleCell
        categoryStyleCell.IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.CGColor
        categoryStyleCell.IBbtnCategoryStyle.tag = tag
        categoryStyleCell.IBbtnCategoryStyle.setTitle(title, forState: UIControlState.Normal)
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
            return categoryStyleCell(title: sAllCategories, tag:PickerType.Categories.rawValue)
        }else if indexPath.row == 5{
            return categoryStyleCell(title: sAllStyles, tag:PickerType.Styles.rawValue)
        }else if indexPath.row == 7{
            return locationCell()
        }else{
            return UITableViewCell()
        }
        
       
    }
}

//
//MARK:- UIPickerViewDataSource,UIPickerViewDelegate Methods
//
extension FilterVC:UIPickerViewDataSource,UIPickerViewDelegate{
    
    //UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
       return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
       return arrPickerTitle.count
    }
    
    //UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return "\(arrPickerTitle[row])"
    }

}

extension FilterVC{
    
//
//MARK:- FilterVC IBAction Methods
//
    @IBAction func IBActionClose(sender: AnyObject) {
        close()
    }
    
    @IBAction func IBActionPickerCancel(sender: UIButton) {
        hidePicker()
    }
    
    @IBAction func IBActionPickerSelect(sender: UIButton) {
        if selectedPickerType == .Categories{
            sAllCategories = arrCategories[IBpickerView.selectedRowInComponent(0)]
            self.IBtblFilter.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Fade)
        }else if selectedPickerType == .Styles{
            sAllStyles = arrStyle[IBpickerView.selectedRowInComponent(0)]
            self.IBtblFilter.reloadRowsAtIndexPaths([NSIndexPath(forRow: 5, inSection: 0)], withRowAnimation: .Fade)
        }else{
        
        }
        self.IBtblFilter.reloadData()
        hidePicker()
    }
    
    @IBAction func IBActionSwipeClosePicker(sender: UISwipeGestureRecognizer) {
        hidePicker()
    }
    
//
//MARK:- CategoryStyleCell IBAction Methods
//
    @IBAction func IBActionCategoryStyleClicked(sender: UIButton) {
        openPickerForTag(sender.tag)
    }
    
    func openPickerForTag(tag:Int){
        //All categories clicked
        if tag == PickerType.Categories.rawValue{
            selectedPickerType = .Categories
            arrPickerTitle = arrCategories
        //All styles clicked
        }else if tag == PickerType.Styles.rawValue{
            selectedPickerType = .Styles
            arrPickerTitle = arrStyle
        }
        showPicker()
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
        hidePicker()
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
                self.delegate?.willCloseChildVC(S_ID_FILTER_VC)
        }
    }
    
    /**
     Shows picker view with animation
     */
    func showPicker(){
        IBpickerView.reloadAllComponents()
        IBconstraintPickerMainTop.constant = 0
        IBconstraintPickerMainBottom.constant = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutSubviews()
        }
    }

    /**
     Hides picker view with animation
     */
    func hidePicker(){
        IBconstraintPickerMainTop.constant = SCREEN_HEIGHT
        IBconstraintPickerMainBottom.constant = -SCREEN_HEIGHT
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutSubviews()
        }
        
    }

}



