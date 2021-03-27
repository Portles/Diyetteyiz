//
//  MealTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 28.03.2021.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    public static let identifier = "MealTableViewCell"

    private let mealIndexLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    private let mealTimeLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mealIndexLabel)
        contentView.addSubview(mealTimeLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mealIndexLabel.frame = CGRect(x: 30, y: 10, width: contentView.width/2, height: contentView.height - 10)
        mealTimeLabel.frame = CGRect(x: mealIndexLabel.right, y: 10, width: contentView.width/2, height: contentView.height - 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with mealIndex: Int?, time: String?) {
        mealIndexLabel.text = String(mealIndex ?? 0) + ". Öğün"
        mealTimeLabel.text = "Saat: " + (time ?? "00:00")
    }
}
