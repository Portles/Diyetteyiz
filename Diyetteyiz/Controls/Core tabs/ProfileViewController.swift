//
//  ProfileViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import JGProgressHUD

struct ProfileViewModel {
    let profileUrl: URL?
    let name: String?
    let surname: String?
    let bio: String?
    let starRate: Double?
}

class ProfileViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    private var data = [ProfileViewModel]()
    
    public var completion: ((ProfileViewModel) -> (Void))?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: Any]]()
    private var hasFetched = false
    
    private let profilePhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(systemName: "person.circle")
        return photo
    }()
    
    private let fullName: UILabel = {
        let label = UILabel()
        label.text = "İsim"
        label.textAlignment = .center
        return label
    }()
    
    private let bio: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textAlignment = .center
        return label
    }()
    
    private let starRate: UILabel = {
        let label = UILabel()
        label.text = "Yıldız: 0.0/5.0"
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Takip Et", for: .normal)
        button.setTitle("Takbi Bırak", for: .selected)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        header.layer.masksToBounds = true
        let backgoundImageView = UIImageView(image: UIImage(named: "upperimage"))
        header.addSubview(backgoundImageView)
        header.layer.zPosition = -1
        return header
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DietitianProfileMenusTableViewCell.self, forCellReuseIdentifier: DietitianProfileMenusTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(profilePhoto)
        view.addSubview(fullName)
        view.addSubview(bio)
        view.addSubview(starRate)
        view.addSubview(followButton)
        
        //configureProfile()
        getUserData(query: UserDefaults.standard.string(forKey: "email") ?? "")
        
        navigationItem.title = "Profil"
    }
    
    private func getUserData(query: String) {
            data.removeAll()
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
        
        let results: [ProfileViewModel] = users.filter({
            guard let email = $0["email"],
                  email as! String == safeMaille else {
                    return false
            }
            
            return (email as AnyObject).hasPrefix(safeMaille.lowercased())
        }).compactMap({
            guard let name = $0["name"], let surName = $0["surname"], let starRate = $0["starRate"], let bio = $0["bio"] else {
                return nil
            }
            
            return ProfileViewModel(profileUrl: URL(string: ""), name: name as? String, surname: surName as? String, bio: bio as? String, starRate: starRate as? Double)
        })
        self.data = results
        
        fullName.text = data[0].name! + " " + data[0].surname!
        bio.text = data[0].bio
    }
    
    private func configureProfile() {
        fullName.text = UserDefaults.standard.string(forKey: "name")
        bio.text = UserDefaults.standard.string(forKey: "name")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width+100, height: view.height/4.0)
        
        let ppSize = view.width/4
        profilePhoto.frame = CGRect(x: (view.width/2)-100, y: view.top+150, width: 200, height: 200)
        
        profilePhoto.layer.cornerRadius = ppSize/2.0
        
        fullName.frame = CGRect(x: (view.width/2)-((view.width-60)/2), y: profilePhoto.bottom + 20, width: view.width-60, height: 20)
        bio.frame = CGRect(x: (view.width/2)-((view.width-60)/2), y: fullName.bottom + 5, width: view.width-60, height: 60)
        starRate.frame = CGRect(x: 30, y: bio.bottom + 10, width: 175, height: 52)
        followButton.frame = CGRect(x: starRate.right, y: bio.bottom + 10, width: 200, height: 52)
        
        configureHeaderView()
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
}
