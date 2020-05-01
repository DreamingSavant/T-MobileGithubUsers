//
//  UserRepoTableViewCell.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

class UserRepoTableViewCell: UITableViewCell {
    
    private var repoNameLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private var starsLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    private var forksLabel: UILabel = .init(textAlignment: .left, numberOfLines: 1)
    
    var repoViewModel: UserRepoViewModelType? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                let repoViewModel = self.repoViewModel else { return }
                self.repoNameLabel.text = repoViewModel.name
                self.forksLabel.text = repoViewModel.forks
                self.starsLabel.text = repoViewModel.stars
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: CellIdentifier.RepoCell.rawValue)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        let vStackView = UIStackView.init(axis: .vertical, alignment: .trailing, distribution: .fillEqually)
        vStackView.addArrangedSubview(forksLabel)
        vStackView.addArrangedSubview(starsLabel)
        
        let hStackView = UIStackView.init(axis: .horizontal, alignment: .center, distribution: .fillEqually)
        hStackView.addArrangedSubview(repoNameLabel)
        hStackView.addArrangedSubview(vStackView)
        
        addSubview(hStackView)
        hStackView.boundToSuperView(constant: 2)
    }
    
}
