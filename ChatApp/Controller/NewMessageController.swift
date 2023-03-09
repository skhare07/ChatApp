//
//  NewMessageController.swift
//  ChatApp
//
//  Created by Apple on 06/12/1944 Saka.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller:  NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController : UITableViewController{
    
    //MARK: - Properties
    
    private var users = [User]()
    private var filteredUsers = [User]()
    
    weak var delegate: NewMessageControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode : Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    //MARK: - Selectors
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API
    
    func fetchUsers(){
        
        showLoader(true)
        Service.fetchUsers { users in
            
            self.showLoader(false)
            self.users = users
            self.tableView.reloadData()
            
            print("DEBUG: Users in new message controller\(users)")
        }
    }
    
    
    
    //MARK: - Helpers
    func configureUI(){
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
    
}

//MARK: - UITableViewDelegate

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        print("DEBUG: Index row is \(indexPath.row)")
        print("DEBUG: User in array is \(users[indexPath.row].username)")
        return cell
    }
    
    
}

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Selected user is \(users[indexPath.row].username)")
        
        let user =  inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]

        delegate?.controller(self, wantsToStartChatWith: user)
    }
}

extension NewMessageController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ user in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        self.tableView.reloadData()

    }
    
    
}
