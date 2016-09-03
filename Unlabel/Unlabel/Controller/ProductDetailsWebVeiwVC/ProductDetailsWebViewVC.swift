//
//  ProductDetailsWebViewVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 25/08/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

class ProductDetailsWebViewVC: UIViewController {

   @IBOutlet weak var IBbtnStar: UIButton!
   
   @IBOutlet weak var IBlblBrandName: UILabel!
    
    @IBOutlet weak var IBwebView: UIWebView!
   
   
   @IBOutlet weak var IBbtnBack: UIBarButtonItem!
   @IBOutlet weak var IBbtnForward: UIBarButtonItem!
   
    weak var selectedBrand:Brand?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        // Do any additional setup after loading the view.
    
      updateButtonUI()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      
      if IBwebView.loading {
         IBwebView.stopLoading()
      }
   }
   
   
   
   func updateButtonUI() {
      guard let _selectedBrand = selectedBrand else {
         return
      }
      
      let imageNamed = (_selectedBrand.isFollowing == true) ? "blackStarred" : "blackUnstarred"
      IBbtnStar.setImage(UIImage(named: imageNamed), forState: UIControlState.Normal)
   }
    
}

extension ProductDetailsWebViewVC: UIWebViewDelegate {
   
   func goBack(sender: UIBarButtonItem) {
      IBwebView.goBack()
   }
   
   func goForward(sender: UIBarButtonItem) {
      IBwebView.goForward()
   }
   
   func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
 
      
         IBbtnBack.enabled = IBwebView.canGoBack
         IBbtnForward.enabled = IBwebView.canGoForward
  
     
      
      return true
   }
   
}



//
//MARK:- ViewFollowingLabelPopup Methods
//

extension ProductDetailsWebViewVC:PopupviewDelegate{
   /**
    If user not following any brand, show this view
    */
   func addPopupView(popupType:PopupType,initialFrame:CGRect){
      let viewFollowingLabelPopup:ViewFollowingLabelPopup = NSBundle.mainBundle().loadNibNamed("ViewFollowingLabelPopup", owner: self, options: nil) [0] as! ViewFollowingLabelPopup
      viewFollowingLabelPopup.delegate = self
      viewFollowingLabelPopup.popupType = popupType
      viewFollowingLabelPopup.frame = initialFrame
      viewFollowingLabelPopup.alpha = 0
      view.addSubview(viewFollowingLabelPopup)
      UIView.animateWithDuration(0.2) {
         viewFollowingLabelPopup.frame = self.view.frame
         viewFollowingLabelPopup.frame.origin = CGPointMake(0, 0)
         viewFollowingLabelPopup.alpha = 1
      }
      if popupType == PopupType.Follow{
         viewFollowingLabelPopup.setFollowSubTitle("Brand")
      }
      viewFollowingLabelPopup.updateView()
   }
   
   func popupDidClickCancel(){
      
   }
   
   func popupDidClickDelete(){
      debugPrint("delete account")
   }
   
   func popupDidClickClose(){
      
   }
}



//
//MARK:- IBActions Methods
//
extension ProductDetailsWebViewVC{
   
   private func openLoginSignupVC(){
      if let loginSignupVC:LoginSignupVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_LOGIN_SIGNUP_VC) as? LoginSignupVC{
         //         loginSignupVC.delegate = self
         self.presentViewController(loginSignupVC, animated: true, completion: nil)
      }
   }
   
   @IBAction func IBActionFollow(sender: AnyObject) {
      
      // return;  version 3
      
      guard let _selectedBrand = selectedBrand else {
         return
      }
      
      debugPrint("Follow clicked")
      //Internet available
      if ReachabilitySwift.isConnectedToNetwork(){
         
         if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            if _selectedBrand.isFollowing {
               _selectedBrand.isFollowing = false
            }else{
               _selectedBrand.isFollowing = true
            }
             self.updateButtonUI()
            FirebaseHelper.followUnfollowBrand(follow: _selectedBrand.isFollowing, brandID:_selectedBrand.ID, userID: userID, withCompletionBlock: { (error, firebase) in
               if error != nil{
                  
               }
            })
            
            if UnlabelHelper.getBoolValue(sPOPUP_SEEN_ONCE){
               
            }else{
               addPopupView(PopupType.Follow, initialFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT))
               UnlabelHelper.setBoolValue(true, key: sPOPUP_SEEN_ONCE)
            }
         } else{
            self.openLoginSignupVC()
         }
       
      }else{
         UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
      
      
   }


  
   
   

    @IBAction func IBActionClose(sender: AnyObject) {
      
    }
}


//
//MARK:- Custom Methods
//
extension ProductDetailsWebViewVC{
    private func setupOnLoad(){
       IBwebView.delegate = self
      IBbtnBack.enabled = false
      IBbtnForward.enabled = false
      
      IBbtnBack.target = self
      IBbtnBack.action = #selector(ProductDetailsWebViewVC.goBack(_:))
      IBbtnForward.target = self
      IBbtnForward.action = #selector(ProductDetailsWebViewVC.goForward(_:))

        loadbrandWebsite()
    }
    
    private func loadbrandWebsite(){
        IBlblBrandName.text = selectedBrand?.Name.uppercaseString
        if let urlString = selectedBrand?.BrandWebsiteURL{
            if let url = NSURL(string: urlString){
                IBwebView.loadRequest(NSURLRequest(URL: url))
            }else{
                showErrorAlert()
            }
        }else{
            showErrorAlert()
        }
    }
    
    private func showErrorAlert(){
        UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}