//
//  AdminToolsViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 12.05.2021.
//

import UIKit

struct adminData: Codable {
    var totalUsers: String?
    var totalDietitians: String?
    var totalDietInProgress: String?
    var totalMenus: String?
}

class AdminToolsViewController: UIViewController {

    private let totalUsers: UILabel = {
       let label = UILabel()
        label.text = "totalUsers"
        return label
    }()
    
    private let totalDietitians: UILabel = {
       let label = UILabel()
        label.text = "totalDietitians"
        return label
    }()
    
    private let totalDietInProcess: UILabel = {
       let label = UILabel()
        label.text = "totalDietInProcess"
        return label
    }()
    
    private let totalMenus: UILabel = {
       let label = UILabel()
        label.text = "totalMenus"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(totalUsers)
        view.addSubview(totalDietitians)
        view.addSubview(totalDietInProcess)
        view.addSubview(totalMenus)
        
        getAdminData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        totalUsers.frame = CGRect(x: 30, y: 300, width: view.width - 60, height: 52)
        totalDietitians.frame = CGRect(x: 30, y: 350, width: view.width - 60, height: 52)
        totalDietInProcess.frame = CGRect(x: 30, y: 400, width: view.width - 60, height: 52)
        totalMenus.frame = CGRect(x: 30, y: 450, width: view.width - 60, height: 52)
    }
    
    private func getAdminData() {
        DatabaseManager.shared.getAdminData(completion: { [weak self]result in
            switch result {
            case .success(let data):
                self!.totalUsers.text = "Sistemde kayıtlı kulanıcı: " + (data.totalUsers ?? "0")
                self!.totalDietitians.text = "Sistemde kayıtlı diyetisyen: " + (data.totalDietitians ?? "0")
                self!.totalDietInProcess.text = "Şuanda uygulanan programlar: " + (data.totalDietInProgress ?? "0")
                self!.totalMenus.text = "Sistemde kayıtlı programlar: " + (data.totalMenus ?? "0")
            case .failure(let error):
                print("Kişi bilgilerine erişilemedi: \(error)")
            }
        })
    }
}
