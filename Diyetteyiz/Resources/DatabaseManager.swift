//
//  DatabaseManager.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 25.02.2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAdress: String) -> String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    static func notSafeEmail(emailAdress: String) -> String {
        var safeEmail = emailAdress.replacingOccurrences(of: "-", with: ".")
        safeEmail = safeEmail.replacingOccurrences(of: "_", with: "@")
        return safeEmail
    }
}

extension DatabaseManager {
    public func getDataFor(path: String, comletion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                comletion(.failure(DatabaseError.dataCekmeHatasi))
                return
            }
            comletion(.success(value))
        }
    }
    
    public enum DatabaseError: Error {
        case dataCekmeHatasi
        
        public var localizedDescription: String{
            switch self {
            case .dataCekmeHatasi:
                return "Başarısızlık"
            }
        }
    }
}

extension DatabaseManager {
    public func UserExist(with email: String,
                          completion: @escaping ((Bool)->Void)){
        
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func InsertUser(with user: DiyetteyizUser, completion: @escaping (Bool) -> Void){
        let nowDate = Date()
        let dateString = DatabaseManager.dateFormatter.string(from: nowDate)
        database.child(user.safeEmail).setValue([
            "name": user.name,
            "canBuyProgram": true
        ], withCompletionBlock: { [weak self]error, _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Database yazım hatası.")
                completion(false)
                return
            }
            strongSelf.database.child("\(user.safeEmail)/notifications").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "header": "Kaydınız hazır",
                        "info": "Artık program satın alabilirsiniz. 👍",
                        "isRead": false,
                        "time": dateString
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                    userNotification.append(newElement)
                    strongSelf.database.child("\(user.safeEmail)/notifications").setValue(userNotification, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        [
                            "header": "Kaydınız hazır",
                            "info": "Artık program satın alabilirsiniz. 👍",
                            "isRead": false,
                            "time": dateString
                        ]
                    ]
                    
                    strongSelf.database.child("\(user.safeEmail)/notifications").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            
            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userCollection = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "name": user.name ,
                        "surname": user.surname ,
                        "email": user.safeEmail,
                        "gender": user.gender ,
                        "fat": user.fat ,
                        "height": user.height ,
                        "isPersonalInfoHidden": user.isPersonalInfoHidden ,
                        "isCheckedLegal": user.isCheckedLegal ,
                        "starRate": user.starRate ,
                        "bio": user.bio
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                    userCollection.append(newElement)
                    strongSelf.database.child("users").setValue(userCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        [
                            "name": user.name ,
                            "surname": user.surname ,
                            "email": user.safeEmail,
                            "gender": user.gender ,
                            "fat": user.fat ,
                            "height": user.height ,
                            "isPersonalInfoHidden": user.isPersonalInfoHidden ,
                            "isCheckedLegal": user.isCheckedLegal ,
                            "starRate": user.starRate ,
                            "bio": user.bio
                        ]
                    ]
                    
                    strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    public func updateProfile(with user: DiyetteyizUserModel,completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let ref = database.child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            if var users = snapshot.value as? [[String: Any]] {
                var position = 0
                let seyfMail = DatabaseManager.safeEmail(emailAdress: UserDefaults.standard.string(forKey: "email")!)
                for conversation in users {
                    if let seyfmeil = conversation["email"] as? String,
                       seyfmeil == seyfMail {
                        print("Silinecek konuşma bulundı")
                        break
                    }
                    position += 1
                }
                users.remove(at: position)
                ref.setValue(users, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(.failure(DatabaseError.dataCekmeHatasi))
                        print("Array'e yeni konuşma bilgisi yazılamadı.")
                        return
                    }
                    print("Seçilen chat silindi.")
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.database.child("users").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                        
                        if var userCollection = snapshot.value as? [[String: Any]] {
                            let newElement = [
                                "name": user.name! ,
                                "surname": user.surname!,
                                "email": user.safeEmail,
                                "gender": user.gender!,
                                "fat": user.fat! ,
                                "height": user.height! ,
                                "isPersonalInfoHidden": user.isPersonalInfoHidden! ,
                                "isCheckedLegal": user.isCheckedLegal! ,
                                "starRate": user.starRate! ,
                                "bio": user.bio!
                            ] as [String : Any]
                            guard let strongSelf = self else {
                                return
                            }
                            userCollection.append(newElement)
                            strongSelf.database.child("users").setValue(userCollection, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(.failure(DatabaseError.dataCekmeHatasi))
                                    return
                                }
                                completion(.success(users))
                            })
                        } else {
                            let newCollection: [[String: Any]] = [
                                [
                                    "name": user.name! ,
                                    "surname": user.surname!,
                                    "email": user.safeEmail,
                                    "gender": user.gender!,
                                    "fat": user.fat! ,
                                    "height": user.height! ,
                                    "isPersonalInfoHidden": user.isPersonalInfoHidden! ,
                                    "isCheckedLegal": user.isCheckedLegal! ,
                                    "starRate": user.starRate! ,
                                    "bio": user.bio!
                                ]
                            ]
                            
                            strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(.failure(DatabaseError.dataCekmeHatasi))
                                    return
                                }
                                completion(.success(users))
                            })
                        }
                    })
                    
                    completion(.success(users))
                })
            }
        }
    }
    
    public func updateDietitianProfile(with user: DiyetteyizUserModel,completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let ref = database.child("dietitians")
        ref.observeSingleEvent(of: .value) { snapshot in
            if var users = snapshot.value as? [[String: Any]] {
                var position = 0
                let seyfMail = DatabaseManager.safeEmail(emailAdress: UserDefaults.standard.string(forKey: "email")!)
                for conversation in users {
                    if let seyfmeil = conversation["email"] as? String,
                       seyfmeil == seyfMail {
                        print("Silinecek konuşma bulundı")
                        break
                    }
                    position += 1
                }
                users.remove(at: position)
                ref.setValue(users, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(.failure(DatabaseError.dataCekmeHatasi))
                        return
                    }
                    print("Seçilen diyetisyen.")
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.database.child("dietitians").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                        
                        if var userCollection = snapshot.value as? [[String: Any]] {
                            let newElement = [
                                "name": user.name! ,
                                "surname": user.surname!,
                                "email": user.safeEmail,
                                "gender": user.gender!,
                                "starRate": user.starRate! ,
                                "bio": user.bio!
                            ] as [String : Any]
                            guard let strongSelf = self else {
                                return
                            }
                            userCollection.append(newElement)
                            strongSelf.database.child("dietitians").setValue(userCollection, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(.failure(DatabaseError.dataCekmeHatasi))
                                    return
                                }
                                completion(.success(users))
                            })
                        } else {
                            let newCollection: [[String: Any]] = [
                                [
                                    "name": user.name! ,
                                    "surname": user.surname!,
                                    "email": user.safeEmail,
                                    "gender": user.gender!,
                                    "starRate": user.starRate! ,
                                    "bio": user.bio!
                                ]
                            ]
                            
                            strongSelf.database.child("dietitians").setValue(newCollection, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(.failure(DatabaseError.dataCekmeHatasi))
                                    return
                                }
                                completion(.success(users))
                            })
                        }
                    })
                    
                    completion(.success(users))
                })
            }
        }
    }
    // MARK: - GET PRODUCT DATA
    public func getDietitianProductData(with dietitian: String,completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let email = DatabaseManager.safeEmail(emailAdress: dietitian)
        database.child("\(email)/products").observeSingleEvent(of: .value, with: { snapshot in
            if let userProductData = snapshot.value as? [[String: Any]] {
                completion(.success(userProductData))
            } else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
            }
        })
    }
    
    // MARK: - SATIN ALIMLAR LOAD
    public func getOngoingProduct(with dietitian: String,completion: @escaping (Result<NSDictionary, Error>) -> Void) {
        let email = DatabaseManager.safeEmail(emailAdress: dietitian)
        database.child("\(email)/ongoingProduct").observeSingleEvent(of: .value, with: { snapshot in
            if let userProductData = snapshot.value as? NSDictionary {
                completion(.success(userProductData))
            } else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
            }
        })
    }
    
    // MARK: - DİYET PROGRAMI LOAD
    public func getFullDietProgram(with dietId: String,completion: @escaping (Result<[String: Any], Error>) -> Void) {
        database.child("ongoingproducts").observeSingleEvent(of: .value, with: { snapshot in
            if let userProductData = snapshot.value as? [String: Any] {
                completion(.success(userProductData))
            } else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
            }
        })
    }
    
    // MARK: - Diyet Programı Ekleme
    
    public func InsertDietitianProgram(with product: DietModel, miniProduct: MenuViewModelDiet, completion: @escaping (Bool) -> Void){
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        let jsonData = try! jsonEncoder.encode(product)
        let str = String(data: jsonData, encoding: String.Encoding.utf8)
        let nowDate = Date()
        
        // MARK: Map product
        
        func convertToDictionary(text: String) -> [String: Any]? {
            if let data = text.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
        }
        
        let json = convertToDictionary(text: str!)
        
        
        let dateString = DatabaseManager.dateFormatter.string(from: nowDate)
        let safeMail = DatabaseManager.safeEmail(emailAdress: UserDefaults.standard.string(forKey: "email")!)
        database.child(safeMail).setValue([
            "name": ""
        ], withCompletionBlock: { [weak self]error, _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Database yazım hatası.")
                completion(false)
                return
            }
            strongSelf.database.child("\(safeMail)/notifications").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "header": "Diyet Programı",
                        "info": "Program bize ulaştı kabul için beklemede kal. 👍",
                        "isRead": false,
                        "time": dateString
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                    userNotification.append(newElement)
                    strongSelf.database.child("\(safeMail)/notifications").setValue(userNotification, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        [
                            "header": "Diyet Programı",
                            "info": "Program bize ulaştı kabul için beklemede kal. 👍",
                            "isRead": false,
                            "time": dateString
                        ]
                    ]
                    
                    strongSelf.database.child("\(safeMail)/notifications").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            // MARK: İlk Kısım Insert
            strongSelf.database.child("\(safeMail)/products").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                
                if var userCollection = snapshot.value as? [[String: Any]] {
                    guard let strongSelf = self else {
                        return
                    }
                    userCollection.append(json!)
                    strongSelf.database.child("\(safeMail)/products").setValue(userCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        json!
                    ]
                    strongSelf.database.child("\(safeMail)/products").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            // MARK: Menus kısmına yazma
            strongSelf.database.child("menus").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "header": miniProduct.header!,
                        "info": miniProduct.info!,
                        "days": miniProduct.days!,
                        "price": miniProduct.price!,
                        "dietitianBind": safeMail,
                        "headerPicLoc": miniProduct.headerPicLoc!
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                    userNotification.append(newElement)
                    strongSelf.database.child("menus").setValue(userNotification, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        [
                            "header": miniProduct.header!,
                            "info": miniProduct.info!,
                            "days": miniProduct.days!,
                            "price": miniProduct.price!,
                            "dietitianBind": safeMail,
                            "headerPicLoc": miniProduct.headerPicLoc!
                        ]
                    ]
                    
                    strongSelf.database.child("menus").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    // MARK: - CHECK PROGRAM AVABİLİTY
    public func checkUserIsAllowToBuyProgram(completion: @escaping (Bool) -> Void){
        let buyyerEmail = UserDefaults.standard.string(forKey: "email")!
        let buyyerId = DatabaseManager.safeEmail(emailAdress: buyyerEmail)
        database.child("\(buyyerId)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let program = value?["canBuyProgram"] as? Bool ?? false

            if program == true {
                completion(true)
            } else {
                completion(false)
            }
            }) { (error) in
                print(error.localizedDescription)
                completion(false)
        }
    }
    
    // MARK: - INSERTSOLDPROGRAM
    public func insertSoldProgram(with program: MenuViewController.MenuViewModel, programId: String, dietitianEmail: String, completion: @escaping (Bool) -> Void){
        let buyyerEmail = UserDefaults.standard.string(forKey: "email")!
        let buyyerId = DatabaseManager.safeEmail(emailAdress: buyyerEmail)
        let nowDate = Date()
        let dateString = DatabaseManager.dateFormatter.string(from: nowDate)
        
        var modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: nowDate)!
        modifiedDate = Calendar.current.date(bySetting: .hour, value: 00, of: modifiedDate)!
        let startDate = Calendar.current.date(bySetting: .minute, value: 00, of: modifiedDate)!
        let startDateString = DatabaseManager.dateFormatter.string(from: startDate)
        
        UserDefaults.standard.setValue(programId, forKey: "programId")
        
        database.child("\(buyyerId)/ongoingProduct").setValue([
            "isHaveOngoingProduct": true ,
            "whichProduct": program.header!,
            "startDate": startDateString,
            "fromWho": dietitianEmail,
            "lastRecord": [
                "leftDays": program.daysCount!,
                "succesRate": 0,
                "nextDay": 1
            ]
        ], withCompletionBlock: { [weak self]error, _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Database yazım hatası.")
                completion(false)
                return
            }
            strongSelf.database.child("\(buyyerId)/notifications").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "header": "Diyet Satın alındı",
                        "info": "Saat 00.00'da diyetine başlayabilirsin.",
                        "isRead": false,
                        "time": dateString
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                    userNotification.append(newElement)
                    strongSelf.database.child("\(buyyerId)/notifications").setValue(userNotification, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        [
                            "header": "Diyet Satın alındı",
                            "info": "Saat 00.00'da diyetine başlayabilirsin.",
                            "isRead": false,
                            "time": dateString
                        ]
                    ]
                    
                    strongSelf.database.child("\(buyyerId)/notifications").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            strongSelf.database.child("ongoingPrograms").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "\(programId)": [
                            "createDate": dateString,
                            "Records": [
                            ]
                        ]
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                userNotification.append(newElement)
                strongSelf.database.child("ongoingPrograms").setValue(userNotification, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            } else {
                let newCollection: [String: Any] = [
                    "\(programId)": [
                        "createDate": dateString,
                        "Records": [
                        ]
                    ]
                ]
                strongSelf.database.child("ongoingPrograms").setValue(newCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                        completion(true)
                    })
                }
            })
            
            strongSelf.database.child("\(buyyerId)/canBuyProgram").setValue(false)
            
            strongSelf.database.child("\(dietitianEmail)/customers").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "soldTo": buyyerId,
                        "id": programId
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                    userNotification.append(newElement)
                    strongSelf.database.child("\(dietitianEmail)/customers").setValue(userNotification, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        [
                            "soldTo": buyyerId,
                            "id": programId
                        ]
                    ]
                    
                    strongSelf.database.child("\(dietitianEmail)/customers").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    // MARK: - ADD RECORD
    
    public func InsertNewDietRecord(with product: ItemRecords, whichDay: Int, leftDays: Int, nextDay: Int, completion: @escaping (Bool) -> Void){
        let succesRate = whichDay/(leftDays+nextDay-1) * 100
        let safeEmail = DatabaseManager.safeEmail(emailAdress: UserDefaults.standard.string(forKey: "email")!)
        let programId = UserDefaults.standard.string(forKey: "programId")!
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        let jsonData = try! jsonEncoder.encode(product)
        let str = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let nowDate = Date()
        let dateString = DatabaseManager.dateFormatter.string(from: nowDate)
        
        func convertToDictionary(text: String) -> [String: Any]? {
            if let data = text.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
        }
        
        let json = convertToDictionary(text: str!)
        
        let leftDaysFix = leftDays - 1
        let nextDayFix = nextDay + 1
        
        database.child("\(safeEmail)/ongoingProduct/lastRecord").setValue([
            "leftDays": leftDaysFix,
            "nextDay": nextDayFix,
            "succesRate": succesRate
        ], withCompletionBlock: { [weak self]error, _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Database yazım hatası.")
                completion(false)
                return
            }
            
            strongSelf.database.child("ongoingPrograms/\(programId)/Records").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    guard let strongSelf = self else {
                        return
                    }
                    userNotification.append(json!)
                    strongSelf.database.child("ongoingPrograms/\(programId)/Records").setValue(userNotification, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        json!
                    ]
                    strongSelf.database.child("ongoingPrograms/\(programId)/Records").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            strongSelf.database.child("\(safeEmail)/notifications").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var userNotification = snapshot.value as? [[String: Any]] {
                    let newElement = [
                        "header": "İlerleme \(whichDay). gün",
                        "info": "İlerlemen kaydedildi. Programına uymayı unutma. 😁👍",
                        "isRead": false,
                        "time": dateString
                    ] as [String : Any]
                    guard let strongSelf = self else {
                        return
                    }
                    userNotification.append(newElement)
                    strongSelf.database.child("\(safeEmail)/notifications").setValue(userNotification, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: Any]] = [
                        [
                            "header": "İlerleme \(whichDay). gün",
                            "info": "İlerlemen kaydedildi. Programına uymayı unutma. 😁👍",
                            "isRead": false,
                            "time": dateString
                        ]
                    ]
                    
                    strongSelf.database.child("\(safeEmail)/notifications").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
        }
    )}
    
    public func getDietitianMenu(with dietitianEmail: String ,completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("\(dietitianEmail)/products").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
                return
            }
            completion(.success(value))
        })
    }
    
    public func checkDidBuyProduct(with userEmail: String ,completion: @escaping (Bool) -> Void) {
        database.child("\(userEmail)/ongoingProduct").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let program = value?["isHaveOngoingProduct"] as? Bool ?? false

            if program == true {
                completion(true)
            } else {
                completion(false)
            }
            }) { (error) in
                print(error.localizedDescription)
                completion(false)
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
                return
            }
            completion(.success(value))
        })
    }
    
    public func getAllMenus(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("menus").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
                return
            }
            completion(.success(value))
        })
    }
    
    public func getAllDietitians(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("dietitians").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
                return
            }
            completion(.success(value))
        })
    }
    
    public func getAllNotifications(with email: String,completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let seyfMail = DatabaseManager.safeEmail(emailAdress: email)
        database.child("\(seyfMail)/notifications").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.dataCekmeHatasi))
                return
            }
            completion(.success(value))
        })
    }
    
    public static let dateFormatter: DateFormatter = {
        let frmttr = DateFormatter()
        frmttr.dateStyle = .medium
        frmttr.timeStyle = .long
        frmttr.locale = .current
        return frmttr
    }()
    
}

struct DiyetteyizUser {
    let name: String
    let surname: String
    let email: String
    let gender: String
    let fat: Decimal
    let height: Decimal
    let isPersonalInfoHidden: Bool
    let isCheckedLegal: Bool
    let starRate: Double
    let bio: String
    
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    var profilePictureFileName: String {
        return "\(safeEmail)_PP.png"
    }
}

struct NotificationModel {
    let header: String?
    let info: String?
    let isRead: Bool?
    let time: Date?
}

struct SearchResult {
    let email: String
    let name: String
    let info: String
    let ppUrl: String
}

struct MenuViewModel {
    let header: String
    let info: String
    let price: String
    let dietitianBind: String
    let days: Int
    let headerPicLoc: String
}
