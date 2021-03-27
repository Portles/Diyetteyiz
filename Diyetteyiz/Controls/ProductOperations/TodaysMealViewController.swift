//
//  TodaysMealViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 27.03.2021.
//

import UIKit

class TodaysMealViewController: UIViewController {

    private var whichDay: Int
    private var product = Product()
    
    private let mealTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: MealTableViewCell.identifier)
        return tableView
    }()
    
    private let itemTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        return tableView
    }()
    
    init(with product: Product, whichDay: Int) {
        self.product = product
        self.whichDay = whichDay
        super.init(nibName: nil ,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mealTableView)
        view.addSubview(itemTableView)
        
        mealTableView.delegate = self
        mealTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.delegate = self
        
        navigationController?.title = String(product.daysCount ?? 0) + ". Gün"
    }

}

extension TodaysMealViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mealTableView {
            return product.mealCount ?? 3
        } else {
            return product.itemCount ?? 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mealTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as! MealTableViewCell
            cell.configure(with: indexPath.row, time: "10:00")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
            
            return cell
        }
    }
    
    
}
