//
//  LeftMenuVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 25/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

enum LeftMenuItems:Int{
    case Discover = 0
    case Following = 1
   case Settings = 2
   
   
   var getLeftMenuTitle:String {
      switch self {
         case .Discover: return "DISCOVER"
         case .Following: return "FOLLOWING"
         case .Settings: return "SETTINGS"
      }
   }
}

//
//MARK:- LeftMenuVC Protocols
//
protocol LeftMenuVCDelegate{
    func didSelectRowAtIndexPath(indexPath: NSIndexPath)
    func willCloseChildVC(childVCName:String)
}


class LeftMenuVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBtblLeftMenu: UITableView!
    @IBOutlet weak var IBlblUserName: UILabel!
    
    private let tempDisplayName = String()
    private let arrTitles = ["DISCOVER","FOLLOWING", "SETTINGS"]
//   private let arrTitles = ["DISCOVER","SETTINGS"]
   var delegate:LeftMenuVCDelegate?
    
    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        
        IBlblUserName.text = tempDisplayName
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
extension LeftMenuVC:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        close(withIndexPath: indexPath)
      
      
      
    }
}

//
//MARK:- UITableViewDataSource Methods
//
extension LeftMenuVC:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let leftMenuCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        leftMenuCell.textLabel?.text = arrTitles[indexPath.row]
        leftMenuCell.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
        leftMenuCell.textLabel?.font = UnlabelHelper.getNeutraface2Text(style: FONT_STYLE_DEMI, size: 14)
        
        return leftMenuCell
    }
}

//
//MARK:- IBAction Methods
//
extension LeftMenuVC{
    @IBAction func IBActionClose(sender: AnyObject) {
     close(withIndexPath: nil)
    }
    
    @IBAction func IBActionLoginRegister(sender: AnyObject) {
        if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            
        }else{
           openLoginSignupVC()
        }
    }
}

//
//MARK:- LoginSignupVCDelegate Methods
//
extension LeftMenuVC:LoginSignupVCDelegate{
    func willDidmissViewController() {
        var userDisplayName = S_LOGIN_REGISTER
        
        if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
                userDisplayName = displayName
            }
        }
        
        IBlblUserName.text = userDisplayName
    }
}


//
//MARK:- Custom Methods
//
extension LeftMenuVC{
    /**
     Setup UI on VC Load.
     */
    private func setupUIOnLoad(){
        IBtblLeftMenu.tableFooterView = UIView()
    }

    /**
     Remove self from parentViewController
     */
    private func close(withIndexPath indexPath:NSIndexPath?){
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.alpha = 0
            self.view.frame.origin.x = -SCREEN_WIDTH
            }) { (value:Bool) -> Void in
                self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                self.delegate?.willCloseChildVC(S_ID_LEFT_MENU_VC)
                if let index = indexPath{
                    self.delegate?.didSelectRowAtIndexPath(index)
                }
        }
    }
    
    private func openLoginSignupVC(){
        if let loginSignupVC:LoginSignupVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_LOGIN_SIGNUP_VC) as? LoginSignupVC{
            loginSignupVC.delegate = self
            self.presentViewController(loginSignupVC, animated: true, completion: nil)
        }
    }
}


