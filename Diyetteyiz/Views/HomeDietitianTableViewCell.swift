//
//  HomeDietitianTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 12.03.2021.
//

import UIKit

class HomeDietitianTableViewCell: UITableViewCell {

    static let identifier = "HomeDietitianTableViewCell"
    
    private let dietitianProfile: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let dietitianName: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dietitianProfile)
        contentView.addSubview(dietitianName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dietitianProfile.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        dietitianName.frame = CGRect(x: 5, y: dietitianProfile.bottom, width: contentView.width-10, height: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: SearchResult) {
        dietitianName.text = model.name
        
        let path = "img/\(DatabaseManager.notSafeEmail(emailAdress: model.email))_PP.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self]result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self?.dietitianProfile.sd_setImage(with: url, completed: nil)
                }
                
            case .failure(let error):
                print("PP indirme linki alınamadı. \(error)")
            }
        })
    }
    
}
