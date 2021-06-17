//
//  Register1-2ViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 26.02.2021.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class Register1_2ViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    
    var isPersonalInfoHidden: Bool!
    var gender: String!
    var height: Decimal!
    var fat: Decimal!
    var isCheckedLegal: Bool!
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Kayıt Bilgileri"
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
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "İsim"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let surnameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Soyadı"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
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
        field.placeholder = "Şifre"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let repassField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Şifre tekrarı"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Devam", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let radioButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.setTitle("Şartları kabul ediyor musunuz?", for: .normal)
        button.setImage(UIImage(named: "checkboxUn")!, for: .normal)
        button.setImage(UIImage(named: "checkboxChecked")!, for: .selected)
        return button
    }()
    
    private let radiobuttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Şartları kabul ediyor musunuz?"
        label.textColor = .systemRed
        return label
    }()
    
    private let warnLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setButtonActions()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setButtonActions() {
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        radioButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(headerLabel)
        view.addSubview(nameField)
        view.addSubview(surnameField)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(repassField)
        view.addSubview(radioButton)
        view.addSubview(radiobuttonLabel)
        view.addSubview(continueButton)
        view.addSubview(warnLabel)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        
        headerLabel.frame = CGRect(x: 30, y: view.top + 125, width: 200, height: 100)
        nameField.frame = CGRect(x: 30, y: headerLabel.bottom + 35, width: view.width-60, height: 52)
        surnameField.frame = CGRect(x: 30, y: nameField.bottom + 20, width: view.width-60, height: 52)
        emailField.frame = CGRect(x: 30, y: surnameField.bottom + 20, width: view.width-60, height: 52)
        passField.frame = CGRect(x: 30, y: emailField.bottom + 20, width: view.width-60, height: 52)
        repassField.frame = CGRect(x: 30, y: passField.bottom + 20, width: view.width-60, height: 52)
        radioButton.frame = CGRect(x: 30, y: repassField.top + 100, width: 52, height: 52)
        radiobuttonLabel.frame = CGRect(x: radioButton.right+10, y: repassField.top+100, width: 300, height: 52)
        continueButton.frame = CGRect(x: 30, y: radiobuttonLabel.bottom + 52, width: view.width-60, height: 52)
        warnLabel.frame = CGRect(x: 30, y: continueButton.bottom + 5, width: view.width, height: 52)
        
        UIView.configureHeaderView(with: headerView)
    }
    
    @objc func buttonAction(){
        if radioButton.isSelected == false {
            radioButton.isSelected = true
            isCheckedLegal = true
        }else{
            radioButton.isSelected = false
            isCheckedLegal = false
        }
    }
    
    private func presentWarnLabel() {
        warnLabel.text = "Lütfen girdileri kontrol edin!"
    }

    @objc private func didTapContinueButton() {
        nameField.resignFirstResponder()
        surnameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        repassField.resignFirstResponder()
        
        warnLabel.text = ""
        
        guard let emailCheck = emailField.text, !emailCheck.contains("*"),!emailCheck.contains("/"),!emailCheck.contains("<"), let name=nameField.text, let surname=surnameField.text, !name.contains("@"), !surname.contains("@"), let pass=passField.text, let repass=repassField.text, !(pass.count <= 3), !(repass.count <= 3) else {
            presentWarnLabel()
            return
        }
        
        guard let gender=self.gender ,let isPersonalInfoHidden = self.isPersonalInfoHidden ,let fat = self.fat ,let height = self.height ,let isCheckedLegal = self.isCheckedLegal ,let name=nameField.text, let surname=surnameField.text, let email=emailField.text, let pass=passField.text, let repass=repassField.text, pass == repass, !name.isEmpty, !surname.isEmpty, !email.isEmpty, !pass.isEmpty, !repass.isEmpty, radioButton.isSelected else {
            return
        }
        
        spinner.show(in: view)
        
        DatabaseManager.shared.UserExist(with: DatabaseManager.safeEmail(emailAdress: email), completion: { [weak self]exist in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exist else {
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion: { authResult, error in
                
                guard authResult != nil, error == nil else{
                print("Hesap oluşturulamadı.")
                return
                }
                
                UserDefaults.standard.set(name, forKey: "name")
                UserDefaults.standard.set(surname, forKey: "surname")
                UserDefaults.standard.set(email, forKey: "email")
                
                let user = DiyetteyizUser(name: name, surname: surname, email: email, gender: gender, fat: fat, height: height, isPersonalInfoHidden: isPersonalInfoHidden, isCheckedLegal: isCheckedLegal, starRate: 0.0, bio: "")
                
                DatabaseManager.shared.InsertUser(with: user, completion: { succes in
                    if succes {
                        print("Kayıt başarılı.")
                    }
                })
            })
        })
        
        
        let navVc = Register1_3ViewController()
        navigationController?.pushViewController(navVc, animated: true)
    }
}
