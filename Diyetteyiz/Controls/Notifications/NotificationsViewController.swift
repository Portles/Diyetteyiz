//
//  NewNotificationsViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 6.03.2021.
//

import UIKit
import JGProgressHUD

class NotificationsViewController: UIViewController {

    public var completion: ((NotificationModel) -> (Void))?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var notifications = [[String: Any]]()
    private var results = [NotificationModel]()
    private var hasFetched = false
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Geri Dön", style: .done, target: self, action: #selector(didTapBackButton))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let who = UserDefaults.standard.string(forKey: "email")!
        getNotificationData(query: who)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc private func didTapBackButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func getNotificationData(query: String) {
            results.removeAll()
            if hasFetched {
                filterUser(with: query)
            }else{
                DatabaseManager.shared.getAllNotifications(with: UserDefaults.standard.string(forKey: "email")!,completion: { [weak self]result in
                    switch result {
                    case .success(let notificatonCollection):
                        self?.hasFetched = true
                        self?.notifications = notificatonCollection
                        self?.filterUser(with: query)
                    case .failure(let error):
                        print("Kişi bilgilerine erişilemedi: \(error)")
                    }
                })
            }
    }
    func filterUser(with term: String) {        
        let results: [NotificationModel] = notifications.compactMap({
            guard let header = $0["header"], let info = $0["info"], let isRead = $0["isRead"], let time = $0["time"] else {
                return nil
            }
            
            return NotificationModel(header: header as? String, info: info as? String, isRead: isRead as? Bool, time: time as? Date)
        })
        self.results = results
        tableView.reloadData()
    }

}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
