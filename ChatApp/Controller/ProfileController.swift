//
//  ProfileController.swift
//  ChatApp
//
//  Created by Apple on 10/12/1944 Saka.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate {
    func handleLogout()
}

class ProfileController : UITableViewController {
    
    //MARK: - Properties
    
    
    
    private var user: User?{
        didSet{ headerView.user = user }
    }
    
     var delegate: ProfileControllerDelegate?

    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))

    private let footerView = ProfileFooter()
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    //MARK: - Selectors
    
    //MARK: - API
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        showLoader(true)
        Service.fetchUser(withUid: uid) { user in
            
            self.showLoader(false)
            self.user = user
        }
    }
    
    
    //MARK: - Helpers
    
    func configureUI(){
        
        
        tableView.backgroundColor = .white
       
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        headerView.backgroundColor = .systemPurple
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        
        footerView.delegate = self
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
    }
    
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

//tableview Delegate


extension ProfileController{

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else {return}
        switch viewModel {
        case .accountInfo:
            print("Show account info page")
        case .settings:
            print("Show Settings page")
        
        }
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}


// ProfileHeader Delegate
extension ProfileController: ProfileHeaderDelegate{
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

// ProfileFooter Delegate

extension ProfileController: ProfileFooterDelegate{
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure ypu want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        }
    
    
}
