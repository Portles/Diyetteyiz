//
//  MenuViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 15.03.2021.
//

import UIKit

class MenuViewController: UIViewController {

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
    
    init(with dietitianEmail: String, id: String?) {
        self.dietitianEmail = dietitianEmail
        self.id = id
        super.init(nibName: nil ,bundle: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        backView.frame = CGRect(x: 30, y: headerView.bottom - 50, width: view.width - 50, height: view.height - 400)
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
