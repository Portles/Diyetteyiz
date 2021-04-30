//
//  ProductsViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit

struct OngoingProduct: Codable {
    var fromWho: String?
    var isHaveOngoingProduct: Bool?
    var lastRecord: LastRecord?
    var startDate, whichProduct, picLoc: String?
}

struct LastRecord: Codable {
    var leftDays, nextDay, succesRate: Int?
}

// MARK: - Product
struct Product: Codable {
    var Days: [Day]?
    var daysCount: Int?
    var header, info: String?
    var isActivated: Bool?
    var itemCount, mealCount: Int?
    var price: String?
    var picLoc: String?

    enum CodingKeys: String, CodingKey {
        case daysCount, header, info, isActivated, itemCount, mealCount, price, Days, picLoc
    }
}

class ProductsViewController: UIViewController {

    public static var productData = Product()
    public var productCompletion: ((Product) -> (Void))?
    public static var ongProduct = OngoingProduct()
    public var ongoingProductCompletion: ((OngoingProduct) -> (Void))?
    
    private var productdata = [[String: Any]]()
    private var ongoingproduct = [String: Any]()
    private var hasFetched = false
    
    private let headerView: UIView = {
        let header = UIView()
        header.layer.masksToBounds = true
        let backgoundImageView = UIImageView(image: UIImage(named: "upperimage"))
        header.addSubview(backgoundImageView)
        header.layer.zPosition = -1
        return header
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
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "BAŞLIK"
        return label
    }()
    
    private let subscriptionButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        return button
    }()
    
    private let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.text = "Ayarlar"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Fiyat"
        return label
    }()
    
    private let dietitianNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Diyetisyen İsmi"
        return label
    }()
    
    private let progressPercentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "İlerleme %"
        return label
    }()
    
    private let todaysButton: UIButton = {
        let button = UIButton()
        button.setTitle("Bu Günün Menüsü", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let nextReportTimeLeftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Gün kaldı"
        return label
    }()
    
    private let todaysReportButton: UIButton = {
        let button = UIButton()
        button.setTitle("Günlük Raporu Tamamla", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "DURUM: (DEVAM,İPTAL)"
        return label
    }()
    
    private let seeRecordsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Geçmiş Günlük Kayıtlar", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let noResultLabel: UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text = "Diyet Satın Alınmamış"
        label.textAlignment = .center
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setButtonActions()
        
        navigationItem.title = "Satın Alımlar"
    }
    
    private func setButtonActions() {
        subscriptionButton.addTarget(self, action: #selector(didTapSubsicriptionsButton), for: .touchUpInside)
        seeRecordsButton.addTarget(self, action: #selector(didTapRecordsButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.insertSubview(noResultLabel, aboveSubview: headerView)
        view.addSubview(headerView)
        view.addSubview(myImageView)
        view.addSubview(headerLabel)
        view.addSubview(subscriptionButton)
        view.addSubview(subscriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(dietitianNameLabel)
        view.addSubview(progressLabel)
        view.addSubview(todaysButton)
        view.addSubview(nextReportTimeLeftLabel)
        view.addSubview(todaysReportButton)
        view.addSubview(progressPercentLabel)
        view.addSubview(seeRecordsButton)
    }
    
    @objc private func didTapSubsicriptionsButton() {
        let vc = ProductSettingsViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapReportTodayButton() {
        let day = Int(ProductsViewController.productData.daysCount!) - Int((ProductsViewController.ongProduct.lastRecord?.leftDays!)!)
        let vc = CheckMealViewController(with: ProductsViewController.productData, whichDay: day)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapTodaysButton() {
        let day = Int(ProductsViewController.productData.daysCount!) - Int((ProductsViewController.ongProduct.lastRecord?.leftDays!)!)
        let vc = TodaysMealViewController(with: ProductsViewController.productData, whichDay: day)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapRecordsButton() {
        let vc = ProductRecordsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hide()
        
        checkBuyedBefore()
    }
    
    private func checkBuyedBefore() {
        let email = UserDefaults.standard.string(forKey: "email")!
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        if UserDefaults.standard.integer(forKey: "permission") == 1 {
            DatabaseManager.shared.checkDidBuyProduct(with: safeEmail, completion: { succes in
                if succes == true {
                    self.viewProgram()
                    DatabaseManager.shared.getOngoingProduct(with: safeEmail, completion: { result in
                        switch result {
                        case .success(let ongoingProduct):
                            do {
                                let data = try JSONSerialization.data(withJSONObject: ongoingProduct, options: .prettyPrinted)

                                let decoder = JSONDecoder()
                                do {
                                    let customer = try decoder.decode(OngoingProduct.self, from: data)
                                    print(customer)
                                    ProductsViewController.ongProduct = customer
                                    self.fillInfo()
                                    
                                    DatabaseManager.shared.getDietitianProductData(with: customer.fromWho!, completion: { [weak self]result in
                                        switch result {
                                        case .success(let productCol):
                                            self?.hasFetched = true
                                            self?.productdata = productCol
                                            self?.filterProduct(with: customer.whichProduct!)
                                            self?.fillInfoSecondPhase()
                                            break
                                        case .failure(let error):
                                            print("Diyetisyen bilgilerine erişilemedi: \(error)")
                                        }
                                    })
                                    
                                    break
                                } catch {
                                    print(error.localizedDescription)
                                }
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                            
                        case .failure(let error):
                            print("Diyetisyen bilgilerine erişilemedi: \(error)")
                        }
                    })
                } else {
                    print("Program alınmamış")
                }
            })
        } else {
            print("Diyetisyensin")
            hide()
            noResultLabel.text = "Diyetisyensin ;)"
        }
    }
    
    func filterProduct(with term: String) {
        let results: [Product] = productdata.filter({
            guard let email = $0["header"],
                  email as! String == term else {
                    return false
            }
            
            return (term as AnyObject).hasPrefix(term)
        }).compactMap({
            do {
            
                let data = try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted)

                let decoder = JSONDecoder()
            
                let customer = try decoder.decode(Product.self, from: data)
                print(customer)
                return customer
            } catch {
                print(error.localizedDescription)
            }
            return nil
        })
        print(results)
        ProductsViewController.productData = results[0]
        print(ProductsViewController.productData)
    }
    
    private func getPic() {
        let picture = "menus/" + ProductsViewController.productData.picLoc! + ".png"
        StorageManager.shared.downloadURL(for: picture, completion: { result in
            switch result {
            case .success(let url):
                self.myImageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
    }
    
    private func fillInfoSecondPhase() {
        priceLabel.text = "Fiyat: " + ProductsViewController.productData.price! + "₺"
        getPic()
        isProgramFinished()
    }
    
    private func isProgramFinished() {
        if ProductsViewController.ongProduct.lastRecord?.leftDays == 0 {
            todaysButton.isEnabled = false
            todaysReportButton.isEnabled = false
            progressLabel.text = "Tamamlandı."
        } else {
            todaysButton.addTarget(self, action: #selector(didTapTodaysButton), for: .touchUpInside)
            todaysReportButton.addTarget(self, action: #selector(didTapReportTodayButton), for: .touchUpInside)
        }
    }
    
    private func fillInfo() {
        headerLabel.text = ProductsViewController.ongProduct.whichProduct
        nextReportTimeLeftLabel.text = "Kalan gün: " + String((ProductsViewController.ongProduct.lastRecord?.leftDays)!)
        progressPercentLabel.text = "İlerleme: %" + String((ProductsViewController.ongProduct.lastRecord?.succesRate)!)
        if ProductsViewController.ongProduct.isHaveOngoingProduct ?? false {
            progressLabel.text = "Program durumu: Devam"
        } else {
            progressLabel.text = "Program durumu: İptal"
        }
        dietitianNameLabel.text = DatabaseManager.notSafeEmail(emailAdress: ProductsViewController.ongProduct.fromWho!)
    }
    
    private func hide() {
        headerView.isHidden = true
        myImageView.isHidden = true
        headerLabel.isHidden = true
        subscriptionButton.isHidden = true
        subscriptionLabel.isHidden = true
        priceLabel.isHidden = true
        dietitianNameLabel.isHidden = true
        progressLabel.isHidden = true
        todaysButton.isHidden = true
        nextReportTimeLeftLabel.isHidden = true
        todaysReportButton.isHidden = true
        progressPercentLabel.isHidden = true
        seeRecordsButton.isHidden = true
        
        noResultLabel.isHidden = false
    }
    
    private func viewProgram() {
        headerView.isHidden = false
        myImageView.isHidden = false
        headerLabel.isHidden = false
        subscriptionButton.isHidden = false
        subscriptionLabel.isHidden = false
        priceLabel.isHidden = false
        dietitianNameLabel.isHidden = false
        progressLabel.isHidden = false
        todaysButton.isHidden = false
        nextReportTimeLeftLabel.isHidden = false
        todaysReportButton.isHidden = false
        progressPercentLabel.isHidden = false
        seeRecordsButton.isHidden = false
        
        noResultLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        noResultLabel.frame = view.bounds
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width+100, height: view.height/4.0)
        myImageView.frame = CGRect(x: 30, y: 100, width: 150, height: 150)
        headerLabel.frame = CGRect(x: myImageView.right + 50, y: 120, width: 300, height: 60)
        
        subscriptionButton.frame = CGRect(x: 40, y: myImageView.bottom + 10, width: 25, height: 25)
        subscriptionLabel.frame = CGRect(x: 30, y: subscriptionButton.bottom + 5, width: 75, height: 52)
        
        priceLabel.frame = CGRect(x: myImageView.right + 50, y: headerLabel.bottom + 30, width: 150, height: 72)
        dietitianNameLabel.frame = CGRect(x: priceLabel.left - 50, y: priceLabel.bottom + 5, width: 300, height: 72)
        
        progressLabel.frame = CGRect(x: 30, y: subscriptionLabel.bottom+40, width: view.width-60, height: 52)
        todaysButton.frame = CGRect(x: 30, y: progressLabel.bottom+10, width: view.width-60, height: 52)
        nextReportTimeLeftLabel.frame = CGRect(x: 30, y: todaysButton.bottom+40, width: view.width-60, height: 52)
        todaysReportButton.frame = CGRect(x: 30, y: nextReportTimeLeftLabel.bottom+10, width: view.width-60, height: 52)
        progressPercentLabel.frame = CGRect(x: 30, y: todaysReportButton.bottom+40, width: view.width-60, height: 52)
        seeRecordsButton.frame = CGRect(x: 30, y: progressPercentLabel.bottom+10, width: view.width-60, height: 52)
        
        UIView.configureHeaderView(with: headerView)
    }
}
