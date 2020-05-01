//
//  UserServices.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

typealias UserHandler = (_ result: Result<UserInfo, ErrorDescription>) -> Void

protocol UserServiceType {
    func getUser(_ url: String, completionHandler: @escaping UserHandler)
}

class UserService: UserServiceType {
    
    func getUser(_ url: String, completionHandler: @escaping UserHandler) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(.init(errorDescription: "Bad URL")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let errorReceived = error {
                completionHandler(.failure(.init(errorDescription: errorReceived.localizedDescription)))
                return
            }
            guard let dataReceived = data else {
                completionHandler(.failure(.init(errorDescription: "No data returned")))
                return
            }
            do {
                let userInfo = try JSONDecoder().decode(UserInfo.self, from: dataReceived)
                completionHandler(.success(userInfo))
            } catch {
                completionHandler(.failure(.rateLimitExceeded))
            }
            
        }.resume()
    }
    
}
