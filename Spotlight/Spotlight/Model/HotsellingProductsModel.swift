//
//  HotsellingProductsModel.swift
//  Spotlight
//
//  Created by Jai Deep on 04/07/23.
//

import Foundation



// Hot Selling Products Model

struct HotSellingItemsModel: Codable {
    let payload: [HotSelling]
    let success: Bool
    let number_of_orders: Int
}

struct HotSelling: Codable, Identifiable {
    let id: String
    let name: String?
    let number_of_orders: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, number_of_orders
    }
}
