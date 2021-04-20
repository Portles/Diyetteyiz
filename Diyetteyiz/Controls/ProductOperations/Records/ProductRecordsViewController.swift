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

struct recordProgress {
    var records: [Progress]?
}

struct Progress {
    var progress: Bool
}

class ProductRecordsViewController: UIViewController {
    
    private var records = RecordTable()
    
    private var itemsBools = [Bool]()
    
    private var recordsProgress = [Progress]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .systemBackground
        
        getProducts()
        
        tableView.reloadData()
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
                        self.records = customer
                        
                        var records = [Progress]()
                        
                        for x in 0..<customer.records!.count {
                            
                            for y in 0..<customer.records![x].items!.count {
                                let percent = customer.records![x].items![y].isMaked
                                if percent ?? true {
                                    if y+1 == customer.records![x].items!.count {
                                        records.append(Progress(progress: true))
                                    }
                                    continue
                                } else {
                                    records.append(Progress(progress: false))
                                    continue
                                }
                            }
                        }
                        
                        self.recordsProgress = records
                        
                        self.tableView.reloadData()
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
        return records.records?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = indexPath.row + 1
        
        let progress = recordsProgress[indexPath.row].progress
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        cell.configure(with: day, progress: progress)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TodaysRecordViewController(with: records, whichDay: indexPath.row + 1)
        navigationController?.pushViewController(vc, animated: true)
    }
}
