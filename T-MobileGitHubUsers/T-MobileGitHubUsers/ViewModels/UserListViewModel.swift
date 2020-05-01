//
//  UserListCiewModel.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

typealias UserCompletionhandler = (_ result: Result<[User], ErrorDescription>) -> Void

protocol UserListViewModelType {
    var update: (() -> Void)? { get set }
    var onError: (() -> Void)? { get set }
    var error: ErrorDescription? { get }
    
    func getUsers(searchTerm: String)
    func getUserVM(for index: Int) -> UserViewModelType
    func getCountOfUsers() -> Int
}

class UserListViewModel: UserListViewModelType {
        
    var userListService: UserListServiceType
    var userService: UserServiceType
    var rateLimitNetworkService: RateLimitServiceType
    var currentSearch: DispatchWorkItem?
    
    var update: (() -> Void)?
    var onError: (() -> Void)?
        
    private var users = [UserInfo]() {
        didSet {
            self.update?()
        }
    }
        
    private var rateLimit = RateLimit()
        
    var error: ErrorDescription? {
        didSet {
            if error != nil {
                self.onError?()
            }
        }
    }
        
    init(userListService: UserListServiceType,
             userService: UserServiceType,
             rateLimitService: RateLimitServiceType,
             update: @escaping (() -> Void),
             onError: @escaping (() -> Void)) {
        self.userListService = userListService
        self.userService = userService
        self.rateLimitNetworkService = rateLimitService
        self.update = update
        self.onError = onError
    }
        
    func getUserVM(for index: Int) -> UserViewModelType {
        return UserViewModel(userInfo: users[index], repoService: RepoService())
    }

    func getCountOfUsers() -> Int {
        return users.count
    }

    func getUsers(searchTerm: String) {
        guard searchTerm.isEmpty == false else { return }
        
        currentSearch?.cancel()
        
        let newSearch = DispatchWorkItem { [weak self] in
            let userCompletion: UserCompletionhandler = { [weak self] response in
                guard let strongSelf = self else { return }
                switch response {
                    case .success(let users):
                        strongSelf.fetchUsers(users)
                    case .failure(let error):
                        strongSelf.error = error
                }
            }
            self?.userListService.getUserList(searchterm: searchTerm, completionHandler: userCompletion)
        }
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.5,
                                                       execute: newSearch)
        currentSearch = newSearch
    }

    private func fetchUsers(_ users: [User]) {
        var userInfos = [UserInfo]()
        var errors = [ErrorDescription]()
        let lock = NSLock()
        let group = DispatchGroup()
        for user in users {
            group.enter()
            self.userService.getUser(user.url ?? "") { response in
                defer { group.leave() }
                lock.lock(); defer { lock.unlock() }
                switch response {
                    case .success(let userDetail):
                        userInfos.append(userDetail)
                    case .failure(let error):
                        errors.append(error)
                }
            }
        }
        group.notify(queue: .main) {
            if userInfos.isEmpty {
                self.determineError(with: errors)
            } else {
                self.error = nil
                self.users = userInfos
            }
        }
    }

    func getRateLimit(completionHandler: @escaping(RateLimitViewModel?) -> Void) {
        rateLimitNetworkService.getRateLimit { (response) in
            switch response {
                case .success(let rate):
                    let RateLimitVM = RateLimitViewModel(rateLimit: rate)
                    completionHandler(RateLimitVM)
                case .failure:
                    completionHandler(nil)
            }
        }
    }

    func determineError(with errors: [ErrorDescription]) {
        self.getRateLimit { response in
            let error: ErrorDescription
            if let response = response, let remainingRequest = response.remainingRequest, remainingRequest == 0 {
                let timeRemaining = response.resetTime?.remaining
                let errorString = """
                You are out of requests! Please try again in \(timeRemaining?.minutes ?? 0) minutes and \(timeRemaining?.seconds ?? 0) seconds.
                """
                error = ErrorDescription(errorDescription: errorString)
            }
            else {
                error = errors.first ?? ErrorDescription.rateLimitExceeded
            }
            self.error = error
            self.users = []
        }
    }
}
