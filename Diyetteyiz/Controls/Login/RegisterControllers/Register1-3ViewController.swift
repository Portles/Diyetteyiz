//
//  Register1-3ViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 26.02.2021.
//

import UIKit

class Register1_3ViewController: UIViewController {
    
    private let headerView: UIView = {
        let header = UIView()
        header.layer.masksToBounds = true
        let backgoundImageView = UIImageView(image: UIImage(named: "upperimage"))
        header.addSubview(backgoundImageView)
        header.layer.zPosition = -1
        return header
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Bildirimler"
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textAlignment = .center
        return label
    }()
    
    private let headerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Bildirimleri açmayı unutmayın!"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private let notificationsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell") , for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        button.backgroundColor = .systemGreen
        button.layer.masksToBounds = true
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tamamla", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerView)
        view.addSubview(headerLabel)
        view.addSubview(headerInfoLabel)
        view.addSubview(notificationsButton)
        view.addSubview(continueButton)
        
        notificationsButton.addTarget(self, action: #selector(didNotificationButton), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didNotificationButton() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                print(error)
            }
            
            // Enable or disable features based on the authorization.
        }
    }
    
    @objc private func didTapContinueButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        
        headerLabel.frame = CGRect(x: (view.width/2)-100, y: view.top + 100, width: 200, height: 20)
        headerInfoLabel.frame = CGRect(x: (view.width/2)-100, y: headerLabel.bottom + 20, width: 200, height: 80)
        let buttonSize = CGFloat(150)
        notificationsButton.layer.cornerRadius = buttonSize/2
        notificationsButton.frame = CGRect(x: (view.width/2)-(buttonSize/2), y: headerInfoLabel.bottom+40, width: buttonSize, height: buttonSize)
        continueButton.frame = CGRect(x: 30, y: notificationsButton.bottom + 100, width: view.width-60, height: 52)
        
        configureHeaderView()
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
}
