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
    
    @IBOutlet weak var IBlblTitle: UILabel!
    @IBOutlet weak var IBbtnClose: UIButton!
    
    var vcType:VCType = .Unknown
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewOnLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



//
//MARK:- IBAction Methods
//

extension LegalStuffPrivacyPolicyVC {
    @IBAction func IBActionClose(sender: UIButton) {
        dismiss()
    }
}


//
//MARK:- Custom Methods
//

extension LegalStuffPrivacyPolicyVC {
    func configureViewOnLoad(){
        if vcType == .LegalStuff{
            IBlblTitle.text = sLegal_Stuff
        }else if vcType == .PrivacyPolicy{
            IBlblTitle.text = sPrivacy_Policy
        }
        else {
            debugPrint("Unknown VC Type")
        }
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
