//
//  RegisterViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit

class Register1_0ViewController: UIViewController {

    var gender: String!
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinsiyetiniz"
        label.font = UIFont.systemFont(ofSize: 24.0)
        return label
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        header.layer.masksToBounds = true
        let backgoundImageView = UIImageView(image: UIImage(named: "upperimage"))
        header.addSubview(backgoundImageView)
        header.layer.zPosition = -1
        return header
    }()
    
    private let femaleButton: UIButton = {
        let button = UIButton()
        button.setTitle("KADIN", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("ERKEK", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Devam", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerView)
        view.addSubview(headerLabel)
        view.addSubview(femaleButton)
        view.addSubview(maleButton)
        view.addSubview(continueButton)
        
        view.backgroundColor = .systemBackground
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(didTapFemaleButton), for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(didTapMaleButton), for: .touchUpInside)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc private func didTapFemaleButton() {
        continueButton.isEnabled = true
        gender = "Female"
        femaleButton.backgroundColor = .systemRed
        maleButton.backgroundColor = .systemGreen
    }
    
    @objc private func didTapMaleButton() {
        continueButton.isEnabled = true
        gender = "Male"
        maleButton.backgroundColor = .systemRed
        femaleButton.backgroundColor = .systemGreen
    }
    
    @objc private func didTapContinueButton() {
        let navVc = Register1_1ViewController()
        navVc.gender = gender
        navigationController?.pushViewController(navVc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        headerLabel.frame = CGRect(x: 30, y: (view.height/4.0)-100, width: 200, height: 100)
        femaleButton.frame = CGRect(x: 30, y: headerLabel.bottom + 10, width: view.width-60, height: 52)
        maleButton.frame = CGRect(x: 30, y: femaleButton.bottom + 100, width: view.width-60, height: 52)
        continueButton.frame = CGRect(x: 30, y: maleButton.bottom + 150, width: view.width-60, height: 52)
        
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
