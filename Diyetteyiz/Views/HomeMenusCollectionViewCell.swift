//
//  HomeMenusCollectionViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 14.03.2021.
//

import UIKit

class HomeMenusCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeMenusCollectionViewCell"
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let view: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4.0
        return view
    }()
    
    private let rightArrow: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        contentView.addSubview(myImageView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(rightArrow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = CGRect(x: 10, y: 0, width: contentView.width-10, height: contentView.height-10)
        myImageView.frame = CGRect(x: view.left + 10, y: 10, width: 175, height: 75)
        headerLabel.frame = CGRect(x: view.left + 10, y: myImageView.bottom + 5, width: 150, height: 26)
        infoLabel.frame = CGRect(x: view.left + 10, y: headerLabel.bottom, width: 400, height: 52)
        daysLabel.frame = CGRect(x: myImageView.right + 30, y: 5, width: 200, height: 75)
        rightArrow.frame = CGRect(x: view.right - 75, y: myImageView.bottom, width: 50, height: 50)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
        headerLabel.text = nil
        infoLabel.text = nil
        daysLabel.text = nil
    }
    
    public func configure(with model: MenuViewModel) {
        headerLabel.text = model.header
        infoLabel.text = model.info
        daysLabel.text = "Toplam: " + String(model.days) + " gün"
        
        let path = "menus/\(model.headerPicLoc).png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self]result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self?.myImageView.sd_setImage(with: url, completed: nil)
                }
                
            case .failure(let error):
                print("Diyet menüsü indirme linki alınamadı. \(error)")
            }
        })
    }
}
