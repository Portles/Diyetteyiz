//
//  ProfileSettingsViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 1.03.2021.
//

import UIKit
import FirebaseAuth
import SDWebImage

struct DiyetteyizUserModel {
    let name: String?
    let surname: String?
    let email: String?
    let gender: String?
    let fat: Int?
    let height: Int?
    let isPersonalInfoHidden: Bool?
    let isCheckedLegal: Bool?
    let starRate: Double?
    let bio: String?
    
    var safeEmail: String {
        var safeEmail = email?.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail?.replacingOccurrences(of: "@", with: "_")
        return safeEmail!
    }
}

class ProfileSettingsViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
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
        field.placeholder = "Soyisim"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let bioField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Bio"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let personalInfoSaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let sendPassEmail: UIButton = {
        let button = UIButton()
        button.setTitle("Şifre Sıfırlama Emaili Gönder", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = .black
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
    
    private let warnLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Uga Buga"
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(nameField)
        view.addSubview(surnameField)
        view.addSubview(bioField)
        view.addSubview(personalInfoSaveButton)
        view.addSubview(sendPassEmail)
        view.addSubview(warnLabel)
        
        view.addSubview(headerView)
        
        imageView.isUserInteractionEnabled = true
        
        personalInfoSaveButton.addTarget(self, action: #selector(didTapUpdateInfoButton), for: .touchUpInside)
        sendPassEmail.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), style: .done, target: self, action: #selector(didTapLogoutButton))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
        
        view.backgroundColor = .systemBackground
    }
    
    @objc func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width+100, height: view.height/4.0)
        
        let size = view.width/3
        imageView.frame = CGRect(x: (view.width/3),y: 200,width: size,height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        nameField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: view.width-60, height: 52)
        surnameField.frame = CGRect(x: 30, y: nameField.bottom + 10, width: view.width-60, height: 52)
        bioField.frame = CGRect(x: 30, y: surnameField.bottom + 10, width: view.width-60, height: 156)
        personalInfoSaveButton.frame = CGRect(x: 30, y: bioField.bottom + 10, width: view.width-60, height: 52)
        sendPassEmail.frame = CGRect(x: 30, y: personalInfoSaveButton.bottom + 40, width: view.width-60, height: 52)
        warnLabel.frame = CGRect(x: (view.width/2)-200, y: sendPassEmail.bottom + 10, width: 400, height: 60)
        
        configureHeaderView()
    }
    
    @objc private func didTapUpdateInfoButton() {
        
        let email: String = UserDefaults.standard.string(forKey: "email")!
        let gender: String = UserDefaults.standard.string(forKey: "gender")!
        let fat: Int = UserDefaults.standard.integer(forKey: "weight")
        let height: Int = UserDefaults.standard.integer(forKey: "height")
        let isPersonalInfoHidden: Bool = true
        let isCheckedLegal: Bool  = true
        let starRate = UserDefaults.standard.double(forKey: "starRate")
        
        let name: String = nameField.text ?? UserDefaults.standard.string(forKey: "name")!
        let surname: String = surnameField.text ?? UserDefaults.standard.string(forKey: "surname")!
        let bio: String = bioField.text ?? UserDefaults.standard.string(forKey: "bio")!
        
        let user = DiyetteyizUserModel(name: name, surname: surname, email: email, gender: gender, fat: fat, height: height, isPersonalInfoHidden: isPersonalInfoHidden, isCheckedLegal: isCheckedLegal, starRate: starRate, bio: bio)
        
        if UserDefaults.standard.integer(forKey: "permission") == 1 {
            DatabaseManager.shared.updateProfile(with: user, completion: { [weak self]result in
                switch result {
                case .success( _):
                    self?.warnLabel.isHidden = false
                    self?.warnLabel.text = "Güncelleme başarılı."
                    print("Update başarılı.")
                    guard let image = self?.imageView.image, let data = image.pngData() else {
                    return
                    }
                    
                    let fileName = "\(email)_PP.png"
                    StorageManager.shared.uploadPP(with: data, fileName: fileName, completion: { result in
                        switch result {
                        case .success(let downloadURL):
                            UserDefaults.standard.set(downloadURL, forKey: "pp_url")
                            print(downloadURL)
                        case .failure(let error):
                            print("Data yönetimi hatası. \(error)")
                        }
                    })
                case .failure(let error):
                    print("Kişi bilgilerine erişilemedi: \(error)")
                }
            })
        } else {
            DatabaseManager.shared.updateDietitianProfile(with: user, completion: { [weak self]result in
                switch result {
                case .success( _):
                    self?.warnLabel.isHidden = false
                    self?.warnLabel.text = "Güncelleme başarılı."
                    print("Update başarılı.")
                    guard let image = self?.imageView.image, let data = image.pngData() else {
                    return
                    }
                    
                    let fileName = "\(email)_PP.png"
                    StorageManager.shared.uploadPP(with: data, fileName: fileName, completion: { result in
                        switch result {
                        case .success(let downloadURL):
                            UserDefaults.standard.set(downloadURL, forKey: "pp_url")
                            print(downloadURL)
                        case .failure(let error):
                            print("Data yönetimi hatası. \(error)")
                        }
                    })
                case .failure(let error):
                    print("Kişi bilgilerine erişilemedi: \(error)")
                }
            })
        }
    }
    
    @objc private func didTapSendButton() {
        Auth.auth().sendPasswordReset(withEmail: UserDefaults.standard.string(forKey: "email")!) { error in
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        warnLabel.isHidden = true
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
    
    @objc private func didTapLogoutButton() {
        
        UserDefaults.standard.setValue(nil, forKey: "email")
        UserDefaults.standard.setValue(nil, forKey: "name")
        UserDefaults.standard.setValue(nil, forKey: "permission")
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        catch {
            print("Failed to log out")
        }
    }
}

extension ProfileSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profil fotoğrafı seç", message: "Fotoğraf nerden alınsın?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Fotoğraf Çek", style: .default, handler: {[weak self]_ in
            self?.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Fotoğraf Seç", style: .default, handler: {[weak self]_ in
            self?.presentPhotoLib()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoLib() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
