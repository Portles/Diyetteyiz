//
//  AddMealViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import UIKit

class AddMealViewController: UIViewController {

    public static var Meals = 0
    public static var currentMeals = [Meal]()
    
    private let tableView: UITableView = {
      let tableView = UITableView()
        tableView.register(AddMealTableViewCell.self, forCellReuseIdentifier: AddMealTableViewCell.identifier)
        return tableView
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
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapPlusButton))
        
        view.backgroundColor = .systemBackground
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
    }
    
    @objc private func didTapConfirmButton() {
        
        let addingItem = Day(Meals: AddMealViewController.currentMeals)
        
        AddDayViewController.currentDays.append(addingItem)
        AddDayViewController.Days += 1
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPlusButton() {
        
        AddItemViewController.currentItems.removeAll()
        
        let vc = AddItemViewController()
        vc.title = "Öğün Bilgileri"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        tableView.frame = CGRect(x: 0, y: 100, width: view.width, height: view.height - 300)
        confirmButton.frame = CGRect(x: 30, y: tableView.bottom + 10, width: view.width - 60, height: 52)
        cancelButton.frame = CGRect(x: 30, y: confirmButton.bottom + 10, width: view.width - 60, height: 52)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

}

extension AddMealViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddMealViewController.currentMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemss = AddMealViewController.currentMeals[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: AddMealTableViewCell.identifier) as!AddMealTableViewCell
        cell.configure(with: itemss!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
