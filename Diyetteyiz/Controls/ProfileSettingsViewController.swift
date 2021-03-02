//
//  ProfileSettingsViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 1.03.2021.
//

import UIKit
import FirebaseAuth

class ProfileSettingsViewController: UIViewController {

    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Çık", for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(logOutButton)
        
        logOutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logOutButton.frame = CGRect(x: 30, y: 200, width: 200, height: 52)
    }
    
    @objc private func didTapLogoutButton() {
        
        UserDefaults.standard.setValue(nil, forKey: "email")
        UserDefaults.standard.setValue(nil, forKey: "name")
        
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
