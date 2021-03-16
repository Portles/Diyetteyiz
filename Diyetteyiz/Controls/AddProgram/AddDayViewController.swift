//
//  AddDayViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import UIKit

class AddDayViewController: UIViewController {

    public var Days = 1
    
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
        
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapPlusButton))
        
        view.backgroundColor = .systemBackground
        
    }
    
    @objc private func didTapPlusButton() {
        Days += 1
        tableView.reloadData()
    }
    
    @objc private func didTapConfirmButton() {
        
        // Doldur aga
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height-400)
        confirmButton.frame = CGRect(x: 30, y: tableView.bottom+10, width: view.width - 60, height: 52)
    }

}

extension AddDayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Days
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddDayTableViewCell.identifier) as!AddDayTableViewCell
        cell.configure(with: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AddMealViewController()
        vc.title = "Öğünler"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}
