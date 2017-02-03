//
//  LegalStuffPrivacyPolicyVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 17/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

enum VCType{
    case unknown
    case legalStuff
    case privacyPolicy
}

class LegalStuffPrivacyPolicyVC: UIViewController {
    
    @IBOutlet weak var IBbtnTitle: UIButton!
    @IBOutlet weak var IBbtnTitle2: UIButton!
    
    @IBOutlet weak var IBbtnX: UIButton!
    @IBOutlet weak var IBconstraintScrollviewToTop: NSLayoutConstraint!
    
    var vcType:VCType = .unknown
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
    @IBAction func IBActionClose(_ sender: UIButton) {
        pop()
    }
    
    @IBAction func IBActionX(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


//
//MARK:- Custom Methods
//

extension LegalStuffPrivacyPolicyVC {
    fileprivate func setupOnLoad(){
        if let _ = navigationController{
            if vcType == .legalStuff{
                IBbtnTitle.setTitle(sLegal_Stuff, for: UIControlState())
            }else if vcType == .privacyPolicy{
                IBbtnTitle.setTitle(sPrivacy_Policy, for: UIControlState())
            }
            else {
                debugPrint("Unknown VC Type")
            }
            IBbtnX.isHidden = true
            IBbtnTitle2.isHidden = true
            IBconstraintScrollviewToTop.constant = 20
        }else{
            if vcType == .legalStuff{
                IBbtnTitle2.setTitle(sLegal_Stuff, for: UIControlState())
            }else if vcType == .privacyPolicy{
                IBbtnTitle2.setTitle(sPrivacy_Policy, for: UIControlState())
            }
            else {
                debugPrint("Unknown VC Type")
            }
            IBbtnX.isHidden = false
            IBbtnTitle2.isHidden = false
            IBconstraintScrollviewToTop.constant = 64
        }
    }
    
    fileprivate func pop(){
        _ = navigationController?.popViewController(animated: true)
    }
}
