//
//  Int+Extension.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

extension Int {
    
    /// Helper variable to find the remaining time for the data cap to be reset
    var remaining: (minutes: Int, seconds: Int) {
        let expirationDate = Date(timeIntervalSince1970: TimeInterval(self))
        let timeRemaining = expirationDate.timeIntervalSince(Date())
        return (Int(timeRemaining / 60.0),
                Int(timeRemaining.truncatingRemainder(dividingBy: 60.0)))
    }
}
