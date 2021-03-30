//
//  TodaysMealViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 27.03.2021.
//

import UIKit

class TodaysMealViewController: UIViewController {

    private var whichDay: Int
    private var AllItems = [Item]()
//    private var product = Product()
    
    private let mealTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: MealTableViewCell.identifier)
        return tableView
    }()
    
    init(with product: Product, whichDay: Int) {
        self.whichDay = whichDay
        super.init(nibName: nil ,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(mealTableView)
        
        mealTableView.delegate = self
        mealTableView.dataSource = self
        
        navigationItem.title = String((ProductsViewController.productData.daysCount ?? 0) - 1) + ". Gün"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mealTableView.frame = view.bounds
    }

}

extension TodaysMealViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductsViewController.productData.Days![self.whichDay].Meals![section].items!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProductsViewController.productData.Days![self.whichDay].Meals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as! MealTableViewCell
//        let mealTime = ProductsViewController.productData.Days![self.whichDay].Meals![indexPath.row].time
        let data = ProductsViewController.productData.Days?[whichDay].Meals![indexPath.section]
//        let mealIndex = ProductsViewController.productData.Days![self.whichDay].Meals?.count
        let items = data?.items![indexPath.row]
        cell.configure(with: items)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < ProductsViewController.productData.Days![self.whichDay].Meals!.count {
            return ProductsViewController.productData.Days![self.whichDay].Meals![section].name
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
