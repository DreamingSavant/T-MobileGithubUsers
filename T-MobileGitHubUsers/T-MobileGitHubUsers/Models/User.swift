//
//  User.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

protocol UserType {
    var url: String? { get }
}

struct User: UserType, Decodable {
    let url: String?
}

protocol UserInfoType {
    var login: String { get }
    var avatarURL: String? { get }
    var reposURL: String? { get }
    var location: String? { get }
    var email: String? { get }
    var bio: String? { get }
    var publicRepos: Int? { get }
    var followers: Int? { get }
    var following: Int? { get }
    var createdAt: String? { get }
}

struct UserInfo: UserInfoType, Decodable {
    let login: String
    let avatarURL: String?
    let reposURL: String?
    let location: String?
    let email: String?
    let bio: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
        case location, email, bio
        case publicRepos = "public_repos"
        case followers, following
        case createdAt = "created_at"
    }
}
