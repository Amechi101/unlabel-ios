//
//  UnlabelConstants.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 24/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation


//
//MARK:- Unlabel Enums Names
//
enum ChildVCName {
    case LeftMenuVC
    case FilterVC
}

//
//MARK:- UIColor Constants
//
let LIGHT_GRAY_TEXT_COLOR = UIColor(red: 177/255, green: 179/255, blue: 184/255, alpha: 1)

//#charcoalGrey
let MEDIUM_GRAY_TEXT_COLOR = UIColor(red: 69/255, green: 73/255, blue: 78/255, alpha: 1)

let LIGHT_GRAY_BORDER_COLOR = UIColor(red: 153/255, green: 156/255, blue: 165/255, alpha: 1)

let MEDIUM_GRAY_BORDER_COLOR = UIColor(red: 187/255, green: 189/255, blue: 194/255, alpha: 1)

let DARK_GRAY_COLOR = UIColor(red: 40/255, green: 44/255, blue: 53/255, alpha: 1)

let WINDOW_TINT_COLOR = APP_DELEGATE.window?.tintColor

//
//MARK:- Storyboard Names
//
let S_NAME_UNLABEL = "Unlabel"
let S_NAME_ADMIN   = "Admin"

//
//MARK:- Storyboard IDs
//
let S_ID_FEED_VC                    = "FeedVC"
let S_ID_ENTRY_VC                   = "EntryVC"
let S_ID_FILTER_VC                  = "FilterVC"
let S_ID_PRODUCT_VC                 = "ProductVC"
let S_ID_ABOUT_US_VC                = "AboutUsVC"
let S_ID_ADD_BRAND_VC               = "AddBrandVC"
let S_ID_LEFT_MENU_VC               = "LeftMenuVC"
let S_ID_SETTINGS_VC                = "SettingsVC"
let S_ID_FOLLOWING_VC               = "FollowingVC"
let S_ID_ABOUT_LABEL_VC             = "AboutLabelVC"
let S_ID_ADD_PRODUCT_VC             = "AddProductVC"
let S_ID_CHANGE_NAME_VC             = "ChangeNameVC"
let S_ID_LOGIN_SIGNUP_VC            = "LoginSignupVC"
let S_ID_PRODUCT_LIST_VC            = "ProductListVC"
let S_ID_NAV_CONTROLLER             = "NavController"
let S_ID_PRODUCT_DETAIL_VC          = "ProductDetailVC"
let S_ID_LAUNCH_LOADING_VC          = "LaunchLoadingVC"
let S_ID_ADMIN_NAV_CONTROLLER       = "AdminNavController"

//
//MARK:- Image Name Constants
//
let IMG_HAMBURGER              = "hamburger"
let IMG_BACK                   = "back"

//
//MARK:- Segue IDs
//
let SEGUE_LOGIN                     = "Login"
let SEGUE_SIGNUP                    = "Signup"
let SEGUE_SETTINGS                  = "Settings"
let SEGUE_LEGAL_STUFF               = "LegalStuff"
let SEGUE_TERMS                     = "Terms"
let SEGUE_PRIVACY_POLICY            = "PrivacyPolicy"
let SEGUE_LEGALSTUFF_FROM_SETTINGS      = "LegalStuffFromSettings"
let SEGUE_PRIVACYPOLICY_FROM_SETTINGS   = "PrivacyPolicyFromSettings"
let SEGUE_ACCOUNTINFO_FROM_SETTINGS     = "AccountInfoFromSettings"

//
//MARK:- Cell Reusable IDs
//
let REUSABLE_ID_ProductCell         = "ProductCell"
let REUSABLE_ID_GenderCell          = "GenderCell"
let REUSABLE_ID_FeedVCCell          = "FeedVCCell"
let REUSABLE_ID_CategoryLocationCell = "CategoryLocationCell"
let REUSABLE_ID_ProductHeaderCell   = "ProductHeaderCell"
let REUSABLE_ID_CategoryStyleCell   = "CategoryStyleCell"
let REUSABLE_ID_ProductFooterView   = "ProductFooterView"
let REUSABLE_ID_FeedVCFooterCell   = "FeedVCFooterCell"

//
//MARK:- Font Style
//
let FONT_STYLE_DEMI = "Demi"
let FONT_STYLE_BOLD = "Bold"

//
//MARK:- Strings
//

let S_PROVIDER_FACEBOOK = "Facebook"
let S_PROVIDER_ACCOUNTKIT = "AccountKit"

let sSOMETHING_WENT_WRONG       = "Something Went Wrong!"
let S_TRY_AGAIN                 = "Please try agian later"
let sARE_YOU_SURE               = "Are you sure?"

let sLegal_Stuff                = "LEGAL STUFF"
let sPrivacy_Policy             = "PRIVACY POLICY"

let sPOPUP_SEEN_ONCE            = "popup_seen_once"

let S_NO_INTERNET               = "No Internet Available!"
let S_PLEASE_CONNECT            = "Please connect to the Internet."

let S_LOGIN_REGISTER            = "LOGIN / REGISTER"
let S_LOGIN                     = "LOGIN"
let S_MUST_LOGGED_IN            = "You must be logged in to access this feature."


//
//MARK:- Anonymous Constants
//
let UNLABEL_EMAIL_ID    = "info@unlabel.us"
let APP_DELEGATE        = UIApplication.sharedApplication().delegate as! AppDelegate
let SCREEN_WIDTH        = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT       = UIScreen.mainScreen().bounds.size.height

//
//MARK:- Error codes
//
let FB_ALREADY_LOGGED_IN = (111,"User already logged in.") //Error code and message
let FB_LOGIN_FAILED = (112,"Login failed.")
