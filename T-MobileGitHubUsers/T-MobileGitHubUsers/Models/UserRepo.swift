//
//  UserRepo.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

protocol RepoType {
    var name: String { get }
    var forks: Int { get }
    var stars: Int { get }
    var url: String { get }
}

struct UserRepo: RepoType, Decodable {
    let name: String
    let forks: Int
    let stars: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case forks = "forks_count"
        case stars = "stargazers_count"
        case url = "html_url"
    }
}
