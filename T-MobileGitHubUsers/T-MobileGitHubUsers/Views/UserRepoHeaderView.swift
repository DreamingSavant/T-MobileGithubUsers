//
//  UserRepoHeaderView.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

class UserRepoHeaderView: UITableViewHeaderFooterView {
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .questionMark)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private lazy var emailLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private lazy var locationLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private lazy var joinDateLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private lazy var followersLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private lazy var followingLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private lazy var bioLabel: UILabel = .init(textAlignment: .left, numberOfLines: 0)
    
    private lazy var searchField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Repos"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: CellIdentifier.RepoHeader.rawValue)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        // View Hierarchy
        let innerVStackView = UIStackView.init(axis: .vertical, alignment: .leading, distribution: .fillEqually)
        innerVStackView.addArrangedSubview(nameLabel)
        innerVStackView.addArrangedSubview(emailLabel)
        innerVStackView.addArrangedSubview(locationLabel)
        innerVStackView.addArrangedSubview(joinDateLabel)
        innerVStackView.addArrangedSubview(followersLabel)
        innerVStackView.addArrangedSubview(followingLabel)
        
        let innerHStackView = UIStackView.init(axis: .horizontal,
                                               alignment: .center,
                                               distribution: .fillEqually)
        innerHStackView.addArrangedSubview(avatarImageView)
        innerHStackView.addArrangedSubview(innerVStackView)
        
        let outerVStackView = UIStackView.init(axis: .vertical,
                                               alignment: .center,
                                               distribution: .fill)
        outerVStackView.addArrangedSubview(innerHStackView)
        outerVStackView.addArrangedSubview(bioLabel)
        outerVStackView.addArrangedSubview(searchField)
        
        addSubview(outerVStackView)
        outerVStackView.boundToSuperView(constant: 8)
        
        searchField.leadingAnchor.constraint(equalTo: outerVStackView.leadingAnchor,
                                             constant: 8).isActive = true
        searchField.trailingAnchor.constraint(equalTo: outerVStackView.trailingAnchor,
                                              constant: -8).isActive = true
        searchField.bottomAnchor.constraint(equalTo: outerVStackView.bottomAnchor,
                                            constant: -8).isActive = true
            
    }
    
    func setDelegate(delegate: UISearchBarDelegate) {
        searchField.delegate = delegate
    }
    
    var userVM: UserViewModelType? {
        didSet {
            DispatchQueue.main.async {
                guard let userVM = self.userVM else { return }
                    userVM.avatarURL?.downloadImage { [weak self] (image) in
                        DispatchQueue.main.async {
                            self?.avatarImageView.image = image
                        }
                    }
                self.nameLabel.text = userVM.username
                self.emailLabel.text = userVM.email
                self.locationLabel.text = userVM.location
                self.joinDateLabel.text = userVM.date
                self.followersLabel.text = userVM.followers
                self.followingLabel.text = userVM.following
                self.bioLabel.text = userVM.bio
            }
        }
    }
}
