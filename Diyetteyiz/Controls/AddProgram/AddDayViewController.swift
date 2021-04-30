//
//  AddDayViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import UIKit

class AddDayViewController: UIViewController {

    public static var Days = 0
    public static var currentDays = [Day]()
    
    private let tableView: UITableView = {
      let tableView = UITableView()
        tableView.register(AddDayTableViewCell.self, forCellReuseIdentifier: AddDayTableViewCell.identifier)
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
    }
    
    @objc private func didTapPlusButton() {
        
        AddMealViewController.currentMeals.removeAll()
        
        let vc = AddMealViewController()
        vc.title = "Öğün Ekle"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapConfirmButton() {
        
        AddProductViewController.product.Days?.append(contentsOf: AddDayViewController.currentDays)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    private func setFrames() {
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height-400)
        confirmButton.frame = CGRect(x: 30, y: tableView.bottom+10, width: view.width - 60, height: 52)
    }

}

extension AddDayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddDayViewController.currentDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddDayTableViewCell.identifier) as!AddDayTableViewCell
        cell.configure(with: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}
