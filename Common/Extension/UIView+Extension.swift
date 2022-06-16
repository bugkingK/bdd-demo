//
//  UIView+Extension.swift
//  Common
//
//  Created by josh.fn7 on 2022/06/16.
//

import UIKit

public extension UIView {
    
    var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }
    
}
