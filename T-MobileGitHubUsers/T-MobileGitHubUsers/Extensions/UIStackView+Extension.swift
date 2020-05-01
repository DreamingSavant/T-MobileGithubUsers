//
//  UIStackView+Extension.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

extension UIStackView {
    
    /// Convenience init to create a factory for UIStackViews
    /// - Parameters:
    ///   - axis: The axis along which the arranged views are laid out.
    ///   - alignment: The alignment of the arranged subviews perpendicular to the stack view’s axis.
    ///   - distribution: The distribution of the arranged views along the stack view’s axis.
    convenience init(axis: NSLayoutConstraint.Axis,
                     alignment: Alignment,
                     distribution: Distribution) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = 4
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
