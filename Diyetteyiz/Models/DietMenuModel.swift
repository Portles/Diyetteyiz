//
//  DietMenuModel.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 16.03.2021.
//

import Foundation

struct DietModel {
    var header: String?
    var info: String?
    var price: String?
    var Days: [Day]?
}

struct Day {
    var Meals: [Meal]?
}

struct Meal {
    var name: String?
    var time: String?
    var items: [Item]?
}

struct Item {
    var name: String?
    var itemType: String?
    var itemCalorie: String?
    var neededMesure: Int?
}
