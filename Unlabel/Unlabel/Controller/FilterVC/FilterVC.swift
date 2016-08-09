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
    func didClickApply(forFilterModel filterModel:Brand)
}


//
//MARK:- FilterVC Enums
//

class FilterVC: UIViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    
    
    @IBOutlet weak var IBlblFilterFor: UILabel!
    @IBOutlet weak var IBtblFilter: UITableView!
    @IBOutlet weak var IBpickerView: UIPickerView!
    
    @IBOutlet weak var IBconstraintPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var IBconstraintPickerMainBottom: NSLayoutConstraint!
    
    private let arrCategories:[String] = ["All categories","Clothing","Accessories","Jewelry","Shoes","Bags"]
    private var selectedCategoryIndexRow:Int = 0
    
    private let arrFilterTitles:[String] = ["LABEL CATEGORY","LOCATION"]
    var filterModel = Brand()
    var shouldClearCategories = false
    
    var delegate:FilterVCDelegate?
    var selectedFilterType:FilterType = .Unknown
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
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

    }
}


//
//MARK:- FilterTitleCellDelegate Methods
//
extension FilterVC:FilterTitleCellDelegate{
    func didChangeTab(index: Int) {
        reloadData()
    }
}


//
//MARK:- UITableViewDataSource Methods
//
extension FilterVC:UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 50
        }else if indexPath.row == 3 {
            return 320
        }else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if indexPath.row == 0 {
            return cellWithTitle(title: arrFilterTitles[indexPath.row/2])
        }else if indexPath.row == 1{
            return categoryStyleCell(indexPath)
        }else if indexPath.row == 2 {
            return filterTitleCell(indexPath)
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
        cellWithTitle.separatorInset = UIEdgeInsetsMake(0, 30, 0, 28)
        cellWithTitle.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
        cellWithTitle.textLabel?.font = UnlabelHelper.getNeutraface2Text(style: FONT_STYLE_DEMI, size: 16)
        
        return cellWithTitle
    }
    
    func filterTitleCell(indexPath:NSIndexPath)->FilterTitleCell{
        let filterTitleCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_FilterTitleCell) as? FilterTitleCell
        filterTitleCell?.delegate = self
        
        var USATextColor:UIColor?
        var InternationalTextColor:UIColor?
        
        if filterTitleCell?.selectedTab == 0{
            USATextColor = MEDIUM_GRAY_TEXT_COLOR
            InternationalTextColor = LIGHT_GRAY_TEXT_COLOR
        }else{
            USATextColor = LIGHT_GRAY_TEXT_COLOR
            InternationalTextColor = MEDIUM_GRAY_TEXT_COLOR
        }
        
        filterTitleCell?.IBbtnUSA.setTitleColor(USATextColor, forState: .Normal)
        filterTitleCell?.IBBtnInternational.setTitleColor(InternationalTextColor, forState: .Normal)
        
        return filterTitleCell!
    }
    
    func categoryStyleCell(indexPath:NSIndexPath)->CategoryStyleCell{
        let categoryStyleCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_CategoryStyleCell) as? CategoryStyleCell
        categoryStyleCell?.delegate = self
        categoryStyleCell?.IBbtnCategoryStyle.setTitle("    \(arrCategories[selectedCategoryIndexRow])", forState: .Normal)
        
        if IBconstraintPickerMainBottom.constant != 0{
            categoryStyleCell?.IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.colorWithAlphaComponent(0.5).CGColor
            categoryStyleCell?.IBbtnCategoryStyle.setTitleColor(LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
        }else{
            categoryStyleCell?.IBbtnCategoryStyle.layer.borderColor = DARK_GRAY_COLOR.colorWithAlphaComponent(0.8).CGColor
            categoryStyleCell?.IBbtnCategoryStyle.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
        }
        
        return categoryStyleCell!
    }
    
    func categoryLocationCell(indexPath:NSIndexPath)->CategoryLocationCell{
        let categoryLocationCell = IBtblFilter.dequeueReusableCellWithIdentifier(REUSABLE_ID_CategoryLocationCell) as! CategoryLocationCell
        categoryLocationCell.delegate = self
//        categoryLocationCell.IBconstraintCollectionViewHeight.constant = IBtblFilter.frame.size.height - 142 // 142 = Height of other cells than category table cell
//        if indexPath.row == 3{
//            if shouldClearCategories{
//                for (index,_) in categoryLocationCell.dictSelectedCategories{
//                    categoryLocationCell.dictSelectedCategories.updateValue(false, forKey: index)
//                    categoryLocationCell.IBtblLocation.reloadData()
//                }
//                shouldClearCategories = false
//            }
//            categoryLocationCell.cellType = CategoryLocationCellType.Category
//            categoryLocationCell.IBtblLocation.tag = TableViewType.Category.rawValue
//            categoryLocationCell.IBconstraintCategoryTableHeight.constant = IBtblFilter.frame.size.height - 142 // 142 = Height of other cells than category table cell
//        }else{
//            categoryLocationCell.cellType = CategoryLocationCellType.Unknown
//            categoryLocationCell.IBtblLocation.tag = TableViewType.Unknown.rawValue
//        }
//        
        return categoryLocationCell
    }
    
}


//
//MARK:- CategoryStyleCellDelegate
//
extension FilterVC:CategoryStyleCellDelegate{
    func didClickStyleCell(forTag:Int){
        
    }
}


//
//MARK:- CategoryDelegate
//
extension FilterVC:CategoryDelegate{
    func didSelectRow(withSelectedCategories dictCategories:[Int:Bool]){
    
    } //arrCategories is key index
}

//
//MARK:- UIPickerViewDelegate,UIPickerViewDataSource
//
extension FilterVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCategories[row]
    }
}


//
//MARK:- FilterVC IBAction Methods
//
extension FilterVC{
    
    @IBAction func IBActionClose(sender: AnyObject) {
        close()
    }
    
    @IBAction func IBActionPickerCancel(sender: UIButton) {
        hidePicker()
    }
    
    @IBAction func IBActionPickerSelect(sender: UIButton) {
        selectedCategoryIndexRow = IBpickerView.selectedRowInComponent(0)
        reloadData()
        hidePicker()
    }
    
    @IBAction func IBActionSwipeClosePicker(sender: UISwipeGestureRecognizer) {
        hidePicker()
    }
    
    @IBAction func IBActionShowLabels(sender: UIButton) {
        close()
        delegate?.didClickApply(forFilterModel: filterModel)
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
    private func setupUIOnLoad(){
        hidePicker()
        registerCell(withID: REUSABLE_ID_GenderCell)
        registerCell(withID: REUSABLE_ID_FilterTitleCell)
        registerCell(withID: REUSABLE_ID_CategoryStyleCell)
        registerCell(withID: REUSABLE_ID_CategoryLocationCell)
    }
    
    /**
     Setup UI on before appear.
     */
    func setupBeforeAppear(){
        if selectedFilterType == .Men{
            IBlblFilterFor.text = "FILTER MEN"
        }else{
            IBlblFilterFor.text = "FILTER WOMEN"
        }
    }
    
    /**
     Register nib for given ID.
     */
    private func registerCell(withID reusableID:String){
        IBtblFilter.registerNib(UINib(nibName: reusableID, bundle: nil), forCellReuseIdentifier: reusableID)
    }
    
    /**
     Remove self from parentViewController
     */
    private func close(){
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
    private func showPicker(){
        IBpickerView.reloadAllComponents()
        IBconstraintPickerMainBottom.constant = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutSubviews()
        }
        
        reloadData()
    }
    
    /**
     Hides picker view with animation
     */
    private func hidePicker(){
        IBconstraintPickerMainBottom.constant = -IBconstraintPickerHeight.constant
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutSubviews()
        }
        
        reloadData()
    }
    
    private func reloadData(){
        UIView.transitionWithView(IBtblFilter, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.IBtblFilter.reloadData()
            }, completion: nil)
    }
}