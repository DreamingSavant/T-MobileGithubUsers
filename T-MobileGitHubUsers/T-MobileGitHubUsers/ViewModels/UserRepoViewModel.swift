//
//  UserRepoViewModel.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

protocol UserRepoViewModelType {
    var name: String { get }
    var forks: String { get }
    var stars: String { get }
    var url: URL? { get }
}

class UserRepoViewModel: UserRepoViewModelType {
    
    private let repo: RepoType
    
    init(repo: RepoType) {
        self.repo = repo
    }
    
    var name: String {
        return repo.name
    }
    
    var forks: String {
        return String(repo.forks) + " Forks"
    }
    
    var stars: String {
        return String(repo.stars) + " Stars"
    }
    
    var url: URL? {
        return URL(string: repo.url)
    }

}
