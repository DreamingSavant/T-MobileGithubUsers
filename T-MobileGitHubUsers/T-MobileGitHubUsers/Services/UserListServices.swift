//
//  UserListServices.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

typealias UserListCompletionhandler = (_ result: Result<[User], ErrorDescription>) -> Void

protocol UserListServiceType {
    func getUserList(searchterm: String, completionHandler: @escaping UserListCompletionhandler)
}

class UserListService: UserListServiceType {
    func getUserList(searchterm: String, completionHandler: @escaping UserListCompletionhandler) {
        guard !searchterm.isEmpty,
            let urlLink = API(searchterm).userLink else {
                completionHandler(.failure(.init(errorDescription: "This is not a good URL link")))
                return
        }
        
        URLSession.shared.dataTask(with: urlLink) { (data, response, error) in
            if let errorReceived = error {
                completionHandler(.failure(.init(errorDescription: errorReceived.localizedDescription)))
                return
            }
            // unwrap the HTTPS response code
            if let httpResponse = response as? HTTPURLResponse {
                // if we receive a valid response code,
                if  (200...299).contains(httpResponse.statusCode) {
                    guard let data = data else {
                        completionHandler(.failure(.init(errorDescription: "No data returned")))
                        return
                    }
                    do {
                        let userList = try JSONDecoder().decode(UserList.self, from: data)
                        completionHandler(.success(userList.users))
                    } catch {
                        completionHandler(.failure(.init(errorDescription: error.localizedDescription)))
                        return
                    }
                } else {
                    completionHandler(.failure(.init(errorDescription: "Error: \(httpResponse.statusCode)")))
                    return
                }
            }
        }.resume()
    }
}
