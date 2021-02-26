//
//  ForgotPasswordViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifremi unuttum?"
        label.textAlignment = .center
        return label
    }()
    
    private let headerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Emailiniz girerek şifrenizi sıfırlama e-postasını alın."
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Email adress"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gönder", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let warnLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Uga Buga"
        label.textAlignment = .center
        label.textColor = .systemRed
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerLabel)
        view.addSubview(headerInfoLabel)
        view.addSubview(emailField)
        view.addSubview(sendButton)
        view.addSubview(warnLabel)
        view.addSubview(headerView)
        view.backgroundColor = .systemBackground
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        
        headerLabel.frame = CGRect(x: (view.width/2)-100, y: view.top + 200, width: 200, height: 20)
        headerInfoLabel.frame = CGRect(x: (view.width/2)-100, y: headerLabel.bottom + 20, width: 200, height: 80)
        emailField.frame = CGRect(x: 30, y: headerInfoLabel.bottom+40, width: view.width-60, height: 52)
        sendButton.frame = CGRect(x: 30, y: emailField.bottom+50, width: view.width-60, height: 52)
        warnLabel.frame = CGRect(x: (view.width/2)-100, y: sendButton.bottom + 20, width: 200, height: 80)
        
        configureHeaderView()
    }
}


