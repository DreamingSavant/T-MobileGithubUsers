//
//  UserListCellTableViewCell.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

class UserListCellTableViewCell: UITableViewCell {
    
    var userVM: UserViewModelType? {
        didSet {
            DispatchQueue.main.async {
                guard let userVM = self.userVM else { return }
                userVM.avatarURL?.downloadImage { [weak self] (image) in
                    DispatchQueue.main.async {
                        self?.imageView?.image = image
                    }
                }
                self.textLabel?.text = userVM.username
                self.detailTextLabel?.text = userVM.repoCountString
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: CellIdentifier.UserListCell.rawValue)
        imageView?.image = .questionMark
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
