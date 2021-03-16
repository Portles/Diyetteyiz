//
//  DietitianHomeCollectionViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 13.03.2021.
//

import UIKit

class DietitianHomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "DietitianHomeCollectionViewCell"
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 100.0/2.0
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let dietitianName: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        contentView.addSubview(dietitianName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = CGRect(x: (contentView.width/2) - 50, y: 5, width: 100, height: 100)
        dietitianName.frame = CGRect(x: myImageView.left+10, y: myImageView.bottom, width: 100, height: 52)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
        dietitianName.text = nil
    }
    
    public func configure(with model: SearchResult) {
        dietitianName.text = model.name
        
        let path = "img/\(DatabaseManager.notSafeEmail(emailAdress: model.email))_PP.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self]result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self?.myImageView.sd_setImage(with: url, completed: nil)
                }
                
            case .failure(let error):
                print("PP indirme linki alınamadı. \(error)")
            }
        })
    }
}
