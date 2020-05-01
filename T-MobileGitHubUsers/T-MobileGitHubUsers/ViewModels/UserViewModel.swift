//
//  UserViewModel.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

protocol UserViewModelType {
    var avatarURL: URL? { get }
    var username: String { get }
    var email: String { get }
    var location: String { get }
    var date: String { get }
    var followers: String { get }
    var following: String { get }
    var bio: String { get }
    var repoCount: Int { get }
    var repoCountString: String { get }
    var update: (() -> Void)? { get set }
    var reposCount: Int { get }
    
    func url(index: Int) -> URL?
    func makeRepoViewModel(index: Int) -> UserRepoViewModelType
    func getRepos()
    func search(_ searchTerm: String)
}

class UserViewModel: UserViewModelType {
    
    lazy var dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    private let user: UserInfo
    let repoService: RepoServiceType
    
    var update: (() -> Void)?
    var onError: (() -> Void)?
    private var _repos: [UserRepo] = [] {
        didSet {
            repos = _repos
        }
    }
    
    private var repos: [UserRepo] = [] {
        didSet {
            userRepoViewModels.removeAll(keepingCapacity: true)
            for repo in repos {
                let repoViewModel = UserRepoViewModel(repo: repo)
                userRepoViewModels.append(repoViewModel)
            }
            self.update?()
        }
    }
    
    private var userRepoViewModels: [UserRepoViewModelType] = []
    
    private(set) var error: ErrorDescription? {
        didSet {
            if error != nil {
                self.onError?()
            }
        }
    }
    
    init(userInfo: UserInfo,
         repoService: RepoServiceType) {
        self.user = userInfo
        self.repoService = repoService
    }
    
}

extension UserViewModel {
    
    var username: String {
        return user.login
    }
    
    var avatarURL: URL? {
        return URL(string: user.avatarURL ?? "")
    }
    
    var reposURL: URL? {
        return URL(string: user.reposURL ?? "")
    }
    
    var repoCount: Int {
        return user.publicRepos ?? 0
    }
        
    var repoCountString: String {
        return "Repos: " + String(user.publicRepos ?? 0)
    }
    
    var email: String {
        return "Email: \(user.email ?? "Unavailable")"
    }
    
    var bio: String {
        return "Bio: \(user.bio ?? "Unavailable")"
    }
    
    var location: String {
        return "Location: \(user.email ?? "Unavailable")"
    }
    
    var followers: String {
        return String(user.followers ?? 0) + " Followers"
    }
    
    var following: String {
        return "Following " + String(user.following ?? 0)
    }
    
    var date: String {
        guard let readableDate = dateFormatter.date(from: user.createdAt ?? "") else { return "Joined: \(user.createdAt ?? "Unavailable")" }
        dateFormatter.formatOptions = .withDashSeparatorInDate
        return dateFormatter.string(from: readableDate)
    }
    
    func url(index: Int) -> URL? {
        return userRepoViewModels[index].url
    }
    
    var reposCount: Int {
        return userRepoViewModels.count
    }
    
}

extension UserViewModel {
    
    func getRepos() {
        repoService.getRepos(reposURL) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
                case .success(let repos):
                    self._repos = repos
                case .failure(let error):
                    self.error = error
            }
        }
    }
    
    func search(_ searchTerm: String) {
        if searchTerm.isEmpty {
            repos = _repos
            return
        }
        let query = searchTerm.lowercased()
        repos = _repos.filter {
            $0.name.lowercased().contains(query)
        }
    }
    
    func makeRepoViewModel(index: Int) -> UserRepoViewModelType {
        return userRepoViewModels[index]
    }
    
    func repoUrl(index: Int) -> URL {
        let repo = repos[index]
        guard let url = URL(string: repo.url) else { fatalError() }
        return url
    }
}
