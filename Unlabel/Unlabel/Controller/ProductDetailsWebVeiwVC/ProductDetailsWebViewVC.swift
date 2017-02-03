//
//  ProductDetailsWebViewVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 25/08/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

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
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      if IBwebView.isLoading {
         IBwebView.stopLoading()
      }
   }
   
   
   
   func updateButtonUI() {
      guard let _selectedBrand = selectedBrand else {
         return
      }
      
      let imageNamed = (_selectedBrand.isFollowing == true) ? "blackStarred" : "blackUnstarred"
      IBbtnStar.setImage(UIImage(named: imageNamed), for: UIControlState())
   }
    
}

extension ProductDetailsWebViewVC: UIWebViewDelegate {
   
   func goBack(_ sender: UIBarButtonItem) {
      IBwebView.goBack()
   }
   
   func goForward(_ sender: UIBarButtonItem) {
      IBwebView.goForward()
   }
   
   func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
 
      
         IBbtnBack.isEnabled = IBwebView.canGoBack
         IBbtnForward.isEnabled = IBwebView.canGoForward
  
     
      
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
   func addPopupView(_ popupType:PopupType,initialFrame:CGRect){
      let viewFollowingLabelPopup:ViewFollowingLabelPopup = Bundle.main.loadNibNamed("ViewFollowingLabelPopup", owner: self, options: nil)! [0] as! ViewFollowingLabelPopup
      viewFollowingLabelPopup.delegate = self
      viewFollowingLabelPopup.popupType = popupType
      viewFollowingLabelPopup.frame = initialFrame
      viewFollowingLabelPopup.alpha = 0
      view.addSubview(viewFollowingLabelPopup)
      UIView.animate(withDuration: 0.2, animations: {
         viewFollowingLabelPopup.frame = self.view.frame
         viewFollowingLabelPopup.frame.origin = CGPoint(x: 0, y: 0)
         viewFollowingLabelPopup.alpha = 1
      }) 
      if popupType == PopupType.follow{
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

   @IBAction func IBActionFollow(_ sender: AnyObject) {
      
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
                        
         } else{
         }
       
      }else{
         UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
      
      
   }


  
   
   

    @IBAction func IBActionClose(_ sender: AnyObject) {
      
    }
}


//
//MARK:- Custom Methods
//
extension ProductDetailsWebViewVC{
    fileprivate func setupOnLoad(){
       IBwebView.delegate = self
      IBbtnBack.isEnabled = false
      IBbtnForward.isEnabled = false
      
      IBbtnBack.target = self
      IBbtnBack.action = #selector(ProductDetailsWebViewVC.goBack(_:))
      IBbtnForward.target = self
      IBbtnForward.action = #selector(ProductDetailsWebViewVC.goForward(_:))

        loadbrandWebsite()
    }
    
    fileprivate func loadbrandWebsite(){
        IBlblBrandName.text = selectedBrand?.Name.uppercased()
        if let urlString = selectedBrand?.BrandWebsiteURL{
            if let url = URL(string: urlString){
                IBwebView.loadRequest(URLRequest(url: url))
            }else{
                showErrorAlert()
            }
        }else{
            showErrorAlert()
        }
    }
    
    fileprivate func showErrorAlert(){
        UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
