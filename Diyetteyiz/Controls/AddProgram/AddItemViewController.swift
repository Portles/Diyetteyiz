//
//  AddMealViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import UIKit

class AddItemViewController: UIViewController {

    public static var items = 0
    public static var currentItems = [Item]()
    
    private let mealName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Öğün İsmi"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let mealTime: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Saat 00:00"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
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
    
    private let tableView: UITableView = {
      let tableView = UITableView()
        tableView.register(AddItemTableViewCell.self, forCellReuseIdentifier: AddItemTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()

        setDelegates()
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapPlusButton))
        
        view.backgroundColor = .systemBackground
    }
    
    private func setDelegates() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(mealName)
        view.addSubview(mealTime)
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
    }
    
    @objc private func didTapConfirmButton() {
        guard let name = mealName.text, let time = mealTime.text else {
            return
        }
        
        let addingItem = Meal(name: name, time: time, items: AddItemViewController.currentItems)
        
        AddMealViewController.currentMeals.append(addingItem)
        AddMealViewController.Meals += 1
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPlusButton() {
        let vc = AddItemInfoViewController()
        vc.title = "Günler"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        mealName.frame = CGRect(x: 30, y: 100, width: view.width - 60, height: 52)
        mealTime.frame = CGRect(x: 30, y: mealName.bottom + 10, width: view.width - 60, height: 52)
        tableView.frame = CGRect(x: 0, y: mealTime.bottom + 10, width: view.width, height: view.height - 400)
        confirmButton.frame = CGRect(x: 30, y: tableView.bottom + 10, width: view.width - 60, height: 52)
        cancelButton.frame = CGRect(x: 30, y: confirmButton.bottom + 10, width: view.width - 60, height: 52)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

extension AddItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddItemViewController.currentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemss = AddItemViewController.currentItems[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTableViewCell.identifier) as!AddItemTableViewCell
        cell.configure(with: itemss!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
