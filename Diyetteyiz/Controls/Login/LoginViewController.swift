//
//  LoginViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = .systemBackground
        return scrollView
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
    
    private let passField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let logButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let regButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let dietitianRegButton: UIButton = {
        let button = UIButton()
        button.setTitle("Diyetisyen misin?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Hoşgeldiniz"
        return label
    }()
    
    private let headerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Türkiyenin 1# numaralı diyet platformu."
        label.numberOfLines = 2
        return label
    }()
    
    private let forgotPassButton: UIButton = {
        let button = UIButton()
        button.setTitle("Şifremi unuttum", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let warnLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Uga Buga"
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(headerInfoLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passField)
        
        scrollView.addSubview(logButton)
        
        scrollView.addSubview(forgotPassButton)
        scrollView.addSubview(warnLabel)
        
        scrollView.addSubview(regButton)
        
        scrollView.addSubview(dietitianRegButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        headerLabel.frame = CGRect(x: 30, y: scrollView.top+20, width: 200, height: 20)
        headerInfoLabel.frame = CGRect(x: 30, y: headerLabel.bottom + 10, width: scrollView.width/2, height: 60)
        emailField.frame = CGRect(x: 30, y: headerInfoLabel.bottom + 40, width: scrollView.width-60, height: 52)
        passField.frame = CGRect(x: 30, y: emailField.bottom+30, width: scrollView.width-60, height: 52)
        
        logButton.frame = CGRect(x: 30, y: passField.bottom+40, width: scrollView.width-60, height: 52)
        let warnLabelWidth = CGFloat(100)
        
        forgotPassButton.frame = CGRect(x: (scrollView.width/2) - (75), y: logButton.bottom+20, width: 150, height: 20)
        
        warnLabel.frame = CGRect(x: (scrollView.width/2) - (warnLabelWidth/2), y: forgotPassButton.bottom+10, width: warnLabelWidth, height: warnLabelWidth)
        
        
        regButton.frame = CGRect(x: 30, y: warnLabel.bottom+80, width: scrollView.width-60, height: 52)
        dietitianRegButton.frame = CGRect(x: 30, y: regButton.bottom+10, width: 150, height: 20)
    }

}
