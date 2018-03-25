//
//  CustomTextView.swift
//  Givo
//
//  Created by SS-181 on 10/26/16.
//  Copyright © 2016 Singsys-112. All rights reserved.
//  by one and only Sarthak Sharma

import Foundation
import UIKit

class CustomTextView: UITextView {
    
    
    override func awakeFromNib()
    {
       self.isEditable = false
       self.isScrollEnabled = false
    }
    
    //MARK:- Disabling selection options
    //    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
    //        if action == #selector(NSObject.paste(_:)) || action == #selector(NSObject.copy(_:)) || action == #selector(NSObject.selectAll(_:)) || action == #selector(NSObject.selectAll(_:)) || action == #selector(NSObject.selectAll(_:)){
    //            return false
    //        }
    //
    //        return super.canPerformAction(action, withSender: sender)
    //    }
    
    
    //MARK:- Making selection menu invisible
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        return false
    }
    
    //MARK:- Preventing long press gesture so their be no selection
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (gestureRecognizer is UITapGestureRecognizer) {
//            if (gestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired > 1 {
//                return true
//            }
//
//            return true
//        }
//        else if gestureRecognizer is UIPanGestureRecognizer
//        {
//            //To make tableView scroll
//            return true
//        }
        return true
    }
    
}
