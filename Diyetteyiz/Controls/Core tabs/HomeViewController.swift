//
//  ViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private var dietitianCollectionView: UICollectionView?
    private var userCollectionView: UICollectionView?
    private var menuCollectionView: UICollectionView?
    
    public var completion: ((SearchResult) -> (Void))?
    
    private var users = [[String: Any]]()
    private var results = [SearchResult]()
    private var userResults = [SearchResult]()
    private var menuResults = [MenuViewModel]()
    private var hasFetched = false
    
    private let headerView: UIView = {
        let header = UIView()
        header.layer.masksToBounds = true
        let backgoundImageView = UIImageView(image: UIImage(named: "upperimage"))
        header.addSubview(backgoundImageView)
        header.layer.zPosition = -1
        return header
    }()
    
    private let dietitiansLabel: UILabel = {
       let label = UILabel()
        label.text = "Diyetisyenler"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    private let usersLabel: UILabel = {
       let label = UILabel()
        label.text = "Kullanıcılar"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    private let menuLabel: UILabel = {
       let label = UILabel()
        label.text = "Menüler"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let menuLayout = UICollectionViewFlowLayout()
        menuLayout.scrollDirection = .horizontal
        menuLayout.itemSize = CGSize(width: view.width-10, height: 200)
        menuLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        dietitianCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        dietitianCollectionView?.register(DietitianHomeCollectionViewCell.self, forCellWithReuseIdentifier: DietitianHomeCollectionViewCell.identifier)
        
        dietitianCollectionView?.showsVerticalScrollIndicator = false
        dietitianCollectionView?.delegate = self
        dietitianCollectionView?.dataSource = self
        dietitianCollectionView?.backgroundColor = .none
        
        userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        userCollectionView?.register(HomeUserCollectionViewCell.self, forCellWithReuseIdentifier: HomeUserCollectionViewCell.identifier)
        
        userCollectionView?.showsVerticalScrollIndicator = false
        userCollectionView?.delegate = self
        userCollectionView?.dataSource = self
        userCollectionView?.backgroundColor = .none
        
        menuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: menuLayout)
        
        menuCollectionView?.register(HomeMenusCollectionViewCell.self, forCellWithReuseIdentifier: HomeMenusCollectionViewCell.identifier)
        
        menuCollectionView?.showsHorizontalScrollIndicator = false
        menuCollectionView?.delegate = self
        menuCollectionView?.dataSource = self
        menuCollectionView?.backgroundColor = .none
        
        guard let myCollection = dietitianCollectionView, let userCollection = userCollectionView, let menuCollection = menuCollectionView else {
            return
        }
        
        view.addSubview(headerView)
        view.insertSubview(myCollection, aboveSubview: headerView)
        view.addSubview(userCollection)
        view.addSubview(usersLabel)
        view.addSubview(dietitiansLabel)
        view.addSubview(menuCollection)
        view.addSubview(menuLabel)
        
        navigationItem.title = "Anasayfa"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Bildirimler", style: .done, target: self, action: #selector(didTapNotificationButton))
        
        getDietitians()
        hasFetched = false
        getUser()
        hasFetched = false
        getMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width+100, height: view.height/4.0)
        configureHeaderView()
        dietitiansLabel.frame = CGRect(x: 30, y: 100, width: 300, height: 52)
        dietitianCollectionView?.frame = CGRect(x: 0, y: dietitiansLabel.bottom, width: view.width, height: 150).integral
        usersLabel.frame = CGRect(x: 30, y: 300, width: 300, height: 52)
        userCollectionView?.frame = CGRect(x: 0, y: usersLabel.bottom, width: view.width, height: 150).integral
        menuLabel.frame = CGRect(x: 30, y: 530, width: 300, height: 52)
        menuCollectionView?.frame = CGRect(x: 0, y: menuLabel.bottom, width: view.width, height: 250).integral
    }

    @objc private func didTapNotificationButton() {
        let vc = NotificationsViewController()
        vc.title = "Bildirimler"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func configureHeaderView(){
        guard headerView.subviews.count == 1 else{
            return
        }
        guard let backgoundView = headerView.subviews.first else {
            return
        }
        backgoundView.frame = headerView.bounds
        
        backgoundView.layer.zPosition = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }

    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    
    func getDietitians() {
        if hasFetched {
            filterDietitian()
        }else{
            DatabaseManager.shared.getAllDietitians(completion: { [weak self]result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterDietitian()
                case .failure(let error):
                    print("Diyetisyen bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    
    func getUser() {
        if hasFetched {
            filterUser()
        }else{
            DatabaseManager.shared.getAllUsers(completion: { [weak self]result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUser()
                case .failure(let error):
                    print("Kullanıcı bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    
    func getMenu() {
        if hasFetched {
            filterMenus()
        }else{
            DatabaseManager.shared.getAllMenus(completion: { [weak self]result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterMenus()
                case .failure(let error):
                    print("Kullanıcı bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    
    func filterDietitian() {
        let results: [SearchResult] = users.compactMap({
            guard let email = $0["email"] as? String, let name = $0["name"] as? String else {
                return nil
            }
            
            return SearchResult(email: email, name: name, info: "", ppUrl: "")
        })
        self.results = results
    }
    func filterUser() {
        let results: [SearchResult] = users.compactMap({
            guard let email = $0["email"] as? String, let name = $0["name"] as? String else {
                return nil
            }
            
            return SearchResult(email: email, name: name, info: "", ppUrl: "")
        })
        self.userResults = results
        
        dietitianCollectionView?.reloadData()
        userCollectionView?.reloadData()
        
    }
    
    func filterMenus() {
        let results: [MenuViewModel] = users.compactMap({
            guard let header = $0["header"] as? String, let info = $0["info"] as? String , let price = $0["price"] as? String , let dietitianBind = $0["dietitianBind"] as? String , let days = $0["days"] as? Int , let headerPicLoc = $0["headerPicLoc"] as? String else {
                return nil
            }
            
            return MenuViewModel(header: header, info: info, price: price, dietitianBind: dietitianBind, days: days, headerPicLoc: headerPicLoc)
        })
        self.menuResults = results
        
        menuCollectionView?.reloadData()
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


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dietitianCollectionView {
            return results.count
        } else if collectionView == userCollectionView {
            return userResults.count
        } else {
            return menuResults.count
        }
           
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dietitianCollectionView {
            let model = results[indexPath.row]
            let cell = dietitianCollectionView?.dequeueReusableCell(withReuseIdentifier: DietitianHomeCollectionViewCell.identifier, for: indexPath) as! DietitianHomeCollectionViewCell
            cell.configure(with: model)
            return cell
        
        } else if collectionView == userCollectionView {
            let model = userResults[indexPath.row]
            let cell = userCollectionView?.dequeueReusableCell(withReuseIdentifier: HomeUserCollectionViewCell.identifier, for: indexPath) as! HomeUserCollectionViewCell
            cell.configure(with: model)
            return cell
        } else {
            let model = menuResults[indexPath.row]
            let cell = menuCollectionView?.dequeueReusableCell(withReuseIdentifier: HomeMenusCollectionViewCell.identifier, for: indexPath) as! HomeMenusCollectionViewCell
            cell.configure(with: model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == dietitianCollectionView {
            dietitianCollectionView?.deselectItem(at: indexPath, animated: true)
            let model = results[indexPath.row]
            openConversation(model)
        } else if collectionView == userCollectionView {
            userCollectionView?.deselectItem(at: indexPath, animated: true)
            let model = userResults[indexPath.row]
            openConversation(model)
        } else {
            userCollectionView?.deselectItem(at: indexPath, animated: true)
            let model = menuResults[indexPath.row]
            openMenu(model)
        }
    }
}
