//
//  MealTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 28.03.2021.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    public static let identifier = "MealTableViewCell"

    private var meal = Item()
    
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
    
//    private let itemTableView: UITableView = {
//       let tableView = UITableView()
//        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
//        return tableView
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemMeasureLabel)
        contentView.addSubview(itemCalLabel)
        
//        itemTableView.delegate = self
//        itemTableView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemNameLabel.frame = CGRect(x: 30, y: 10, width: contentView.width/3, height: contentView.height - 10)
        itemMeasureLabel.frame = CGRect(x: itemNameLabel.right, y: 10, width: contentView.width/3, height: contentView.height - 10)
        itemCalLabel.frame = CGRect(x: itemMeasureLabel.right, y: 10, width: contentView.width/3, height: contentView.height - 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: Item?) {
        itemNameLabel.text = item?.name
        itemMeasureLabel.text = String((item?.neededMesure!)!) + " " + (item?.itemType!)!
        itemCalLabel.text = String((item?.itemCalorie)!) + "CAL"
    }
}

//extension MealTableViewCell: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return meal.items!.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let items = meal.items?[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
//        cell.configure(with: items)
//        return cell
//    }
//}
