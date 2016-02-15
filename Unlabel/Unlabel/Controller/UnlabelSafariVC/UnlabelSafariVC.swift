//
//  UnlabelSafariVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 15/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SafariServices

class UnlabelSafariVC: SFSafariViewController {
    var edgeView: UIView? {
        get {
            if (_edgeView == nil && isViewLoaded()) {
                _edgeView = UIView()
                _edgeView?.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(_edgeView!)
                _edgeView?.backgroundColor = UIColor(white: 1.0, alpha: 0.005)
                let bindings = ["edgeView": _edgeView!]
                let options = NSLayoutFormatOptions(rawValue: 0)
                let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[edgeView(5)]", options: options, metrics: nil, views: bindings)
                let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[edgeView]-0-|", options: options, metrics: nil, views: bindings)
                view?.addConstraints(hConstraints)
                view?.addConstraints(vConstraints)
            }
            return _edgeView
        }
    }
    private var _edgeView: UIView?
}
