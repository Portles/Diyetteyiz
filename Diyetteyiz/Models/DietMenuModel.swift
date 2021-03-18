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
    var isActivated: Bool?
}

struct Day: Codable {
    var Meals: [Meal]?
}

struct Meal: Codable {
    var name: String?
    var time: String?
    var items: [Item]?
}

struct Item: Codable {
    var name: String?
    var itemType: String?
    var itemCalorie: String?
    var neededMesure: Int?
}
