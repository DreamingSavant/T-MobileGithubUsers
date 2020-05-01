//
//  UserList.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

protocol UserListType {
    var users: [User] { get }
}

struct UserList: UserListType, Decodable {
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}
