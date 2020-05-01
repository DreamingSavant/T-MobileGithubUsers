//
//  UserListViewController.swift
//  T-MobileGitHubUsers
//
//  Created by Roderick Presswoodd on 4/30/20.
//  Copyright © 2020 Roderick Presswoodd. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userListVM: UserListViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserListCellTableViewCell.self, forCellReuseIdentifier: CellIdentifier.UserListCell.rawValue)
        // SearchBar
        searchBar.delegate = self
        // ViewModel
        let update = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        let onError = { [weak self] in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                let errorMessage = strongSelf.userListVM.error?.errorDescription ?? "Unknown Error"
                strongSelf.showErrorAlert(text: errorMessage)
            }
        }
        userListVM = UserListViewModel(userListService: UserListService(), userService: UserService(), rateLimitService: RateLimitNetworkService(), update: update, onError: onError)
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userViewModel = userListVM.getUserVM(for: indexPath.row)
        if let vc = UserRepoViewController.createViewController(userViewModel: userViewModel) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListVM.getCountOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.UserListCell.rawValue, for: indexPath) as? UserListCellTableViewCell else {
            fatalError("Something went wrong")
        }
        cell.userVM = userListVM.getUserVM(for: indexPath.row)
        return cell
    }
}

extension UserListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userListVM.getUsers(searchTerm: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userListVM.getUsers(searchTerm: searchBar.text ?? "")
    }
}
