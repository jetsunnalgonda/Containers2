//
//  Extensions.swift
//  Containers
//
//  Created by Haluk Isik on 7/30/15.
//  Copyright (c) 2015 Haluk Isik. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView Extension
extension UIView {
    
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}