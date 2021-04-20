//
//  TodaysRecordTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 19.04.2021.
//

import UIKit

class TodaysRecordTableViewCell: UITableViewCell {

    public static let identifier = "TodaysRecordTableViewCell"

    private let itemNameLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    private let itemMeasureLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    private let itemCalLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    private let progressLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemMeasureLabel)
        contentView.addSubview(itemCalLabel)
        contentView.addSubview(progressLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemNameLabel.frame = CGRect(x: 30, y: 10, width: contentView.width/3.2, height: contentView.height - 10)
        itemMeasureLabel.frame = CGRect(x: itemNameLabel.right, y: 10, width: contentView.width/5, height: contentView.height - 10)
        itemCalLabel.frame = CGRect(x: itemMeasureLabel.right, y: 10, width: contentView.width/5, height: contentView.height - 10)
        progressLabel.frame = CGRect(x: itemCalLabel.right, y: 10, width: contentView.width/5, height: contentView.height - 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: Item, progress: Int) {
        itemNameLabel.text = item.name
        itemMeasureLabel.text = String((item.neededMesure!)) + " " + (item.itemType!)
        itemCalLabel.text = String((Int(item.itemCalorie!)!*progress)/100) + "CAL"
        if progress>70 {
            progressLabel.textColor = .systemGreen
        } else {
            progressLabel.textColor = .systemRed
        }
        progressLabel.text = String(progress) + "%"
    }
}

