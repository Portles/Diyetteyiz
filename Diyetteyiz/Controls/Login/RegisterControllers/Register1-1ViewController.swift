//
//  Register1-1ViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 26.02.2021.
//

import UIKit

class Register1_1ViewController: UIViewController {
    
    var gender: String!
    var height: Decimal!
    var fat: Decimal!
    var isPersonalInfoHidden: Bool!
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Boy-Kilo"
        label.font = UIFont.systemFont(ofSize: 24.0)
        return label
    }()
    
    private let warnLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 24.0)
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
    
    private let weightField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Boy CM"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.keyboardType = UIKeyboardType.decimalPad
        return field
    }()
    
    private let heightField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Kilo KG"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.keyboardType = UIKeyboardType.decimalPad
        return field
    }()
    
    private let radioButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.setTitle("Profilinizde gözüksün mü?", for: .normal)
        button.setImage(UIImage(named: "checkboxUn")!, for: .normal)
        button.setImage(UIImage(named: "checkboxChecked")!, for: .selected)
        return button
    }()
    
    private let radiobuttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Profilinizde gözüksün mü?"
        label.textColor = .systemRed
        return label
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
        view.addSubview(heightField)
        view.addSubview(weightField)
        view.addSubview(radioButton)
        view.addSubview(continueButton)
        view.addSubview(radiobuttonLabel)
        view.addSubview(warnLabel)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func buttonAction(){
        if radioButton.isSelected == false {
            radioButton.isSelected = true
            isPersonalInfoHidden = true
        }else{
            radioButton.isSelected = false
            isPersonalInfoHidden = false
        }
        
    }
    
    private func presentWarnLabel() {
        warnLabel.text = "Lütfen sayısal girdi yapın!"
    }
    
    @objc private func didTapContinueButton() {
        warnLabel.text = ""
        guard let weight = weightField.text,let height1 = heightField.text, !weight.isEmpty, !height1.isEmpty else {
            presentWarnLabel()
            return
        }
        
        guard let weight = weightField.text,let height1 = heightField.text, !weight.isEmpty, !height1.isEmpty, weight.count <= 6, height1.count <= 6 else {
            return
        }
        fat = Decimal(string: weight) ?? 0
        height = Decimal(string: height1) ?? 0
        let navVc = Register1_2ViewController()
        navVc.fat = fat
        navVc.gender = gender
        navVc.height = height
        navVc.isPersonalInfoHidden = isPersonalInfoHidden
        navigationController?.pushViewController(navVc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        headerLabel.frame = CGRect(x: 30, y: view.top + 100, width: view.width-60, height: 52)
        heightField.frame = CGRect(x: 30, y: headerLabel.top + 150, width: view.width-60, height: 52)
        weightField.frame = CGRect(x: 30, y: heightField.top + 100, width: view.width-60, height: 52)
        radioButton.frame = CGRect(x: 30, y: weightField.top + 100, width: 52, height: 52)
        radiobuttonLabel.frame = CGRect(x: radioButton.right+10, y: weightField.top+100, width: 300, height: 52)
        continueButton.frame = CGRect(x: 30, y: radioButton.top + 100, width: view.width-60, height: 52)
        warnLabel.frame = CGRect(x: 30, y: continueButton.bottom + 5, width: view.width, height: 52)
        
        UIView.configureHeaderView(with: headerView)
    }
}
