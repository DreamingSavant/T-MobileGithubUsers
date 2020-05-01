//
//  UserRepoViewController.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

class UserRepoViewController: UIViewController {

    @IBOutlet weak var repoTableView: UITableView!
    
    var userViewModel: UserViewModelType?
    
    static func createViewController(userViewModel: UserViewModelType) -> UserRepoViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: ViewControllerIdentifier.UserRepoViewController.rawValue) as? UserRepoViewController
        vc?.userViewModel = userViewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        repoTableView.delegate = self
        repoTableView.dataSource = self
            
        repoTableView.register(UserRepoHeaderView.self, forHeaderFooterViewReuseIdentifier: CellIdentifier.RepoHeader.rawValue)
        repoTableView.register(UserRepoTableViewCell.self, forCellReuseIdentifier: CellIdentifier.RepoCell.rawValue)
        
        repoTableView.rowHeight = UITableView.automaticDimension
        repoTableView.estimatedRowHeight = 100.0
        repoTableView.sectionHeaderHeight = UITableView.automaticDimension
        repoTableView.estimatedSectionHeaderHeight = 100.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userViewModel?.update = {
            DispatchQueue.main.async {
                self.repoTableView.reloadData()
            }
        }
        userViewModel?.getRepos()
    }
    
}

extension UserRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = userViewModel?.url(index: indexPath.row) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension UserRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel?.reposCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellIdentifier.RepoHeader.rawValue) as? UserRepoHeaderView
        
        header?.userVM = userViewModel
        header?.setDelegate(delegate: self)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.RepoCell.rawValue, for: indexPath) as? UserRepoTableViewCell else {
            fatalError("Something went wrong")
        }
        cell.repoViewModel = userViewModel?.makeRepoViewModel(index: indexPath.row)
        return cell
    }
    
}

extension UserRepoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userViewModel?.search(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userViewModel?.search(searchBar.text ?? "")
    }
}
