//
//  AddDayTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import UIKit

class AddMealTableViewCell: UITableViewCell {

    static let identifier = "AddMealTableViewCell"
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    private let rightArrow: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(rightArrow)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 30, y: 5, width: 200, height: 52)
        rightArrow.frame = CGRect(x: contentView.right - 52, y: 5, width: 52, height: 52)
    }
    
    public func configure(with which: String) {
        nameLabel.text = "Öğün " + which
    }
}
