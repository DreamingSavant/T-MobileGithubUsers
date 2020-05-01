//
//  RateLimit.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

struct RateLimit: Codable {
    var resources: Resources?
    var rate: Rate?
}

struct Rate: Codable {
    var limit, remaining, reset: Int?
}

struct Resources: Codable {
    var core, graphql, manifest, search: Rate?

    enum CodingKeys: String, CodingKey {
        case core
        case graphql
        case manifest = "integration_manifest"
        case search
    }
}
