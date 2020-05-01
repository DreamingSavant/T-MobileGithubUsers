//
//  UILabel+Extension.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// Convenience init to create a factory for UILabels
    /// - Parameters:
    ///   - textAlignment: The technique to use for aligning the text.
    ///   - numberOfLines: The maximum number of lines to use for rendering text.
    convenience init(textAlignment: NSTextAlignment, numberOfLines: Int) {
        self.init()
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.text = "Label"
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
