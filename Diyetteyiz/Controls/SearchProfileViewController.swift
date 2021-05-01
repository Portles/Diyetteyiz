//
//  SearchProfileViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 14.03.2021.
//

import UIKit
import JGProgressHUD

class SearchProfileViewController: UIViewController {
    
    private let email: String?
    private let name: String?
    
    private var data = [ProfileViewModel]()
    
    public var completion: ((ProfileViewModel) -> (Void))?
    
    private var dietitianData = [DietitianViewModel]()
    
    public var dietitianCompletion: ((DietitianViewModel) -> (Void))?
    
    private var menuResults = [MenuViewModel]()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: Any]]()
    private var dietitians = [[String: Any]]()
    private var hasFetched = false
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hasFetched = false
    }
    
    private let profilePhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(systemName: "person.circle")
        photo.contentMode = .scaleAspectFill
        photo.backgroundColor = .white
        photo.layer.borderColor = UIColor.green.cgColor
        photo.layer.borderWidth = 3
        photo.layer.masksToBounds = true
        return photo
    }()
    
    private let fullName: UILabel = {
        let label = UILabel()
        label.text = "İsim"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let bio: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textAlignment = .center
        label.numberOfLines = 3
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
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profil"
        
        addSubviews()
        
        if email?.contains("_diyetteyiz-com") == true {
            setDelegates()
            getDietitianData(query: email!)
        } else {
            getUserData(query: email!)
        }
        
        getPP()
        setButtonActions()
    }
    
    private func setDelegates() {
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setButtonActions() {
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(profilePhoto)
        view.addSubview(fullName)
        view.addSubview(bio)
        view.addSubview(starRate)
        view.addSubview(followButton)
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width+100, height: view.height/4.0)
        
        profilePhoto.frame = CGRect(x: (view.width/2)-100, y: view.top+150, width: 200, height: 200)
        profilePhoto.layer.cornerRadius = profilePhoto.width/2
        
        fullName.frame = CGRect(x: (view.width/2)-((view.width-60)/2), y: profilePhoto.bottom + 20, width: view.width-60, height: 40)
        bio.frame = CGRect(x: (view.width/2)-((view.width-60)/2), y: fullName.bottom + 5, width: view.width-60, height: 180)
        starRate.frame = CGRect(x: 30, y: bio.bottom + 10, width: 175, height: 52)
        followButton.frame = CGRect(x: starRate.right, y: bio.bottom + 10, width: 200, height: 52)
        tableView.frame = CGRect(x: 0, y: followButton.bottom + 5, width: view.width, height: 300)
        
        UIView.configureHeaderView(with: headerView)
    }
    
    private func getPP() {
        guard let searchedEmail = email else {
            return
        }
        
        let notSafeSearchedEmail = DatabaseManager.notSafeEmail(emailAdress: searchedEmail)
        
        let filename = notSafeSearchedEmail + "_PP.png"
        let path = "img/"+filename
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.profilePhoto.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
    }
    
    private func getDietitianData(query: String) {
        dietitianData.removeAll()
        if hasFetched {
            filterDietitian(with: query)
        }else{
            DatabaseManager.shared.getAllDietitians(completion: { [weak self]result in
                switch result {
                case .success(let dietitianCollection):
                    self?.hasFetched = true
                    self?.dietitians = dietitianCollection
                    self?.filterDietitian(with: query)
                case .failure(let error):
                    print("Diyetisyen bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    func filterDietitian(with term: String) {
        guard let currentUserEmail = email, hasFetched else {
            return
        }
        
        let safeMaille = DatabaseManager.safeEmail(emailAdress: currentUserEmail)
        
        let results: [DietitianViewModel] = dietitians.filter({
            guard let email = $0["email"],
                  email as! String == safeMaille else {
                return false
            }
            
            return (email as AnyObject).hasPrefix(safeMaille.lowercased())
        }).compactMap({
            guard let name = $0["name"], let surName = $0["surname"], let starRate = $0["starRate"], let bio = $0["bio"], let gender = $0["gender"]  else {
                return nil
            }
            
            return DietitianViewModel(name: name as? String, surname: surName as? String, bio: bio as? String, starRate: starRate as? Double, gender: gender as? String)
        })
        self.dietitianData = results
        
        fullName.text = dietitianData[0].name! + " " + dietitianData[0].surname!
        bio.text = dietitianData[0].bio
        starRate.text = "Yıldız: " + String(dietitianData[0].starRate!) + "/5.0"
        
        getMenu()
    }
    
    
    private func getMenu() {
        hasFetched = false
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
    
    private func filterMenus() {
        
        let dietitian = DatabaseManager.safeEmail(emailAdress: self.email!)
        
        let results: [MenuViewModel] = users.filter({
            guard let email = $0["dietitianBind"],
                  email as! String == dietitian else {
                return false
            }
            
            return (email as AnyObject).hasPrefix(dietitian.lowercased())
        }).compactMap({
            guard let header = $0["header"] as? String, let info = $0["info"] as? String , let price = $0["price"] as? String , let dietitianBind = $0["dietitianBind"] as? String , let days = $0["days"] as? Int , let headerPicLoc = $0["headerPicLoc"] as? String else {
                return nil
            }
            
            return MenuViewModel(header: header, info: info, price: price, dietitianBind: dietitianBind, days: days, headerPicLoc: headerPicLoc)
        })
        self.menuResults = results
        
        tableView.reloadData()
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
        guard let currentUserEmail = email, hasFetched else {
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
            guard let name = $0["name"], let surName = $0["surname"], let starRate = $0["starRate"], let bio = $0["bio"], let fat = $0["fat"] ,let height = $0["height"], let gender = $0["gender"]  else {
                return nil
            }
            
            return ProfileViewModel(name: name as? String, surname: surName as? String, bio: bio as? String, starRate: starRate as? Double, height: height as? String, fat: fat as? String, gender: gender as? String)
        })
        self.data = results
        
        fullName.text = data[0].name! + " " + data[0].surname!
        bio.text = data[0].bio
        starRate.text = "Yıldız: " + String(data[0].starRate!) + "/5.0"
    }
    
    @objc private func didTapFollowButton() {
        if followButton.isSelected {
            followButton.isSelected = false
            followButton.backgroundColor = .systemBlue
        } else {
            followButton.isSelected = true
            followButton.backgroundColor = .systemRed
        }
    }
    
    init(with email: String, name: String?) {
        self.email = email
        self.name = name
        super.init(nibName: nil ,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = menuResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DietitianProfileMenusTableViewCell.identifier, for: indexPath) as! DietitianProfileMenusTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
