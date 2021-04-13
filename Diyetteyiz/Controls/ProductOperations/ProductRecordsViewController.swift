//
//  ProductRecordsViewController.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 27.03.2021.
//

import UIKit

// MARK: - WelcomeElement
struct RecordTable: Codable {
    var records: [Record]?
    var createDate: String?

    enum CodingKeys: String, CodingKey {
        case records = "Records"
        case createDate
    }
}

// MARK: - Record
struct Record: Codable {
    var items: [item]?
}

// MARK: - Item
struct item: Codable {
    var itemIndex: Int?
    var isMaked: Bool?
    var makedMeasure, mealIndex: Int?

    enum CodingKeys: String, CodingKey {
        case itemIndex = "ItemIndex"
        case isMaked, makedMeasure, mealIndex
    }
}

class ProductRecordsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .systemBackground
        
        getProducts()
    }
    
    func getProducts() {
        DatabaseManager.shared.getProductRecords(completion: { result in
            switch result {
            case .success(let usersCollection):
                do{
                    let data = try JSONSerialization.data(withJSONObject: usersCollection, options: .prettyPrinted)
                    
                    let decoder = JSONDecoder()
                    do {
                        let customer = try decoder.decode(RecordTable.self, from: data)
                        print(customer)
                    } catch {
                        print(error.localizedDescription)
                    }
                }catch let parsingError {
                    print("Error", parsingError)
                }
                self.filterPrograms()
            case .failure(let error):
                print("Kayıt yok: \(error)")
            }
        })
    }
    
    func filterPrograms() {
        
    }
}

extension ProductRecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
