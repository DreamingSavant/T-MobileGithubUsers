//
//  API.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

struct API {
    
    enum GitURL: String, RawRepresentable {
        case base = "https://api.github.com/search/users?q="
        case rateLimit = "https://api.github.com/rate_limit"
    }
    
    var searchTerm: String
    let base = GitURL.base.rawValue
    
    init(_ searchTerm: String) {
        self.searchTerm = searchTerm
    }
    
    var userLink: URL? {
        return URL(string: base + searchTerm)
    }
}
