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
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
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
    
    public func InsertUser(with user: User, completion: @escaping (Bool) -> Void){
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
                            "isCheckedLegal": user.isCheckedLegal
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
                                "isCheckedLegal": user.isCheckedLegal
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
}

struct User {
    let name: String
    let surname: String
    let email: String
    let gender: String
    let fat: Decimal
    let height: Decimal
    let isPersonalInfoHidden: Bool
    let isCheckedLegal: Bool
    
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profilePictureFileName: String {
        return "\(safeEmail)_PP.png"
    }
}
