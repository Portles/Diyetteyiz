//
//  DietitianRegisterViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import UIKit
import MessageUI

class DietitianRegisterViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Aramıza Katıl!"
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textAlignment = .center
        return label
    }()
    
    private let headerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Aramıza katılmak için başvuru metnini doldurun."
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private let mailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "envelope") , for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        button.backgroundColor = .systemGreen
        button.layer.masksToBounds = true
        return button
    }()
    
    private let warnLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Uga Buga"
        label.textAlignment = .center
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        
        setButtonActions()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setButtonActions() {
        mailButton.addTarget(self, action: #selector(didTapMailButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(headerLabel)
        view.addSubview(headerInfoLabel)
        view.addSubview(mailButton)
        view.addSubview(warnLabel)
        view.addSubview(headerView)
    }
    
    @objc private func didTapMailButton() {
        
        guard MFMailComposeViewController.canSendMail() else {
            MailServicesAlert()
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        composeVC.setToRecipients(["diyetteyiz@example.com"])
        composeVC.setSubject("Başvuru Formu")
        composeVC.setMessageBody("Başvuru için aşağıdaki formu doldurun.\n\nİsim: \nSoyisim:\nÜniversite: \n", isHTML: false)
         
        self.present(composeVC, animated: true, completion: nil)
    }
    
    private func MailServicesAlert() {
        let alert = UIAlertController(title: "Mail Servisleri", message: "Mail servislerinizi açıp tekrar deneyiniz", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Çıkış", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setFrames()
    }
    
    private func setFrames() {
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/4.0)
        
        headerLabel.frame = CGRect(x: (view.width/2)-100, y: view.top + 200, width: 200, height: 20)
        headerInfoLabel.frame = CGRect(x: (view.width/2)-100, y: headerLabel.bottom + 20, width: 200, height: 80)
        let buttonSize = CGFloat(150)
        mailButton.layer.cornerRadius = buttonSize/2
        mailButton.frame = CGRect(x: (view.width/2)-(buttonSize/2), y: headerInfoLabel.bottom+40, width: buttonSize, height: buttonSize)
        warnLabel.frame = CGRect(x: (view.width/2)-100, y: mailButton.bottom + 20, width: 200, height: 80)
        
        UIView.configureHeaderView(with: headerView)
    }

}

extension DietitianRegisterViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
        }
        
        switch result {
        case .cancelled:
            print("Canceled.")
        case .failed:
            print("Failed.")
        case .saved:
            print("Mail Saved.")
        case .sent:
            print("Mail sended.")
        @unknown default:
            fatalError()
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
