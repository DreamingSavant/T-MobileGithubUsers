//
//  URL+Extension.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

typealias ImageHandler = (UIImage?) -> Void

extension URL {
    
    /// Image downloader functionality
    /// - Parameter completion: Completion handler for updating the UI
    func downloadImage(completion: @escaping ImageHandler) {
        URLSession.shared.dataTask(with: self) { (dat, _, _) in
            let image: UIImage?
            if let data = dat {
                image = UIImage(data: data)
            } else {
                image = .questionMark
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
}
