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
@objc protocol FilterVCDelegate{
    optional func willCloseChildVC(childVCName:String)
    optional func didClickApply(forFilterModel filterModel:Brand)
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
    
    @IBOutlet weak var IBbtnClear: UIButton!
    @IBOutlet weak var IBconstraintPickerMainTop: NSLayoutConstraint!
    @IBOutlet weak var IBconstraintPickerMainBottom: NSLayoutConstraint!
    
    private var sAllCategories = "All categories"
    private let arrFilterTitles:[String] = ["SEX","CATEGORY","LOCATION"]
    var filterModel = Brand()
    var shouldClearCategories = false
    
    
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 {
            return cellWithTitle(title: arrFilterTitles[indexPath.row/2])
        }else if indexPath.row == 1{
            return genderCell()
        }else if indexPath.row == 3{
            return categoryLocationCell(indexPath)
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
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
        
        if filterModel.Menswear{
            enableButton(genderCell.IBbtnMale)
        }else{
            disableButton(genderCell.IBbtnMale)
        }
        
        if filterModel.Womenswear{
            enableButton(genderCell.IBbtnFemale)
        }else{
            disableButton(genderCell.IBbtnFemale)
        }
        
        return genderCell
    }

    func categoryLocationCell(indexPath:NSIndexPath)->CategoryLocationCell{
        let categoryLocationCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_CategoryLocationCell) as! CategoryLocationCell
        categoryLocationCell.delegate = self
        
        if indexPath.row == 3{
            if shouldClearCategories{
                for (index,_) in categoryLocationCell.dictSelectedCategories{
                    categoryLocationCell.dictSelectedCategories.updateValue(false, forKey: index)
                    categoryLocationCell.IBtblLocation.reloadData()
                }
                shouldClearCategories = false
            }
            categoryLocationCell.cellType = CategoryLocationCellType.Category
            categoryLocationCell.IBtblLocation.tag = TableViewType.Category.rawValue
            categoryLocationCell.IBconstraintCategoryTableHeight.constant = IBtblFilter.frame.size.height - 142 // 142 = Height of other cells than category table cell
        }else{
            categoryLocationCell.cellType = CategoryLocationCellType.Unknown
            categoryLocationCell.IBtblLocation.tag = TableViewType.Unknown.rawValue
        }
        
        return categoryLocationCell
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
//        if selectedPickerType == .Categories{
//            sAllCategories = arrCategories[IBpickerView.selectedRowInComponent(0)]
//            self.IBtblFilter.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Fade)
//        }else if selectedPickerType == .Styles{
//            sAllStyles = arrStyle[IBpickerView.selectedRowInComponent(0)]
//            self.IBtblFilter.reloadRowsAtIndexPaths([NSIndexPath(forRow: 5, inSection: 0)], withRowAnimation: .Fade)
//        }else{
//        
//        }
//        self.IBtblFilter.reloadData()
//        hidePicker()
    }
    
    @IBAction func IBActionSwipeClosePicker(sender: UISwipeGestureRecognizer) {
        hidePicker()
    }
    
    @IBAction func IBActionApply(sender: UIButton) {
        close()
        delegate?.didClickApply!(forFilterModel: filterModel)
    }
    
    @IBAction func IBActionClear(sender: UIButton) {
        filterModel.Menswear = false
        filterModel.Womenswear = false
        filterModel.Clothing = false
        filterModel.Accessories = false
        filterModel.Jewelry = false
        filterModel.Shoes = false
        filterModel.Bags = false
        shouldClearCategories = true
        IBtblFilter.reloadData()
    }
    
//
//MARK:- CategoryStyleCell IBAction Methods
//
    @IBAction func IBActionCategoryStyleClicked(sender: UIButton) {
        openPickerForTag(sender.tag)
    }
    
    func openPickerForTag(tag:Int){
//        //All categories clicked
//        if tag == PickerType.Categories.rawValue{
//            selectedPickerType = .Categories
//            arrPickerTitle = arrCategories
//        //All styles clicked
//        }else if tag == PickerType.Styles.rawValue{
//            selectedPickerType = .Styles
//            arrPickerTitle = arrStyle
//        }
//        showPicker()
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
        registerCell(withID: REUSABLE_ID_CategoryLocationCell)

        IBbtnClear.layer.borderColor = DARK_GRAY_COLOR.CGColor
        IBtblFilter.estimatedRowHeight = SCREEN_HEIGHT - 218 //218 for StatusBar+Footer+XButton height
        IBtblFilter.rowHeight = UITableViewAutomaticDimension
        IBtblFilter.tableFooterView = UIView()
        IBtblFilter.reloadData()
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
                self.delegate?.willCloseChildVC!(S_ID_FILTER_VC)
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
//        IBconstraintPickerMainTop.constant = SCREEN_HEIGHT
//        IBconstraintPickerMainBottom.constant = -SCREEN_HEIGHT
//        UIView.animateWithDuration(0.3) { () -> Void in
//            self.view.layoutSubviews()
//        }
        
    }
    
    


}


//
//MARK:- Gender Cell
//
extension FilterVC{
    
    //
    //MARK:- Gender cell IBAction Methods
    //
    //Tag 1 for Male, 2 for Female
    @IBAction func IBActionGenderClicked(sender: UIButton) {
        handleGenderSelection(sender)
    }
    
    //
    //MARK:- Gender cell Custom Methods
    //
        func handleGenderSelection(sender:UIButton){
            //Male Clicked
            if sender.tag == 1{
                filterModel.Menswear = !filterModel.Menswear
                
                //Female Clicked
            }else{
                filterModel.Womenswear = !filterModel.Womenswear
            }
            
            IBtblFilter.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    
        /**
         Enable button
         */
        func enableButton(makeEnabled:UIButton){
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                makeEnabled.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
                makeEnabled.layer.borderColor = MEDIUM_GRAY_TEXT_COLOR.CGColor
            }
        }
        
        /**
         Disable button
         */
        func disableButton(makeDisabled:UIButton){
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                makeDisabled.setTitleColor(LIGHT_GRAY_BORDER_COLOR, forState: .Normal)
                makeDisabled.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.CGColor
            }
        }
}

//
//MARK:- Category Cell
//
extension FilterVC:CategoryDelegate{
    func didSelectRow(withSelectedCategories dictCategories: [Int : Bool]) {
        
        if let clothing:Bool = dictCategories[1]{
            filterModel.Clothing = clothing
        }
        
        if let accessories:Bool = dictCategories[2]{
            filterModel.Accessories = accessories
        }
        
        if let jewelry:Bool = dictCategories[3]{
            filterModel.Jewelry = jewelry
        }
        
        if let shoes:Bool = dictCategories[4]{
            filterModel.Shoes = shoes
        }
        
        if let bags:Bool = dictCategories[5]{
            filterModel.Bags = bags
        }
        
    }
}
