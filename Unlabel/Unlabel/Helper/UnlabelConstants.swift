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
//MARK:- AWS Constants
//
let CognitoRegionType = AWSRegionType.USEast1  // e.g. AWSRegionType.USEast1
let DefaultServiceRegionType = AWSRegionType.USEast1 // e.g. AWSRegionType.USEast1
let CognitoIdentityPoolId = "us-east-1:b660d049-9d0d-4e48-820e-4e32fd614ed7"
let S3_BUCKET_NAME = "unlabel-userfiles-mobilehub-626392447"


//
//MARK:- UIColor Constants
//
let LIGHT_GRAY_TEXT_COLOR = UIColor(red: 177/255, green: 179/255, blue: 184/255, alpha: 1)

//#charcoalGrey
let MEDIUM_GRAY_TEXT_COLOR = UIColor(red: 69/255, green: 73/255, blue: 78/255, alpha: 1)

let LIGHT_GRAY_BORDER_COLOR = UIColor(red: 153/255, green: 156/255, blue: 165/255, alpha: 1)

//
//MARK:- Storyboard Names
//
let S_NAME_UNLABEL = "Unlabel"
let S_NAME_ADMIN   = "Admin"


//
//MARK:- Storyboard IDs
//
let S_ID_FEED_VC                    = "FeedVC"
let S_ID_LABEL_VC                   = "LabelVC"
let S_ID_FILTER_VC                  = "FilterVC"
let S_ID_ADDLABEL_VC                = "AddLabelVC"
let S_ID_LEFT_MENU_VC               = "LeftMenuVC"
let S_ID_LABEL_LIST_VC              = "LabelListVC"
let S_ID_NAV_CONTROLLER             = "NavController"
let S_ID_ADMIN_NAV_CONTROLLER       = "AdminNavController"


//
//MARK:- Cell Reusable IDs
//
let REUSABLE_ID_LabelCell           = "LabelCell"
let REUSABLE_ID_GenderCell          = "GenderCell"
let REUSABLE_ID_FeedVCCell          = "FeedVCCell"
let REUSABLE_ID_LocationCell        = "LocationCell"
let REUSABLE_ID_LabelHeaderCell     = "LabelHeaderCell"
let REUSABLE_ID_CategoryStyleCell   = "CategoryStyleCell"

//
//MARK:- Font Style
//
let FONT_STYLE_DEMI = "Demi"
let FONT_STYLE_BOLD = "Bold"

//
//MARK:- Strings
//
let sSOMETHING_WENT_WRONG = "Something Went Wrong!"


//
//MARK:- Anonymous Constants
//
let SCREEN_WIDTH        = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT       = UIScreen.mainScreen().bounds.size.height