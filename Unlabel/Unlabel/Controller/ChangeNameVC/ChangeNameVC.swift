//
//  ChangeNameVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 01/05/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

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
    
    override func viewDidAppear(_ animated: Bool) {
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
    @IBAction func IBActionApply(_ sender: UIButton) {
        updateUserName()
    }
    
    @IBAction func IBActionBack(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }
}

//
//MARK:- UITextFieldDelegate Methods
//
extension ChangeNameVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateUserName()
        return true
    }
}

//
//MARK:- Custom Methods
//
extension ChangeNameVC{
    fileprivate func setupOnLoad(){
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: IBtxtFieldEnterNewName.frame.size.height - 1, width: IBtxtFieldEnterNewName.frame.size.width, height: 1.0);
        bottomBorder.backgroundColor = MEDIUM_GRAY_BORDER_COLOR.cgColor
        IBtxtFieldEnterNewName.layer.addSublayer(bottomBorder)
        setUserName()
    }
    
    fileprivate func setUserName(){
        if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
            IBlblName.text = displayName
        }else{
            IBlblName.text = "Unlabel User"
        }
    }
    
    fileprivate func updateUserName(){
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            if let trimmedName = IBtxtFieldEnterNewName.text?.removeWhitespace(), trimmedName.characters.count > 0{ //Checking if user has entered all white space
                if let updatedUserName = IBtxtFieldEnterNewName.text, updatedUserName.characters.count > 0{
                    IBtxtFieldEnterNewName.resignFirstResponder()
                    UnlabelHelper.setDefaultValue(updatedUserName, key: PRM_DISPLAY_NAME)
                    setUserName()
              //      let displayName:[String:AnyObject] = [PRM_DISPLAY_NAME:updatedUserName as AnyObject]
/*********************** changed in v4
//                    FirebaseHelper.updateUser(userDict: displayName, completion: { (error) in
//                        if error == nil{
//                            debugPrint("name updated")
//                        }else{
//                            debugPrint(error!)
//                        }
//                    })
 
***********************/
                }else{
                    UnlabelHelper.showAlert(onVC: self, title: "Name Can't be empty", message: "Please provide correct name", onOk: {})
                }
            }else{
                UnlabelHelper.showAlert(onVC: self, title: "Invalid User Name", message: "Please provide correct name", onOk: {})
            }
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
        }
    }
}
