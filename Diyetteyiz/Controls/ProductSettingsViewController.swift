//
//  ProductSettingsViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 11.04.2021.
//

import UIKit

class ProductSettingsViewController: UIViewController {

    let button: UIButton = {
       let button = UIButton()
        button.setTitle("Aboneliği iptal et", for: .normal)
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
    }
    
    private func addSubviews() {
        view.addSubview(button)
    }
    
    private func setButtonActions() {
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFrames()
    }
    
    private func setFrames() {
        button.frame = CGRect(x: 30, y: 200, width: view.width - 60, height: 52)
    }
    
    @objc private func didTapCancelButton() {
        
    }
    
}
