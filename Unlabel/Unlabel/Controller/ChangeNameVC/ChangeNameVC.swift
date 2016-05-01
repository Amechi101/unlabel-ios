//
//  ChangeNameVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 01/05/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

class ChangeNameVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBlblName: UILabel!
    @IBOutlet weak var IBtxtFieldEnterNewName: UITextField!
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        IBtxtFieldEnterNewName.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//MARK:- IBAction Methods
//
extension ChangeNameVC{
    @IBAction func IBActionApply(sender: UIButton) {
        updateUserName()
    }
    
    @IBAction func IBActionBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}

//
//MARK:- UITextFieldDelegate Methods
//
extension ChangeNameVC:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        updateUserName()
        return true
    }
}

//
//MARK:- Custom Methods
//
extension ChangeNameVC{
    func setupOnLoad(){
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, IBtxtFieldEnterNewName.frame.size.height - 1, IBtxtFieldEnterNewName.frame.size.width, 1.0);
        bottomBorder.backgroundColor = MEDIUM_GRAY_BORDER_COLOR.CGColor
        IBtxtFieldEnterNewName.layer.addSublayer(bottomBorder)
        setUserName()
    }
    
    func setUserName(){
        if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
            IBlblName.text = displayName
        }else{
            IBlblName.text = "Unlabel User"
        }
    }
    
    func updateUserName(){
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            if let updatedUserName = IBtxtFieldEnterNewName.text where updatedUserName.characters.count > 0{
                IBtxtFieldEnterNewName.resignFirstResponder()
                UnlabelHelper.setDefaultValue(updatedUserName, key: PRM_DISPLAY_NAME)
                setUserName()
                FirebaseHelper.updateUserName(updatedUserName, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                    if error == nil{
                        print(firebase)
                    }else{
                        print(error)
                    }
                })
            }else{
                UnlabelHelper.showAlert(onVC: self, title: "Name Can't be empty", message: "Please provide your name", onOk: {})
            }
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
        }
    }
}
