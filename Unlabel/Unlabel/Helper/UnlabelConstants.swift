//
//  UnlabelConstants.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 24/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation




//MARK:- UIColor Constants

let EXTRA_LIGHT_GRAY_TEXT_COLOR = UIColor(red: 226/255, green: 228/255, blue: 231/255, alpha: 1)

let LIGHT_GRAY_TEXT_COLOR = UIColor(red: 177/255, green: 179/255, blue: 184/255, alpha: 1)

//#charcoalGrey
let MEDIUM_GRAY_TEXT_COLOR = UIColor(red: 69/255, green: 73/255, blue: 78/255, alpha: 1)

let LIGHT_GRAY_BORDER_COLOR = UIColor(red: 153/255, green: 156/255, blue: 165/255, alpha: 1)

let MEDIUM_GRAY_BORDER_COLOR = UIColor(red: 187/255, green: 189/255, blue: 194/255, alpha: 1)

let DARK_GRAY_COLOR = UIColor(red: 40/255, green: 44/255, blue: 53/255, alpha: 1)

let DARK_RED_COLOR = UIColor(red: 216/255, green: 87/255, blue: 77/255, alpha: 1)

let WINDOW_TINT_COLOR = APP_DELEGATE.window?.tintColor

//MARK:- Storyboard Names
let S_NAME_UNLABEL = "Unlabel"
let S_NAME_ADMIN   = "Admin"

//MARK:- XIB Names

let FORGET_PASSWORD_POPUP   = "ViewForgotPasswordPopup"
let ADD_NEW_CELL            = "AddNewCell"
let PRODUCT_IMAGE_CELL      = "ProductImageCell"
let ADD_TO_CART_POPUP       = "AddToCartPopup"
let LIKE_FOLLOW_POPUP       = "LikeFollowPopup"
let NOT_FOUND_VIEW          = "NotFoundView"
let VIEW_FOLLOWING_POPUP    = "ViewFollowingLabelPopup"
let Rental_Info_VC    = "RentalInfoVC"
//MARK:- Storyboard IDs

let S_ID_FEED_VC                    = "FeedVC"
let S_ID_FILTER_VC                  = "FilterVC"
let S_ID_PRODUCT_VC                 = "ProductVC"
let S_ID_ABOUT_US_VC                = "AboutUsVC"
let S_ID_ADD_BRAND_VC               = "AddBrandVC"
let S_ID_SETTINGS_VC                = "SettingsVC"
let S_ID_FOLLOWING_VC               = "FollowingVC"
let S_ID_ABOUT_LABEL_VC             = "AboutLabelVC"
let S_ID_ADD_PRODUCT_VC             = "AddProductVC"
let S_ID_CHANGE_NAME_VC             = "ChangeNameVC"
let S_ID_PRODUCT_LIST_VC            = "ProductListVC"
let S_ID_NAV_CONTROLLER             = "NavController"
let S_ID_TAB_CONTROLLER             = "TabbarController"
let S_ID_COMMON_TABLE_VC            = "CommonTableVC"
let S_ID_PRODUCT_DETAIL_VC          = "ProductDetailVC"
let S_ID_LAUNCH_LOADING_VC          = "LaunchLoadingVC"
let S_ID_ADMIN_NAV_CONTROLLER       = "AdminNavController"
let S_ID_PRODUCT_DETAIL_WEBVIEW_VC  = "ProductDetailsWebVeiwVC"
let S_ID_ADD_EDIT_SHIPPING_ADDRESS_VC = "AddEditShippingAddressVC"
let S_ID_ADD_EDIT_PAYMENT_INFO_VC   = "AddEditPaymentInfoVC"
let S_CART_VIEW_CONTROLLER          = "CartViewController"
let S_ID_Product_Content_Header     = "ProductContentHeader"

let S_ID_Rental_Info_VC    = "RentalInfoVC"
//MARK:- Image Name Constants

let IMG_HAMBURGER              = ""
let IMG_BACK                   = "back"
let IMG_SEARCH                 = "search"


//MARK:- Segue IDs

let SEGUE_LOGIN                     = "Login"
let SEGUE_SIGNUP                    = "Signup"
let SEGUE_SETTINGS                  = "Settings"
let SEGUE_LEGAL_STUFF               = "LegalStuff"
let SEGUE_TERMS                     = "Terms"
let SEGUE_PRIVACY_POLICY            = "PrivacyPolicy"
let SEGUE_LEGALSTUFF_FROM_SETTINGS      = "LegalStuffFromSettings"
let SEGUE_PRIVACYPOLICY_FROM_SETTINGS   = "PrivacyPolicyFromSettings"
let SEGUE_ACCOUNTINFO_FROM_SETTINGS     = "AccountInfoFromSettings"
let SEGUE_FILTER_LABELS             = "FilterLabels"
let SEGUE_SELECT_DATE_TIME          = "selectDateAndTimeSegue"
let S_ID_PRODUCT_INFO_SEGUE  = "ProductInfoViewSegue"
//MARK:- Cell Reusable IDs

let REUSABLE_ID_ProductCell         = "ProductCell"
let REUSABLE_ID_GenderCell          = "GenderCell"
let REUSABLE_ID_FeedVCCell          = "FeedVCCell"
let REUSABLE_ID_CategoryLocationCell = "CategoryLocationCell"
let REUSABLE_ID_ProductHeaderCell   = "ProductHeaderCell"
let REUSABLE_ID_ProductDescCell     = "ProductDescCell"
let REUSABLE_ID_CategoryStyleCell   = "CategoryStyleCell"
let REUSABLE_ID_ProductFooterView   = "ProductFooterView"

let REUSABLE_ID_ProductSortCell   = "ProductSortCell"
let REUSABLE_ID_ProductContentHeaderCell   = "ProductContentHeaderCell"

let REUSABLE_ID_FeedVCFooterCell    = "FeedVCFooterCell"
let REUSABLE_ID_FeedVCHeaderCell    = "FeedVCHeaderCell"
let REUSABLE_ID_CommonTableVCCell   = "CommonTableVCCell"
let REUSABLE_ID_TitleBoxCell        = "TitleBoxCell"
let REUSABLE_ID_FilterTitleCell     = "FilterTitleCell"
let REUSABLE_ID_ADD_NEW_CELL = "AddNewCell"
let REUSABLE_ID_PRODUCT_IMAGE_CELL = "ProductImageCell"
let REUSABLE_ID_CART_FOOTER_CELL = "CartFooterView"
let REUSABLE_ID_CART_HEADER_CELL = "CartHeaderView"

//MARK:- Font Style

let FONT_STYLE_DEMI = "Demi"
let FONT_STYLE_BOLD = "Bold"


//MARK:- Strings


let sSOMETHING_WENT_WRONG       = "Something went wrong!"
let S_TRY_AGAIN                 = "Please try agian later"
let sARE_YOU_SURE               = "Are you sure?"

let sLegal_Stuff                = "LEGAL STUFF"
let sPrivacy_Policy             = "PRIVACY POLICY"

let sPOPUP_SEEN_ONCE            = "popup_seen_once"
let sFOLLOW_SEEN_ONCE            = "follow_seen_once"
let sENTRY_ONCE_SEEN            = "sENTRY_ONCE_SEEN"

let S_NO_INTERNET               = "No Internet Available!"
let S_PLEASE_CONNECT            = "Please connect to the Internet"

let S_LOGIN_REGISTER            = "LOGIN / REGISTER"
let S_LOGIN                     = "LOGIN"
let S_MUST_LOGGED_IN            = "You must be logged in to access this feature."


//MARK:- Anonymous Constants

let UNLABEL_EMAIL_ID    = "info@unlabel.us"
let APP_DELEGATE        = UIApplication.shared.delegate as! AppDelegate
let SCREEN_WIDTH        = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT       = UIScreen.main.bounds.size.height



//MARK:- v4 constants

let v4BaseUrl       = "http://35.166.138.246/"
let v4username      = "username"
let v4password      = "password"
let v4first_name    = "first_name"
let v4email         = "email"
let v4accessToken   = "access_token"

let CART_HEADER_CELL_HEIGHT: CGFloat = 58.0
let CART_ITEM_CELL_HEIGHT: CGFloat = 271.0
let CART_FOOTER_CELL_HEIGHT: CGFloat = 368.0

struct Strings{
  static let clear = "CLEAR"
}
