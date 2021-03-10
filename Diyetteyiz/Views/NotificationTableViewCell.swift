//
//  NotificationTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 6.03.2021.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    static let identifier = "NotificationTableViewCell"

    private let UserImageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.image = UIImage(systemName: "person.circle")
        imgv.layer.cornerRadius = 35
        imgv.layer.masksToBounds = true
        return imgv
    }()
    
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(UserImageView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UserImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 70,
                                     height: 70)
        
        headerLabel.frame = CGRect(x: UserImageView.right + 10,
                                     y: 10,
                                     width: contentView.width - 20 - UserImageView.width,
                                     height: 50)
        
        infoLabel.frame = CGRect(x: UserImageView.right + 10, y: 40, width: contentView.width - 20 - UserImageView.width, height: 50)

    }
    
    public func configure(with model: NotificationModel) {
        headerLabel.text = model.header
        infoLabel.text = model.info
        
//        let seyfmeyil = DatabaseManager.safeEmail(emailAdress: model.email)
        
//        let path = "img/\(seyfmeyil)_PP.png"
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self]result in
//            switch result {
//            case .success(let url):
                
//                DispatchQueue.main.async {
//                    self?.UserImageView.sd_setImage(with: url, completed: nil)
//                }
                
//            case .failure(let error):
//                print("PP indirme linki alınamadı. \(error)")
//            }
//        })
    }
}
