//
//  ForgotPasswordViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifremi unuttum?"
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textAlignment = .center
        return label
    }()
    
    private let headerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Emailiniz girerek şifrenizi sıfırlama e-postasını alın."
        label.font = UIFont.systemFont(ofSize: 20.0)
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
        view.backgroundColor = .systemBackground
        
        addSubviews()
        
        setButtonActions()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setButtonActions() {
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(headerLabel)
        view.addSubview(headerInfoLabel)
        view.addSubview(emailField)
        view.addSubview(sendButton)
        view.addSubview(warnLabel)
        view.addSubview(headerView)
    }
    
    @objc private func didTapSendButton() {
        guard let emaile = emailField.text, !emaile.isEmpty, emaile.count > 5 else {
            return
        }
        
        guard let email = emailField.text, !email.isEmpty, email.count > 5 else {
            ForgotPassAlet()
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                self.warnLabel.isHidden = false
                self.warnLabel.text = "Böyle bir email sistemde yok."
                print("Böyle bir email yok.")
                return
            }
            self.warnLabel.isHidden = false
            self.warnLabel.text = "E-postanız gönderildi. 👍"
        }
    }
    
    private func ForgotPassAlet() {
        let alert = UIAlertController(title: "E-posta", message: "E postanızı doğru yazıp tekrar deneyiniz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Çıkış", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        
        headerLabel.frame = CGRect(x: (view.width/2)-100, y: view.top + 200, width: 200, height: 20)
        headerInfoLabel.frame = CGRect(x: (view.width/2)-100, y: headerLabel.bottom + 20, width: 200, height: 80)
        emailField.frame = CGRect(x: 30, y: headerInfoLabel.bottom+40, width: view.width-60, height: 52)
        sendButton.frame = CGRect(x: 30, y: emailField.bottom+50, width: view.width-60, height: 52)
        warnLabel.frame = CGRect(x: (view.width/2)-200, y: sendButton.bottom + 20, width: 400, height: 80)
        
        UIView.configureHeaderView(with: headerView)
    }
}


