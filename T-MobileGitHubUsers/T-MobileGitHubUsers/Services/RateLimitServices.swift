//
//  RateLimitServices.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import Foundation

protocol RateLimitServiceType {
    func getRateLimit(completion: @escaping (_ result: Result<RateLimit, ErrorDescription>) -> Void)
}

class RateLimitNetworkService: RateLimitServiceType {
    func getRateLimit(completion: @escaping (_ result: Result<RateLimit, ErrorDescription>) -> Void) {
        let rateLimitString = API.GitURL.rateLimit.rawValue
        
        guard let rateLink = URL(string: rateLimitString) else {
            return
        }
        URLSession.shared.dataTask(with: rateLink) { (data, _, _) in
            guard let rateLimit = data else {
                completion(.failure(.init(errorDescription: "Rate Limit Data")))
                return
            }
            do {
                let result = try JSONDecoder().decode(RateLimit.self, from: rateLimit)
                completion(.success(result))
                
            } catch {
                completion(.failure(.init(errorDescription: error.localizedDescription)))
                return
            }
        }.resume()
    }
}
