//
//  ItemTableViewCell.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 28.03.2021.
//

struct ItemRecords: Codable {
    var items: [ItemRecord]?
}

struct ItemRecord: Codable {
    var mealIndex: Int?
    var ItemIndex: Int?
    var isMaked: Bool?
    var makedMeasure: Int?
}

import UIKit

class CheckMealTableViewCell: UITableViewCell {

    public static let identifier = "CheckMealTableViewCell"

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
    
    private let radioButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.setTitle("Yaptın mı?", for: .normal)
        button.setImage(UIImage(named: "checkboxUn")!, for: .normal)
        button.setImage(UIImage(named: "checkboxChecked")!, for: .selected)
        return button
    }()
    
    private let textField: UITextField = {
       let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "000"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0, width: 5,height:0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.isEnabled = true
        return field
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemMeasureLabel)
        contentView.addSubview(itemCalLabel)
        contentView.addSubview(radioButton)
        contentView.addSubview(textField)
        
        textField.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemNameLabel.frame = CGRect(x: 30, y: 10, width: contentView.width/3.2, height: contentView.height - 10)
        itemMeasureLabel.frame = CGRect(x: itemNameLabel.right, y: 10, width: contentView.width/5, height: contentView.height - 10)
        itemCalLabel.frame = CGRect(x: itemMeasureLabel.right, y: 10, width: contentView.width/12, height: contentView.height - 10)
        textField.frame = CGRect(x: itemCalLabel.right + 20, y: 15, width: contentView.width/10, height: 52)
        radioButton.frame = CGRect(x: textField.right + 10, y: 15, width: contentView.width/7, height: 52)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: Item?) {
        itemNameLabel.text = item?.name
        itemMeasureLabel.text = String((item?.neededMesure!)!) + " " + (item?.itemType!)!
        itemCalLabel.text = String((item?.itemCalorie)!)
    }
}

extension CheckMealTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let data = Int(textField.text ?? "0")
        if ((textField.text?.isEmpty) != nil) {
//            Day al meal al
            let data = ItemRecord(mealIndex: CheckMealViewController.MealIndex, ItemIndex: CheckMealViewController.itemIndex, isMaked: true, makedMeasure: data)
            
            CheckMealViewController.items.append(data)
        } else {
            let data = ItemRecord(mealIndex: CheckMealViewController.MealIndex, ItemIndex: CheckMealViewController.itemIndex, isMaked: false, makedMeasure: data)
            
            CheckMealViewController.items.append(data)
        }
        
        if CheckMealViewController.itemIndex == ProductsViewController.productData.Days![CheckMealViewController.todayIndex].Meals![CheckMealViewController.MealIndex].items!.count - 1 {
            CheckMealViewController.MealIndex += 1
            CheckMealViewController.itemIndex = 0
        } else {
            CheckMealViewController.itemIndex += 1
        }
        
        radioButton.isSelected = true
        textField.isEnabled = false
        print("\(textField.text ?? "sa")")
        print("\(CheckMealViewController.items)")
        return true
    }
}
