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
            "name": user.name
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
    
    public func getAllUsers(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
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
