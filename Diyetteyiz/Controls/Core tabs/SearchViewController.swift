//
//  SearchViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import JGProgressHUD

class SearchViewController: UIViewController {

    public var completion: ((SearchResult) -> (Void))?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: Any]]()
    private var results = [SearchResult]()
    private var menuResults = [MenuViewModel]()
    private var hasFetched = false
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "İsim arama"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UserSearchTableViewCell.self, forCellReuseIdentifier: UserSearchTableViewCell.identifier)
        return table
    }()
    
    private let dietitianButton: UIButton = {
        let button = UIButton()
        button.setTitle("Diyetisyenler", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    
    private let userButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kullanıcılar", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    
    private let productsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Menüler", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    
    private let noResultLabel: UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text = "Sonuç yok"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setDelegates()
        setNavItem()
        setButtonActions()
        
        dietitianButton.isSelected = true
        dietitianButton.backgroundColor = .link
        
        searchBar.becomeFirstResponder()
    }
    
    private func setNavItem() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "İptal", style: .done, target: self, action: #selector(dismissSelf))
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func setButtonActions() {
        dietitianButton.addTarget(self, action: #selector(didTapDietitianButton), for: .touchUpInside)
        userButton.addTarget(self, action: #selector(didTapUsersButton), for: .touchUpInside)
        productsButton.addTarget(self, action: #selector(didTapMenusButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        view.addSubview(dietitianButton)
        view.addSubview(userButton)
        view.addSubview(productsButton)
    }
    
    @objc private func didTapDietitianButton() {
        dietitianButton.isSelected = true
        dietitianButton.backgroundColor = .link
        
        userButton.isSelected = false
        userButton.backgroundColor = .systemGreen
        
        productsButton.isSelected = false
        productsButton.backgroundColor = .systemGreen
        
        hasFetched = false
        
        tableView.register(UserSearchTableViewCell.self, forCellReuseIdentifier: UserSearchTableViewCell.identifier)
    }
    
    @objc private func didTapUsersButton() {
        dietitianButton.isSelected = false
        dietitianButton.backgroundColor = .systemGreen
        
        userButton.isSelected = true
        userButton.backgroundColor = .link
        
        productsButton.isSelected = false
        productsButton.backgroundColor = .systemGreen
        
        hasFetched = false
        
        tableView.register(UserSearchTableViewCell.self, forCellReuseIdentifier: UserSearchTableViewCell.identifier)
    }
    
    @objc private func didTapMenusButton() {
        dietitianButton.isSelected = false
        dietitianButton.backgroundColor = .systemGreen
        
        userButton.isSelected = false
        userButton.backgroundColor = .systemGreen
        
        productsButton.isSelected = true
        productsButton.backgroundColor = .link
        
        hasFetched = false
        
        tableView.register(DietitianProfileMenusTableViewCell.self, forCellReuseIdentifier: DietitianProfileMenusTableViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        dietitianButton.frame = CGRect(x: 10, y: view.top + 120, width: view.width/3-10, height: 20)
        userButton.frame = CGRect(x: dietitianButton.right + 5, y: view.top + 120, width: view.width/3-10, height: 20)
        productsButton.frame = CGRect(x: userButton.right + 5, y: view.top + 120, width: view.width/3-10, height: 20)
        tableView.frame = CGRect(x: 0, y: dietitianButton.bottom, width: view.width, height: view.height)
        noResultLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    @objc private func dismissSelf() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func openConversation(_ model: SearchResult){
        let vc = SearchProfileViewController(with: model.email, name: model.name)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openMenu(_ model: MenuViewModel){
        let vc = MenuViewController(with: model.dietitianBind, id: model.header, picLoc: model.headerPicLoc)
        vc.title = "Menü"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsButton.isSelected {
            return menuResults.count
        } else {
            return results.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if productsButton.isSelected {
            let model = menuResults[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: DietitianProfileMenusTableViewCell.identifier, for: indexPath) as! DietitianProfileMenusTableViewCell
            cell.configure(with: model)
            return cell
        } else {
            let model = results[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchTableViewCell.identifier, for: indexPath) as! UserSearchTableViewCell
            cell.configure(with: model)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if productsButton.isSelected {
            let model = menuResults[indexPath.row]
            openMenu(model)
        } else {
            let model = results[indexPath.row]
            openConversation(model)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if productsButton.isSelected {
            return 180
        } else {
            return 90
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        results.removeAll()
        menuResults.removeAll()
        tableView.reloadData()
        
        spinner.show(in: view)
        if userButton.isSelected {
            searchUsers(query: text)
            self.spinner.dismiss()
        } else if dietitianButton.isSelected {
            searchDietitians(query: text)
            self.spinner.dismiss()
        } else if productsButton.isSelected {
            getMenu(with: text)
            self.spinner.dismiss()
        }
    }
    
    private func getMenu(with query: String) {
        hasFetched = false
        if hasFetched {
            filterMenus(with: query)
        }else{
            DatabaseManager.shared.getAllMenus(completion: { [weak self]result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterMenus(with: query)
                case .failure(let error):
                    print("Kullanıcı bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    
    private func filterMenus(with term: String) {
        
        let results: [MenuViewModel] = users.filter({
            guard let name = ($0["header"] as? String)?.lowercased() else {
                return false
            }
            
            return (name as AnyObject).hasPrefix(term.lowercased())
        }).compactMap({
            guard let header = $0["header"] as? String, let info = $0["info"] as? String , let price = $0["price"] as? String , let dietitianBind = $0["dietitianBind"] as? String , let days = $0["days"] as? Int , let headerPicLoc = $0["photoLoc"] as? String else {
                return nil
            }
            
            return MenuViewModel(header: header, info: info, price: price, dietitianBind: dietitianBind, days: days, headerPicLoc: headerPicLoc)
        })
        self.menuResults = results
        
        updateUI()
    }
    
    func searchDietitians(query: String) {
        if hasFetched {
            filterUser(with: query)
        }else{
            DatabaseManager.shared.getAllDietitians(completion: { [weak self]result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUser(with: query)
                case .failure(let error):
                    print("Diyetisyen bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    func searchUsers(query: String) {
        if hasFetched {
            filterUser(with: query)
        }else{
            DatabaseManager.shared.getAllUsers(completion: { [weak self]result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUser(with: query)
                case .failure(let error):
                    print("Kişi bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    func filterUser(with term: String) {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }
        
        let safeMaille = DatabaseManager.safeEmail(emailAdress: currentUserEmail)
        
        let results: [SearchResult] = users.filter({
            guard let email = $0["email"], email as! String != safeMaille else {
                    return false
            }
            
            guard let name = ($0["name"] as? String)?.lowercased() else {
                return false
            }
            
            return name.hasPrefix(term.lowercased())
        }).compactMap({
            guard let email = $0["email"] as? String, let name = $0["name"] as? String, let bio = $0["bio"] as? String else {
                return nil
            }
            
            return SearchResult(email: email, name: name, info: bio, ppUrl: "")
        })
        self.results = results
        
        updateUI()
    }
    func updateUI() {
        if !(results.isEmpty || menuResults.isEmpty) {
            noResultLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noResultLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}

