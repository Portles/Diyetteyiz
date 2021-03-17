//
//  DietMenuModel.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import Foundation

struct DietModel: Codable {
    var header: String?
    var info: String?
    var price: String?
    var Days: [Day]?
    
    enum CodeKeys: CodingKey
      {
            case header
            case info
            case price
            case Days
      }

      init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodeKeys.self)
        header = try container.decode (String.self, forKey: .header)
        info = try container.decode (String.self, forKey: .info)
        price = try container.decode (String.self, forKey: .price)
        Days = try container.decode ([Day].self, forKey: .Days)
           
      }

      func encode(to encoder: Encoder) throws
      {
           var container = encoder.container(keyedBy: CodeKeys.self)
            try container.encode (header, forKey: .header)
            try container.encode (info, forKey: .info)
            try container.encode (price, forKey: .price)
            try container.encode (Days, forKey: .Days)
      }
}

struct Day: Codable {
    var Meals: [Meal]?
    
    enum CodeKeys: CodingKey
      {
            case Meals
      }

      init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodeKeys.self)
        Meals = try container.decode ([Meal].self, forKey: .Meals)
           
      }

      func encode(to encoder: Encoder) throws
      {
           var container = encoder.container(keyedBy: CodeKeys.self)
            try container.encode (Meals, forKey: .Meals)
      }
}

struct Meal: Codable {
    var name: String?
    var time: String?
    var items: [Item]?
    
    enum CodeKeys: CodingKey
      {
            case name
            case time
            case items
      }

      init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodeKeys.self)
        name = try container.decode (String.self, forKey: .name)
        time = try container.decode (String.self, forKey: .time)
        items = try container.decode ([Item].self, forKey: .items)
           
      }

      func encode(to encoder: Encoder) throws
      {
           var container = encoder.container(keyedBy: CodeKeys.self)
            try container.encode (name, forKey: .name)
            try container.encode (time, forKey: .time)
            try container.encode (items, forKey: .items)
      }
}

struct Item: Codable {
    var name: String?
    var itemType: String?
    var itemCalorie: String?
    var neededMesure: Int?
    
    enum CodeKeys: CodingKey
      {
            case name
            case itemType
            case itemCalorie
            case neededMesure
      }

      init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodeKeys.self)
        name = try container.decode (String.self, forKey: .name)
        itemType = try container.decode (String.self, forKey: .itemType)
        itemCalorie = try container.decode (String.self, forKey: .itemCalorie)
        neededMesure = try container.decode (Int.self, forKey: .neededMesure)
      }

      func encode(to encoder: Encoder) throws
      {
           var container = encoder.container(keyedBy: CodeKeys.self)
            try container.encode (name, forKey: .name)
            try container.encode (itemType, forKey: .itemType)
            try container.encode (itemCalorie, forKey: .itemCalorie)
            try container.encode (neededMesure, forKey: .neededMesure)
      }
}
