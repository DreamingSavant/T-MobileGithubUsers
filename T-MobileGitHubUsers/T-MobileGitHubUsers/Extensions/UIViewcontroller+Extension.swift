//
//  UIViewcontroller+Extension.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Convenience alert presenter function
    /// - Parameter text: Main text to be displayed on alert
    func showErrorAlert(text: String) {
        showAlert(text: text, subtext: "Try again soon.")
    }
    
    /// Function to present an alert controller
    /// - Parameters:
    ///   - text: Main text to be displayed on alert
    ///   - subtext: Subtext to be displayed on alert
    func showAlert(text: String, subtext: String? = nil) {
        let alert = UIAlertController(title: text, message: subtext, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
