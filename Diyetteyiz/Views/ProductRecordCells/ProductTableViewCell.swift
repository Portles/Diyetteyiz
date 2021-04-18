//
//  ProductTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 14.04.2021.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    static let identifier = "ProductTableViewCell"

    private let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "Day"
        return label
    }()
    
    private let progressLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGreen
        label.text = "progress"
        return label
    }()
    
    private let rightArrow: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dayLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(rightArrow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dayLabel.frame = CGRect(x: 30, y: 0, width: contentView.width / 3, height: 52)
        progressLabel.frame = CGRect(x: dayLabel.right, y: 0, width: contentView.width / 3, height: 52)
        rightArrow.frame = CGRect(x: contentView.right - 52, y: 5, width: 52, height: 52)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with day: Int, progress: Bool) {
        dayLabel.text = String(day) + ". Gün Kaydı"
        if progress {
            progressLabel.text = "Başarılı"
        } else {
            progressLabel.text = "Başarısız"
            progressLabel.textColor = .systemRed
        }
    }
}
