//
//  LoginViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class LoginViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    
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
        label.font = UIFont.systemFont(ofSize: 24.0)
        return label
    }()
    
    private let headerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Türkiyenin 1# numaralı diyet platformu."
        label.font = UIFont.systemFont(ofSize: 20.0)
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
        view.addSubview(passField)
        
        view.addSubview(logButton)
        
        view.addSubview(forgotPassButton)
        view.addSubview(warnLabel)
        
        view.addSubview(regButton)
        
        view.addSubview(dietitianRegButton)
        
        view.addSubview(headerView)
        
        logButton.addTarget(self, action: #selector(didTapLogButton), for: .touchUpInside)
        forgotPassButton.addTarget(self, action: #selector(didTapforgotPassButton), for: .touchUpInside)
        regButton.addTarget(self, action: #selector(didTapregButton), for: .touchUpInside)
        dietitianRegButton.addTarget(self, action: #selector(didTapdietitianRegButton), for: .touchUpInside)
        
        
        view.backgroundColor = .systemBackground
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    @objc private func didTapLogButton() {
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        
        guard let email = emailField.text, let pass = passField.text,
        !email.isEmpty, !pass.isEmpty, pass.count >= 6 else {
            alertLogError()
            return
        }
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass, completion: {[weak self]authResult, error in
            guard let strongSelf = self else{
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let result = authResult, error == nil else {
                print("Hatalı giriş: \(email)")
                return
            }
            let user = result.user
            
            let safmeail = DatabaseManager.safeEmail(emailAdress: email)
            DatabaseManager.shared.getDataFor(path: safmeail, comletion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                        let name = userData["name"] as? String else {
                        return
                    }
                    UserDefaults.standard.set("\(name)", forKey: "name")
                    UserDefaults.standard.setValue("\(email)", forKey: "email")
                    if email.contains("@diyetteyiz.com") {
                        UserDefaults.standard.setValue(2, forKey: "permission")
                    } else {
                        UserDefaults.standard.setValue(1, forKey: "permission")
                    }
                case .failure(let error):
                    print("Data okunamadı: \(error)")
                }
            })
            
            print("Giriş başarılı. \(user)")
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    private func alertLogError() {
        let alert = UIAlertController(title: "OH", message: "Lütfen email ile şifrenizin doğruluğunu kontrol edin.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Boşver", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func didTapforgotPassButton() {
        let navVc = ForgotPasswordViewController()
        navigationController?.pushViewController(navVc, animated: true)
    }
    
    @objc private func didTapregButton() {
        let navVc = Register1_0ViewController()
        navigationController?.pushViewController(navVc, animated: true)
    }
    
    @objc private func didTapdietitianRegButton() {
        let navVc = DietitianRegisterViewController()
        navigationController?.pushViewController(navVc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        
        headerLabel.frame = CGRect(x: 30, y: view.top+100, width: 200, height: 20)
        headerInfoLabel.frame = CGRect(x: 30, y: headerLabel.bottom + 10, width: view.width/2, height: 60)
        emailField.frame = CGRect(x: 30, y: headerInfoLabel.bottom + 30, width: view.width-60, height: 52)
        passField.frame = CGRect(x: 30, y: emailField.bottom+30, width: view.width-60, height: 52)
        
        logButton.frame = CGRect(x: 30, y: passField.bottom+40, width: view.width-60, height: 52)
        let warnLabelWidth = CGFloat(100)
        
        forgotPassButton.frame = CGRect(x: (view.width/2) - (75), y: logButton.bottom+10, width: 150, height: 20)
        
        warnLabel.frame = CGRect(x: (view.width/2) - (warnLabelWidth/2), y: forgotPassButton.bottom+10, width: warnLabelWidth, height: warnLabelWidth)
        
        
        regButton.frame = CGRect(x: 30, y: warnLabel.bottom+20, width: view.width-60, height: 52)
        dietitianRegButton.frame = CGRect(x: 30, y: regButton.bottom+10, width: 150, height: 20)
        
        configureHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
