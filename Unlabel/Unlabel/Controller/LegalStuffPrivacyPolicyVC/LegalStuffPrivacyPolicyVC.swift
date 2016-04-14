//
//  LegalStuffPrivacyPolicyVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 17/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

enum VCType{
    case Unknown
    case LegalStuff
    case PrivacyPolicy
}

class LegalStuffPrivacyPolicyVC: UIViewController {
    
    @IBOutlet weak var IBbtnTitle: UIButton!
    @IBOutlet weak var IBbtnTitle2: UIButton!
    
    @IBOutlet weak var IBbtnX: UIButton!
    @IBOutlet weak var IBconstraintScrollviewToTop: NSLayoutConstraint!
    
    var vcType:VCType = .Unknown
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let _ = self.navigationController{
            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- UIGestureRecognizerDelegate Methods
//
extension LegalStuffPrivacyPolicyVC:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navVC = navigationController{
            if navVC.viewControllers.count > 1{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
}

//
//MARK:- IBAction Methods
//
extension LegalStuffPrivacyPolicyVC {
    @IBAction func IBActionClose(sender: UIButton) {
        pop()
    }
    
    @IBAction func IBActionX(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


//
//MARK:- Custom Methods
//

extension LegalStuffPrivacyPolicyVC {
    func setupOnLoad(){
        if let _ = navigationController{
            if vcType == .LegalStuff{
                IBbtnTitle.setTitle(sLegal_Stuff, forState: .Normal)
            }else if vcType == .PrivacyPolicy{
                IBbtnTitle.setTitle(sPrivacy_Policy, forState: .Normal)
            }
            else {
                debugPrint("Unknown VC Type")
            }
            IBbtnX.hidden = true
            IBbtnTitle2.hidden = true
            IBconstraintScrollviewToTop.constant = 20
        }else{
            if vcType == .LegalStuff{
                IBbtnTitle2.setTitle(sLegal_Stuff, forState: .Normal)
            }else if vcType == .PrivacyPolicy{
                IBbtnTitle2.setTitle(sPrivacy_Policy, forState: .Normal)
            }
            else {
                debugPrint("Unknown VC Type")
            }
            IBbtnX.hidden = false
            IBbtnTitle2.hidden = false
            IBconstraintScrollviewToTop.constant = 64
        }
    }
    
    func pop(){
        navigationController?.popViewControllerAnimated(true)
    }
}
