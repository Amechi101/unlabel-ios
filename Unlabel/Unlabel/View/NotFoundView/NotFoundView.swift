//
//  NotFoundView.swift
//  Unlabel
//
//  Created by Zaid Pathan on 29/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol NotFoundViewDelegate {
    func didSelectViewLabels()
}
class NotFoundView: UIView {

    var delegate:NotFoundViewDelegate?
    
    @IBAction func IBActionViewLabels(sender: AnyObject) {
        delegate?.didSelectViewLabels()
    }
}
