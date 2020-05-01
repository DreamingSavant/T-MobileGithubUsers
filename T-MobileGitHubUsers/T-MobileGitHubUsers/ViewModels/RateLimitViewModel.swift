//
//  RateLimitViewModel.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

class RateLimitViewModel {
    
    private let rateLimit: RateLimit
    
    init(rateLimit: RateLimit) {
        self.rateLimit = rateLimit
    }
    
    var limitRequest: Int? {
        return rateLimit.rate?.limit
    }
    
    var remainingRequest: Int? {
        return rateLimit.rate?.remaining
    }
    var resetTime: Int? {
        return rateLimit.rate?.reset
    }
}
