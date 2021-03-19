//
//  MenuViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 15.03.2021.
//

import UIKit

class MenuViewController: UIViewController {

    struct MenuViewModel {
        let header: String?
        let info: String?
        let isActivated: Bool?
        let price: String?
        let daysCount: Int?
        let mealCount: Int?
        let itemCount: Int?
    }
    
    private var picloc: String?
    
    private var menuData = [MenuViewModel]()
    private var menu = [[String : Any]]()
    private var hasFetched = false
    
    private let dietitianEmail: String?
    private let id: String?
    
    private let headerView: UIView = {
        let header = UIView()
        header.layer.masksToBounds = true
        let backgoundImageView = UIImageView(image: UIImage(named: "upperimage"))
        header.addSubview(backgoundImageView)
        header.layer.zPosition = -1
        return header
    }()
    
    private let backView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4.0
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "BAŞLIK"
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "INFO"
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.text = "GÜN"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "FİYAT"
        return label
    }()
    
    private let mealCountLabel: UILabel = {
        let label = UILabel()
        label.text = "ÇEŞİT"
        return label
    }()
    
    private let productCountLabel: UILabel = {
        let label = UILabel()
        label.text = "ÖĞÜN"
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Satın al", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .black
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerView)
        
        view.addSubview(backView)
        view.addSubview(myImageView)
        view.addSubview(daysLabel)
        view.addSubview(priceLabel)
        view.addSubview(mealCountLabel)
        view.addSubview(productCountLabel)
        view.addSubview(headerLabel)
        view.addSubview(infoLabel)
        view.addSubview(buyButton)
        
        view.backgroundColor = .systemBackground
        
    }
    
    init(with dietitianEmail: String, id: String?, picLoc: String) {
        self.dietitianEmail = dietitianEmail
        self.id = id
        self.picloc = picLoc
        super.init(nibName: nil ,bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMenu(query: self.dietitianEmail!)
        getPic()
    }
    
    private func getPic() {
        let picture = "menus/" + self.picloc! + ".png"
        StorageManager.shared.downloadURL(for: picture, completion: { result in
            switch result {
            case .success(let url):
                self.myImageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
    }
    
    // MARK: Gettin Menu
    private func getMenu(query: String) {
        if hasFetched {
            filterMenu(with: query)
        }else{
            DatabaseManager.shared.getDietitianMenu(with: self.dietitianEmail!,completion: { [weak self]result in
                switch result {
                case .success(let menuCollection):
                    self?.hasFetched = true
                    self?.menu = menuCollection
                    self?.filterMenu(with: query)
                case .failure(let error):
                    print("Kişi bilgilerine erişilemedi: \(error)")
                }
            })
        }
        
    }
    private func filterMenu(with term: String) {
        let results: [MenuViewModel] = menu.filter({
            guard let header = $0["header"],
                  header as? String == self.id else {
                    return false
            }

            return (header as! String).hasPrefix(self.id!)
        }).compactMap({
            guard let header = $0["header"], let info = $0["info"], let isActivated = $0["isActivated"], let price = $0["price"], let daysCount = $0["daysCount"], let mealCount = $0["mealCount"], let itemCount = $0["itemCount"] else {
                return nil
            }

            return MenuViewModel(header: header as? String, info: info as? String, isActivated: isActivated as? Bool, price: price as? String, daysCount: daysCount as? Int, mealCount: mealCount as? Int, itemCount: itemCount as? Int)
        })
        self.menuData = results
        
        headerLabel.text = self.menuData[0].header
        infoLabel.text = self.menuData[0].info
        priceLabel.text = "Fiyat: " + self.menuData[0].price!
        daysLabel.text = "Toplam: " + String(self.menuData[0].daysCount!) + "gün"
        mealCountLabel.text =  "Öğün Sayısı: " + String(self.menuData[0].mealCount!)
        productCountLabel.text = "Çeşit Sayısı: " + String(self.menuData[0].itemCount!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        backView.frame = CGRect(x: 30, y: headerView.bottom - 50, width: view.width - 60, height: view.height - 400)
        myImageView.frame = CGRect(x: backView.left + 10, y: backView.top + 10, width: (backView.width/2) - 20, height: 100)
        daysLabel.frame = CGRect(x: myImageView.right + 30, y: myImageView.top, width: 125, height: 30)
        priceLabel.frame = CGRect(x: myImageView.right + 30, y: daysLabel.bottom + 10, width: 125, height: 30)
        productCountLabel.frame = CGRect(x: myImageView.right + 30, y: priceLabel.bottom + 10, width: 125, height: 30)
        mealCountLabel.frame = CGRect(x: backView.left + 10, y: myImageView.bottom + 10, width: 350, height: 50)
        headerLabel.frame = CGRect(x: backView.left + 10, y: mealCountLabel.bottom, width: 350, height: 50)
        infoLabel.frame = CGRect(x: backView.left + 10, y: headerLabel.bottom, width: 350, height: 300)
        buyButton.frame =  CGRect(x: 30, y: backView.bottom+20, width: view.width-60, height: 52)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
