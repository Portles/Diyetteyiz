//
//  CheckMealViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 27.03.2021.
//

import UIKit

class CheckMealViewController: UIViewController {

    public static var todayIndex: Int = 0
    private var whichDay: Int
    public static var itemIndex: Int = 0
    public static var MealIndex: Int = 0
    public static var itemRecords = [ItemRecord]()
//    private var product = Product()
    
    private let mealTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(CheckMealTableViewCell.self, forCellReuseIdentifier: CheckMealTableViewCell.identifier)
        return tableView
    }()
    
    private let complateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tamamla", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    init(with product: Product, whichDay: Int) {
        self.whichDay = whichDay
        CheckMealViewController.todayIndex = whichDay
        super.init(nibName: nil ,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(mealTableView)
        view.addSubview(complateButton)
        
        mealTableView.delegate = self
        mealTableView.dataSource = self
        
        complateButton.addTarget(self, action: #selector(didTapComplateButton), for: .touchUpInside)
        
        navigationItem.title = String((ProductsViewController.productData.daysCount ?? 0) - 1) + ". Gün"
    }
    
    @objc private func didTapComplateButton() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mealTableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - 200)
        complateButton.frame = CGRect(x: 30, y: mealTableView.bottom + 10, width: view.width - 60, height: 52)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        CheckMealViewController.itemIndex = 0
        CheckMealViewController.MealIndex = 0
        CheckMealViewController.itemRecords.removeAll()
    }

}

extension CheckMealViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductsViewController.productData.Days![self.whichDay].Meals![section].items!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProductsViewController.productData.Days![self.whichDay].Meals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckMealTableViewCell.identifier, for: indexPath) as! CheckMealTableViewCell
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
