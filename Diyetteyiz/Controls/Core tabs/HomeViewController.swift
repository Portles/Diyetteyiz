//
//  ViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    public var completion: ((SearchResult) -> (Void))?
    
    private var users = [[String: Any]]()
    private var results = [SearchResult]()
    private var hasFetched = false
    
    private let dietitiansTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(HomeDietitianTableViewCell.self, forCellReuseIdentifier: HomeDietitianTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dietitiansTableView)
        
        dietitiansTableView.delegate = self
        dietitiansTableView.dataSource = self
        
        navigationItem.title = "Anasayfa"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Bildirimler", style: .done, target: self, action: #selector(didTapNotificationButton))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dietitiansTableView.frame = CGRect(x: 0, y: 100, width: view.width, height: view.height/2)
    }

    @objc private func didTapNotificationButton() {
        let vc = NotificationsViewController()
        vc.title = "Bildirimler"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        searchDietitians()
    }

    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    
    func searchDietitians() {
        if hasFetched {
            filterUser()
        }else{
            DatabaseManager.shared.getAllDietitians(completion: { [weak self]result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUser()
                case .failure(let error):
                    print("Diyetisyen bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    func filterUser() {
        let results: [SearchResult] = users.compactMap({
            guard let email = $0["email"] as? String, let name = $0["name"] as? String else {
                return nil
            }
            
            return SearchResult(email: email, name: name, info: "", ppUrl: "")
        })
        self.results = results
        
        dietitiansTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeDietitianTableViewCell.identifier, for: indexPath) as! HomeDietitianTableViewCell
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
