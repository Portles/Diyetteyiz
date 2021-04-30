//
//  AddItemViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import UIKit

class AddItemInfoViewController: UIViewController {
    
    private let source = ["MG", "ML", "ADET", "Tatlı Kaşığı"]
    
    private let itemField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Yemek"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let itemTypeField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Birim tipi"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let itemCalorieField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Birim kalori"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let neededMesureField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Kaç birim"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.keyboardType = .numberPad
        return field
    }()
    
    private let picker: UIPickerView = {
       let picker = UIPickerView()
        return picker
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Onayla", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Vazgeç", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        setDelegates()
        
        itemTypeField.inputView = picker
        
        createToolbar()
        
        confirmButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
    }
    
    private func setDelegates() {
        picker.delegate = self
        picker.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(itemField)
        view.addSubview(itemTypeField)
        view.addSubview(itemCalorieField)
        view.addSubview(neededMesureField)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
    }
    
    private func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(AddItemInfoViewController.dismissPicker))
        toolBar.setItems([doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        itemTypeField.inputAccessoryView = toolBar
    }
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        itemField.frame = CGRect(x: 30, y: 300, width: view.width - 60, height: 52)
        itemTypeField.frame = CGRect(x: 30, y: itemField.bottom + 20, width: 100, height: 36)
        neededMesureField.frame = CGRect(x: 30, y: itemTypeField.bottom + 20, width: view.width - 60, height: 52)
        itemCalorieField.frame = CGRect(x: 30, y: neededMesureField.bottom + 20, width: view.width - 60, height: 52)
        
        confirmButton.frame = CGRect(x: 30, y: itemCalorieField.bottom+60, width: view.width-60, height: 52)
        cancelButton.frame = CGRect(x: 30, y: confirmButton.bottom+20, width: view.width-60, height: 52)
    }
    
    @objc private func deleteItem() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func addItem() {
        guard let name = itemField.text, let itemType = itemTypeField.text, let itemCalorie = itemCalorieField.text, let neededMesure = neededMesureField.text else {
            return
        }
        
        let addingItem = Item(name: name, itemType: itemType, itemCalorie: itemCalorie, neededMesure: Int(neededMesure))
        
        AddItemViewController.currentItems.append(addingItem)
        AddItemViewController.items += 1
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddItemInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return source.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             return source[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            return itemTypeField.text = source[row]
        }
}
