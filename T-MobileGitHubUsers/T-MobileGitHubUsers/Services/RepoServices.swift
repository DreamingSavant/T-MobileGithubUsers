//
//  RepoServices.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

typealias RepoHandler = (_ result: Result<[UserRepo],ErrorDescription>) -> Void

protocol RepoServiceType {
    func getRepos(_ url: URL?, completionHandler: @escaping RepoHandler)
}

class RepoService: RepoServiceType {
    func getRepos(_ url: URL?, completionHandler: @escaping RepoHandler) {
        guard let url = url else {
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
                let result = try JSONDecoder().decode([UserRepo].self, from: dataReceived)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(.init(errorDescription: error.localizedDescription)))
                return
            }
            
        }.resume()
    }
}
