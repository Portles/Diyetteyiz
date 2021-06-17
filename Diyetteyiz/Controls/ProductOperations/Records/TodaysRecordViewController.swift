//
//  TodaysRecordViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 19.04.2021.
//

import UIKit

class TodaysRecordViewController: UIViewController {

    private var itemIndex: Int = 0
    private var whichDay: Int
    private var AllItems = [Item]()
    private var records = RecordTable()
//    private var product = Product()
    
    private let mealTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TodaysRecordTableViewCell.self, forCellReuseIdentifier: TodaysRecordTableViewCell.identifier)
        return tableView
    }()
    
    init(with record: RecordTable, whichDay: Int) {
        self.records = record
        self.whichDay = whichDay - 1
        super.init(nibName: nil ,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = String((ProductsViewController.productData.daysCount ?? 0) - (ProductsViewController.ongProduct.lastRecord?.leftDays)!) + ". Gün Kaydı"
        
        addSubviews()
        setDelegates()
    }
    
    private func addSubviews() {
        view.addSubview(mealTableView)
    }
    
    private func setDelegates() {
        mealTableView.delegate = self
        mealTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mealTableView.frame = view.bounds
    }

}

extension TodaysRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductsViewController.productData.Days![self.whichDay].Meals![section].items!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProductsViewController.productData.Days![self.whichDay].Meals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodaysRecordTableViewCell.identifier, for: indexPath) as! TodaysRecordTableViewCell
        
        let data = ProductsViewController.productData.Days?[whichDay].Meals![indexPath.section]
        
        let maked = records.records![whichDay].items![itemIndex].makedMeasure!
        
        let items = data?.items![indexPath.row]
        
        itemIndex += 1
        
        let progress =  Int((Float(maked)/Float((items?.neededMesure)!))*100)
        
        cell.configure(with: items!, progress: progress)
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
