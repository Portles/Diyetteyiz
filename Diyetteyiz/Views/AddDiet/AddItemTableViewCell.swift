//
//  AddItemTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 17.03.2021.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {

    static let identifier = "AddItemTableViewCell"
    
    private let itemLabel: UILabel = {
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
        contentView.addSubview(itemLabel)
        contentView.addSubview(rightArrow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemLabel.frame = CGRect(x: 10, y: 5, width: 100, height: 52)
        rightArrow.frame = CGRect(x: contentView.right - 52, y: 5, width: 52, height: 52)
    }
    
    public func configure(with which: String) {
        itemLabel.text = which
    }
}
