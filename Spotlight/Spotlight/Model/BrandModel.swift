//
//  BrandModel.swift
//  Spotlight
//
//  Created by Jai Deep on 04/07/23.
//

import Foundation



// MARK: Brand Model

struct HotSellingBrands: Codable {
    let success: Bool
    let payload: [PopularBrands]?
}

struct PopularBrands: Codable {
    let brandID: String?
    let numberOfOrders: Int?

    enum CodingKeys: String, CodingKey {
        case brandID = "brand_id"
        case numberOfOrders = "number_of_orders"
    }
}

// MARK: BrandsBasic
struct brandBasicModel: Codable{
    let success: Bool
    let payload: [Brand]
}

struct Brand: Codable, Hashable {
    let id: String
    let name: String
    let username: String
    let logo: Logo
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        // Implement Equatable protocol
        static func ==(lhs: Brand, rhs: Brand) -> Bool {
            return lhs.id == rhs.id
        }
    }


struct Logo: Codable {
    let src: String?
}

// MARK: Sorted Brand list MOdel

struct SortedBrandModel: Codable {
    let success: Bool?
    let payload: [String: [SortedBrand]]?
}

struct SortedBrand: Codable, Identifiable {
    let id: String?
    let name: String?
    let logo: Logo?
    let username: String?
}

