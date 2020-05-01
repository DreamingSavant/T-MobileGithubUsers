//
//  UIView+Extension.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Helper function to bound a view fully to it's superview with top, bottom, trailing, and leading anchors
    /// - Parameter constant: Constant used for constraints
    func boundToSuperView(constant: CGFloat) {
        guard let superview = self.superview else { return }
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
    }
    
}
