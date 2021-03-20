//
//  AddProductViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import UIKit

struct MenuViewModelDiet {
    let header: String?
    let info: String?
    let price: String?
    let dietitianBind: String?
    let days: Int?
    let headerPicLoc: String?
}

class AddProductViewController: UIViewController {

    public static var product = DietModel()
    
    private let headerField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Başlık"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
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
    
    private let infoField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "İçerik"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.text = "Fiyat: "
        return label
    }()
    
    private let priceField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "00.00₺"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let manageDaysButton: UIButton = {
        let button = UIButton()
        button.setTitle("Günleri Ayarla", for: .normal)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let sendFormButton: UIButton = {
        let button = UIButton()
        button.setTitle("Onaylamaya Gönder", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerField)
        view.addSubview(myImageView)
        view.addSubview(infoField)
        view.addSubview(priceLabel)
        view.addSubview(priceField)
        view.addSubview(manageDaysButton)
        view.addSubview(sendFormButton)
        
        myImageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangePicture))
        myImageView.addGestureRecognizer(gesture)
        
        manageDaysButton.addTarget(self, action: #selector(didTapManageDaysButton), for: .touchUpInside)
        sendFormButton.addTarget(self, action: #selector(didTapSendFormButton), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), style: .done, target: self, action: #selector(didTapCloseButton))
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sendFormButton.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerField.frame = CGRect(x: 30, y: 150, width: view.width - 60, height: 52)
        myImageView.frame = CGRect(x: 30, y: headerField.bottom + 20, width: 100, height: 70)
        infoField.frame = CGRect(x: 30, y: myImageView.bottom + 20, width: view.width - 60, height: 200)
        priceLabel.frame = CGRect(x: 30, y: infoField.bottom + 20, width: 100, height: 52)
        priceField.frame = CGRect(x: priceLabel.right + 10, y: infoField.bottom + 20, width: 100, height: 52)
        manageDaysButton.frame = CGRect(x: 30, y: priceField.bottom + 20, width: view.width - 60, height: 52)
        sendFormButton.frame = CGRect(x: 30, y: manageDaysButton.bottom + 60, width: view.width - 60, height: 52)
    }
    
    @objc private func didTapSendFormButton() {
        guard let header = headerField.text, let info = infoField.text, let price = priceField.text, !header.isEmpty, !info.isEmpty, !price.isEmpty else {
            return
        }
        
        AddProductViewController.product.header = header
        AddProductViewController.product.info = info
        AddProductViewController.product.price = price
        AddProductViewController.product.Days = AddDayViewController.currentDays
        AddProductViewController.product.isActivated = false
        AddProductViewController.product.daysCount = AddDayViewController.Days
        AddProductViewController.product.mealCount = AddMealViewController.Meals
        AddProductViewController.product.itemCount = AddItemViewController.items
        
        let email = DatabaseManager.safeEmail(emailAdress: UserDefaults.standard.string(forKey: "email")!)
        let picLoc = "\(email)" + String(Int.random(in: 0...100))
        let picLocUpload = picLoc + ".png"
        let smallInfo: String = info.prefix(20) + "..."
        let dayCount = String(AddProductViewController.product.Days?.count ?? 0)
        
        let searchProduct = MenuViewModelDiet(header: header, info: smallInfo, price: price, dietitianBind: email, days: Int(dayCount), headerPicLoc: picLoc)
        
        DatabaseManager.shared.InsertDietitianProgram(with: AddProductViewController.product, miniProduct: searchProduct, completion: { succes in
            if succes {
                print("Kayıt başarılı.")
            }
        })
        
        guard let image = self.myImageView.image, let data = image.pngData() else {
        return
        }
        
        StorageManager.shared.uploadMenuPic(with: data, fileName: picLocUpload, completion: { result in
            switch result {
            case .success(let downloadURL):
                print(downloadURL)
            case .failure(let error):
                print("Data yönetimi hatası. \(error)")
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapManageDaysButton() {
        
        AddDayViewController.currentDays.removeAll()
        
        let vc = AddDayViewController()
        vc.title = "Gün Ekleme"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapChangePicture() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        self.myImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
